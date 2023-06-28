//
//  NoticeRecoderTryListenView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeRecoderTryListenView.h"

@implementation NoticeRecoderTryListenView
{
    NSOperationQueue *soundTouchQueue;
    AVAudioPlayer *audioPalyer;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        backImageView.image = UIImageNamed(@"Image_backRecoderimg");
        [self addSubview:backImageView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,STATUS_BAR_HEIGHT, 60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 32)];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.font = [UIFont systemFontOfSize:32];
        self.timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.timeL];
        self.timeL.center = CGPointMake(self.center.x, self.center.y-16-190);
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-160)/2, CGRectGetMaxY(self.timeL.frame)+30, 160, 160)];
        [self.playButton addTarget:self action:@selector(playLocaClick) forControlEvents:UIControlEventTouchUpInside];
        self.playButton.layer.cornerRadius = 80;
        self.playButton.layer.masksToBounds = YES;
        
        
        HWCircleView *circleView = [[HWCircleView alloc] initWithFrame:CGRectMake(self.playButton.frame.origin.x-15, self.playButton.frame.origin.y-15,190, 190)];
        circleView.width = 6;
        [self addSubview:circleView];
        self.progressView = circleView;
        
        [self addSubview:self.playButton];
        
        UIButton *reBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-48, (DR_SCREEN_WIDTH-60)/2, 48)];
        [reBtn setTitle:[NoticeTools getLocalStrWith:@"recoder.rere"] forState:UIControlStateNormal];
        [reBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        reBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        reBtn.layer.cornerRadius = 8;
        reBtn.layer.masksToBounds = YES;
        reBtn.layer.borderWidth = 1;
        reBtn.layer.borderColor = [UIColor colorWithHexString:@"#5C5F66"].CGColor;
        [self addSubview:reBtn];
        [reBtn addTarget:self action:@selector(reClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(reBtn.frame)+20,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-48, (DR_SCREEN_WIDTH-60)/2, 48)];
        [nextBtn setTitle:[NoticeTools getLocalStrWith:@"photo.next"] forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        nextBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        nextBtn.layer.cornerRadius = 8;
        nextBtn.layer.masksToBounds = YES;
        nextBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self addSubview:nextBtn];
        [nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.voiceTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-170)/2, CGRectGetMaxY(self.playButton.frame)+40, 135, 30)];
        self.voiceTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
        [self.voiceTypeBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        self.voiceTypeBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [self addSubview:self.voiceTypeBtn];
        [self.voiceTypeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
        self.voiceTypeBtn.layer.cornerRadius = 2;
        [self.voiceTypeBtn setTitle:[NoticeTools getLocalStrWith:@"ly.bsleix"] forState:UIControlStateNormal];
        self.voiceTypeBtn.layer.masksToBounds = YES;
        
        self.changeTypeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.voiceTypeBtn.frame), self.voiceTypeBtn.frame.origin.y, 35, 30)];
        self.changeTypeL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.changeTypeL.font = TWOTEXTFONTSIZE;
        self.changeTypeL.text = [NoticeTools getLocalStrWith:@"luy.change"];
        self.changeTypeL.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.changeTypeL];
        self.changeTypeL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeClick)];
        [self.changeTypeL addGestureRecognizer:tap];
        
        soundTouchQueue = [[NSOperationQueue alloc] init];
        soundTouchQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)setIsLead:(BOOL)isLead{
    _isLead = isLead;
    if (isLead) {
        self.clickFinishImageView.hidden = NO;
        self.clickFinishImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-144, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-48-100-30, 144, 97);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickFinishImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-144, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-48-100, 144, 97);
        } completion:nil];
    }
}

- (UIImageView *)clickFinishImageView{
    if (!_clickFinishImageView) {
        _clickFinishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-144, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-48-100, 144, 97)];
        _clickFinishImageView.image = UIImageNamed(@"Image_recoderFinish11");
        [self addSubview:_clickFinishImageView];
        _clickFinishImageView.hidden = YES;
    }
    return _clickFinishImageView;
}


- (void)changeClick{
    [self.voicePlayer stopPlaying];
    self.changeView.locaPath = self.locaPath;
    [self.changeView show];
}

- (NoticeChangeVoiceView *)changeView{
    if (!_changeView) {
        _changeView = [[NoticeChangeVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _changeView.typeModelBlock = ^(NoticeVoiceTypeModel * _Nonnull model) {
            weakSelf.vocieTypeM = model;
        };
        _changeView.newVoiceBlock = ^(NSString * _Nonnull path, NSString * _Nonnull timeLen) {
            weakSelf.timeLen = timeLen;
            weakSelf.currentPath = path;
            weakSelf.timeL.text = [NSString stringWithFormat:@"%@s",weakSelf.timeLen];
        };
    }
    return _changeView;
}

- (void)playLocaClick{
    if (self.rePlay) {
        self.rePlay = NO;
        [self.voicePlayer stopPlaying];
        self.isPause = YES;
    }
    
    self.isPause = !self.isPause;
    __weak typeof(self) weakSelf = self;

    if (!self.isPause) {
        [self.playButton setImage:UIImageNamed(@"ly_zantingplay") forState:UIControlStateNormal];
        if (!self.isPlaying) {//判断是否在播放
            [self.voicePlayer startPlayWithUrl:self.currentPath isLocalFile:YES];
        }else{
            [self.voicePlayer pause:NO];
        }
        
        self.voicePlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            weakSelf.isPlaying = YES;
        };
        
        self.voicePlayer.playComplete = ^{//音频播放完成
            weakSelf.isPause = YES;
            weakSelf.progressView.progress = 0;
            weakSelf.isPlaying = NO;
            weakSelf.timeL.text = [NSString stringWithFormat:@"%@s",weakSelf.timeLen];
            [weakSelf.playButton setImage:UIImageNamed(@"ly_playLocal") forState:UIControlStateNormal];
        };
        
        self.voicePlayer.playingBlock = ^(CGFloat currentTime) {
            NSString *str = [NSString stringWithFormat:@"%@s",[NSString stringWithFormat:@"%.f",weakSelf.timeLen.integerValue-currentTime]];
            if (weakSelf.timeLen.integerValue - currentTime <= 0) {
                str = @"0s";
            }
            weakSelf.progressView.progress = currentTime/self.timeLen.floatValue;
            weakSelf.timeL.text= str;
        };
        
    }else{
        [weakSelf.playButton setImage:UIImageNamed(@"ly_playLocal") forState:UIControlStateNormal];
        [self.voicePlayer pause:self.isPause];
    }
}

- (void)setVocieTypeM:(NoticeVoiceTypeModel *)vocieTypeM{
    _vocieTypeM = vocieTypeM;
    [self.voiceTypeBtn setTitle:[NSString stringWithFormat:@"%@：%@",[NoticeTools getLocalStrWith:@"ly.typevoice"],vocieTypeM.typeName] forState:UIControlStateNormal];
}

- (void)playEditVoice{
    [self.showView show];

    NSString *filePath = self.locaPath;
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    MySountTouchConfig config;
    config.sampleRate = self.vocieTypeM.cRate;
    config.tempoChange = self.vocieTypeM.speed;
    config.pitch = self.vocieTypeM.fenbei;
    config.rate = self.vocieTypeM.rate;
    
    SoundTouchOperation *sdop = [[SoundTouchOperation alloc] initWithTarget:self
                                                                     action:@selector(soundMusicFinish:)
                                                           SoundTouchConfig:config soundFile:data];
    [soundTouchQueue cancelAllOperations];
    [soundTouchQueue addOperation:sdop];
}
    
#pragma mark - 处理音频文件结束
- (void)soundMusicFinish:(NSString *)path {
    NSURL *url = [NSURL URLWithString:path];
    [self.showView disMiss];
    audioPalyer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.timeLen = [NSString stringWithFormat:@"%.f",audioPalyer.duration];
    self.currentPath = path;
    self.timeL.text = [NSString stringWithFormat:@"%@s",self.timeLen];
}


- (void)reClick{
    [self.voicePlayer stopPlaying];
    [self removeFromSuperview];
    if (self.actionBlock) {
        self.actionBlock(1, @"", @"");
    }
}

- (void)nextClick{
    [self.voicePlayer stopPlaying];
    [self removeFromSuperview];
    if (self.actionBlock) {
        self.actionBlock(2, self.timeLen, self.currentPath);
    }
}

- (void)setLocaPath:(NSString *)locaPath{
    _locaPath = locaPath;
    self.currentPath = locaPath;
}

- (void)cancelClick{
    [self.voicePlayer stopPlaying];
    if (self.actionBlock) {
        self.actionBlock(0, @"", @"");
    }
}

- (void)show{
    self.rePlay = YES;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    self.progressView.progress = 0;
    [self.playButton setBackgroundImage:UIImageNamed(@"ly_playLocal") forState:UIControlStateNormal];
    if (self.vocieTypeM.type != 0) {
        [self playEditVoice];
    }else{
        self.timeL.text = [NSString stringWithFormat:@"%@s",self.timeLen];
    }
    
    if (self.isLead) {
        self.clickFinishImageView.hidden = NO;
        self.clickFinishImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-144, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-48-100-30, 144, 97);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickFinishImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-144, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-48-100, 144, 97);
        } completion:nil];
    }
}

- (NoticeActShowView *)showView{
    if (!_showView) {
        _showView = [[NoticeActShowView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }

    return _showView;
}
- (LGAudioPlayer *)voicePlayer
{
    if (!_voicePlayer) {
        _voicePlayer = [[LGAudioPlayer alloc] init];
   
    }
    return _voicePlayer;
}


@end
