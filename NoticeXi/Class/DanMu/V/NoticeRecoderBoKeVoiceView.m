//
//  NoticeRecoderBoKeVoiceView.m
//  NoticeXi
//
//  Created by li lei on 2022/9/23.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeRecoderBoKeVoiceView.h"
#import "NoticeChangeVoiceView.h"
@implementation NoticeRecoderBoKeVoiceView
{
    UILabel *_dianL;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        UILabel *backL = [[UILabel alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT, 100, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        backL.font = EIGHTEENTEXTFONTSIZE;
        backL.textColor = [UIColor colorWithHexString:@"#25262E"];
        backL.text = [NoticeTools chinese:@"退出" english:@"Quit" japan:@"終了する"];
        backL.userInteractionEnabled = YES;
        [self addSubview:backL];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
        [backL addGestureRecognizer:tap];
                
        NSInteger width = GET_STRWIDTH(@"00", 32, 50)+4;
        
        self.minL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-26-width*2)/2,NAVIGATION_BAR_HEIGHT+25, width,50)];
        self.minL.font = THIRTTYBoldFontSize;
        self.minL.text = @"00";
        self.minL.layer.cornerRadius = 8;
        self.minL.layer.masksToBounds = YES;
        self.minL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.minL];
        
        UILabel *pointL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minL.frame), self.minL.frame.origin.y, 26, 50)];
        pointL.text = @":";
        pointL.textAlignment = NSTextAlignmentCenter;
        pointL.font = THIRTTYBoldFontSize;
        pointL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:pointL];
        _dianL = pointL;
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pointL.frame),NAVIGATION_BAR_HEIGHT+25, width,50)];
        self.timeL.font = THIRTTYBoldFontSize;
        self.timeL.text = @"00";
        self.timeL.layer.cornerRadius = 8;
        self.timeL.layer.masksToBounds = YES;
        self.timeL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeL];
        
        _dianL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.minL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.minL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.timeL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-234)/2,CGRectGetMaxY(self.timeL.frame)+10, 234, 16)];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        self.markL.text =  [NoticeTools getLocalStrWith:@"recoder.600"];
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:self.markL];
        
        //动画视图
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.markL.frame)+20, DR_SCREEN_WIDTH-40, 200)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        
        self.recodBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-100-71, DR_SCREEN_WIDTH, 171)];
        [self addSubview:self.recodBtnView];
        self.recodBtnView.backgroundColor = self.backgroundColor;
        
        //录制按钮
        self.recodImageView = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-71)/2, 0, 71, 71)];
        [self.recodImageView setBackgroundImage:UIImageNamed(@"bkReco_Image") forState:UIControlStateNormal];
        self.recodImageView.layer.cornerRadius = 71/2;
        self.recodImageView.layer.masksToBounds = YES;
        [self.recodBtnView addSubview:self.recodImageView];
        [self.recodImageView addTarget:self action:@selector(startOrStop) forControlEvents:UIControlEventTouchUpInside];
        
        self.reingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.recodImageView.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 71, 14)];
        self.reingLabel.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.reingLabel.font = [UIFont systemFontOfSize:10];
        self.reingLabel.textAlignment = NSTextAlignmentCenter;
        self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.clickluy"];
        [self.recodBtnView addSubview:self.reingLabel];
                
        //确定按钮
        self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.recodImageView.frame)+40,self.recodImageView.frame.origin.y+8, 56, 56)];
        [self.sureBtn setBackgroundImage:UIImageNamed(@"bkRecoFin_Image") forState:UIControlStateNormal];
        [self.sureBtn addTarget:self action:@selector(sureUp) forControlEvents:UIControlEventTouchUpInside];
        [self.recodBtnView addSubview:self.sureBtn];
        self.sureBtn.hidden = YES;
        
        self.sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sureBtn.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 56, 14)];
        self.sureLabel.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.sureLabel.font = [UIFont systemFontOfSize:10];
        self.sureLabel.textAlignment = NSTextAlignmentCenter;
        self.sureLabel.text = [NoticeTools getLocalStrWith:@"groupfm.finish"];
        self.sureLabel.hidden = YES;
        [self.recodBtnView addSubview:self.sureLabel];
        
        //删除重录按钮
        self.reRecoderBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.recodImageView.frame.origin.x-40-56,self.recodImageView.frame.origin.y+8, 56, 56)];
        [self.reRecoderBtn setBackgroundImage:UIImageNamed(@"bkRecoDele_Image") forState:UIControlStateNormal];
        [self.reRecoderBtn addTarget:self action:@selector(rerecoderClick) forControlEvents:UIControlEventTouchUpInside];
        [self.recodBtnView addSubview:self.reRecoderBtn];
        self.reRecoderBtn.hidden = YES;
        
        self.reLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.reRecoderBtn.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 56, 14)];
        self.reLabel.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.reLabel.font = [UIFont systemFontOfSize:10];
        self.reLabel.textAlignment = NSTextAlignmentCenter;
        self.reLabel.text = [NoticeTools getLocalStrWith:@"em.rerecoder"];
        [self.recodBtnView addSubview:self.reLabel];
        self.reLabel.hidden = YES;
    }
    return self;
}

//播放编辑选择bgm视图
- (UIView *)playAndEditView{
    if (!_playAndEditView) {
        _playAndEditView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-10-72-36-40, DR_SCREEN_WIDTH, 72+36+40)];
        [self addSubview:_playAndEditView];
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-60)/2, 0, 60, 36)];
        [self.playButton setImage:UIImageNamed(@"playbokeimg") forState:UIControlStateNormal];
        [_playAndEditView addSubview:self.playButton];
        
        [self.playButton addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *shdawView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.playButton.frame)+40, DR_SCREEN_WIDTH-40, 72)];
        shdawView.backgroundColor = self.backgroundColor;
        shdawView.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
        shdawView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        shdawView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        shdawView.layer.shadowRadius = 2;//阴影半径，默认3
        [_playAndEditView addSubview:shdawView];
        
        FSCustomButton *editBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-40-104)/3, 10, 52, 52)];
        [editBtn setTitle:[NoticeTools chinese:@"剪辑" english:@"Edit" japan:@"編集"] forState:UIControlStateNormal];
        editBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [editBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        [editBtn setImage:UIImageNamed(@"bokeeditimg") forState:UIControlStateNormal];
        editBtn.buttonImagePosition = FSCustomButtonImagePositionTop;
        [shdawView addSubview:editBtn];
        [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        
        FSCustomButton *bgmBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(editBtn.frame)+(DR_SCREEN_WIDTH-40-104)/3, 10, 52, 52)];
        [bgmBtn setTitle:@"BGM" forState:UIControlStateNormal];
        bgmBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [bgmBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        [bgmBtn setImage:UIImageNamed(@"bokebgmimg") forState:UIControlStateNormal];
        bgmBtn.buttonImagePosition = FSCustomButtonImagePositionTop;
        [shdawView addSubview:bgmBtn];
        [bgmBtn addTarget:self action:@selector(bgmClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-66-20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 66, 28)];
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.nextButton.layer.cornerRadius = 14;
        self.nextButton.layer.masksToBounds = YES;
        self.nextButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.nextButton setTitle:[NoticeTools getLocalStrWith:@"photo.next"] forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
    }
    return _playAndEditView;
}

//bgm选择
- (void)bgmClick{
    if (_voicePlayer) {
        [self.voicePlayer stopPlaying];
    }
    self.bgmView.currentStatus = 0;
    [self.bgmView show];
}

- (NoticeChoiceBgmTypeView *)bgmView{
    if (!_bgmView) {
        _bgmView = [[NoticeChoiceBgmTypeView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _bgmView.useMusicBlock = ^(NSString * _Nonnull url, NSString * _Nonnull bgmId, NSInteger bgmType, NSString * _Nonnull bgmName) {
            [weakSelf.showView show];
            weakSelf.bgmNameView.hidden = NO;
            weakSelf.bgmNameL.text = bgmName;
            weakSelf.bgmPath = url;
            [weakSelf.audioToAudio recoderAudioPath:weakSelf.localAACUrl bgmPath:url isTuijian:NO];
        };
    }
    return _bgmView;
}

- (NoticeAudioJoinToAudioModel *)audioToAudio{
    if (!_audioToAudio) {
        _audioToAudio = [[NoticeAudioJoinToAudioModel alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioToAudio.audioBlock = ^(NSString * _Nonnull currentAudioPath, NSInteger reuslt) {
            if (reuslt == 0) {
                weakSelf.addAudioPath = currentAudioPath;
            }else{
                [[NoticeTools getTopViewController] showToastWithText:@"音频合成失败"];
                weakSelf.bgmNameView.hidden = YES;
            }
            [weakSelf.showView disMiss];
        };
    }
    return _audioToAudio;
}

- (NoticeActShowView *)showView{
    if (!_showView) {
        _showView = [[NoticeActShowView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _showView.titleL.text = @"音频合成中，请耐心等待...";
    }
    return _showView;
}

//bgm显示视图
- (UIView *)bgmNameView{
    if (!_bgmNameView) {
        _bgmNameView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.markL.frame)+20+200+15, DR_SCREEN_WIDTH-40, 36)];
        _bgmNameView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _bgmNameView.layer.cornerRadius = 2;
        _bgmNameView.layer.masksToBounds = YES;
        [self addSubview:_bgmNameView];
        
        UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,8, 20, 20)];
        markImageView.image = UIImageNamed(@"ly_moon");
        [_bgmNameView addSubview:markImageView];
        
        self.bgmNameL = [[UILabel alloc] initWithFrame:CGRectMake(34, 0,DR_SCREEN_WIDTH-40-36-28,36)];
        self.bgmNameL.font = TWOTEXTFONTSIZE;
        self.bgmNameL.textColor = [UIColor colorWithHexString:@"#A0784F"];
        [_bgmNameView addSubview:self.bgmNameL];
 
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.bgmNameL.frame), 8, 20, 20)];
        [closeBtn setBackgroundImage:UIImageNamed(@"blackdeleteimg") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBgmClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgmNameView addSubview:closeBtn];
    }
    return _bgmNameView;
}

- (void)closeBgmClick{
    self.addAudioPath = nil;
    self.bgmPath = nil;
    self.bgmNameView.hidden = YES;
}

-(NSString *)getSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;

    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];

    if (seconds <0) {
        return @"00";
    }
    return str_second;
}

-(NSString *)getMMFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];

    if (seconds <0) {
        return @"00";
    }
    return str_minute;
}

- (void)show{
    self.rePlay = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    }];
}

- (void)playClick{
    if (self.rePlay) {
        self.rePlay = NO;
        [self.voicePlayer stopPlaying];
        self.isPause = YES;
    }
    
    self.isPause = !self.isPause;
    __weak typeof(self) weakSelf = self;

    if (!self.isPause) {
        [self.playButton setImage:UIImageNamed(@"stopbokeimg") forState:UIControlStateNormal];
        if (!self.isPlaying) {//判断是否在播放
            [self.voicePlayer startPlayWithUrl:self.addAudioPath?self.addAudioPath: self.localAACUrl isLocalFile:YES];
        }else{
            [self.voicePlayer pause:NO];
        }
        
        self.voicePlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            weakSelf.isPlaying = YES;
        };
        
        self.voicePlayer.playComplete = ^{//音频播放完成
            weakSelf.isPause = YES;
            weakSelf.isPlaying = NO;
            weakSelf.timeL.text = [weakSelf getSSFromSS:weakSelf.audioTimeLen];
            weakSelf.minL.text = [weakSelf getMMFromSS:weakSelf.audioTimeLen];
            [weakSelf.playButton setImage:UIImageNamed(@"playbokeimg") forState:UIControlStateNormal];
        };
                      
        self.voicePlayer.playingBlock = ^(CGFloat currentTime) {
            NSInteger playTime = weakSelf.audioTimeLen-currentTime;
            if (playTime < 0) {
                playTime = 0;
            }
            weakSelf.timeL.text = [weakSelf getSSFromSS:(NSInteger)playTime];
            weakSelf.minL.text = [weakSelf getMMFromSS:(NSInteger)playTime];
        };
    }else{
        [weakSelf.playButton setImage:UIImageNamed(@"playbokeimg") forState:UIControlStateNormal];
        [self.voicePlayer pause:self.isPause];
    }
}

- (LGAudioPlayer *)voicePlayer
{
    if (!_voicePlayer) {
        _voicePlayer = [[LGAudioPlayer alloc] init];
    }
    return _voicePlayer;
}


//完成录制
- (void)sureUp{
    self.isSureFinish = YES;
    [self pasuceClick];
}

//结束录制
- (void)pasuceClick{
    self.markL.textColor = _markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    _dianL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.minL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.minL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.timeL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
    if (self.isRecoding || self.isPauseRecoding) {//如果正在录制或者暂停
        [self.recorder stopRecording];
    }else{
        if (self.localAACUrl) {
            [self sureFinish];
        }
    }
}


//开始或者暂停录制
- (void)startOrStop{
    self.reingLabel.textColor = [UIColor colorWithHexString:@"#FF68A3"];
    if (!self.isPauseRecoding) {//之前是暂停录音的话，现在继续录音
        if (!self.startRecoder) {//还没有开始录音则开始录音
            __weak typeof(self) weakSelf = self;
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) { // 有使用麦克风的权限
                        [weakSelf recoders];
                    }else { // 没有麦克风权限
                        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                        alerView.resultIndex = ^(NSInteger index) {
                            if (index == 1) {
                                UIApplication *application = [UIApplication sharedApplication];
                                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                if ([application canOpenURL:url]) {
                                    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                        if (@available(iOS 10.0, *)) {
                                            [application openURL:url options:@{} completionHandler:nil];
                                        }
                                    } else {
                                        [application openURL:url options:@{} completionHandler:nil];
                                    }
                                }
                            }
                        };
                        [alerView showXLAlertView];
                    }
                });
            }];
        }else{//录制中就是暂停录音
            NSString *str = [NSString stringWithFormat:@"%@%lds",[NoticeTools getLocalStrWith:@"recoder.shegnxiatime"],600-_currentRecodTime];
            self.markL.text = str;
            [self pauseRecoder];
        }
    }else{
        self.markL.text = [NoticeTools getLocalStrWith:@"recoder.600"];
        [self rePlayClick];
    }
}

- (void)recoders{
    self.reRecoderBtn.hidden = NO;
    self.sureBtn.hidden = NO;
    self.reLabel.hidden = NO;
    self.sureLabel.hidden = NO;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.reing"];
    
    self.markL.text = [NoticeTools getLocalStrWith:@"recoder.600"];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"bgRecoing_Image") forState:UIControlStateNormal];
    self.isRecoding = YES;
    self.startRecoder = YES;
    self.isPauseRecoding = NO;
    [self.recorder startRecording];
}

//继续录音
- (void)rePlayClick{
    
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.recroging"];
  
    self.isShowFinish = NO;
    
    self.isRecoding = NO;
    [self.recodImageView setBackgroundImage:UIImageNamed(@"bgRecoing_Image") forState:UIControlStateNormal];

    self.isRecoding = YES;
    self.isPauseRecoding = NO;
    self.isBeginFromContion = YES;

    [self.recorder contuintRecording];
    [self startRecordTimer];
    [self.recodImageView startPulseWithColor:[UIColor colorWithHexString: @"#FF68A3"] animation:YGPulseViewAnimationTypeRadarPulsing];
    
}

- (void)destory
{
    [self stopRecordTimer];
}

- (NoticePointView *)drawView{//上边波纹
    if (!_drawView) {
        NoticePointView *view = [[NoticePointView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(self.markL.frame)+20,DR_SCREEN_WIDTH-40, 100)];
        view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:view];
        view.colorStr = @"#FF68A3";
        _drawView = view;
    }
    return _drawView;
}

- (NoticePointView *)drawView1{//下方波纹
    if (!_drawView1) {
        NoticePointView *view1 = [[NoticePointView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(self.markL.frame)+20+100,DR_SCREEN_WIDTH-40, 100)];
        view1.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:view1];
        view1.colorStr = @"#FF68A3";
        _drawView1 = view1;
        _drawView1.transform = CGAffineTransformMakeScale(1.0,-1.0);//下方播放沿x轴翻转180度
    }
    return _drawView1;
}

//绘制波纹条的时候把分贝值作为波纹的高度，放进数组即可
- (void)destryDraw{
    //随机点20～100
    CGPoint point = CGPointMake(self.drawView.bounds.size.height,0);
    [self.pointArray removeAllObjects];
    //插入到数组最前面（动画视图最右边），array添加CGPoint需要转换一下
    [self.pointArray insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
    //传值，重绘视图
    self.drawView.pointArray = self.pointArray;
    self.drawView1.pointArray = self.pointArray;
}

//重新录制
- (void)rerecoderClick{
    _markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    _dianL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.minL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.minL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.timeL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self destryDraw];
    self.minL.text = @"00";
    self.timeL.text = @"00";
    self.isRecoding = NO;
    self.markL.text = [NoticeTools getLocalStrWith:@"recoder.600"];
    self.reRecoderBtn.hidden = YES;
    self.sureBtn.hidden = YES;
    self.reLabel.hidden = YES;
    self.sureLabel.hidden = YES;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.clickluy"];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"bkReco_Image") forState:UIControlStateNormal];
    
    self.isRecoderClick = YES;
    self.isPauseRecoding = NO;
    self.startRecoder = NO;
    self.isSureFinish = NO;
    [self.recorder stopRecording];
    
}

//确定放弃录制
- (void)mustGiveUp{

    self.isGiveUp = YES;
    self.isSureFinish = NO;
    self.startRecoder = NO;
    [self.recorder stopRecording];
}

//返回按钮
- (void)backClick{
    if (self.startRecoder || self.localAACUrl) {
        __weak typeof(self) weakSelf = self;
        
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.showt"] message:nil sureBtn:@"放弃" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf stopRecordTimer];
                [weakSelf rerecoderClick];
                //取消设置屏幕常亮
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                [weakSelf dissMiss];
            }
        };
        [alerView showXLAlertView];
    }else{
        //取消设置屏幕常亮
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        [self dissMiss];
    }
}

//确定完成
- (void)sureFinish{
    if (!self.localAACUrl) {
        [[NoticeTools getTopViewController] showToastWithText:@"录音失败"];
        return;
    }
    if (!self.audioTimeLen) {
        [[NoticeTools getTopViewController] showToastWithText:@"录音失败"];
        return;
    }

    self.isRecoding = NO;
    self.markL.text = [NoticeTools getLocalStrWith:@"recoder.600"];
    self.reRecoderBtn.hidden = YES;
    self.sureBtn.hidden = YES;
    self.reLabel.hidden = YES;
    self.sureLabel.hidden = YES;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.clickluy"];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"bkReco_Image") forState:UIControlStateNormal];
    
    self.isRecoderClick = YES;
    self.isPauseRecoding = NO;
    
    self.startRecoder = NO;
    self.isSureFinish = NO;
    
    self.recodBtnView.hidden = YES;
    self.playAndEditView.hidden = NO;
    self.markL.hidden = YES;

}

- (void)nextClick{

    if (self.sureFinishBlock) {
        self.sureFinishBlock(self.addAudioPath ? self.addAudioPath : self.localAACUrl,[NSString stringWithFormat:@"%ld",self.audioTimeLen]);
    }
    [self dissMiss];
}

- (void)dissMiss{
    if (_voicePlayer) {
        [self.voicePlayer stopPlaying];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    }];
    [self destryDraw];
}

- (void)updateRecordTime{
    if (self.isPauseRecoding) {
        return;
    }
    _currentRecodTime = self.isBeginFromContion? self.oldRecodingTime:self.recorder.currentTime;
  
    self.isBeginFromContion = NO;

    [self.recodImageView setBackgroundImage:UIImageNamed(@"bgRecoing_Image") forState:UIControlStateNormal];
    
    self.oldRecodingTime = _currentRecodTime;

    if (_currentRecodTime >= 600) {
        self.isSureFinish = YES;
        [self.recorder stopRecording];
    }
    self.timeL.text = [self getSSFromSS:(NSInteger)_currentRecodTime];
    self.minL.text = [self getMMFromSS:(NSInteger)_currentRecodTime];
    if (600 - _currentRecodTime <= 10) {
        NSString *str = [NSString stringWithFormat:@"%@%lds",[NoticeTools getLocalStrWith:@"recoder.shegnxiatime"],600-_currentRecodTime];

        self.markL.text = str;
        _markL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        _dianL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.minL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.minL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.timeL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    
    //随机点20～100
    CGPoint point = CGPointMake(self.drawView.bounds.size.height, [self.recorder levels]>100?100:[self.recorder levels]);
    if (!self.pointArray) {
        self.pointArray = [[NSMutableArray alloc] init];
    }
    //插入到数组最前面（动画视图最右边），array添加CGPoint需要转换一下
    [self.pointArray insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
    
    //传值，重绘视图
    self.drawView.pointArray = self.pointArray;
    self.drawView1.pointArray = self.pointArray;
}

//暂停录音
- (void)pauseRecoder{
    //在录制当中，则进行暂停
    self.isShowFinish = YES;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.goonre"];
    self.isRecoding = NO;
    self.isPauseRecoding = YES;
    [self stopRecordTimer];
    [self.recorder pauseRecording];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"bkReco_Image") forState:UIControlStateNormal];
    [self.recodImageView stopPulse];
}

#pragma mark -setter and getter

- (void)handleInterruption{
    if (self.startRecoder) {
        [self pauseRecoder];
    }
}


- (void)startRecordTimer
{
    [self stopRecordTimer];
    self.recordTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
    [self.recordTimer fire];
}

- (void)stopRecordTimer
{
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
}

- (LGVoiceRecorder *)recorder
{
    if (!_recorder) {
        _recorder = [[LGVoiceRecorder alloc] init];
        //监听来电，来电时候暂停录音
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption) name:AVAudioSessionInterruptionNotification object:audioSession];
        
        __weak typeof(self) weakSelf = self;
        //开始录音
        _recorder.audioStartRecording = ^(BOOL isSuccess) {
            if (isSuccess) {
                [weakSelf startRecordTimer];
                [weakSelf.recodImageView startPulseWithColor:[UIColor colorWithHexString:@"#FF68A3"] animation:YGPulseViewAnimationTypeRadarPulsing];
            } else {
                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"recoder.openmac"]];
            }
        };
                
        //录音失败，时间过短
        _recorder.audioRecordingFail = ^(NSString *reason) {
            [weakSelf stopRecordTimer];
            [weakSelf.recodImageView stopPulse];
        };
        
        _recorder.audioFinishRecording = ^(NSString *aacUrl, NSUInteger audioTimeLength) {
            [weakSelf stopRecordTimer];
            weakSelf.reingLabel.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
            [weakSelf.recodImageView stopPulse];
            if (weakSelf.isGiveUp) {
                [weakSelf dissMiss];
                return;
            }
            
            if (weakSelf.isRecoderClick && !weakSelf.isSureFinish) {
                weakSelf.isRecoderClick = NO;
                weakSelf.audioTimeLen = 0;
                weakSelf.timeL.text = [weakSelf getSSFromSS:(NSInteger)weakSelf.audioTimeLen];
                weakSelf.minL.text = [weakSelf getMMFromSS:(NSInteger)weakSelf.audioTimeLen];
                return;
            }
            
            if (!weakSelf.isReRecoder) {
                weakSelf.localAACUrl = aacUrl;
            }
            
            if (audioTimeLength) {
                weakSelf.audioTimeLen = audioTimeLength;
            }else{
                if (!weakSelf.isReRecoder) {
                    weakSelf.audioTimeLen = 1;
                    weakSelf.timeL.text = [weakSelf getSSFromSS:(NSInteger)weakSelf.audioTimeLen];
                    weakSelf.minL.text = [weakSelf getMMFromSS:(NSInteger)weakSelf.audioTimeLen];
                }
            }
            
            if (weakSelf.isReRecoder) {
                weakSelf.isReRecoder = NO;
            }
            
            if ( weakSelf.isSureFinish) {
                weakSelf.localAACUrl = aacUrl;
                [weakSelf sureFinish];
            }
        };
    }
    return _recorder;
}

- (void)editClick{
    
    if (self.audioTimeLen < 30) {
        [[NoticeTools getTopViewController] showToastWithText:[NoticeTools chinese:@"音频时长大于30s才能剪辑噢～" english:@"Audio track too short (less than 30 sec)!" japan:@"オーディオ が短すぎます (30 秒未満)"]];
        return;
    }
    
    if (self.hasCutEd) {
        [[NoticeTools getTopViewController] showToastWithText:@"您已经进行过剪切了噢～，当前只能更换BGM"];
        return;
    }
    
    [_voicePlayer stopPlaying];
    _editVoiceView = [[NoticeRecoderEditView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.editVoiceView.locaPath = self.localAACUrl;
    self.editVoiceView.bgmPath = self.bgmPath;
    self.editVoiceView.pointArray = self.pointArray;
    self.editVoiceView.timeLen = [NSString stringWithFormat:@"%ld",self.audioTimeLen];
    __weak typeof(self) weakSelf = self;
    _editVoiceView.sureFinishBlock = ^(NSString * _Nonnull path, NSString * _Nonnull tiemLength, BOOL hasCut) {
        weakSelf.localAACUrl = path;
        weakSelf.audioTimeLen = tiemLength.integerValue;
        weakSelf.timeL.text = [weakSelf getSSFromSS:weakSelf.audioTimeLen];
        weakSelf.minL.text = [weakSelf getMMFromSS:weakSelf.audioTimeLen];
        weakSelf.hasCutEd = hasCut;
        if (weakSelf.bgmPath) {
            [weakSelf.showView show];
            [weakSelf.audioToAudio recoderAudioPath:weakSelf.localAACUrl bgmPath:weakSelf.bgmPath isTuijian:NO];
        }
    };
    [self addSubview:self.editVoiceView];
}

@end


                                                                                                                                                                                                                                                                            
