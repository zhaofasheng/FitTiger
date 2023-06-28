//
//  NoticeSayToSelfCell.m
//  NoticeXi
//
//  Created by li lei on 2021/4/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSayToSelfCell.h"

@implementation NoticeSayToSelfCell
{
    UIView *_playView;//播放点击
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 70)];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.backView];
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(15,38,70, 17)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:_timeL];
        
        _dateL = [[UILabel alloc] initWithFrame:CGRectMake(15,15,150, 20)];
        _dateL.font = XGFourthBoldFontSize;
        _dateL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_dateL];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-20-120,19, 120, 32)];
        self.playerView.isThird = YES;
        [_playerView.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [self.backView addSubview:_playerView];
        
        self.playerView.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.3];
        self.playerView.slieView.trackTintColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.3];
        self.playerView.slieView.progressTintColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.3];
        self.playerView.leftView.backgroundColor = [self.playerView.backgroundColor colorWithAlphaComponent:0];
        self.playerView.rightView.backgroundColor = [self.playerView.backgroundColor colorWithAlphaComponent:0];
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(-15, -3,_playerView.frame.size.height+15+5, _playerView.frame.size.height+6)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
       
        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
        self.dragView.userInteractionEnabled = YES;
        self.dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
        [self.playerView addSubview:self.dragView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.0;
        [self.dragView addGestureRecognizer:longPress];

        self.playerView.playButton.frame = CGRectMake(5, (self.playerView.frame.size.height-20)/2, 20, 20);
        
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longDleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDeleteVoice:)];
        longDleTap.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longDleTap];
    }
    return self;
}

- (void)longDeleteVoice:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (!self.needLongTap) {
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"groupManager.del"],[NoticeTools getLocalStrWith:@"em.yd"]]];
            sheet.delegate = self;
            [sheet show];
            break;
        }
        default:
            break;
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVoiceWithModel:)]) {
            [self.delegate deleteVoiceWithModel:self.sayModel];
        }
    }else if(buttonIndex == 2){
        if (self.delegate && [self.delegate respondsToSelector:@selector(moveVoiceWithModel:)]) {
            [self.delegate moveVoiceWithModel:self.sayModel];
        }
    }
}

- (void)setSayModel:(NoticeSayToSelf *)sayModel{
    _sayModel = sayModel;
    self.dateL.text = sayModel.day;
    self.timeL.text = sayModel.hour;
    
    self.playerView.timeLen = sayModel.nowTime.integerValue?sayModel.nowTime: sayModel.note_len;
    self.playerView.voiceUrl = sayModel.note_url;
    self.playerView.slieView.progress = sayModel.nowPro >0 ?sayModel.nowPro:0;

    [self.playerView refreWithFrame];
    
    
    if(self.isDiaLog){
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (sayModel.isPlaying) {
            _timeL.textColor = [UIColor colorWithHexString:@"#0099E6"];
            _dateL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        }else{
            _timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            _dateL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        
        if (appdel.alphaValue >0 && appdel.alphaValue < 0.9) {
            self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.0];
            self.backView.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.2];
        }else{
            self.backView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
            self.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        }
    }else{
        if (sayModel.isPlaying) {
            _timeL.textColor = [UIColor colorWithHexString:@"#0099E6"];
            _dateL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        }else{
            _timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            _dateL.textColor = [UIColor colorWithHexString:@"#25262E"];
        }
    }
}
//点击播放
- (void)playNoReplay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userstartPlayAndStop:)]) {
        [self.delegate userstartPlayAndStop:self.index];
    }
}

- (void)longPressGestureRecognized:(id)sender{

    if (!_sayModel.isPlaying) {
        return;
    }
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];

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

    if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index:)]) {
 
        [self.delegate dragingFloat:(_sayModel.note_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
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
