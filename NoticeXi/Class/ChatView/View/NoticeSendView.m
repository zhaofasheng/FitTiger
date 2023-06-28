//
//  NoticeSendView.m
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSetYuReplyController.h"
#import "NoticeListenLocalVoiceView.h"
@implementation NoticeSendView
{
    BOOL _isAudio;
    BOOL cancelSend;
    UIView *_bakcView;
    
    UIImageView *_backImageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.0];
        
        self.userInteractionEnabled = YES;
        
        UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,frame.size.height)];
        backImgV.image = UIImageNamed(@"mohudupng");
        [self addSubview:backImgV];
        _backImageView = backImgV;
        
  
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
        _recordButton.layer.cornerRadius = 18;
        _recordButton.layer.masksToBounds = YES;
        _recordButton.exclusiveTouch = YES;
        _recordButton.frame = CGRectMake(20,6, DR_SCREEN_WIDTH-40,36);
        [_recordButton addTarget:self action:@selector(recoderClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordButton];
        
        CGFloat width = 24+4+GET_STRWIDTH([NoticeTools getLocalStrWith:@"chat.messageSend"], 14, 36);
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_recordButton.frame.size.width-width)/2, 6, 24, 24)];
        self.imageView.image = UIImageNamed(@"img_microphone");
        [_recordButton addSubview:self.imageView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+4, 0, GET_STRWIDTH([NoticeTools getLocalStrWith:@"chat.messageSend"], 14, 36), 36)];
        self.titleL.font = FOURTHTEENTEXTFONTSIZE;
        self.titleL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        self.titleL.text = [NoticeTools getLocalStrWith:@"chat.messageSend"];
        [_recordButton addSubview:self.titleL];

        NSArray *arr = @[@"Image_whiteem",@"Image_newsendimgpri",@"Image_carramim",@"Image_httpimg",@"Image_whiteimg"];
        CGFloat space = (DR_SCREEN_WIDTH-80-34*4)/4;
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40+(24+space)*i, CGRectGetMaxY(_recordButton.frame)+10, 24, 24)];
            [btn setImage:UIImageNamed(arr[i]) forState:UIControlStateNormal];
            [self addSubview:btn];
            if (i == 0) {
                self.emtionBtn = btn;
            }else if (i == 1){
                self.imgBtn = btn;
            }else if(i == 2){
                self.carmBtn = btn;
            }else if(i == 3){
                self.httpBtn = btn;
            }else if(i == 4){
                self.whiteBtn = btn;
            }
        }
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.3;
        [_recordButton addGestureRecognizer:longPress];

        self.textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 42)];
        self.textView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self addSubview:self.textView];
        self.textView.hidden = YES;
        
        self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(5,0,DR_SCREEN_WIDTH-20-64-5, 36)];
        self.topicField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
        self.topicField.font = FOURTHTEENTEXTFONTSIZE;
        self.topicField.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"group.copylianjie"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8]}];
        [self.topicField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.topicField.delegate = self;
     
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 6, DR_SCREEN_WIDTH-64-20, 36)];
        backV.layer.cornerRadius = 18;
        backV.layer.masksToBounds = YES;
        backV.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.2];
        [backV addSubview:self.topicField];
        [self.textView addSubview:backV];
        self.backV = backV;
        
        self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backV.frame),6, 64, 36)];
        [self.sendBtn setTitle:[NoticeTools getLocalStrWith:@"read.send"] forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.sendBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.textView addSubview:self.sendBtn];
    }
    return self;
}

- (void)setIsHs:(BOOL)isHs{
    _isHs = isHs;
    if (_isHs) {
        self.topicField.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.carmBtn.hidden = YES;
        self.whiteBtn.hidden = YES;
        _backImageView.hidden = YES;
        [self.httpBtn setImage:UIImageNamed(@"Image_hslinkimg") forState:UIControlStateNormal];
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        
        self.httpBtn.frame = CGRectMake(10, 0, 44, 50);
        self.recordButton.frame = CGRectMake(54, 7, DR_SCREEN_WIDTH-54-18-24-10-24-20,36);
        self.recordButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.recordButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        self.emtionBtn.frame = CGRectMake(CGRectGetMaxX(self.recordButton.frame)+18, 0, 24, 50);
        self.imgBtn.frame = CGRectMake(CGRectGetMaxX(self.emtionBtn.frame)+10, 0, 24, 50);
        CGFloat width = 24+4+GET_STRWIDTH([NoticeTools getLocalStrWith:@"chat.messageSend"], 14, 36);
        self.imageView.frame = CGRectMake((_recordButton.frame.size.width-width)/2, 6, 24, 24);
        self.titleL.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+4, 0, GET_STRWIDTH([NoticeTools getLocalStrWith:@"chat.messageSend"], 14, 36), 36);
        
        self.textView.backgroundColor = [UIColor whiteColor];
        self.backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.textView.frame = CGRectMake(54, 0, DR_SCREEN_WIDTH-54, 42);
        self.backV.frame = CGRectMake(0, 6, DR_SCREEN_WIDTH-64-54, 36);
        self.sendBtn.frame = CGRectMake(CGRectGetMaxX(_backV.frame),6, 64, 36);
    }
}


- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;

    if (_field.text.length) {
        [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
    }else{
        [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }
}

- (instancetype)initWithisHs:(BOOL)ishs{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        
        self.userInteractionEnabled = YES;

    }
    return self;
}


- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (self.isLead) {
        return;
    }
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendTextDelegate)]) {
            [self.delegate sendTextDelegate];
        }
    }
}

- (void)recoderClick{
   [self onTouchRecordBtnDown];
}

- (void)onTouchRecordBtnDown{
    cancelSend = NO;
    self.recordPhase = NAudioRecordPhaseStart;

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
    if (!self.isHs) {
        NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
        recodeView.isSayToSelf = YES;
        recodeView.hideCancel = NO;
        recodeView.noPushLeade = YES;
        recodeView.isLead = self.isLead;
        recodeView.isReply = YES;
        __weak typeof(self) weakSelf = self;
        recodeView.overGuidelock = ^(BOOL isGiveUp) {
            if (weakSelf.overGuidelock) {
                weakSelf.overGuidelock(YES);
            }
        };
        recodeView.delegate = self;
        recodeView.startRecdingNeed = YES;
        [recodeView show];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(onStartRecording)]) {
        [self.delegate onStartRecording];
    }
}

- (void)reRecoderLocalVoice{
    [self onTouchRecordBtnDown];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendTime:path:)]) {
        [self.delegate sendTime:timeLength.intValue path:locaPath];
    }
}

- (UIViewController *)theTopviewControler{

    //获取根控制器
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    UIViewController *parent = rootVC;
    //遍历 如果是presentViewController
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
   
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    return rootVC;
}

@end
