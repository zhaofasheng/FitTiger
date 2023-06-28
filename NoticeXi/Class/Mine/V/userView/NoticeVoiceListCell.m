                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              //
//  NoticeVoiceListCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceListCell.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSendViewController.h"
#import "NoticeTopiceVoicesListViewController.h"
#import "NoticeBackVoiceViewController.h"
#import "NoticeChatWithOtherViewController.h"
#import "NoticeNoticenterModel.h"
#import "NoticrChatLike.h"
#import "NoticeClipImage.h"
#import "NoticePlayerVideoController.h"
@implementation NoticeVoiceListCell

{
    UIView *_playView;//播放点击
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
    UIView *_mbView;
    UIViewController *_topController;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(26+_iconImageView.frame.origin.x, 26+_iconImageView.frame.origin.y, 15, 15)];
        self.markImage.image = UIImageNamed(@"jlzb_img");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        _mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _mbView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [_iconImageView addSubview:_mbView];
        _mbView.layer.cornerRadius = 20;
        _mbView.layer.masksToBounds = YES;
        _mbView.hidden = [NoticeTools isWhiteTheme]?YES:NO;
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 17, 160, 15)];
        _nickNameL.font = THRETEENTEXTFONTSIZE;
        _nickNameL.textColor = GetColorWithName(VMainTextColor);
        [self.contentView addSubview:_nickNameL];
        
        //上锁 Imagelock
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-22, 14.5, 22, 22)];
        _lockImageView.image = UIImageNamed(@"Imagelock");
        [self.contentView addSubview:_lockImageView];
        _lockImageView.hidden = YES;
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6, 160, 12)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = GetColorWithName(VDarkTextColor);
        [self.contentView addSubview:_timeL];
        
        //话题
        _topiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeL.frame), CGRectGetMaxY(_nickNameL.frame), 0, 12+12)];
        _topiceLabel.font = ELEVENTEXTFONTSIZE;
        _topiceLabel.textColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        _topiceLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicTextClick)];
        [_topiceLabel addGestureRecognizer:taptop];
        [self.contentView addSubview:_topiceLabel];
        
        //右上角按钮
        _topiceButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-66-15,19-3.5,66, 20)];
        _topiceButton.layer.cornerRadius = 10;
        _topiceButton.layer.masksToBounds = YES;
        _topiceButton.titleLabel.font = ELEVENTEXTFONTSIZE;
        _topiceButton.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FAFAFA":@"#222238"];
        [_topiceButton setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 150, 40)];
        _playerView.hidden = YES;
        self.playerView.delegate = self;
        self.playerView.isThird = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"btn_play") forState:UIControlStateNormal];
        [self.contentView addSubview:_playerView];
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(-15, -3,_playerView.frame.size.height+15+5, _playerView.frame.size.height+6)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
    
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
        _rePlayView.hidden = YES;
        [self.contentView addSubview:_rePlayView];
        
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, 0, 0)];
        [self.contentView addSubview:self.imageViewS];
        
        self.buttonView = [[NoticeVoiceListButtonView alloc] init];
        self.buttonView.delegate = self;
        [self.contentView addSubview:self.buttonView];
        
        _listenL = [[UILabel alloc] initWithFrame:self.topiceButton.frame];
        _listenL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3e3e4a"];
        _listenL.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FAFAFA":@"#222238"];
        _listenL.layer.cornerRadius = self.topiceButton.frame.size.height/2;
        _listenL.layer.masksToBounds = YES;
        _listenL.font = [UIFont systemFontOfSize:9];
        _listenL.textAlignment = NSTextAlignmentCenter;
    
        _listenL.hidden = YES;
        [self.contentView addSubview:_listenL];
        [self.contentView addSubview:_topiceButton];

        _scroImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_scroImageView];
        //电影
        _movieView = [[NoticeMoivceInCell alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH-30, 83)];
        [self.contentView addSubview:_movieView];
        
        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
        self.dragView.userInteractionEnabled = YES;
        self.dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
        [self.playerView addSubview:self.dragView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.17;
        [self.dragView addGestureRecognizer:longPress];

    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        _insteadView = view;
        UIImageView *imgeV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
        self.instedImageV = imgeV;
        [view addSubview:imgeV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8+15+20, 0, DR_SCREEN_WIDTH-15-30, 40)];
        label.font = TWOTEXTFONTSIZE;
        self.instedL = label;
        label.textColor = GetColorWithName(VMainThumeWhiteColor);
        label.textColor = [NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#b2b2b2"];
        [view addSubview:label];
        [self.contentView addSubview:_insteadView];
        _insteadView.hidden = YES;
        
        //屏蔽别人心情
        self.pinbTools = [[NoticeVoicePinbi alloc] init];
        self.pinbTools.delegate = self;
        
        //分享到世界
        self.shareWorld = [[NoticeShareToWorld alloc] init];
        self.shareWorld.delegate = self;

        self.topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-45-73, _nickNameL.frame.origin.y, 73, 61)];
        [self.contentView addSubview:self.topImageView];
        self.topImageView.hidden = YES;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_iconImageView.frame), DR_SCREEN_WIDTH-30, 40)];
        self.titleL.textColor = GetColorWithName(VMainTextColor);
        self.titleL.font = XGSIXBoldFontSize;
        [self.contentView addSubview:self.titleL];
        self.titleL.hidden = YES;
        
        self.textContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_iconImageView.frame)+15, DR_SCREEN_WIDTH-30,40)];
        self.textContentLabel.numberOfLines = 0;
        self.textContentLabel.textColor = GetColorWithName(VMainTextColor);
        self.textContentLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.textContentLabel];
        self.textContentLabel.hidden = YES;
        self.textContentLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextL)];
        [self.textContentLabel addGestureRecognizer:contentTap];
        
    }
    return self;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-66-15-20-15,19-3.5,20, 20)];
        [_shareBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sharegroup_b":@"Image_sharegroup_y") forState:UIControlStateNormal];
        [self.contentView addSubview:_shareBtn];
        [_shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIButton *)bookLikeBtn{
    if (!_bookLikeBtn) {
        _bookLikeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-65, 19, 65, 27)];
        _bookLikeBtn.layer.cornerRadius = 27/2;
        _bookLikeBtn.layer.masksToBounds = YES;
        _bookLikeBtn.layer.borderColor = GetColorWithName(VMainThumeColor).CGColor;
        _bookLikeBtn.layer.borderWidth = 1;
        [_bookLikeBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"minee.xs"]:@"關註" forState:UIControlStateNormal];
        [_bookLikeBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        _bookLikeBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [_bookLikeBtn addTarget:self action:@selector(guanzhuClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_bookLikeBtn];
        
    }
    return _bookLikeBtn;
}

//分享
- (void)shareClick{
    
    NoticeShareGroupView *shareGroupView = [[NoticeShareGroupView alloc] initWithShareVoiceToGroup];
    shareGroupView.voiceM = self.voiceM;
    [shareGroupView showShareView];
}

//点击播放
- (void)playNoReplay{
    DRLog(@"点击播放区域");
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:self.index];
    }
}

//点击重新播放
- (void)playReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRePlayer:)]) {
        [self.delegate startRePlayer:self.index];
    }
}

- (void)longPressGestureRecognized:(id)sender{

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
     
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag: progross:)]) {
                [self.delegate endDrag:self.tag progross:p.x/self.playerView.frame.size.width];
            }
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

//我的声昔
- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
 
    [self setDataModel:voiceM];
//    **********以上是不需要变动的
    //右上角按钮
     [_topiceButton setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"voicelist.listen"),voiceM.played_num] forState:UIControlStateNormal];
}

- (void)setMoviceM:(NoticeVoiceListModel *)moviceM{
    _moviceM = moviceM;
    _voiceM = _moviceM;
    self.shareBtn.frame = CGRectMake(DR_SCREEN_WIDTH-66-15-20-15-20-15,19-3.5,20, 20);
    [self setDataModel:moviceM];
    
    if ([moviceM.resource_type isEqualToString:@"1"] || [moviceM.resource_type isEqualToString:@"2"]) {
        if ([moviceM.user_score isEqualToString:@"0"]) {
            _scroImageView.image = UIImageNamed(@"bad_select");
        }else if ([moviceM.user_score isEqualToString:@"50"]){
            _scroImageView.image = UIImageNamed(@"normal_select");
        }
        else{
            _scroImageView.image = UIImageNamed(@"good_select");
        }
        
    }else if ([moviceM.resource_type isEqualToString:@"3"]){
        if ([moviceM.user_score isEqualToString:@"100"]) {
            _scroImageView.image = UIImageNamed(@"Image_cg100");
        }else if ([moviceM.user_score isEqualToString:@"150"]){
            _scroImageView.image = UIImageNamed(@"Image_cg150");
        }
        else{
            _scroImageView.image = UIImageNamed(@"Image_cg200");
        }
    }

    self.timeL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6,GET_STRWIDTH(self.isShowShareTime ? _voiceM.sharedTime : _voiceM.created_at, 12, 12), 12);
    
    //话题
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        self.topiceLabel.text = _voiceM.topicName;
        self.topiceLabel.frame = CGRectMake(CGRectGetMaxX(_timeL.frame), _timeL.frame.origin.y,DR_SCREEN_WIDTH-CGRectGetMaxX(_timeL.frame)-15, 12);
    }else{
        self.topiceLabel.text = @"";
        self.topiceLabel.frame = CGRectMake(CGRectGetMaxX(_timeL.frame)+5, _timeL.frame.origin.y,0, 0);
    }
    //共享时间
    self.timeL.text = self.isShowShareTime ? _voiceM.sharedTime : _voiceM.created_at;
    _topiceButton.hidden = YES;
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是自己，右上角按钮现实收听数，否则隐藏
        _topiceButton.hidden = YES;
        if (moviceM.is_private.integerValue) {
            _listenL.hidden = YES;
            _lockImageView.hidden = NO;
            _scroImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-22-10-_listenL.frame.size.height, _lockImageView.frame.origin.y, _listenL.frame.size.height, _listenL.frame.size.height);
        }else{
             _lockImageView.hidden = YES;
            _listenL.hidden = NO;
            if (!moviceM.played_num.integerValue) {
                moviceM.played_num = @"";
            }
            _listenL.text = [NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"voicelist.listen"),moviceM.played_num];
            _scroImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-_bookLikeBtn.frame.size.height-10-_listenL.frame.size.width, _listenL.frame.origin.y-(_bookLikeBtn.frame.size.height-_listenL.frame.size.height)/2, _bookLikeBtn.frame.size.height, _bookLikeBtn.frame.size.height);
        }
        
    }else{
        _listenL.hidden = YES;
        _lockImageView.hidden = YES;
        _scroImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-_bookLikeBtn.frame.size.width-_bookLikeBtn.frame.size.height-10, _bookLikeBtn.frame.origin.y, _bookLikeBtn.frame.size.height, _bookLikeBtn.frame.size.height);
    }
    if (_voiceM.content_type.intValue == 2) {
        _listenL.hidden = YES;
        _topiceButton.hidden = YES;
        _scroImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-_bookLikeBtn.frame.size.width, _bookLikeBtn.frame.origin.y, _bookLikeBtn.frame.size.height, _bookLikeBtn.frame.size.height);
    }
}

//世界
- (void)setWorldM:(NoticeVoiceListModel *)worldM{
    _worldM = worldM;
    _voiceM = worldM;
    [self setDataModel:worldM];
    if (self.isShowShareTime) {
       self.timeL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6,GET_STRWIDTH(_voiceM.sharedTime, 12, 12), 12);
    }else{
        self.timeL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6,GET_STRWIDTH(_voiceM.created_at, 12, 12), 12);
    }
    
    //话题
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        self.topiceLabel.text = _voiceM.topicName;
        self.topiceLabel.frame = CGRectMake(CGRectGetMaxX(_timeL.frame), _timeL.frame.origin.y,DR_SCREEN_WIDTH-CGRectGetMaxX(_timeL.frame)-15, 12);
    }else{
        self.topiceLabel.text = @"";
        self.topiceLabel.frame = CGRectMake(CGRectGetMaxX(_timeL.frame)+5, _timeL.frame.origin.y,0, 0);
    }
    
    //共享时间
    self.timeL.text = self.isShowShareTime ? _voiceM.sharedTime : _voiceM.created_at;
    [_topiceButton setTitle:@"" forState:UIControlStateNormal];
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是自己，右上角按钮现实收听数，否则隐藏
        _topiceButton.hidden = YES;
        if (worldM.is_private.integerValue) {
            _listenL.hidden = YES;
            _lockImageView.hidden = NO;
        }else{
            _lockImageView.hidden = YES;
            _listenL.hidden = NO;
            if (!worldM.played_num.integerValue) {
                worldM.played_num = @"";
            }
            _listenL.text = [NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"voicelist.listen"),worldM.played_num];
        }
    }else{
        _listenL.hidden = YES;
        _lockImageView.hidden = YES;
        if ([worldM.friend_status isEqualToString:@"1"]) {
            _topiceButton.hidden = NO;
            [_topiceButton removeTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
            _topiceButton.backgroundColor = _listenL.backgroundColor;
            [_topiceButton setTitle:@"等待验证" forState:UIControlStateNormal];
            [_topiceButton setTitleColor:[NoticeTools isWhiteTheme]?[UIColor colorWithHexString:@"#b2b2b2"]:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            _topiceButton.titleLabel.font = [UIFont systemFontOfSize:9];
        }else if ([worldM.friend_status isEqualToString:@"0"]){
            _topiceButton.hidden = YES;
            [_topiceButton setTitle:@"+ 学友" forState:UIControlStateNormal];
            _topiceButton.titleLabel.font = [UIFont systemFontOfSize:9];
            [_topiceButton setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
            [_topiceButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_topiceButton removeTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
            _topiceButton.hidden = YES;
        }
        
    }
    if (self.isWorld && _voiceM.topAt.intValue && [_voiceM.subUserModel.userId isEqualToString:@"1"]) {
        _listenL.hidden = YES;
        _topiceButton.hidden = YES;
    }
    
    if (self.isMovie) {
        _topiceButton.hidden = YES;
    }
    if (_voiceM.content_type.intValue == 2) {
        _listenL.hidden = YES;
        _topiceButton.hidden = YES;
    }

}

//好友
- (void)setFriendM:(NoticeVoiceListModel *)friendM{
    _friendM = friendM;
    //底部按钮位置
    [self setDataModel:friendM];
    _topiceButton.hidden = YES;
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是自己，右上角按钮现实收听数，否则隐藏
        if (friendM.is_private.integerValue) {
            _listenL.hidden = YES;
            _lockImageView.hidden = NO;
        }else{
            _lockImageView.hidden = YES;
            _listenL.hidden = NO;
            if (!friendM.played_num.integerValue) {
                friendM.played_num = @"";
            }
            
            _listenL.text = [NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"voicelist.listen"),friendM.played_num];
        }
    }else{
        _listenL.hidden = YES;
        _lockImageView.hidden = YES;
    }
    if (_voiceM.content_type.intValue == 2) {
        _listenL.hidden = YES;
        _topiceButton.hidden = YES;
    }
}

- (void)refreCellFrame{
    if (self.needFavietaer) {
        if (_voiceM.intersect_tags.count) {
            _insteadView.hidden = NO;
            _insteadView.backgroundColor = [_voiceM.subUserModel.interface_type isEqualToString:@"I"] ? [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#A6E3E9":@"#85b6ba"] : [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFC0D0":@"#cc9aa6"];
            self.instedL.text = [NSString stringWithFormat:@"你和ta有%ld段相同的经历：%@",_voiceM.intersect_tags.count,_voiceM.insterString];
            if ([_voiceM.subUserModel.interface_type isEqualToString:@"I"]) {
                self.instedImageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_manins_b":@"Image_manins_y");
            }else{
                self.instedImageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_woman_b":@"Image_woman_y");
            }
            
            _iconImageView.frame = CGRectMake(15, 15+40, 40, 40);
            _nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 17+40, 160, 15);
            _lockImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-22, 14.5, 22, 22);
            _timeL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6, 160, 12);
            _topiceButton.frame = CGRectMake(DR_SCREEN_WIDTH-66-15,19-3.5+40,66, 20);
            _bookLikeBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-65, 19+40, 65, 27);
        }else{
            _iconImageView.frame = CGRectMake(15, 15, 40, 40);
            _nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 17, 160, 15);
            _lockImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-22, 14.5, 22, 22);
            _timeL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6, 160, 12);
            _topiceButton.frame = CGRectMake(DR_SCREEN_WIDTH-66-15,19-3.5,66, 20);
            _insteadView.hidden = YES;
            _bookLikeBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-65, 19, 65, 27);
        }
        _listenL.frame = self.topiceButton.frame;
        self.markImage.frame = CGRectMake(26+_iconImageView.frame.origin.x, 26+_iconImageView.frame.origin.y, 15, 15);
    }
}

- (SelVideoPlayer *)player{
    if (!_player) {

        _player = [[SelVideoPlayer alloc] initWithFrame:CGRectMake(0, _voiceM.content_type.intValue!=2? (CGRectGetMaxY(_playerView.frame)+15):50, 200,200)];
        _player.playbackControls.hidden = YES;
        [self.contentView addSubview:_player];
        _player.layer.cornerRadius = 10;
        _player.layer.masksToBounds = YES;
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _videoImageView.image = UIImageNamed(@"Image_videoimg");
        [self.contentView addSubview:_videoImageView];
        _player.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        _videoImageView.center = _player.center;
        _player.playerLayer.videoGravity = AVLayerVideoGravityResize;
        _player.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTap)];
        [_player addGestureRecognizer:tap];
    }
    return _player;
}

- (void)videoTap{
    NoticePlayerVideoController *ctl = [[NoticePlayerVideoController alloc] init];
    ctl.videoUrl = _voiceM.img_list[0];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)setDataModel:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
    
    if (self.isNeedLikeBtn) {
        if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
            self.bookLikeBtn.hidden = NO;
            if (voiceM.be_subscribed.integerValue) {//书籍心情 是否已欣赏
                _bookLikeBtn.backgroundColor = GetColorWithName(VlistColor);
                [_bookLikeBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"intro.yilike"]:@"已關註" forState:UIControlStateNormal];
                [_bookLikeBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
                _bookLikeBtn.layer.borderWidth = 0;
            }else{
                [_bookLikeBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"minee.xs"]:@"關註" forState:UIControlStateNormal];
                [_bookLikeBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
                _bookLikeBtn.backgroundColor = GetColorWithName(VBackColor);
                _bookLikeBtn.layer.borderWidth = 1;
            }
        }else{
            self.bookLikeBtn.hidden = YES;
        }
    }else{
        self.bookLikeBtn.hidden = YES;
    }
    
    if (self.isWorld && voiceM.topAt.intValue) {
        _listenL.hidden = YES;
        self.topiceButton.hidden = YES;
        self.topImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_xehav_b":@"Image_xehav_y");
        self.topImageView.hidden = NO;
    }else{
        self.topImageView.hidden = YES;
        _listenL.hidden = NO;
    }
    if ([voiceM.subUserModel.identity_type isEqualToString:@"0"]) {
        self.markImage.hidden = YES;
    }else if ([voiceM.subUserModel.identity_type isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
    }else if ([voiceM.subUserModel.identity_type isEqualToString:@"2"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
    }else{
        self.markImage.hidden = YES;
    }
    if ([_voiceM.subUserModel.userId isEqualToString:@"1"]) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
    }
    
    _mbView.hidden = [NoticeTools isWhiteTheme]?YES:NO;
    
    [self refreCellFrame];
    //电影
    self.movieView.hidden = (voiceM.resource)? NO:YES;
    self.movieView.type = voiceM.resource_type;
    if ([voiceM.resource_type isEqualToString:@"1"]) {
      self.movieView.movie = voiceM.movieM;
        self.movieView.userScro = voiceM.user_score;
    }else if ([voiceM.resource_type isEqualToString:@"2"]){//书籍
        self.movieView.userScro = voiceM.user_score;
        self.movieView.book = voiceM.bookM;
    }else if ([voiceM.resource_type isEqualToString:@"3"]){//歌曲
        self.movieView.songScro = voiceM.user_score;
        self.movieView.song = voiceM.songM;
    }
        
    if (self.isSmallLine) {
        self.buttonView.line.frame = CGRectMake(0,50,DR_SCREEN_WIDTH, 1);
    }
    self.timeL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6,GET_STRWIDTH(voiceM.created_at, 12, 12), 12);
    //话题
    if (voiceM.topic_name && voiceM.topic_name.length) {
        self.topiceLabel.text = voiceM.topicName;
        self.topiceLabel.frame = CGRectMake(CGRectGetMaxX(_timeL.frame), _timeL.frame.origin.y,DR_SCREEN_WIDTH-CGRectGetMaxX(_timeL.frame)-15, 12);
    }else{
        self.topiceLabel.text = @"";
        self.topiceLabel.frame = CGRectMake(CGRectGetMaxX(_timeL.frame)+5, _timeL.frame.origin.y,0, 0);
    }
    //发布时间
    self.timeL.text = voiceM.created_at;
    self.nickNameL.text = voiceM.subUserModel.nick_name;
    

    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    
    self.playerView.timeLen = voiceM.nowTime.integerValue?voiceM.nowTime: voiceM.voice_len;
    self.playerView.voiceUrl = voiceM.voice_url;
    self.playerView.slieView.progress = voiceM.nowPro >0 ?voiceM.nowPro:0;
    
    //位置
    if (voiceM.voice_len.integerValue < 5) {
        self.playerView.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 130, 40);
    }else if (voiceM.voice_len.integerValue >= 5 && voiceM.voice_len.integerValue <= 105){
        self.playerView.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 130+voiceM.voice_len.integerValue, 40);
    }else if (voiceM.voice_len.integerValue >= 120){
        self.playerView.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 130+120, 40);
    }
    else{
        self.playerView.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, 130+voiceM.voice_len.integerValue, 40);
    }
    self.dragView.frame =  CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height);
    
    //文字滚动模块
    voiceM.contentLWidth = self.playerView.frame.size.width-self.playerView.frame.size.height*2-5;//文字可显示长度
    voiceM.overContentWidth = voiceM.contentWidth-voiceM.contentLWidth;//文字超出模块
    if (voiceM.voice_len.intValue && voiceM.overContentWidth > 0) {//当音频时长不为零并且超出可显示长度的时候计算速度
       voiceM.moveSpeed = voiceM.overContentWidth/voiceM.voice_len.intValue;//文字滚动速度
    }
    
    if (voiceM.contentStr) {
        self.playerView.textL.text = voiceM.contentStr;
        self.playerView.textL.hidden = NO;
    }
    
    self.playerView.textL.hidden = YES;// [NoticeTools isCotentOpen];
    
    self.playerView.contentWidth = voiceM.contentWidth;
    self.playerView.textL.textColor = [NoticeTools getWhiteColor:@"#BCFEFD" NightColor:@"#82B0AF"];
    if (!(voiceM.nowPro > 0)) {
        self.playerView.reBackFrame = YES;
    }
    
    if (voiceM.content_type.intValue == 2) {
        
    }else{
        [self.playerView refreWithFrame];
    }
    
    [self refreshFrameForSelfCell];
    self.imageViewS.hidden = (voiceM.img_list.count && voiceM.attr_type.intValue != 2) ? NO  : YES;
    if (!self.imageViewS.hidden) {
        self.imageViewS.imgArr = voiceM.img_list;
    }
    
    
    [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
    _rePlayView.hidden = voiceM.isPlaying? NO:YES;
    _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame),self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
    
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是自己，则是共享到世界，是别人则是「有启发」
        if (_voiceM.content_type.intValue == 1  && _voiceM.length_type.intValue == 2) {//长心情
            if (voiceM.is_private.boolValue) {
                self.buttonView.firstL.text = [NoticeTools getLocalStrWith:@"mineme.cancelonglyself"];
                self.buttonView.firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_justself_b":@"Image_justself_y");
            }else{
                self.buttonView.firstL.text = @"设为仅自己可见";
                self.buttonView.firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_nojustself_b":@"Image_nojustself_y");
            }
        }else{
            self.buttonView.firstImageView.image = GETUIImageNamed(@"shareNewButton");
            if (voiceM.is_shared.boolValue) {
                self.buttonView.firstL.text = GETTEXTWITE(@"voicelist.shanreback");
                self.buttonView.firstImageView.image = UIImageNamed(@"Imagebackfrom");
            }else{
                self.buttonView.firstL.text = @"共享到操场";
                self.buttonView.firstImageView.image = GETUIImageNamed(@"shareNewButton");
            }
        }

        if (voiceM.is_private.boolValue) {
            self.shareBtn.hidden = YES;
        }else{
            self.shareBtn.hidden = _voiceM.content_type.intValue == 1?NO:YES;
        }
        
    }else{
        self.shareBtn.hidden = YES;
        self.buttonView.firstL.text = [NoticeTools getTextWithSim:@"有启发" fantText:@"有啟發"];
        self.buttonView.firstImageView.image =  GETUIImageNamed(voiceM.is_collected.boolValue? @"like_select" : @"like_default_yebtn");
    }

    [self.contentView bringSubviewToFront:self.topiceLabel];
    
    //对话或者悄悄话数量
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue) {
            [self.buttonView.replyBytton setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"voicelist.backVoice"),_voiceM.chat_num] forState:UIControlStateNormal];
        }else{
            [self.buttonView.replyBytton setTitle:GETTEXTWITE(@"voicelist.backVoice") forState:UIControlStateNormal];
        }
    }else{
        if (_voiceM.dialog_num.integerValue) {
            [self.buttonView.replyBytton setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"chat.duihua"),_voiceM.dialog_num] forState:UIControlStateNormal];
        }else{
            [self.buttonView.replyBytton setTitle:GETTEXTWITE(@"voicelist.backVoice") forState:UIControlStateNormal];
        }
    }
    [_movieView refreshUI];
    if (_voiceM.content_type.intValue == 2) {
        _listenL.hidden = YES;
        _topiceButton.hidden = YES;
    }
}

- (void)refreshFrameForSelfCell{
    self.playerView.hidden = _voiceM.content_type.intValue == 2?YES:NO;
    
    self.markPlayImageView.hidden = self.playerView.hidden;
    self.listenL.hidden = self.playerView.hidden;
    self.topiceButton.hidden = self.listenL.hidden;
    self.textContentLabel.hidden = !self.playerView.hidden;
    
    if (_voiceM.titleHeight > 0) {
        self.titleL.hidden = NO;
    }else{
        self.titleL.hidden = YES;

    }
    self.titleL.text = _voiceM.title;
    self.titleL.textColor = GetColorWithName(VMainTextColor);
    if (self.textContentLabel.hidden) {
        if (_voiceM.img_list.count == 1) {
            self.imageViewS.frame = CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*0.448);
        }else if (_voiceM.img_list.count == 2){
            self.imageViewS.frame = CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*0.373);
        }else{
            self.imageViewS.frame = CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-46)/3);
        }
        self.movieView.frame = CGRectMake(15, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH-30, 83);

        if (_voiceM.resource) {
            self.buttonView.frame = CGRectMake(0, CGRectGetMaxY(_playerView.frame)+83+15+10, DR_SCREEN_WIDTH,self.isSmallLine ?51: 58);
        }else if (_voiceM.img_list.count){
            self.buttonView.frame = CGRectMake(0, CGRectGetMaxY(_imageViewS.frame), DR_SCREEN_WIDTH,self.isSmallLine ?51: 58);
        }else{
            self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(_playerView.frame), DR_SCREEN_WIDTH,self.isSmallLine ?51: 58);
        }
        
        if (_voiceM.img_list.count && _voiceM.attr_type.intValue == 2) {
            self.player.hidden = NO;
            self.player.frame = CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH*0.448, DR_SCREEN_WIDTH*0.448);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                self.player.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_voiceM.img_list[0]]];
                self.player.player = [AVPlayer playerWithPlayerItem:self.player.playerItem];
                self.player.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player.player];
            });

        }else{
            _player.hidden = YES;
        }
    }else{
        //心情文字
        if (_voiceM.content_type.intValue == 2) {
            if (!self.isNeedAllContent) {//如果不需要显示全部文案
                self.textContentLabel.attributedText = _voiceM.isMoreFiveLines?_voiceM.fiveAttTextStr:_voiceM.allTextAttStr;
            }else{
                self.textContentLabel.attributedText = _voiceM.allTextAttStr;
            }
        }
        CGFloat textHeightShow;
        if (self.isNeedAllContent) {
            textHeightShow = _voiceM.textHeight;
        }else{
            textHeightShow = _voiceM.isMoreFiveLines?_voiceM.fiveTextHeight:_voiceM.textHeight;
        }
        if (_voiceM.titleHeight > 0) {
            _textContentLabel.frame = CGRectMake(15, CGRectGetMaxY(_titleL.frame), DR_SCREEN_WIDTH-30, textHeightShow);
        }else{
            _textContentLabel.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+15, DR_SCREEN_WIDTH-30, textHeightShow);
        }
        
        if (_voiceM.img_list.count == 1) {
            self.imageViewS.frame = CGRectMake(0, CGRectGetMaxY(_textContentLabel.frame)+15, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*0.448);
        }else if (_voiceM.img_list.count == 2){
            self.imageViewS.frame = CGRectMake(0, CGRectGetMaxY(_textContentLabel.frame)+15, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*0.373);
        }else{
            self.imageViewS.frame = CGRectMake(0, CGRectGetMaxY(_textContentLabel.frame)+15, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-46)/3);
        }
        self.movieView.frame = CGRectMake(15, CGRectGetMaxY(_textContentLabel.frame)+15, DR_SCREEN_WIDTH-30, 83);

        if (_voiceM.img_list.count && _voiceM.attr_type.intValue == 2) {
            self.player.hidden = NO;
            self.player.frame = CGRectMake(0, CGRectGetMaxY(_textContentLabel.frame)+15, DR_SCREEN_WIDTH*0.448, DR_SCREEN_WIDTH*0.448);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                self.player.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_voiceM.img_list[0]]];
                self.player.player = [AVPlayer playerWithPlayerItem:self.player.playerItem];
                self.player.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player.player];
            });

        }else{
            _player.hidden = YES;
        }
        
        if (_voiceM.resource) {
            self.buttonView.frame = CGRectMake(0, CGRectGetMaxY(_textContentLabel.frame)+83+15+10, DR_SCREEN_WIDTH,self.isSmallLine ?51: 58);
        }else if (_voiceM.img_list.count){
            self.buttonView.frame = CGRectMake(0, CGRectGetMaxY(_imageViewS.frame), DR_SCREEN_WIDTH,self.isSmallLine ?51: 58);
        }else{
            self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(_textContentLabel.frame), DR_SCREEN_WIDTH,self.isSmallLine ?51: 58);
        }
    }
}

//点击文本
- (void)tapTextL{
    if (self.isNeedAllContent || !_voiceM.isMoreFiveLines) {
        return;
    }
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeBackVoiceViewController *ctl = [[NoticeBackVoiceViewController alloc] init];
        ctl.voiceM = _voiceM;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlay)]) {
            [self.delegate stopPlay];
        }
        
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        NoticeChatWithOtherViewController *ctl = [[NoticeChatWithOtherViewController alloc] init];
        ctl.voiceM = _voiceM;
        ctl.noNeedGetVoiceM = YES;
        ctl.identType = _voiceM.subUserModel.identity_type;
        ctl.chatId = _voiceM.chat_id;
        ctl.userId = _voiceM.subUserModel.userId;
        ctl.toUserName = _voiceM.subUserModel.nick_name;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

//点击话题
- (void)topicTextClick{
    
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlay)]) {
            [self.delegate stopPlay];
        }
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

//点击欣赏或者取消欣赏
- (void)guanzhuClick{
    if (_voiceM.be_subscribed.integerValue) {
        [self clickGuanzhu];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }

    NSString *tostStr = nil;
    if ([_voiceM.resource_type isEqualToString:@"1"]) {
        tostStr = [NoticeTools isSimpleLau]?@"欣赏成功! 在「电影社」广场页收听":@"關註成功! 在「电影社」廣場頁收聽";
    }else if ([_voiceM.resource_type isEqualToString:@"2"]){
        tostStr = [NoticeTools isSimpleLau]?@"欣赏成功! 在「读书社」广场页收听":@"關註成功! 在「讀書社」廣場頁收聽";
    }else if ([_voiceM.resource_type isEqualToString:@"3"]){
        tostStr = [NoticeTools isSimpleLau]?@"欣赏成功! 在「音乐社」广场页收听":@"關註成功! 在「音乐社」廣場頁收聽";
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self->_voiceM.voice_id forKey:@"voiceId"];
    [parm setObject:self->_voiceM.user_id forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"userSubscription" Accept:@"application/vnd.shengxi.v4.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self->_voiceM.be_subscribed = dict[@"data"][@"id"];
            self->_bookLikeBtn.backgroundColor = GetColorWithName(VlistColor);
            [self->_bookLikeBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"intro.yilike"]:@"已關註" forState:UIControlStateNormal];
            [self->_bookLikeBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            self->_bookLikeBtn.layer.borderWidth = 0;
            [nav.topViewController showToastWithText:tostStr];
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}

- (void)clickGuanzhu{
    if (_voiceM.be_subscribed.integerValue) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        NSString *subsId = _voiceM.be_subscribed;
        NSString *str = nil;
        if ([_voiceM.resource_type isEqualToString:@"1"]) {
            str = [NoticeTools isSimpleLau]?@"确定取消欣赏Ta的电影心情吗?":@"確定取消關註Ta的电影心情嗎?";
        }else if ([_voiceM.resource_type isEqualToString:@"2"]){
            str = [NoticeTools isSimpleLau]?@"确定取消欣赏Ta的书籍心情吗?":@"確定取消關註Ta的書籍心情嗎?";
        }else if ([_voiceM.resource_type isEqualToString:@"3"]){
            str = [NoticeTools isSimpleLau]?@"确定取消欣赏Ta的音乐心情吗?":@"確定取消關註Ta的音乐心情嗎?";
        }
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"main.sure"]:@"確定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"]];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"userSubscription/%@",subsId] Accept:@"application/vnd.shengxi.v4.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(noGuanzhuSuccess:)]) {
                            [self.delegate noGuanzhuSuccess:self.index];
                        }
                        self->_voiceM.be_subscribed = @"0";
                        [self->_bookLikeBtn setTitle:[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"minee.xs"]:@"關註" forState:UIControlStateNormal];
                        self->_bookLikeBtn.backgroundColor = GetColorWithName(VBackColor);
                        [self->_bookLikeBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
                        self->_bookLikeBtn.layer.borderWidth = 1;
                        [nav.topViewController showToastWithText:[NoticeTools isSimpleLau]?@"已取消欣赏":@"已取消關註"];
                    }
                } fail:^(NSError * _Nullable error) {
                    
                }];
            }
        };
        
        [alerView showXLAlertView];
    }else{
        [self guanzhuClick];
    }
    
}

//添加好友
- (void)addFriend{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }

    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:_voiceM.user_id forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/friendslog",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            self->_voiceM.friend_status = @"1";
            [self.topiceButton removeTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
            [self.topiceButton setTitle:@"等待验证" forState:UIControlStateNormal];
            [self.topiceButton setTitleColor:[NoticeTools isWhiteTheme]?[UIColor colorWithHexString:@"#b2b2b2"]:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            [NoticeAddFriendTools addFriendWithUserId:self->_voiceM.user_id];
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}

//点击共鸣或者共享到世界
- (void)shareAndLikeClick{
    //判断是否是自己,不是自己则为点击「有启发」
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        if (_voiceM.is_collected.boolValue) {//取消「有启发」
            if (_voiceM.canTapLike) {//防止多次点击
                return;
            }
            _voiceM.likeNoMove = YES;
            _voiceM.is_collected = @"0";
            [self.buttonView.firstImageView popInsideWithDuration:0.4];
            self.buttonView.firstImageView.image = GETUIImageNamed(@"like_default_yebtn");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelCollectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
            _voiceM.canTapLike = YES;
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                self->_voiceM.canTapLike = NO;
                self->_voiceM.is_collected = @"0";
                
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
            }];
        }else{//「有启发」
            if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
                return;
            }
            if (_voiceM.canTapLike) {
                return;
            }
            [self.buttonView.firstImageView popInsideWithDuration:0.5];
            self.buttonView.firstImageView.image = GETUIImageNamed(@"like_select");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
            _voiceM.is_collected = @"1";
            _voiceM.canTapLike = YES;
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"5" forKey:@"needDelay"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                self->_voiceM.canTapLike = NO;
                self->_voiceM.is_collected = @"1";

            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
                [nav.topViewController hideHUD];
            }];
        }
        return;
    }
    if (_voiceM.content_type.intValue == 1 && _voiceM.length_type.intValue == 2) {
        if (_voiceM.is_private.boolValue) {
            [self setPri:_voiceM];
            return;
        }
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:GETTEXTWITE(@"sx.justself") message:GETTEXTWITE(@"sx.justinfo") sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf setPri:self->_voiceM];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    [self.shareWorld shareToWorldWitn:_voiceM];

}

- (void)setPri:(NoticeVoiceListModel *)model{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:model.is_private.integerValue ? @"0" : @"1" forKey:@"privateStatus"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/voices/%@",[[NoticeSaveModel getUserInfo] user_id],model.voice_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if (model.is_private.integerValue) {
                model.is_private = @"0";
                [nav.topViewController showToastWithText:@"已取消仅自己可见"];
            }else{
                model.is_private = @"1";
                [nav.topViewController showToastWithText:@"已设置为仅自己可见"];
            }
            if (model.content_type.intValue == 1  && model.length_type.intValue == 2) {//长心情
                if (model.is_private.boolValue) {
                    self.buttonView.firstL.text = [NoticeTools getLocalStrWith:@"mineme.cancelonglyself"];
                    self.buttonView.firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_justself_b":@"Image_justself_y");
                }else{
                    self.buttonView.firstL.text = @"设为仅自己可见";
                    self.buttonView.firstImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_nojustself_b":@"Image_nojustself_y");
                }
            }else{
                self.buttonView.firstImageView.image = GETUIImageNamed(@"shareNewButton");
                if (model.is_shared.boolValue) {
                    self.buttonView.firstL.text = GETTEXTWITE(@"voicelist.shanreback");
                    self.buttonView.firstImageView.image = UIImageNamed(@"Imagebackfrom");
                }else{
                    self.buttonView.firstL.text = @"共享到操场";
                    self.buttonView.firstImageView.image = GETUIImageNamed(@"shareNewButton");
                }
            }
            
            if (model.is_private.integerValue) {
                self.shareBtn.hidden = model.content_type.intValue == 1?NO:YES;
            }else{
                self.shareBtn.hidden = YES;
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

//共享或者取消共享成功回调
- (void)shareToWorldSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickShareWith:)]) {//共享点击
        [self.delegate hasClickShareWith:self.index];
    }
}

//点击更多
- (void)moreClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickMoreWith:)]) {//更多点击
        [self.delegate hasClickMoreWith:self.index];
    }
    
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        [self.pinbTools pinbiWithModel:_voiceM];
       
    }
}

//屏蔽成功回调
- (void)pinbiSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherPinbSuccess)]) {
        [self.delegate otherPinbSuccess];
    }
}

//点击悄悄话
- (void)replayClick:(UIButton *)button{
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeBackVoiceViewController *ctl = [[NoticeBackVoiceViewController alloc] init];
        ctl.voiceM = _voiceM;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlay)]) {
            [self.delegate stopPlay];
        }
        
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        button.enabled = NO;
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        if (!_voiceM.dialog_num.integerValue) {//没有对话过，则为执行对话，否则进入对话列表

            if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickReplyWith:)]) {
                [self.delegate hasClickReplyWith:self.index];
            }
            [[DRNetWorking shareInstance] requestCheckPathWith:[NSString stringWithFormat:@"chats/check/%@/1/%@",_voiceM.subUserModel.userId,_voiceM.voice_id] Accept:@"application/vnd.shengxi.v4.6.3+json" success:^(NSDictionary * _Nullable dict, BOOL success) {
                button.enabled = YES;
                if (success) {
                    NoticeNoticenterModel *autoM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
                    
                    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:GETTEXTWITE(@"chat.limit")];
                    recodeView.isHS = YES;
                    if (![dict[@"data"][@"chat_hobby"] isEqual:[NSNull null]]) {
                        NoticrChatLike *autoM1 = [NoticrChatLike mj_objectWithKeyValues:dict[@"data"][@"chat_hobby"]];
                        if ([autoM1.likeId isEqualToString:@"1"]) {
                            recodeView.isShort = YES;
                        }else if ([autoM1.likeId isEqualToString:@"2"]){
                            recodeView.isLong = YES;
                        }
                    }
                    if (autoM.chat_tips.count) {
                        NSString *str1 = @"";
                        for (NSDictionary *dic in autoM.chat_tips) {
                            NoticrChatLike *likeM = [NoticrChatLike mj_objectWithKeyValues:dic];
                            str1 = [NSString stringWithFormat:@"%@,%@",likeM.name,str1];
                        }
                        if (autoM.chat_tips.count == 2) {
                            str1 = @"NO联系方式·NO查户口";
                        }
                        if ([[str1 substringFromIndex:str1.length-1] isEqualToString:@","]) {
                            str1 = [str1 substringToIndex:str1.length-1];
                        }
                        recodeView.chatTips = str1;
                    }
                    __weak typeof(self) weakSelf = self;
                    recodeView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId) {
                        NSMutableDictionary *sendDic = [NSMutableDictionary new];
                        [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self->_voiceM.subUserModel.userId] forKey:@"to"];
                        [sendDic setObject:@"singleChat" forKey:@"flag"];
                        NSMutableDictionary *messageDic = [NSMutableDictionary new];
                        [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
                        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
                        [messageDic setObject:@"2" forKey:@"dialogContentType"];
                        [messageDic setObject:url forKey:@"dialogContentUri"];
                        [messageDic setObject:@"0" forKey:@"dialogContentLen"];
                        [messageDic setObject:@"" forKey:@"dialogContentText"];
                        [sendDic setObject:messageDic forKey:@"data"];
                        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [appdel.socketManager sendMessage:sendDic];
                        self->_voiceM.dialog_num = [NSString stringWithFormat:@"%ld",self->_voiceM.dialog_num.integerValue + 1];
                        [weakSelf.buttonView.replyBytton setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"chat.duihua"),self->_voiceM.dialog_num] forState:UIControlStateNormal];
                        
                        [weakSelf gotoChatView];
                    };
                    
                    recodeView.needLongTap = YES;
                    recodeView.hideCancel = NO;
                    recodeView.isAuto = autoM.auto_reply.integerValue ? YES : NO;
                    recodeView.delegate = self;
                    recodeView.isReply = YES;
                    recodeView.iconUrl = self->_voiceM.subUserModel.avatar_url;
                    [recodeView show];
                }else{
                    NSString *errorMessage = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:errorMessage message:nil cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];
                    [alerView showXLAlertView];
                }
            } fail:^(NSError * _Nullable error) {
                button.enabled = YES;
            }];

        }else{
            button.enabled = YES;
            [self gotoChatView];
        }
    }
}

- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.isReply = YES;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.voiceM.subUserModel.nick_name];
    inputView.delegate = self;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if ([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.voiceM.subUserModel.nick_name]) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.voiceM.subUserModel.nick_name], 0.9) path:pathMd5 text:str];
    }
}
- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    __weak typeof(self) weakSelf = self;
   // [_topController showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self->_voiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
            [messageDic setObject:text forKey:@"dialogContentText"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            self->_voiceM.dialog_num = [NSString stringWithFormat:@"%ld",self->_voiceM.dialog_num.integerValue + 1];
            [weakSelf.buttonView.replyBytton setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"chat.duihua"),self->_voiceM.dialog_num] forState:UIControlStateNormal];
            //[self->_topController hideHUD];
            
            [weakSelf gotoChatView];
            
        }else{
           // [self->_topController hideHUD];
           // [self->_topController showToastWithText:errorMessage];
        }
    }];
}

//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    __weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self->_voiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [nav.topViewController hideHUD];
            self->_voiceM.dialog_num = [NSString stringWithFormat:@"%ld",self->_voiceM.dialog_num.integerValue + 1];
            [weakSelf.buttonView.replyBytton setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"chat.duihua"),self->_voiceM.dialog_num] forState:UIControlStateNormal];
            [nav.topViewController showToastWithText:@"悄悄话已发布"];
            
            [weakSelf gotoChatView];
        }else{
            [nav.topViewController showToastWithText:Message];
            [nav.topViewController hideHUD];
        }
    }];
}

- (void)gotoChatView{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    NoticeChatWithOtherViewController *ctl = [[NoticeChatWithOtherViewController alloc] init];
    ctl.voiceM = _voiceM;
    ctl.noNeedGetVoiceM = YES;
    ctl.identType = _voiceM.subUserModel.identity_type;
    //ctl.noPush = YES;
    ctl.chatId = _voiceM.chat_id;
    ctl.userId = _voiceM.subUserModel.userId;
    ctl.toUserName = _voiceM.subUserModel.nick_name;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
}

//点击头像
- (void)userInfoTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(stopPlay)]) {
        [self.delegate stopPlay];
    }
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        
        NoticeMineViewController *ctl = [[NoticeMineViewController alloc] init];
        ctl.isFromOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _voiceM.user_id;
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)changeColor{
    [_shareBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sharegroup_b":@"Image_sharegroup_y") forState:UIControlStateNormal];
    self.markPlayImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_playmark_b":@"Image_playmark_y");
    self.backgroundColor = GetColorWithName(@"BackColor");
    _listenL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#b2b2b2":@"#3e3e4a"];
    _listenL.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FAFAFA":@"#222238"];
    // _topiceButton.layer.borderColor = GetColorWithName(VDarkTextColor).CGColor;
    _topiceButton.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FAFAFA":@"#222238"];
    [_topiceButton setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
    _timeL.textColor = GetColorWithName(VDarkTextColor);
    _nickNameL.textColor = GetColorWithName(VMainTextColor);
    self.textContentLabel.textColor = GetColorWithName(VMainTextColor);
    [self refreshFrameForSelfCell];
    [_movieView refreshUI];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
