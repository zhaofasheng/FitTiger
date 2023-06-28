//
//  NoticeRecoderMain.m
//  NoticeXi
//
//  Created by li lei on 2019/11/29.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeRecoderMain.h"
#import "NoticeSendViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSendMovieViewController.h"

@implementation NoticeRecoderMain
{
    BOOL _isPause;
    UIButton *_pasuBtn;
}
- (instancetype)initWithImageView:(NSString *)imgName type:(NoticeRecoderType)recoderType{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT*0.212, DR_SCREEN_WIDTH, 30)];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FEFFFF":@"#B2B2B2"];
        self.titleL.font = THIRTTYBoldFontSize;
        self.titleL.text = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"recoder.recroging"]:@"錄音中";
        [self addSubview:self.titleL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleL.frame)+33, DR_SCREEN_WIDTH, 20)];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FEFFFF":@"#B2B2B2"];
        self.timeL.font = XGTwentyBoldFontSize;
        self.timeL.text = @"1S";
        [self addSubview:self.timeL];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeL.frame)+33, DR_SCREEN_WIDTH, 14)];
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#EBEBEB":@"#72727F"];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        self.markL.text = recoderType == NoticeRecoderSong? ([NoticeTools isSimpleLau]?@"最长可录制300秒":@"最長可錄制300秒") : ([NoticeTools isSimpleLau]?@"最长可录制120秒":@"最長可錄制120秒");
        [self addSubview:self.markL];
        
        self.recodImageView = [[UIButton alloc] init];
        if (recoderType == NoticeRecoderTabbar) {
            self.recodImageView.frame = CGRectMake((DR_SCREEN_WIDTH-58)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-11-58, 58, 58);
        }else if (recoderType == NoticeRecoderTime){
            self.recodImageView.frame = CGRectMake((DR_SCREEN_WIDTH-58)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-25-58+12, 58, 58);
        }else if (recoderType == NoticeRecoderUserCenter){
            self.recodImageView.frame = CGRectMake((DR_SCREEN_WIDTH-58)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-58-35-50, 58, 58);
        }
        else{
            self.recodImageView.frame = CGRectMake((DR_SCREEN_WIDTH-58)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-35-58, 58, 58);
        }
        self.recodImageView.layer.cornerRadius = self.recodImageView.frame.size.height/2;
        self.recodImageView.layer.masksToBounds = YES;
        [self.recodImageView setBackgroundImage:UIImageNamed(imgName) forState:UIControlStateNormal];
        [self.recodImageView addTarget:self action:@selector(stopRecoderClickWithButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.recodImageView];
        
        self.type = recoderType;
        self.maxTime = recoderType == NoticeRecoderSong?300:120;
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-25)/2, 25, 25)];
        [closeBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"recode_img_b":@"recode_img_y") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(cancelRecoderClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        UIButton *lookBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-90, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-25)/2,90, 25)];
        lookBtn.layer.cornerRadius = 25/2;
        lookBtn.layer.masksToBounds = YES;
        lookBtn.layer.borderColor = [NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#B2B2B2"].CGColor;
        lookBtn.layer.borderWidth = 1;
        lookBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [lookBtn setTitle:@"看图说话>>" forState:UIControlStateNormal];
        [lookBtn setTitleColor:[NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#B2B2B2"] forState:UIControlStateNormal];
        [lookBtn addTarget:self action:@selector(lookBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lookBtn];
        
//        UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,DR_SCREEN_HEIGHT-50-200,DR_SCREEN_WIDTH-30,50)];
//        [pauseBtn setTitle:@"暂停录音" forState:UIControlStateNormal];
//        [pauseBtn addTarget:self action:@selector(pauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:pauseBtn];
//        _pasuBtn = pauseBtn;
    }
    return self;
}

- (void)pauseBtnClick{
    _isPause = !_isPause;
    [_pasuBtn setTitle:_isPause?[NoticeTools getLocalStrWith:@"recoder.goonre"]:@"暂停录音" forState:UIControlStateNormal];
    if (!_isPause) {
        self.recordTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
        [self.recordTimer fire];
        [self.recorder contuintRecording];
        [self.recodImageView startPulseWithColor:(self.type == NoticeRecoderMBS || self.type == NoticeRecoderSong || self.type == NoticeRecoderTopic || self.type == NoticeRecoderUserCenter) ?[UIColor colorWithHexString:@"#FFB650"]:GetColorWithName(VMainThumeColor) animation:YGPulseViewAnimationTypeRadarPulsing];
    }else{
        [self.recordTimer invalidate];
        [self.recorder pauseRecording];
        [self.recodImageView stopPulse];
    }
}


- (void)setIsLongTime:(BOOL)isLongTime{
    _isLongTime = isLongTime;
    self.markL.text = isLongTime? ([NoticeTools isSimpleLau]?@"最长可录制300秒":@"最長可錄制300秒") : ([NoticeTools isSimpleLau]?@"最长可录制120秒":@"最長可錄制120秒");
    self.maxTime = isLongTime?300:120;
}

- (void)startRecoder{
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

}

- (void)recoders{
    [self startRecordTimer];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
    [self.recodImageView startPulseWithColor:(self.type == NoticeRecoderMBS || self.type == NoticeRecoderSong || self.type == NoticeRecoderTopic || self.type == NoticeRecoderUserCenter) ?[UIColor colorWithHexString:@"#FFB650"]:GetColorWithName(VMainThumeColor) animation:YGPulseViewAnimationTypeRadarPulsing];
    [self.recorder startRecording];
}

- (void)creatShowAnimation
{
    self.timeL.transform = CGAffineTransformMakeScale(0.90, 0.90);
    self.titleL.transform = CGAffineTransformMakeScale(0.90, 0.90);
    self.markL.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.timeL.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.titleL.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.markL.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
}

- (void)stopRecoderClickWithButton{
    [self.recorder stopRecording];
}

- (void)lookBtnClick{
    self.noPush = YES;
    [self cancelRecoderClick];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (self.type == NoticeRecoderMBS || self.type == NoticeRecoderSong) {//书影音
        NoticeSendMovieViewController *ctl = [[NoticeSendMovieViewController alloc] init];
        ctl.isLongTime = self.isLongTime;
        ctl.goRecoderAndLook = YES;
        if (self.movice) {
            ctl.movice = self.movice;
        }else if (self.book){
            ctl.book = self.book;
            ctl.type = 1;
        }else if (self.song){
            ctl.song = self.song;
            ctl.type = 2;
        }else{
            [nav.topViewController showToastWithText:@"暂无对应数据"];
            return;
        }
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:nav.topViewController.navigationController.view];
        [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        return;
    }
    
    NoticeSendViewController *ctl = [[NoticeSendViewController alloc] init];
    ctl.isLongTime = self.isLongTime;
    ctl.isFromMain = self.isFromMain;
    ctl.goRecoderAndLook = YES;
    if (self.zjId) {
        ctl.zjId = self.zjId;
    }
    if (self.type == NoticeRecoderTabbar) {
       ctl.isFromMain = YES;
    }
    if (self.topicName) {
        ctl.topicName = self.topicName;
        ctl.topicId = self.topicId;
    }
    if (self.type == NoticeRecoderTabbar) {
        ctl.noNeedBanner = NO;
    }else{
        ctl.noNeedBanner = YES;
    }
    
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
}

- (void)cancelRecoderClick{
    self.noPush = YES;
    [self.recorder stopRecording];
}

- (void)stopRecoderClick{
    [self dissMisssView];
    [self.recordTimer invalidate];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    if (self.type == NoticeRecoderMBS || self.type == NoticeRecoderSong) {//书影音
        NoticeSendMovieViewController *ctl = [[NoticeSendMovieViewController alloc] init];
        ctl.isLongTime = self.isLongTime;
        if (self.movice) {
            ctl.movice = self.movice;
        }else if (self.book){
            ctl.book = self.book;
            ctl.type = 1;
        }else if (self.song){
            ctl.song = self.song;
            ctl.type = 2;
        }else{
            [nav.topViewController showToastWithText:@"暂无对应数据"];
            return;
        }
        if (self.audioTimeLen) {
            ctl.timeLen = [NSString stringWithFormat:@"%lu",(unsigned long)self.audioTimeLen];
            ctl.locaPath = self.localAACUrl;
        }
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:nav.topViewController.navigationController.view];
        [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        return;
    }
    
    NoticeSendViewController *ctl = [[NoticeSendViewController alloc] init];
    ctl.isLongTime = self.isLongTime;
    if (self.zjId) {
        ctl.zjId = self.zjId;
    }
    if (self.type == NoticeRecoderTabbar) {
       ctl.isFromMain = YES;
    }
    if (self.audioTimeLen) {
        ctl.timeLen = [NSString stringWithFormat:@"%lu",(unsigned long)self.audioTimeLen];
        ctl.locaPath = self.localAACUrl;
    }
    if (self.topicName) {
        ctl.topicName = self.topicName;
        ctl.topicId = self.topicId;
    }
    if (self.type == NoticeRecoderTabbar) {
        ctl.noNeedBanner = NO;
    }else{
        ctl.noNeedBanner = YES;
    }
    
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
}

- (void)startRecordTimer
{
    self.recordTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
    [self.recordTimer fire];
    
}

- (void)updateRecordTime{
    _currentRecodTime = self.recorder.currentTime;
    if (_currentRecodTime == self.maxTime) {
        self.noPush = NO;
        [self.recorder stopRecording];
        return;
    }
    self.titleL.text = GETTEXTWITE(@"recod.ing");
    self.timeL.text = [NSString stringWithFormat:@"%ldS",(long)_currentRecodTime];
    DRLog(@"计时钟");
}

- (LGVoiceRecorder *)recorder
{
    if (!_recorder) {
        _recorder = [[LGVoiceRecorder alloc] init];
        __weak typeof(self) weakSelf = self;

        //开始录音
        _recorder.audioStartRecording = ^(BOOL isSuccess) {
            if (isSuccess) {

            } else {
                [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"recoder.openmac"]];
            }
        };

        //录音失败，时间过短
        _recorder.audioRecordingFail = ^(NSString *reason) {
            [weakSelf dissMisssView];
        };

        _recorder.audioFinishRecording = ^(NSString *aacUrl, NSUInteger audioTimeLength) {
            weakSelf.localAACUrl = aacUrl;
            if (audioTimeLength) {
                weakSelf.audioTimeLen = audioTimeLength;
            }else{
                weakSelf.audioTimeLen = 1;
                weakSelf.timeL.text = [NSString stringWithFormat:@"%luS",(unsigned long)weakSelf.audioTimeLen];
            }
            if (!weakSelf.noPush) {
                [weakSelf stopRecoderClick];
            }else{
                [weakSelf dissMisssView];
                [weakSelf.recordTimer invalidate];
            }
        };
    }
    return _recorder;
}

- (void)dissMisssView{
    [self removeFromSuperview];
}
@end
