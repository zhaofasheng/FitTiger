//
//  NoticeRecoderController.m
//  NoticeXi
//
//  Created by li lei on 2022/3/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeRecoderController.h"
#import "NoticeCustumeNavView.h"
#import "LGVoiceRecorder.h"
#import "NoticeRecoderTryListenView.h"
#import "NoticeSendViewController.h"
#import "NoticeChangeVoiceView.h"
#import "NoticeChoicePickerImgView.h"
#import "NoticeLookImageViewView.h"
#import "NoticeVoiceReadController.h"
#import "NoticeHeJiListController.h"
#import "NoticeReadAllContentView.h"
#import "NoticeTopicModel.h"

@interface NoticeRecoderController ()<TZImagePickerControllerDelegate>
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, strong) LGVoiceRecorder * __nullable recorder;
@property (nonatomic, assign) NSUInteger audioTimeLen;
@property (nonatomic, assign) BOOL isSureFinish;//确定录制完成
@property (nonatomic, assign) BOOL startRecoder;
@property (nonatomic, assign) BOOL isGiveUp;
@property (nonatomic, assign) BOOL isReRecoder;//删除重新录制
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *recodImageView;
@property (nonatomic, assign) BOOL isRecoderClick;//重新录制
@property (nonatomic, strong) NSString *localAACUrl; //aac地址
@property (nonatomic, strong) NSTimer *recordTimer; //录音定时器
@property (nonatomic, assign) BOOL isBeginFromContion;//从暂停录音状态继续录音
@property (nonatomic, assign) BOOL isPauseRecoding;//暂停录音状态
@property (nonatomic, assign) NSInteger oldRecodingTime;//暂停录音时记录当前时间
@property (nonatomic, assign) BOOL isRecoding;//判断是否在录制
@property (nonatomic, assign) NSInteger currentRecodTime;
@property (nonatomic, strong) UILabel *reingLabel;
@property (nonatomic, assign) BOOL isShowFinish;//暂停了显示了完成UI
@property (nonatomic, strong) UILabel *sureLabel;
@property (nonatomic, strong) UIButton *reRecoderBtn;
@property (nonatomic, strong) UILabel *reLabel;
@property (nonatomic, strong) NoticeRecoderTryListenView *listenView;
@property (nonatomic, strong) NoticeVoiceTypeModel *typeModel;
@property (nonatomic, strong) UIButton *voiceTypeBtn;
@property (nonatomic, strong) UILabel *changeTypeL;
@property (nonatomic, strong) NoticeChangeVoiceView *changeView;
@property (nonatomic, strong) NoticeChoicePickerImgView *pickerView;
@property (nonatomic, strong) NoticeLookImageViewView *lookImgsView;
@property (nonatomic, strong) NoticeReadAllContentView *readingView;

@property (nonatomic, strong,nullable) NoticeTopicModel *topicM;
@property (nonatomic, strong) NSMutableArray *moveArr;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) UIImageView *clickRecoImageView;
@property (nonatomic, strong) UIImageView *clickFinishImageView;

@property (nonatomic, strong) NoticeVoiceReadModel *readModel;
@property (nonatomic, assign) BOOL isPushHeji;
@end

@implementation NoticeRecoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    backImageView.image = UIImageNamed(@"Image_backRecoderimg");
    [self.view addSubview:backImageView];
    
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.rightButton setImage:UIImageNamed(@"Image_morelookspe") forState:UIControlStateNormal];

    if (self.isLead) {
        UIButton *closBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 52, 28)];
        [closBtn setBackgroundImage:UIImageNamed(@"Image_leaclose") forState:UIControlStateNormal];
        [closBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:closBtn];
        self.navBarView.backButton.hidden = YES;
    }
    
    self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-220-30, DR_SCREEN_WIDTH,30)];
    self.timeL.font = XGTwentyFifBoldFontSize;
    self.timeL.text = @"0s";
    self.timeL.textAlignment = NSTextAlignmentCenter;
    self.timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.view addSubview:self.timeL];
    
    //录制按钮
    self.recodImageView = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-71)/2, CGRectGetMaxY(self.timeL.frame)+25, 71, 71)];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"Image_newclickRec") forState:UIControlStateNormal];
    self.recodImageView.layer.cornerRadius = 71/2;
    self.recodImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.recodImageView];
    [self.recodImageView addTarget:self action:@selector(startOrStop) forControlEvents:UIControlEventTouchUpInside];
    
    self.reingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.recodImageView.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 71, 14)];
    self.reingLabel.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.reingLabel.font = [UIFont systemFontOfSize:10];
    self.reingLabel.textAlignment = NSTextAlignmentCenter;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.clickluy"];
    [self.view addSubview:self.reingLabel];
    
    self.markL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-234)/2,CGRectGetMaxY(self.recodImageView.frame)+50, 234, 44)];
    self.markL.font = FOURTHTEENTEXTFONTSIZE;
    self.markL.text =  [NoticeTools getLocalStrWith:@"recoder.300"];
    self.markL.textAlignment = NSTextAlignmentCenter;
    self.markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    [self.view addSubview:self.markL];
    
    //确定按钮
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.recodImageView.frame)+40,self.recodImageView.frame.origin.y+8, 56, 56)];
    [self.sureBtn setBackgroundImage:UIImageNamed(@"ly_surefinish") forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureBtn];
    self.sureBtn.hidden = YES;
    
    self.sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sureBtn.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 56, 14)];
    self.sureLabel.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.sureLabel.font = [UIFont systemFontOfSize:10];
    self.sureLabel.textAlignment = NSTextAlignmentCenter;
    self.sureLabel.text = [NoticeTools getLocalStrWith:@"groupfm.finish"];
    self.sureLabel.hidden = YES;
    [self.view addSubview:self.sureLabel];
    
    //删除重录按钮
    self.reRecoderBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.recodImageView.frame.origin.x-40-56,self.recodImageView.frame.origin.y+8, 56, 56)];
    [self.reRecoderBtn setBackgroundImage:UIImageNamed(@"ly_suredelete") forState:UIControlStateNormal];
    [self.reRecoderBtn addTarget:self action:@selector(rerecoderClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reRecoderBtn];
    self.reRecoderBtn.hidden = YES;
    
    self.reLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.reRecoderBtn.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 56, 14)];
    self.reLabel.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.reLabel.font = [UIFont systemFontOfSize:10];
    self.reLabel.textAlignment = NSTextAlignmentCenter;
    self.reLabel.text = [NoticeTools getLocalStrWith:@"em.rerecoder"];
    [self.view addSubview:self.reLabel];
    self.reLabel.hidden = YES;
    
    self.typeModel = [[NoticeVoiceTypeModel alloc] init];
    self.typeModel.type = 0;
    
    self.voiceTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-170)/2, self.timeL.frame.origin.y-40-30, 135, 30)];
    self.voiceTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
    [self.voiceTypeBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    self.voiceTypeBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [self.view addSubview:self.voiceTypeBtn];
    [self.voiceTypeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    self.voiceTypeBtn.layer.cornerRadius = 2;
    [self.voiceTypeBtn setTitle:[NoticeTools getLocalStrWith:@"ly.bsleix"] forState:UIControlStateNormal];
    self.voiceTypeBtn.layer.masksToBounds = YES;
    
    self.changeTypeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.voiceTypeBtn.frame), self.voiceTypeBtn.frame.origin.y, 35, 30)];
    self.changeTypeL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.changeTypeL.font = TWOTEXTFONTSIZE;
    self.changeTypeL.text = [NoticeTools getLocalStrWith:@"luy.change"];
    self.changeTypeL.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.changeTypeL];
    self.changeTypeL.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeClick)];
    [self.changeTypeL addGestureRecognizer:tap];
    
    self.lookImgsView.hidden = YES;
    
    if (self.isLead) {
        self.clickFinishImageView.hidden = YES;
        self.clickRecoImageView.hidden = NO;
        self.clickRecoImageView.frame = CGRectMake(self.recodImageView.frame.origin.x-80+35, self.recodImageView.frame.origin.y-244-30,206, 244);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickRecoImageView.frame = CGRectMake(self.recodImageView.frame.origin.x-80+35, self.recodImageView.frame.origin.y-244,206, 244);
        } completion:nil];
    }
}

- (void)closeClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定放弃任务吗？" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            if (weakSelf.isLead) {
                [weakSelf.listenView removeFromSuperview];
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"100"}];
        }
    };
    [alerView showXLAlertView];
}

- (UIImageView *)clickRecoImageView{
    if (!_clickRecoImageView) {
        _clickRecoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.recodImageView.frame.origin.x-80+35, self.recodImageView.frame.origin.y-244,206, 244)];
        _clickRecoImageView.image = UIImageNamed(@"Image_clickreclead10");
        [self.view addSubview:_clickRecoImageView];
        _clickRecoImageView.hidden = YES;
    }
    return _clickRecoImageView;
}

- (UIImageView *)clickFinishImageView{
    if (!_clickFinishImageView) {
        _clickFinishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sureBtn.frame.origin.x+28, self.sureBtn.frame.origin.y-97, 112, 97)];
        _clickFinishImageView.image = UIImageNamed(@"Image_recoderFinish10");
        [self.view addSubview:_clickFinishImageView];
        _clickFinishImageView.hidden = YES;
    }
    return _clickFinishImageView;
}

- (void)changeClick{
    if (!self.changeTypeL.hidden) {
        self.changeView.locaPath = @"";
        [self.changeView show];
    }
}

- (NoticeChangeVoiceView *)changeView{
    if (!_changeView) {
        _changeView = [[NoticeChangeVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _changeView.typeModelBlock = ^(NoticeVoiceTypeModel * _Nonnull model) {
            weakSelf.typeModel = model;
        };
    }
    return _changeView;
}

- (void)setTypeModel:(NoticeVoiceTypeModel *)typeModel{
    _typeModel = typeModel;
    [self.voiceTypeBtn setTitle:[NSString stringWithFormat:@"%@：%@",[NoticeTools getLocalStrWith:@"ly.typevoice"],typeModel.typeName] forState:UIControlStateNormal];
}

//完成录制
- (void)sureUp{
    self.isSureFinish = YES;
    [self pasuceClick];
}

//结束录制
- (void)pasuceClick{

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
    if (self.isLead) {
        self.clickRecoImageView.hidden = YES;
    }
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
            NSString *str = [NSString stringWithFormat:@"%@%lds",[NoticeTools getLocalStrWith:@"recoder.shegnxiatime"],300-_currentRecodTime];
            NSString *str1 = [NSString stringWithFormat:@"%lds",300-_currentRecodTime];
            self.markL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#DB6E6E"] setLengthString:str1 beginSize:4];
            [self pauseRecoder];
        }
    }else{
        self.markL.text = [NoticeTools getLocalStrWith:@"recoder.300"];
        [self rePlayClick];
    }
}

- (void)recoders{
    self.navBarView.rightButton.hidden = YES;
    self.reRecoderBtn.hidden = NO;
    self.sureBtn.hidden = NO;
    self.reLabel.hidden = NO;
    self.changeTypeL.hidden = YES;
    self.sureLabel.hidden = NO;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.reing"];
    
    self.markL.text = [NoticeTools getLocalStrWith:@"recoder.300"];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"ly_reing") forState:UIControlStateNormal];
    self.isRecoding = YES;
    self.startRecoder = YES;
    self.isPauseRecoding = NO;
    [self.recorder startRecording];
    
    if (self.isLead) {//新手指南
        self.clickFinishImageView.hidden = NO;
        self.clickFinishImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-112, self.sureBtn.frame.origin.y-97-30, 112, 97);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickFinishImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-112, self.sureBtn.frame.origin.y-97, 112, 97);
        } completion:nil];
    }
}

//继续录音
- (void)rePlayClick{
    
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.recroging"];
    self.isShowFinish = NO;
    self.isRecoding = NO;
    [self.recodImageView setBackgroundImage:UIImageNamed(@"ly_reing") forState:UIControlStateNormal];
    self.isRecoding = YES;
    self.isPauseRecoding = NO;
    self.isBeginFromContion = YES;
    [self.recorder contuintRecording];
    [self startRecordTimer];
    [self.recodImageView startPulseWithColor:[UIColor colorWithHexString: @"#b2b2b2"] animation:YGPulseViewAnimationTypeRadarPulsing];
    
}


- (void)destory
{
    [self stopRecordTimer];
}

//重新录制
- (void)rerecoderClick{
    
    self.timeL.text = @"0s";
    self.isRecoding = NO;
    self.markL.text = [NoticeTools getLocalStrWith:@"recoder.300"];
    self.reRecoderBtn.hidden = YES;
    self.sureBtn.hidden = YES;
    self.reLabel.hidden = YES;
    self.changeTypeL.hidden = NO;
    self.sureLabel.hidden = YES;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.clickluy"];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"Image_newclickRec") forState:UIControlStateNormal];
    
    self.isRecoderClick = YES;
    self.isPauseRecoding = NO;
    self.startRecoder = NO;
    self.navBarView.rightButton.hidden = NO;
    self.isSureFinish = NO;
    [self.recorder stopRecording];
    
    if (self.isLead) {
        self.clickFinishImageView.hidden = YES;
        self.clickRecoImageView.hidden = NO;
        self.clickRecoImageView.frame = CGRectMake(self.recodImageView.frame.origin.x-80+35, self.recodImageView.frame.origin.y-244-30,206, 244);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickRecoImageView.frame = CGRectMake(self.recodImageView.frame.origin.x-80+35, self.recodImageView.frame.origin.y-244,206, 244);
        } completion:nil];
    }
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
    if (self.startRecoder) {
        __weak typeof(self) weakSelf = self;
        
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.showt"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf rerecoderClick];
                //取消设置屏幕常亮
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
    }else{
        //取消设置屏幕常亮
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//确定完成
- (void)sureFinish{
    if (!self.localAACUrl) {
        [self showToastWithText:@"录音失败"];
        return;
    }
    
    if (!self.audioTimeLen) {
        [self showToastWithText:@"录音失败"];
        return;
    }

    self.listenView.vocieTypeM = self.typeModel;
    self.listenView.locaPath = self.localAACUrl;
    self.listenView.timeLen = [NSString stringWithFormat:@"%ld",self.audioTimeLen];
    [self.listenView show];
    self.typeModel.type = 0;
    [self.voiceTypeBtn setTitle:[NSString stringWithFormat:@"%@：%@",[NoticeTools getLocalStrWith:@"ly.typevoice"],self.typeModel.typeName] forState:UIControlStateNormal];
    [self rerecoderClick];
}

- (void)updateRecordTime{
    if (self.isPauseRecoding) {
        return;
    }
    _currentRecodTime = self.isBeginFromContion? self.oldRecodingTime:self.recorder.currentTime;
  
    self.isBeginFromContion = NO;

    [self.recodImageView setBackgroundImage:UIImageNamed(@"ly_reing") forState:UIControlStateNormal];
    
    self.oldRecodingTime = _currentRecodTime;

    if (_currentRecodTime >= 300) {
        self.isSureFinish = YES;
        [self.recorder stopRecording];
    }
    self.timeL.text = [NSString stringWithFormat:@"%lds",(long)_currentRecodTime];
    if (300 - _currentRecodTime <= 10) {
        NSString *str = [NSString stringWithFormat:@"%@%lds",[NoticeTools getLocalStrWith:@"recoder.shegnxiatime"],300-_currentRecodTime];
        NSString *str1 = [NSString stringWithFormat:@"%lds",300-_currentRecodTime];
        self.markL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#DB6E6E"] setLengthString:str1 beginSize:4];
    }
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
    [self.recodImageView setBackgroundImage:UIImageNamed(@"ly_zanting") forState:UIControlStateNormal];
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
    self.recordTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
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
                [weakSelf.recodImageView startPulseWithColor:[UIColor colorWithHexString:@"#DB6E6E"] animation:YGPulseViewAnimationTypeRadarPulsing];
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
            [weakSelf.recodImageView stopPulse];
            if (weakSelf.isGiveUp) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            if (weakSelf.isRecoderClick && !weakSelf.isSureFinish) {
                weakSelf.isRecoderClick = NO;
                weakSelf.audioTimeLen = 0;
                weakSelf.timeL.text = [NSString stringWithFormat:@"%lus",(unsigned long)weakSelf.audioTimeLen];
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
                    weakSelf.timeL.text = [NSString stringWithFormat:@"%lus",(unsigned long)weakSelf.audioTimeLen];
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


- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        _navBarView.hidden = YES;
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView.rightButton addTarget:self action:@selector(moreclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

//右上角更多按钮点击
- (void)moreclick{
    [self.pickerView show];
}

- (NoticeChoicePickerImgView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[NoticeChoicePickerImgView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _pickerView.typeChoiceBlock = ^(BOOL isImagPicker) {
            if (isImagPicker) {
                TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:weakSelf];
                imagePicker.sortAscendingByModificationDate = NO;
                imagePicker.allowPickingOriginalPhoto = false;
                imagePicker.alwaysEnableDoneBtn = true;
                imagePicker.allowPickingVideo = false;
                imagePicker.allowPickingGif = false;
                imagePicker.allowPickingMultipleVideo = NO;
                imagePicker.showPhotoCannotSelectLayer = YES;
                imagePicker.allowCrop = NO;
                imagePicker.showSelectBtn = YES;
                imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
                [weakSelf presentViewController:imagePicker animated:NO completion:nil];
            }else{
                [weakSelf pushRead:NO];
            }
        };
    }
    return _pickerView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [self destory];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:1];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = nil;
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //不透明
        self.navigationController.navigationBar.translucent = NO;
        
    }else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#14151A"];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundEffect = nil;
        appperance.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = [[UIColor greenColor] colorWithAlphaComponent:0];
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }else{
    
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (NoticeRecoderTryListenView *)listenView{
    if (!_listenView) {
        _listenView = [[NoticeRecoderTryListenView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _listenView.isLead = self.isLead;
        __weak typeof(self) weakSelf = self;
        _listenView.actionBlock = ^(NSInteger type, NSString * _Nonnull timeLen, NSString * _Nonnull locaPath) {
            if (type == 0) {
                if (weakSelf.isLead) {
                    [weakSelf.moveArr removeAllObjects];
                    weakSelf.topicM = nil;
                    weakSelf.status = 0;
                    [weakSelf closeClick];
                    return;
                }
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.showtnbaoc"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        [weakSelf.moveArr removeAllObjects];
                        weakSelf.topicM = nil;
                        weakSelf.status = 0;
                        [weakSelf.listenView removeFromSuperview];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                };
                [alerView showXLAlertView];
            }else if(type == 2){
                NoticeSendViewController *ctl = [[NoticeSendViewController alloc] init];
                ctl.typeModel = weakSelf.listenView.vocieTypeM;
                ctl.isActivity = weakSelf.isFromActivity;
                ctl.locaPath = locaPath;
                ctl.resourcePath = locaPath;
                ctl.timeLen = timeLen;
                ctl.isLead = weakSelf.isLead;
                if (weakSelf.topicM) {
                    ctl.topicM = weakSelf.topicM;
                }
                if (weakSelf.moveArr.count) {
                    ctl.moveArr = weakSelf.moveArr;
                }
                
                if (weakSelf.status > 0) {
                    ctl.status = weakSelf.status;
                }
                if (weakSelf.topicId) {
                    ctl.topicId = weakSelf.topicId;
                    ctl.topicName = weakSelf.topicName;
                }
                if (!weakSelf.readingView.hidden) {
                    ctl.readId = weakSelf.readingView.readModel.readId;
                }
                ctl.reEditVoiceBlock = ^(NoticeTopicModel * _Nonnull topicM, NSMutableArray * _Nonnull moveArr,NSInteger status) {
                    weakSelf.moveArr = moveArr;
                    weakSelf.topicM = topicM;
                    weakSelf.status = status;
                    [weakSelf.listenView show];
                };
                
                ctl.voiceById = [NSString stringWithFormat:@"%ld",weakSelf.listenView.vocieTypeM.type];
                CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                                withSubType:kCATransitionFromLeft
                                                                                   duration:0.3f
                                                                             timingFunction:kCAMediaTimingFunctionLinear
                                                                                       view:weakSelf.navigationController.view];
                [weakSelf.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
                [weakSelf.navigationController pushViewController:ctl animated:YES];
            }
        };
    }
    return _listenView;
}

//选择图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    if (photos.count) {
        [self.lookImgsView.photoArr removeAllObjects];
        for (int i = 0; i < photos.count;i++) {
            NoticeVoiceTypeModel *model = [[NoticeVoiceTypeModel alloc] init];
            model.currentImg = photos[i];
            if (i==0) {
                model.isChoice = YES;
                self.lookImgsView.currentModel = model;
                self.lookImgsView.imageShowView.image = model.currentImg;
                self.lookImgsView.imageShowView.hidden = NO;
                [CoreAnimationEffect animationEaseIn:self.lookImgsView.imageShowView];
            }else{
                model.isChoice = NO;
            }
            
            [self.lookImgsView.photoArr addObject:model];
        }
        self.lookImgsView.hidden = NO;
        [self.lookImgsView.collectionView reloadData];
        
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromTop
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionDefault
                                                                               view:self.lookImgsView];
        [self.lookImgsView.layer addAnimation:test forKey:@"pushanimation"];
        // 渐隐渐消
//        + (void)animationEaseIn:(UIView *)view;
//        + (void)animationEaseOut:(UIView *)view;
    }
}

- (NoticeLookImageViewView *)lookImgsView{
    if (!_lookImgsView) {
        _lookImgsView = [[NoticeLookImageViewView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.voiceTypeBtn.frame.origin.y-20)];
        [self.view addSubview:_lookImgsView];
        [self.view bringSubviewToFront:_lookImgsView];
        _lookImgsView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _lookImgsView.cancelBlock = ^(BOOL cancel) {
            
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recod.surefqnr"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [weakSelf rerecoderClick];
                    weakSelf.lookImgsView.imageShowView.hidden = YES;
                    weakSelf.lookImgsView.hidden = YES;
                }
            };
            [alerView showXLAlertView];
        };
    }
    return _lookImgsView;
}

- (NoticeReadAllContentView *)readingView{
    if (!_readingView) {
        _readingView = [[NoticeReadAllContentView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.voiceTypeBtn.frame.origin.y-20)];
        [self.view addSubview:_readingView];
        _readingView.hidden = YES;
        _readingView.isRecoder = YES;
        __weak typeof(self) weakSelf = self;
        _readingView.cancelBlock = ^(BOOL cancel) {
            
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recod.surefqnr"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [weakSelf rerecoderClick];
                    weakSelf.lookImgsView.imageShowView.hidden = YES;
                    weakSelf.lookImgsView.hidden = YES;
                    weakSelf.readingView.hidden = YES;
                    [weakSelf pushRead:weakSelf.isPushHeji];
                }
            };
            [alerView showXLAlertView];
        };
        [_readingView refreshUI];
    }
    return _readingView;
}


- (void)pushRead:(BOOL)isPushheji{
    __weak typeof(self) weakSelf = self;
    if (isPushheji) {
        NoticeHeJiListController *ctl = [[NoticeHeJiListController alloc] init];
        ctl.readModel = self.readModel;
        ctl.readingBlock = ^(NoticeVoiceReadModel * _Nonnull readM, BOOL isHejiBack) {
            weakSelf.readingView.readModel = readM;
            weakSelf.readingView.isRecoder = YES;
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.noPop = YES;
            weakSelf.readingView.hidden = NO;
            weakSelf.readModel = readM;
            weakSelf.isPushHeji = isHejiBack;
            [CoreAnimationEffect animationEaseIn:weakSelf.readingView];
        };
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:self.navigationController.view];
        [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [self.navigationController pushViewController:ctl animated:NO];
    }else{
        NoticeVoiceReadController *ctl = [[NoticeVoiceReadController alloc] init];
        ctl.readingBlock = ^(NoticeVoiceReadModel * _Nonnull readM, BOOL isHejiBack) {
            weakSelf.readingView.readModel = readM;
            weakSelf.readingView.isRecoder = YES;
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.noPop = YES;
            weakSelf.readingView.hidden = NO;
            weakSelf.readModel = readM;
            weakSelf.isPushHeji = isHejiBack;
            [CoreAnimationEffect animationEaseIn:weakSelf.readingView];
        };
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                        withSubType:kCATransitionFromLeft
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:self.navigationController.view];
        [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [self.navigationController pushViewController:ctl animated:NO];
    }
}
@end
