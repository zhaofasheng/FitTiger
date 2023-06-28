//
//  NoticeUserVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserVoiceCell.h"
#import "NoticeTopiceVoicesListViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeUserVoiceCell
{
    UIView *_playView;//播放点击
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(15,15,70, 13)];
        _timeL.font = THRETEENTEXTFONTSIZE;
        _timeL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_timeL];
        
        _dateL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_timeL.frame)+10,70, 11)];
        _dateL.font = ELEVENTEXTFONTSIZE;
        _dateL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_dateL];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 150, 40)];
        self.playerView.isThird = YES;
        self.playerView.hidden = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"btn_play") forState:UIControlStateNormal];
        [self.contentView addSubview:_playerView];
        
        //话题
        _topiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_playerView.frame.origin.x, CGRectGetMaxY(_playerView.frame)+8, 0, 11)];
        _topiceLabel.font = ELEVENTEXTFONTSIZE;
        _topiceLabel.textColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        _topiceLabel.userInteractionEnabled = YES;
        _topiceLabel.hidden = YES;
        UITapGestureRecognizer *taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTextClick)];
        [_topiceLabel addGestureRecognizer:taptop];
        [self.contentView addSubview:_topiceLabel];
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(-15, -3,_playerView.frame.size.height+15+5, _playerView.frame.size.height+6)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
        _rePlayView.hidden = YES;
        [self.contentView addSubview:_rePlayView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(8+CGRectGetMaxX(_dateL.frame),15, DR_SCREEN_WIDTH-30, 13)];
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        self.titleL.font = XGTHREEBoldFontSize;
        [self.contentView addSubview:self.titleL];
        self.titleL.hidden = YES;
        
        self.contentTextL = [[UILabel alloc] initWithFrame:CGRectMake(15+CGRectGetMaxX(_dateL.frame), 15, DR_SCREEN_WIDTH-100-15, 13)];
        self.contentTextL.textColor = GetColorWithName(VMainTextColor);
        self.contentTextL.font = THRETEENTEXTFONTSIZE;
        self.contentTextL.numberOfLines = 0;
        [self.contentView addSubview:self.contentTextL];
        self.contentTextL.hidden = YES;
        
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH, 0)];
        [self.contentView addSubview:self.imageViewS];
        
        self.movieV = [[NoticeUserMoview alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.contentView addSubview:self.movieV];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 0)];
        _line.backgroundColor = GetColorWithName(VBigLineColor);
        [self.contentView addSubview:_line];
        
        //上锁 Imagelock
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-22, 14.5, 22, 22)];
        _lockImageView.image = UIImageNamed(@"Imagelock");
        [self.contentView addSubview:_lockImageView];
        _lockImageView.hidden = YES;
        
        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
        self.dragView.userInteractionEnabled = YES;
        self.dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
        [self.playerView addSubview:self.dragView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.0;
        [self.dragView addGestureRecognizer:longPress];
        
//        UILongPressGestureRecognizer *longd = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressDelete:)];
//        longPress.minimumPressDuration = 0.3;
//        [self addGestureRecognizer:longd];
    }
    return self;
}
- (void)longPressDelete:(id)sender{
    if (_isSay) {
        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVoiceSelf:)]) {
                [self.delegate deleteVoiceSelf:self.index];
            }
        }
    }
}

- (void)longPressGestureRecognized:(id)sender{

    if (_isSay) {
        if (!_sayModel.isPlaying) {
            return;
        }
    }
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    if (!_voiceM.isPlaying) {
        if (longPressState == UIGestureRecognizerStateEnded) {
            [self playNoReplay];
        }
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            DRLog(@"开始%.f",p.x);
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag:)]) {
                [self.delegate beginDrag:self.tag];
            }
            [self dragWithPoint:p];
            break;
        }
        case UIGestureRecognizerStateChanged:{
           
            [self dragWithPoint:p];
            break;
        }
        default: {

            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag:)]) {
                [self.delegate endDrag:self.tag];
            }
            break;
        }
    }
}

- (void)dragWithPoint:(CGPoint)p{
    self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
    if (_voiceM.moveSpeed > 0) {
        //每像素代表多少秒，等同于时间
        CGFloat beishuNum = _voiceM.voice_len.intValue/self.playerView.frame.size.width;
        [self.playerView refreshMoveFrame:beishuNum*_voiceM.moveSpeed*p.x];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index:)]) {
        if ((_voiceM.voice_len.floatValue/self.playerView.frame.size.width)*p.x < _voiceM.voice_len.length/5) {
            return;
        }
        [self.delegate dragingFloat:(_voiceM.voice_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
    }
}

- (void)setSayModel:(NoticeSayToSelf *)sayModel{
    _sayModel = sayModel;
    self.dateL.text = sayModel.day;
    self.timeL.text = sayModel.hour;
    
    self.playerView.hidden = NO;
    self.contentTextL.hidden = YES;
    
    self.playerView.timeLen = sayModel.note_len;
    self.playerView.voiceUrl = sayModel.note_url;
    self.playerView.slieView.progress = sayModel.nowPro >0 ?sayModel.nowPro:0;
    
    if (sayModel.note_len.integerValue < 5) {
        self.playerView.frame = CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 120, 40);
    }else if (sayModel.note_len.integerValue >= 5 && sayModel.note_len.integerValue <= 105){
        self.playerView.frame = CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 120+sayModel.note_len.integerValue, 40);
    }else if (sayModel.note_len.integerValue > 105){
        self.playerView.frame = CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 120+105, 40);
    }
    else{
        self.playerView.frame = CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 120+sayModel.note_len.integerValue, 40);
    }
    [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
    _rePlayView.hidden = sayModel.isPlaying? NO:YES;
    _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame),self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
    //_playView.frame = CGRectMake(0,0, self.playerView.frame.size.width, self.playerView.frame.size.height);
    [self.playerView refreWithFrame];
    self.dragView.frame =  CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height);
    _line.frame = CGRectMake(0,CGRectGetMaxY(self.playerView.frame)+15, DR_SCREEN_WIDTH, 8);
}

- (void)setIsSay:(BOOL)isSay{
    _isSay = isSay;
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    self.dateL.text = voiceM.year;
    self.timeL.text = voiceM.day;

    self.playerView.timeLen = voiceM.voice_len;
    self.playerView.voiceUrl = voiceM.voice_url;
    self.playerView.slieView.progress = voiceM.nowPro >0 ?voiceM.nowPro:0;
    
    if (voiceM.voice_len.integerValue < 5) {
        self.playerView.frame = CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 120, 40);
    }else if (voiceM.voice_len.integerValue >= 5 && voiceM.voice_len.integerValue <= 105){
        self.playerView.frame = CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 120+voiceM.voice_len.integerValue, 40);
    }else if (voiceM.voice_len.integerValue > 105){
        self.playerView.frame = CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 120+105, 40);
    }
    else{
        self.playerView.frame = CGRectMake(15+CGRectGetMaxX(_dateL.frame),15, 120+voiceM.voice_len.integerValue, 40);
    }
    [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
    _rePlayView.hidden = voiceM.isPlaying? NO:YES;
    _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame),self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);


    self.playerView.textL.hidden = YES;
    if (!(voiceM.nowPro > 0)) {
        self.playerView.reBackFrame = YES;
    }
    
    [self.playerView refreWithFrame];
    self.dragView.frame =  CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height);
    
    self.contentTextL.hidden = voiceM.content_type.intValue == 2?NO:YES;
    self.playerView.hidden = !self.contentTextL.hidden;
    
    CGFloat titleH = 0;
    CGFloat moreHeight = 0;
    if (voiceM.titleHeight>0) {
        self.titleL.hidden = NO;
        titleH = 38;
        moreHeight = 23;
    }else{
        moreHeight = 0;
        titleH = 15;
        self.titleL.hidden = YES;
    }
    self.titleL.text = voiceM.title;
    if (voiceM.content_type.intValue == 2) {
        self.contentTextL.attributedText = voiceM.isReMoreFiveLines?voiceM.refiveAttTextStr:voiceM.reAllTextAttStr;
        if (voiceM.topicName.length && voiceM.rememberTextHeight < 30) {
            self.contentTextL.frame = CGRectMake(8+CGRectGetMaxX(_dateL.frame), titleH, DR_SCREEN_WIDTH-100-15,15);
        }
        else{
            if (voiceM.rememberTextHeight <= 34) {
                self.contentTextL.frame = CGRectMake(8+CGRectGetMaxX(_dateL.frame),titleH, DR_SCREEN_WIDTH-100-15,34);
            }else{
                self.contentTextL.frame = CGRectMake(8+CGRectGetMaxX(_dateL.frame), titleH, DR_SCREEN_WIDTH-100-15,voiceM.rememberTextHeight);
            }
        }
    }
    CGRect Yframe = voiceM.content_type.intValue == 2?_contentTextL.frame:_playerView.frame;
    if (voiceM.topicName.length) {
        self.topiceLabel.hidden = NO;
        self.topiceLabel.text = voiceM.topicName;
        self.topiceLabel.frame = CGRectMake(_playerView.frame.origin.x, CGRectGetMaxY(Yframe)+8,GET_STRWIDTH(voiceM.topicName, 11, 11), 11);
    }else{
        self.topiceLabel.hidden = YES;
    }
    if (voiceM.img_list.count) {
        _imageViewS.hidden = NO;
        if (voiceM.img_list.count == 1) {
            self.imageViewS.frame = CGRectMake(0,(voiceM.topicName.length?CGRectGetMaxY(_topiceLabel.frame) : CGRectGetMaxY(Yframe))+15, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*0.448);
        }else if (voiceM.img_list.count == 2){
            self.imageViewS.frame = CGRectMake(0,(voiceM.topicName.length?CGRectGetMaxY(_topiceLabel.frame) : CGRectGetMaxY(Yframe))+15, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*0.373);
        }else{
            self.imageViewS.frame = CGRectMake(0,(voiceM.topicName.length?CGRectGetMaxY(_topiceLabel.frame) : CGRectGetMaxY(Yframe))+15, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-46)/3);
        }
    }else{
        _imageViewS.hidden = YES;
    }
    self.imageViewS.imgArr = voiceM.img_list;
    
    if (voiceM.resource) {
        self.movieV.hidden = NO;
        if ([voiceM.resource_type isEqualToString:@"1"]) {
            self.movieV.movie = voiceM.movieM;
            self.movieV.userScroe = voiceM.user_score;
            self.movieV.frame = CGRectMake(0, (voiceM.topicName.length?CGRectGetMaxY(_topiceLabel.frame) : CGRectGetMaxY(Yframe)), DR_SCREEN_WIDTH, 155);
        }else if ([voiceM.resource_type isEqualToString:@"2"]){
            self.movieV.book = voiceM.bookM;
            self.movieV.userScroe = voiceM.user_score;
            self.movieV.frame = CGRectMake(0, (voiceM.topicName.length?CGRectGetMaxY(_topiceLabel.frame) : CGRectGetMaxY(Yframe)), DR_SCREEN_WIDTH, 155);
        }else if ([voiceM.resource_type isEqualToString:@"3"]){
            self.movieV.song = voiceM.songM;
            self.movieV.songScroe = voiceM.user_score;
            self.movieV.frame = CGRectMake(0, (voiceM.topicName.length?CGRectGetMaxY(_topiceLabel.frame) : CGRectGetMaxY(Yframe)), DR_SCREEN_WIDTH, 115);
        }
    }else{
        self.movieV.hidden = YES;
    }
    
    if ([voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo]user_id]] && voiceM.is_private.integerValue) {//是自己并且设置了私密
        _lockImageView.hidden = NO;
        _lockImageView.frame = CGRectMake(DR_SCREEN_WIDTH-5-22, self.playerView.frame.origin.y+9, 22, 22);
    }else{
        _lockImageView.hidden = YES;
    }
    
    NoticeVoiceListModel *model = voiceM;
    CGFloat cellHeight = 0;
    if (model.content_type.intValue == 2) {
        if (model.img_list.count) {
             if (model.img_list.count == 1) {
                cellHeight = 72+((model.topicName.length && model.rememberTextHeight > 34)? 19 : 0) + DR_SCREEN_WIDTH*0.448+15+model.rememberBetTextHeight+moreHeight;
            }else if (model.img_list.count == 2){
                cellHeight = 72+((model.topicName.length && model.rememberTextHeight > 34) ? 19 : 0) + DR_SCREEN_WIDTH*0.373+15+model.rememberBetTextHeight+moreHeight;
            }else{
                cellHeight = 72+((model.topicName.length && model.rememberTextHeight > 34)? 19 : 0) + (DR_SCREEN_WIDTH-46)/3+15+model.rememberBetTextHeight+moreHeight;
            }
        }else if ([model.resource_type isEqualToString:@"1"] || [model.resource_type isEqualToString:@"2"]) {
            cellHeight = 72+ 155+model.rememberBetTextHeight;
        }else if ([model.resource_type isEqualToString:@"3"]) {
            cellHeight = 72 + 115+model.rememberBetTextHeight;
        }else{
            cellHeight = 72+((model.topicName.length && model.rememberTextHeight > 34) ? 19 : 0)+model.rememberBetTextHeight+moreHeight;
        }
    }else{
        if (model.img_list.count) {
             if (model.img_list.count == 1) {
                cellHeight = 78+(model.topicName.length ? 19 : 0) + DR_SCREEN_WIDTH*0.448+15;
            }else if (model.img_list.count == 2){
                cellHeight = 78+(model.topicName.length ? 19 : 0) + DR_SCREEN_WIDTH*0.373+15;
            }else{
                cellHeight = 78+(model.topicName.length ? 19 : 0) + (DR_SCREEN_WIDTH-46)/3+15;
            }
        }else if ([model.resource_type isEqualToString:@"1"] || [model.resource_type isEqualToString:@"2"]) {
            cellHeight = 78+(model.topicName.length ? 19 : 0) + 155;
        }else if ([model.resource_type isEqualToString:@"3"]) {
            cellHeight = 78+(model.topicName.length ? 19 : 0) + 115;
        }else{
            cellHeight = 78+(model.topicName.length ? 19 : 0);
        }
    }
    _line.frame = CGRectMake(0,cellHeight-8, DR_SCREEN_WIDTH, 8);
}

//点击播放
- (void)playNoReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userstartPlayAndStop:)]) {
        [self.delegate userstartPlayAndStop:self.index];
    }
}

//点击重新播放
- (void)playReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userstartRePlayer:)]) {
        [self.delegate userstartRePlayer:self.index];
    }
}
//点击话题
- (void)topicTextClick{
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        NoticeTopiceVoicesListViewController *ctl = [[NoticeTopiceVoicesListViewController alloc] init];
        ctl.topicName = _voiceM.topic_name;
        ctl.topicId = _voiceM.topic_id;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
