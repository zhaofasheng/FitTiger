//
//  NoticeRecoderView.m
//  NoticeXi
//
//  Created by li lei on 2018/10/25.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeRecoderView.h"
#import "LGAudioPlayer.h"
#import "LGVoiceRecorder.h"
#import "AppDelegate.h"
#import "NoticePhotoListView.h"
#import "NoticeWebViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeTextVoiceController.h"
#import "NoticeScroEmtionView.h"
#import "YYKit.h"
#import "NoticeGetPhotosFromLibary.h"
#import "NoticeBgmView.h"
#import "NoticeCustomView.h"
#import "NoticeListenLocalVoiceView.h"
#import "NoticeBgmLineView.h"
#import "NoticeCurentLeaveController.h"
#import "WHWeatherView.h"
#import "NoticeXi-Swift.h"
@interface NoticeRecoderView()

@property (nonatomic, assign) BOOL isSureFinish;//确定录制完成
@property (nonatomic, assign) BOOL startRecoder;
@property (nonatomic, assign) BOOL isGiveUp;
@property (nonatomic, assign) BOOL isReRecoder;//删除重新录制
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *recodImageView;
@property (nonatomic, strong) NoticeCustumMusiceModel *currentModel;
@property (nonatomic, strong) NSString *choiceMusic;
@property (nonatomic, strong) NSString *musicId;
@property (nonatomic, strong) NSTimer *recordTimer; //录音定时器
@property (nonatomic, strong) NSString *localAACUrl; //aac地址
@property (nonatomic, assign) NSInteger currentRecodTime;
@property (nonatomic, assign) BOOL isRecoding;//判断是否在录制
@property (nonatomic, assign) BOOL isPlaying;//判断是否在播放
@property (nonatomic, assign) BOOL isPausePlaying;//判断播放是否是暂停
@property (nonatomic, assign) BOOL isFromOpen;//判断是否在播放
@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL isShowFinish;//暂停了显示了完成UI
@property (nonatomic, strong) UIButton *lookPhotoBtn;
@property (nonatomic, strong) UIButton *musicBtn;
@property (nonatomic, assign) BOOL isLook;
@property (nonatomic, assign) BOOL isNiMing;
@property (nonatomic, assign) BOOL photoOpen;
@property (nonatomic, assign) BOOL isShowAting;
@property (nonatomic, assign) BOOL isRecodingNoDiss;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *phassetArr;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) NoticePhotoListView *photolistView;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) NoticeScroEmtionView *emotionView;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) BOOL isEmotion;
@property (nonatomic, assign) BOOL isBeginFromContion;//从暂停录音状态继续录音
@property (nonatomic, assign) BOOL isRecoderClick;//重新录制
@property (nonatomic, assign) BOOL isPauseRecoding;//暂停录音状态
@property (nonatomic, assign) NSInteger oldRecodingTime;//暂停录音时记录当前时间
@property (nonatomic, strong) UIView *hstitleView;
@property (nonatomic, strong) UIButton *giveUpBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *pyTypeL;
@property (nonatomic, strong) UIImageView *sureColorImageView;
@property (nonatomic, strong) UIButton *reRecoderBtn;
@property (nonatomic, strong) NoticeBgmView *bgmView;
@property (nonatomic, strong) NoticeBgmLineView *bgmLineView;
@property (nonatomic, strong) UIView *pyFgView;
@property (nonatomic, strong) NoticeListenLocalVoiceView *listenLocalView;
@property (nonatomic, strong) NoticeCustomView *imageShowView;
@property (nonatomic, strong) UILabel *reLabel;
@property (nonatomic, strong) UILabel *reingLabel;
@property (nonatomic, strong) UILabel *sureLabel;

@property (nonatomic, strong) WHWeatherView *weatherView;
@end

@implementation NoticeRecoderView
{
    BOOL _canNotDiss;
}

- (instancetype)shareRecoderViewWithNoclean{
    if (self == [super init]) {
        [self setUI:@""];
        self.isRecoding = NO;
        self.isPlaying = NO;
        self.isFromOpen = NO;
    }
    return self;
}

- (instancetype)shareRecoderViewWithPeiYing:(NSString *)content{
    if (self == [super init]) {
        
        self.isRecoding = NO;
        self.isPlaying = NO;
        
        [self setUI:@""];
        self.isPy = YES;
        CGFloat height = [self getSpaceLabelHeight:content withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-80];
        
        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-(305+BOTTOM_HEIGHT)-BOTTOM_HEIGHT-10-height-30-55, DR_SCREEN_WIDTH-40, height+40+10)];
        self.contentBackView.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
        self.contentBackView.layer.cornerRadius = 10;
        self.contentBackView.layer.masksToBounds = YES;
        [self addSubview:self.contentBackView];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(20, 40,self.contentBackView.frame.size.width-40, height)];
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [UIColor colorWithHexString:@"#B8BECC"];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.attributedText = [self setLabelSpacewithValue:content withFont:FOURTHTEENTEXTFONTSIZE];
        [self.contentBackView addSubview:self.contentL];
        
        self.pyTypeL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
        self.pyTypeL.font = TWOTEXTFONTSIZE;
        self.pyTypeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentBackView addSubview:self.pyTypeL];
    }
    return self;
}

//返回文案
-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;//设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          
    };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (instancetype)shareRecoderViewWithStartRecod:(LGVoiceRecorder *)recoder{
    if (self == [super init]) {
        self.isRecoding = YES;
        self.isPlaying = NO;
        self.recorder = recoder;
        self.isFromOpen = YES;
        [self setUI:@""];
        [self startRecordTimer];
    }
    return self;
}

- (instancetype)shareRecoderViewWith:(NSString *)title{
    if (self == [super init]) {
        self.isFromOpen = NO;
        self.isRecoding = NO;
        self.isPlaying = NO;
        [self setUI:title];
        //[self.recorder reRecording];//每次进来清除之前记录
    }
    return self;
}

- (instancetype)shareRecoderViewWithSong:(BOOL)isSong{
    if (self == [super init]) {
        self.isSong = isSong;
        self.isFromOpen = NO;
        self.isRecoding = NO;
        self.isPlaying = NO;
        [self setUI:@""];
        [self.recorder reRecording];//每次进来清除之前记录
    }
    return self;
}

//悄悄话
- (void)setIsHS:(BOOL)isHS{
    _isHS = isHS;
    if (isHS) {

        self.titleL.text = @"";
        self.giveUpBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25,13, 25, 25);
        [self.giveUpBtn setTitle:@"" forState:UIControlStateNormal];
        [self.giveUpBtn setImage:UIImageNamed(@"Image_giveluyin") forState:UIControlStateNormal];
    }
}

//给自己留言
- (void)setIsSayToSelf:(BOOL)isSayToSelf{
    _isSayToSelf = isSayToSelf;
    self.giveUpBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25,13, 25, 25);
    [self.giveUpBtn setTitle:@"" forState:UIControlStateNormal];
    [self.giveUpBtn setImage:UIImageNamed(@"Image_giveluyin") forState:UIControlStateNormal];
}

//切换消息类型
- (void)changeClick{
    if (self.isRecoding) {
        return;
    }
    self.isEmotion = !self.isEmotion;
    if (self.isEmotion) {
        self.hstitleView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.emotionView.frame = CGRectMake(0,50, DR_SCREEN_WIDTH,self.functionView.frame.size.height-50);
        }];
        self.changeButton.frame = CGRectMake(15, 13, 25, 25);
        [self.changeButton setBackgroundImage:UIImageNamed(@"Image_groupvoice_b") forState:UIControlStateNormal];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.emotionView.frame = CGRectMake(DR_SCREEN_WIDTH,50, DR_SCREEN_WIDTH,self.functionView.frame.size.height-50);
        }];
        [self.changeButton setBackgroundImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.changeButton.frame = CGRectMake(DR_SCREEN_WIDTH-15-25-15-25,13, 25, 25);
        self.hstitleView.hidden = NO;
    }
}


//对方是不是自动回复
- (void)setIsAuto:(BOOL)isAuto{
    _isAuto = isAuto;
    if (!isAuto) {
        self.markImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"online_img":@"online_imgy");
    }else{
        self.markImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"no_online_img":@"no_online_imgy");
    }
}


- (void)setIsDb:(BOOL)isDb{
    _isDb = isDb;
    if (isDb) {
        self.giveUpBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25,13, 25, 25);
        [self.giveUpBtn setTitle:@"" forState:UIControlStateNormal];
        [self.giveUpBtn setImage:UIImageNamed(@"Image_giveluyin") forState:UIControlStateNormal];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-50*2, 50)];
        self.titleL.font = XGTwentyBoldFontSize;
        self.titleL.text = [NoticeTools getLocalStrWith:@"recoder.recqianm"];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.functionView addSubview:self.titleL];
    }
}

//是否是配音
- (void)setIsPy:(BOOL)isPy{
    _isPy = isPy;
    if (self.selectBtn) {
        return;
    }
    self.pyFgView.hidden = YES;
    self.giveUpBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25,13, 25, 25);
    [self.giveUpBtn setTitle:@"" forState:UIControlStateNormal];
    [self.giveUpBtn setImage:UIImageNamed(@"Image_giveluyin") forState:UIControlStateNormal];
    
    UIButton *seleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,13 ,66, 24)];
    seleBtn.layer.cornerRadius = 12;
    seleBtn.layer.masksToBounds = YES;
    seleBtn.layer.borderWidth = 1;
    seleBtn.layer.borderColor = [UIColor colorWithHexString:@"#8A8F99"].CGColor;
    [seleBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    [seleBtn setTitle:[NoticeTools getLocalStrWith:@"recoder.niming"] forState:UIControlStateNormal];
    seleBtn.backgroundColor = [UIColor colorWithHexString:@"#292B33"];

    seleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [seleBtn addTarget:self action:@selector(isNiMingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:seleBtn];
    self.selectBtn = seleBtn;
}

- (UIView *)pyFgView{
    if (!_pyFgView) {
        _pyFgView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 35)];
        _pyFgView.backgroundColor = GetColorWithName(VBackColor);
        _pyFgView.layer.cornerRadius = 20;
        _pyFgView.layer.masksToBounds = YES;
        [self addSubview:_pyFgView];
        [self sendSubviewToBack:_pyFgView];
        _pyFgView.hidden = YES;
    }
    return _pyFgView;
}

- (void)setPyTag:(NSInteger)pyTag{
    _pyTag = pyTag;
    if (_pyTag == 2) {
        self.pyTypeL.text = @"求freestyle#";
    }else{
        self.pyTypeL.text = @"#求配音";
    }
}

- (void)setNeedLongTap:(BOOL)needLongTap{
    _needLongTap = needLongTap;
    if (needLongTap && self.isSend) {
        NSArray *arr = @[[NoticeTools getLocalStrWith:@"recoder.sayyoufann"],[NoticeTools getLocalStrWith:@"recoder.sayyoukuaile"]];
        self.markL.text = arr[arc4random()%2];
    }else if (self.isHS){
        self.markL.text = [NoticeTools getLocalStrWith:@"recoder.zhenzhiyongheng"];
    }
}

- (void)setUI:(NSString *)title{
    //设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOrder) name:@"HASNEWORDERCHANTORDER" object:nil];
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-305-BOTTOM_HEIGHT)];
    tapView.userInteractionEnabled = YES;
    [tapView addGestureRecognizer:tap];
    [self addSubview:tapView];
    _tapView = tapView;
    
    self.functionView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 305+BOTTOM_HEIGHT+20)];
    self.functionView.backgroundColor =  [[UIColor colorWithHexString:@"#A6B9CC"] colorWithAlphaComponent:1];
    self.functionView.layer.cornerRadius = 20;
    self.functionView.layer.masksToBounds = YES;
    [self addSubview:self.functionView];
    

    self.giveUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,13,67, 25)];
    [self.giveUpBtn addTarget:self action:@selector(giveUpClick) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:self.giveUpBtn];

    self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,76, DR_SCREEN_WIDTH,24)];
    self.timeL.font = XGTwentyFifBoldFontSize;
    self.timeL.text = @"0s";
    self.timeL.textAlignment = NSTextAlignmentCenter;
    self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.functionView addSubview:self.timeL];
        
    //录制按钮
    self.recodImageView = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-71)/2, CGRectGetMaxY(self.timeL.frame)+25, 71, 71)];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"btn_rec_default") forState:UIControlStateNormal];
    self.recodImageView.layer.cornerRadius = 71/2;
    self.recodImageView.layer.masksToBounds = YES;
    [self.functionView addSubview:self.recodImageView];
    
    self.reingLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.recodImageView.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 71, 14)];
    self.reingLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.reingLabel.font = [UIFont systemFontOfSize:10];
    self.reingLabel.textAlignment = NSTextAlignmentCenter;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.clickluy"];
    [self.functionView addSubview:self.reingLabel];
    
    self.markL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-234)/2,CGRectGetMaxY(self.recodImageView.frame)+50, 234, 44)];
    self.markL.font = FOURTHTEENTEXTFONTSIZE;
    self.markL.text = self.needLongTap?[NoticeTools getLocalStrWith:@"chat.messageSend"]: [NoticeTools getLocalStrWith:@"recoder.clickluy"];
    self.markL.textAlignment = NSTextAlignmentCenter;
    self.markL.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.functionView addSubview:self.markL];
    
    //确定按钮
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.recodImageView.frame)+40,self.recodImageView.frame.origin.y+8, 56, 56)];
    [self.sureBtn setBackgroundImage:UIImageNamed(@"Imagefinfishluyin") forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureUp) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:self.sureBtn];
    self.sureBtn.hidden = YES;
    
    self.sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sureBtn.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 56, 14)];
    self.sureLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.sureLabel.font = [UIFont systemFontOfSize:10];
    self.sureLabel.textAlignment = NSTextAlignmentCenter;
    self.sureLabel.text = [NoticeTools getLocalStrWith:@"groupfm.finish"];
    self.sureLabel.hidden = YES;
    [self.functionView addSubview:self.sureLabel];
    
    //删除重录按钮
    self.reRecoderBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.recodImageView.frame.origin.x-40-56,self.recodImageView.frame.origin.y+8, 56, 56)];
    [self.reRecoderBtn setBackgroundImage:UIImageNamed(@"Image_cxluzhi") forState:UIControlStateNormal];
    [self.reRecoderBtn addTarget:self action:@selector(rerecoderClick) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:self.reRecoderBtn];
    self.reRecoderBtn.hidden = YES;
    
    self.reLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.reRecoderBtn.frame.origin.x, CGRectGetMaxY(self.recodImageView.frame)+6, 56, 14)];
    self.reLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.reLabel.font = [UIFont systemFontOfSize:10];
    self.reLabel.textAlignment = NSTextAlignmentCenter;
    self.reLabel.text = [NoticeTools getLocalStrWith:@"em.rerecoder"];
    [self.functionView addSubview:self.reLabel];
    self.reLabel.hidden = YES;
    
    [self.functionView bringSubviewToFront:self.recodImageView];
    [self.recodImageView addTarget:self action:@selector(startOrStop) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.3;
    [self.recodImageView addGestureRecognizer:longPress];
}

- (void)isNiMingClick:(UIButton *)button{
    self.isNiMing = !self.isNiMing ;
    if (self.isNiMing ) {
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [button setTitle:[NoticeTools getLocalStrWith:@"recoder.nimingOn"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        button.layer.borderWidth = 0;
    }else{
        [button setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        [button setTitle:[NoticeTools getLocalStrWith:@"recoder.niming"] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:0.6];
    }
}

- (void)setIsRgister:(BOOL)isRgister{
    _isRgister = isRgister;
    if (_isRgister) {
        self.markL.text = [NoticeTools getLocalStrWith:@"chat.messageSend"];
        _tapView.userInteractionEnabled = NO;
        [self.giveUpBtn removeFromSuperview];
    }
}

- (void)setStartRecdingNeed:(BOOL)startRecdingNeed{
    _startRecdingNeed = startRecdingNeed;
    [self startOrStop];
}

//发心情
- (void)setIsSend:(BOOL)isSend{
    _isSend = isSend;
    if (_isSend) {

        self.functionView.layer.cornerRadius = 0;
        if (self.needLookPhoto) {
            self.lookPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-36,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-36)/2, 36, 36)];
            [self.lookPhotoBtn addTarget:self action:@selector(openPhotoClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.lookPhotoBtn];
            [self.lookPhotoBtn setImage:UIImageNamed(@"Image_ktsh") forState:UIControlStateNormal];
            self.lookPhotoBtn.layer.cornerRadius = 36/2;
            self.lookPhotoBtn.layer.masksToBounds = YES;
            self.lookPhotoBtn.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.3];
        }
        
        self.musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-36-20-36,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-36)/2, 36, 36)];
        [self.musicBtn addTarget:self action:@selector(openmusicClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.musicBtn];
        [self.musicBtn setImage:UIImageNamed(@"Image_zdyyiny") forState:UIControlStateNormal];
        self.musicBtn.layer.cornerRadius = 36/2;
        self.musicBtn.layer.masksToBounds = YES;
        self.musicBtn.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.3];
        
        [self.giveUpBtn removeFromSuperview];
        [self.bgmView addSubview:self.giveUpBtn];

        [self.giveUpBtn setImage:UIImageNamed(@"Image_giveluyin") forState:UIControlStateNormal];
        self.giveUpBtn.frame = CGRectMake(DR_SCREEN_WIDTH-10-50, 0, 50, 40);
     
        self.bgmView.custumeMusicView.hidden = YES;
        [self addSubview:self.bgmView.custumeMusicView];
        [self sendSubviewToBack:self.bgmView.custumeMusicView];
        
        [self bringSubviewToFront:self.lookPhotoBtn];
        [self bringSubviewToFront:self.musicBtn];
       // self.weatherView.hidden = NO;
    }
}

//是否是来自新手指南
- (void)setIsLead:(BOOL)isLead{
    _isLead = isLead;
    if (isLead) {
        [self.giveUpBtn removeFromSuperview];
        UIButton *closBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 52, 28)];
        [closBtn setBackgroundImage:UIImageNamed(@"Image_leaclose") forState:UIControlStateNormal];
        [closBtn addTarget:self action:@selector(clickLieadGive) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closBtn];
        
        self.clickRecoImageView.hidden = NO;
        self.clickRecoImageView.frame = CGRectMake((DR_SCREEN_WIDTH-182)/2-60, self.recodImageView.frame.origin.y-200-30, 182, 200);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickRecoImageView.frame = CGRectMake((DR_SCREEN_WIDTH-182)/2-60, DR_SCREEN_HEIGHT-180-BOTTOM_HEIGHT-200, 182, 200);
        } completion:nil];
    }
}

- (void)clickLieadGive{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定放弃任务吗？" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf mustGiveUp];
            if (!weakSelf.noPushLeade) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }

                CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                                withSubType:kCATransitionFromLeft
                                                                                   duration:0.3f
                                                                             timingFunction:kCAMediaTimingFunctionLinear
                                                                                       view:nav.topViewController.navigationController.view];
                [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
                NoticeLeaderController *ctl = [[NoticeLeaderController alloc] init];
                [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            }
            if (weakSelf.overGuidelock) {
                weakSelf.overGuidelock(YES);
            }
        }
    };
    [alerView showXLAlertView];
}

- (NoticePhotoListView *)photolistView{
    if (!_photolistView) {
        _photolistView = [[NoticePhotoListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-305-95-15+50)];
        __weak typeof(self) weakSelf = self;
        _photolistView.choiceBlock = ^(UIImage * _Nonnull image) {
            weakSelf.imageShowView.image = image;
            [weakSelf openPhotoClick];
            weakSelf.lookPhotoBtn.hidden = NO;
        };
        self.imageShowView = [[NoticeCustomView alloc] initWithFrame:_photolistView.frame];
        [self addSubview:self.imageShowView];
        self.imageShowView.hidden = YES;
        
        [self addSubview:_photolistView];
        [self sendSubviewToBack:_photolistView];
        _photolistView.hidden = YES;
    }
    return _photolistView;
}

//打开相册
- (void)openPhotoClick{
    
    self.bgmLineView.hidden = YES;
    self.photoOpen = !self.photoOpen;
    [self bringSubviewToFront:self.photolistView];
    self.photolistView.hidden = NO;
    self.bgmView.custumeMusicView.hidden = YES;
    if (self.photoOpen) {
        self.photolistView.hidden = NO;
    }else{
        self.photolistView.hidden = YES;
    }
    self.imageShowView.hidden = NO;
    [self bringSubviewToFront:self.bgmView];
    [self bringSubviewToFront:self.lookPhotoBtn];
    [self bringSubviewToFront:self.musicBtn];
    self.musicBtn.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.3];
    self.lookPhotoBtn.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.6];
    
}

- (void)openmusicClick{
    __weak typeof(self) weakSelf = self;
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if (!userM.level.intValue) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.lvsj"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                NoticeCurentLeaveController *ctl = [[NoticeCurentLeaveController alloc] init];
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                [weakSelf mustGiveUp];
            }
        };
        [alerView showXLAlertView];
        
        return;
    }
    self.bgmLineView.hidden = YES;
    self.bgmView.custumeMusicView.hidden = !self.bgmView.custumeMusicView.hidden;
    self.photolistView.hidden = YES;
    self.photoOpen = NO;
    self.imageShowView.hidden = YES;
    if (self.bgmView.custumeMusicView.hidden) {
        self.musicBtn.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.3];
    }else{
        self.musicBtn.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.6];
    }
    
    self.lookPhotoBtn.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.3];
    [self bringSubviewToFront:self.bgmView.custumeMusicView];
    [self bringSubviewToFront:self.musicBtn];
    [self bringSubviewToFront:self.lookPhotoBtn];
    self.markL.text = @"";
        
    self.backgroundColor = [[UIColor colorWithHexString:@"#A1A7B3"]colorWithAlphaComponent:0.8];
}


//点击确定
- (void)sureUp{
    self.isSureFinish = YES;
    [self pasuceClick];
}

- (void)sureFinish{
    if (!self.localAACUrl) {
        return;
    }
    if (!self.audioTimeLen) {
        return;
    }
    
    if (self.isHS || self.isPy || self.isGroupChatAt || self.isSayToSelf) {
        self.hidden = YES;
        __weak typeof(self) weakSelf = self;
        NoticeListenLocalVoiceView *listenV = [[NoticeListenLocalVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        listenV.localPath = self.localAACUrl;
        listenV.isLead = self.isLead;
        listenV.timeLength = self.audioTimeLen;

        listenV.sendBlock = ^(BOOL sureSend) {
            if (sureSend) {
                [weakSelf hasListenSureSend];
            }else{
                [weakSelf mustGiveUp];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(reRecoderLocalVoice)]) {
                    [weakSelf.delegate reRecoderLocalVoice];
                }
            }
        };
        [listenV showShareView];
        return;
    }

    [self hasListenSureSend];
}

- (void)hasListenSureSend{
    self.noReplay = YES;
    [self.audioPlayer stopPlaying];
    if (self.delegate && [self.delegate respondsToSelector:@selector(recoderSureWithPath:time:)]) {
        [self.delegate recoderSureWithPath:self.localAACUrl time:[NSString stringWithFormat:@"%lu",(unsigned long)self.audioTimeLen]];
    }
    
    if (self.isGroupChatAt) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recoderSureWithPath:time: atArr:)]) {
            [self.delegate recoderSureWithPath:self.localAACUrl time:[NSString stringWithFormat:@"%lu",(unsigned long)self.audioTimeLen] atArr:self.atArr];
        }
    }
    if (_isPy) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recoderSureWithPath:time: isNiMing:)]) {
            [self.delegate recoderSureWithPath:self.localAACUrl time:[NSString stringWithFormat:@"%lu",(unsigned long)self.audioTimeLen] isNiMing:self.isNiMing];
        }
    }
    if (_isSend || _isLead) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recoderSureWithPath:time: musiceId:)]) {
            [self.delegate recoderSureWithPath:self.localAACUrl time:[NSString stringWithFormat:@"%lu",(unsigned long)self.audioTimeLen] musiceId:self.musicId];
        }
    }
    if (_isRgister) {//如果是注册页面进来的，则不自动退出父视图
        return;
    }
    
    if (self.isSend) {
        [self.bgmView removeFromSuperview];
        [self.photolistView removeFromSuperview];
        [self.imageShowView removeFromSuperview];
    }

    [_HeaderView removeFromSuperview];
    _lookPhotoBtn.hidden = YES;
    
    [self removeFromSuperview];
}

- (void)setIsHasAdress:(BOOL)isHasAdress{

    if (isHasAdress) {
        self.isShowFinish = YES;
        self.localAACUrl = self.adressUrl;
        _currentRecodTime = self.timeLength;
        self.timeL.text = [NSString stringWithFormat:@"%lds",(long)self.timeLength];
        [self refreshWithMoreButton];
    }
}

- (void)setIsLongTime:(BOOL)isLongTime{
    _isLongTime = isLongTime;
    self.markL.text =_isLongTime?[NoticeTools getLocalStrWith:@"recoder.300"]:[NoticeTools getLocalStrWith:@"recoder.120"];
}

//停止录制刷新UI
- (void)refreshWithMoreButton{
    self.oldRecodingTime = 0;//停止录制，去除之前的时间

    if (self.isReply && self.audioTimeLen) {
        self.titleL.hidden = YES;

        self.needCancel = YES;
    }
    if (self.isSend) {
        _canNotDiss = NO;
    }
    if (self.localAACUrl) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recoderSureWithPathWithNoClick:time:)]) {
            [self.delegate recoderSureWithPathWithNoClick:self.localAACUrl time:[NSString stringWithFormat:@"%lu",(unsigned long)self.audioTimeLen]];
        }
    }
}

//结束录制
- (void)pasuceClick{
    if (self.isSend) {
        [self.bgmView removeFromSuperview];
        [self.photolistView removeFromSuperview];
        [self.imageShowView removeFromSuperview];
        self.bgmLineView.hidden = YES;
    }

    if (self.isRecoding || self.isPauseRecoding) {//如果正在录制或者暂停

        [self.recorder stopRecording];
    }else{
        if (self.localAACUrl) {
            [self sureFinish];
        }
    }
}

//开始了录音就显示停止录音按钮，包括暂停状态
- (void)setStartRecoder:(BOOL)startRecoder{
    _startRecoder = startRecoder;
}

- (void)mustGiveUp{
    
    self.isGiveUp = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideRecoderView)]) {
        [self.delegate hideRecoderView];
    }

    if (self.isRecoding || self.isPauseRecoding) {
        [self destory];
        if (self.delegate && [self.delegate respondsToSelector:@selector(giveUpRecoderIng:)]) {
            [self.delegate giveUpRecoderIng:YES];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(giveUpRecoderIng:)]) {
            [self.delegate giveUpRecoderIng:NO];
        }
        self.noReplay = YES;
        self.isSureFinish = NO;
        self.startRecoder = NO;
        _HeaderView.hidden = YES;
        self.groupBtnView.hidden = YES;
        [self removeFromSuperview];
    }
    [self.audioPlayer stopPlaying];
}

- (void)newOrder{
    [self mustGiveUp];
}

//放弃录制
- (void)giveUpClick{
    if (self.startRecoder) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.showt"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf mustGiveUp];
            }
        };
        [alerView showXLAlertView];
    }else{
        //取消设置屏幕常亮
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        if (self.delegate && [self.delegate respondsToSelector:@selector(hideRecoderView)]) {
            [self.delegate hideRecoderView];
        }
        [self removeFromSuperview];
    }
}


- (void)setIsCheers:(BOOL)isCheers{
    _isCheers = isCheers;
    if (_isCheers) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
}

- (void)cancelClick{

    if (self.isHS || _isPy) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.suregiveup"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf canDismiss];
            }
        };
        
        [alerView showXLAlertView];
        return;
    }
    [self dismiss];
}

- (void)setHideCancel:(BOOL)hideCancel{

    if (hideCancel) {
        self.titleL.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-40-10, 40);
    }
}

- (void)longPressGestureRecognized:(id)sender{
    if (self.isSend) {
        return;
    }
    if (!self.needLongTap) {
        return;
    }
    if (self.localAACUrl || self.isRecoding || self.startRecoder) {//开始了录音不允许跳转
        return;
    }

    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (longPressState == UIGestureRecognizerStateBegan) {
        if (self.isRgister || self.isHS || self.isSendTextMBS) {
            if (self.isHS || self.isSendTextMBS) {
                //取消设置屏幕常亮
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                self.noReplay = YES;
                [self.audioPlayer stopPlaying];
                [self destory];
                [self removeFromSuperview];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(longTapToSendText)]) {
                [self.delegate longTapToSendText];
            }
            return;
        }
        //取消设置屏幕常亮
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        self.noReplay = YES;
        [self.audioPlayer stopPlaying];
        [self destory];
        [self removeFromSuperview];
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
        ctl.topicId = self.topicId;
        ctl.topicName = self.topName;
        ctl.backRoot = self.isFromMain;
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                        withSubType:kCATransitionFromTop
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionDefault
                                                                               view:nav.topViewController.navigationController.view];
        [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
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
            NSString *str = [NSString stringWithFormat:@"%@%lds",[NoticeTools getLocalStrWith:@"recoder.shegnxiatime"],(self.isLongTime?300:120)-_currentRecodTime];
            NSString *str1 = [NSString stringWithFormat:@"%lds",(self.isLongTime?300:120)-_currentRecodTime];
            self.markL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:str1 beginSize:4];
            [self pauseRecoder];
        }
    }else{
        self.markL.text =self.isLongTime?[NoticeTools getLocalStrWith:@"recoder.300"]:[NoticeTools getLocalStrWith:@"recoder.120"];
        [self rePlayClick];
    }
}

- (void)recoders{
    self.reRecoderBtn.hidden = NO;
    self.sureBtn.hidden = NO;
    self.reLabel.hidden = NO;
    self.sureLabel.hidden = NO;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.reing"];
    
    self.markL.text =self.isLongTime?[NoticeTools getLocalStrWith:@"recoder.300"]:[NoticeTools getLocalStrWith:@"recoder.120"];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"luyonghzongtup") forState:UIControlStateNormal];
    self.isRecoding = YES;
    self.startRecoder = YES;
    self.isPauseRecoding = NO;
    self.giveUpBtn.hidden = NO;
    self.changeButton.hidden = YES;
    self.isRecodingNoDiss = YES;
    [self.recorder startRecording];
    
    if (self.isLead) {//新手指南
        self.clickFinishImageView.hidden = NO;
        self.clickFinishImageView.frame = CGRectMake((DR_SCREEN_WIDTH)/2+35+40-60, DR_SCREEN_HEIGHT-120-BOTTOM_HEIGHT-200-30, 112, 120);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickFinishImageView.frame = CGRectMake((DR_SCREEN_WIDTH)/2+35+40-60, DR_SCREEN_HEIGHT-120-BOTTOM_HEIGHT-200+8, 112, 120);
        } completion:nil];
    }
}


//重新录制
- (void)rerecoderClick{

    self.noReplay = YES;
    self.isRecoding = NO;
    if (self.isSend) {
        for (NoticeTextZJMusicModel *locaM in self.bgmView.dataArr) {
            locaM.noNeedRic = YES;
            locaM.isSelect = NO;
        }
        [self.bgmView.collectionView reloadData];
        self.noReplay = YES;

        [self.audioPlayer pause:YES];

        if (!self.bgmView.playCustumeView.hidden && self.bgmView.playCustumeView.musicModel.status) {
            [self.bgmView.custumeMusicView clickWith:self.bgmView.playCustumeView.musicModel];
        }
        [self.bgmView surecloseclick];
    }
    self.markL.text =_isLongTime?[NoticeTools getLocalStrWith:@"recoder.300"]:[NoticeTools getLocalStrWith:@"recoder.120"];
    self.reRecoderBtn.hidden = YES;
    self.sureBtn.hidden = YES;
    self.reLabel.hidden = YES;
    self.sureLabel.hidden = YES;
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.clickluy"];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"btn_rec_default") forState:UIControlStateNormal];
    
    self.isRecoderClick = YES;
    self.isPauseRecoding = NO;
    self.startRecoder = NO;
    
    self.isSureFinish = NO;
    [self.recorder stopRecording];
    
    
    if (self.isLead) {//新手指南
        self.clickFinishImageView.hidden = YES;
        self.clickRecoImageView.hidden = NO;
        self.clickRecoImageView.frame = CGRectMake((DR_SCREEN_WIDTH-182)/2-60, DR_SCREEN_HEIGHT-180-BOTTOM_HEIGHT-200-30, 182, 200);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.clickRecoImageView.frame = CGRectMake((DR_SCREEN_WIDTH-182)/2-60, DR_SCREEN_HEIGHT-180-BOTTOM_HEIGHT-200, 182, 200);
        } completion:nil];
    }
}

- (UIImageView *)clickRecoImageView{
    if (!_clickRecoImageView) {
        _clickRecoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-182)/2, DR_SCREEN_HEIGHT-180-BOTTOM_HEIGHT-200, 182, 200)];
        _clickRecoImageView.image = UIImageNamed(@"Image_clickreclead");
        [self addSubview:_clickRecoImageView];
        _clickRecoImageView.hidden = YES;
    }
    return _clickRecoImageView;
}

- (UIImageView *)clickFinishImageView{
    if (!_clickFinishImageView) {
        _clickFinishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH - self.sureBtn.frame.origin.x-112+25, self.sureBtn.frame.origin.y-200, 112, 144)];
        _clickFinishImageView.image = UIImageNamed(@"Image_recoderFinish");
        [self addSubview:_clickFinishImageView];
        _clickFinishImageView.hidden = YES;
    }
    return _clickFinishImageView;
}

//继续录音
- (void)rePlayClick{
    
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.recroging"];
  
    self.deleteBtn.hidden = YES;
    self.isShowFinish = NO;
    
    self.isRecoding = NO;
    [self.recodImageView setBackgroundImage:UIImageNamed(@"luyonghzongtup") forState:UIControlStateNormal];
    if (self.isSend) {
        if (!self.bgmView.playCustumeView.hidden && self.bgmView.playCustumeView.musicModel.status) {
            [self.bgmView.custumeMusicView clickWith:self.bgmView.playCustumeView.musicModel];
        }
        [self.audioPlayer pause:NO];
        for (NoticeTextZJMusicModel *locaM in self.bgmView.dataArr) {
            locaM.noNeedRic = NO;
        }
        [self.bgmView.collectionView reloadData];
    }
    
    self.isRecoding = YES;
    self.isPauseRecoding = NO;
    self.isBeginFromContion = YES;

    [self.recorder contuintRecording];
    [self startRecordTimer];
    [self.recodImageView startPulseWithColor:[UIColor colorWithHexString: @"#b2b2b2"] animation:YGPulseViewAnimationTypeRadarPulsing];
    
    self.giveUpBtn.hidden = NO;
    self.changeButton.hidden = YES;
}

//暂停录音
- (void)pauseRecoder{
    //在录制当中，则进行暂停
    self.isShowFinish = YES;
    if (self.isSend) {
        for (NoticeTextZJMusicModel *locaM in self.bgmView.dataArr) {
            locaM.noNeedRic = YES;
        }
        [self.bgmView.collectionView reloadData];
        self.noReplay = YES;

        [self.audioPlayer pause:YES];

        if (!self.bgmView.playCustumeView.hidden && self.bgmView.playCustumeView.musicModel.status) {
            [self.bgmView.custumeMusicView clickWith:self.bgmView.playCustumeView.musicModel];
        }
    }
    self.reingLabel.text = [NoticeTools getLocalStrWith:@"recoder.goonre"];
    self.isRecoding = NO;
    self.isPauseRecoding = YES;
    self.isReply = YES;
    [self stopRecordTimer];
    [self.recorder pauseRecording];
    [self.recodImageView setBackgroundImage:UIImageNamed(@"znatingluyin") forState:UIControlStateNormal];
    [self.recodImageView stopPulse];
    
}

- (void)startRecordTimer
{
    if (self.isReply) {
       // self.titleL.hidden = YES;
       // _cancelBtn.hidden = YES;
    }
    if (self.isSend) {
        _canNotDiss = YES;
    }
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

- (void)updateRecordTime{
    if (self.isPauseRecoding) {
        return;
    }
    _currentRecodTime = self.isBeginFromContion? self.oldRecodingTime:self.recorder.currentTime;
  

    self.isBeginFromContion = NO;

    [self.recodImageView setBackgroundImage:UIImageNamed(@"luyonghzongtup") forState:UIControlStateNormal];
    
    self.oldRecodingTime = _currentRecodTime;

    if (_currentRecodTime >= (self.isPy?120 : (self.isLongTime?300 : 120))) {
        self.isSureFinish = YES;
        [self.recorder stopRecording];
    }
    self.timeL.text = [NSString stringWithFormat:@"%lds",(long)_currentRecodTime];
    if ((self.isPy?120 : (self.isLongTime?300 : 120)) - _currentRecodTime <= 10) {
        NSString *str = [NSString stringWithFormat:@"%@%lds",[NoticeTools getLocalStrWith:@"recoder.shegnxiatime"],(self.isLongTime?300:120)-_currentRecodTime];
        NSString *str1 = [NSString stringWithFormat:@"%lds",(self.isLongTime?300:120)-_currentRecodTime];
        self.markL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:str1 beginSize:4];
    }
}

#pragma mark -setter and getter

- (void)handleInterruption{

    if (self.startRecoder) {
        [self pauseRecoder];
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
                if (weakSelf.choiceMusic && weakSelf.isSend) {
                   // [weakSelf.audioPlayer startPlayWithUrlandRecoding:[[NSBundle mainBundle] pathForResource:weakSelf.choiceMusic ofType:@"mp3"] isLocalFile:YES];
                }
                [weakSelf startRecordTimer];
                [weakSelf.recodImageView startPulseWithColor:[UIColor colorWithHexString:@"#b2b2b2"] animation:YGPulseViewAnimationTypeRadarPulsing];
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
                [weakSelf removeFromSuperview];
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

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"revideoplay" object:nil];
}

- (void)show{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopvideoplay" object:nil];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    if (self.isSend) {
        self.bgmView.hidden = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.functionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-305, DR_SCREEN_WIDTH, 305+BOTTOM_HEIGHT);
        self.pyFgView.frame =  CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-305-20, DR_SCREEN_WIDTH, 35);
        if (self.isSend) {
          self.bgmView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-305-BOTTOM_HEIGHT-95-15+50, DR_SCREEN_WIDTH, 95+15);
        }
    } completion:^(BOOL finished) {

        if (self.atArr.count) {
            self.HeaderView.hidden = NO;
        }
        if (self.isGroupChatAt) {
            self.groupBtnView.hidden = NO;
        }
    }];
}

- (void)noClearDissmiss{
    if (self.atArr.count) {//有爱特的人时候不能关
        return;
    }
    if (self.isRecodingNoDiss) {
        return;
    }
    _HeaderView.hidden = YES;

    self.lookPhotoBtn.hidden = YES;
    self.noReplay = YES;
    [self.audioPlayer stopPlaying];
    //取消设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideRecoderView)]) {
        [self.delegate hideRecoderView];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.functionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 305+BOTTOM_HEIGHT);
        self.pyFgView.frame =  CGRectMake(0,self.functionView.frame.origin.y-20, DR_SCREEN_WIDTH, 35);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)canDismiss{
    if (self.atArr.count) {//有爱特的人时候不能关
        return;
    }
    if (self.isRecodingNoDiss) {
        return;
    }
    _HeaderView.hidden = YES;

    if (self.isSend) {
        self.bgmView.hidden = YES;
        self.bgmLineView.hidden = YES;
        [self.photolistView removeFromSuperview];
        [self.imageShowView removeFromSuperview];
    }

    //取消设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.lookPhotoBtn.hidden = YES;
    //取消设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideRecoderView)]) {
        [self.delegate hideRecoderView];
    }
    self.noReplay = YES;
    [self.audioPlayer stopPlaying];

    //self.audioPlayer = nil;
    [self destory];
    [UIView animateWithDuration:0.5 animations:^{
        self.functionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 305+BOTTOM_HEIGHT);
        self.pyFgView.frame =  CGRectMake(0,self.functionView.frame.origin.y-20, DR_SCREEN_WIDTH, 35);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismiss{
    if (self.isSend) {//发心情的时候只允许点击放弃关闭
        return;
    }
    if (self.isLead) {//新手指南不允许点击全屏关闭
        return;
    }
    if (self.atArr.count) {//有爱特的人时候不能关
        return;
    }
    if (self.isRecodingNoDiss) {
        return;
    }
    if (self.isSend && (_canNotDiss || (self.audioTimeLen || self.timeL.text.integerValue))) {//录制过程不允许推出
        return;
    }
    
    if (self.isHS && (self.audioTimeLen || self.timeL.text.integerValue)) {
        return;
    }
    _HeaderView.hidden = YES;

    if (self.isSend) {
        self.bgmView.hidden = YES;
        self.bgmLineView.hidden = YES;
        [self.photolistView removeFromSuperview];
        [self.imageShowView removeFromSuperview];
    }
    //取消设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideRecoderView)]) {
        [self.delegate hideRecoderView];
    }
    self.noReplay = YES;
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
    if (self.adressUrl) {
        [self noClearDissmiss];
        return;
    }
    self.lookPhotoBtn.hidden = YES;

    [self destory];
    [UIView animateWithDuration:0.5 animations:^{
        self.functionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 305+BOTTOM_HEIGHT);
        self.pyFgView.frame =  CGRectMake(0,self.functionView.frame.origin.y-20, DR_SCREEN_WIDTH, 35);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)canDismissWithNoClear{
    if (self.atArr.count) {//有爱特的人时候不能关
        return;
    }
    if (self.isRecodingNoDiss) {
        return;
    }
    _HeaderView.hidden = YES;


    if (self.isSend) {
        self.bgmView.hidden = YES;
        self.bgmLineView.hidden = YES;
        [self.photolistView removeFromSuperview];
        [self.imageShowView removeFromSuperview];
    }
    //取消设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.lookPhotoBtn.hidden = YES;
    //取消设置屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideRecoderView)]) {
        [self.delegate hideRecoderView];
    }
    self.noReplay = YES;
    [self.audioPlayer stopPlaying];

    //self.audioPlayer = nil;
    [self stopRecordTimer];
    [UIView animateWithDuration:0.5 animations:^{
        self.functionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 305+BOTTOM_HEIGHT);
        self.pyFgView.frame =  CGRectMake(0,self.functionView.frame.origin.y-20, DR_SCREEN_WIDTH, 35);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)destory
{
    [self stopRecordTimer];
    if (self.recorder.isRecording) {
        [self.recorder stopRecording];
    } else {
        [self.recorder reRecording];
    }
}

- (UIImageView *)sureColorImageView{
    if (!_sureColorImageView) {
        _sureColorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.functionView.frame.size.width, self.functionView.frame.size.height)];
        [self.functionView addSubview:_sureColorImageView];
        [self.functionView sendSubviewToBack:_sureColorImageView];
        _sureColorImageView.hidden = YES;
    }
    return _sureColorImageView;
}


- (NoticeBgmView *)bgmView{
    if (!_bgmView) {
        _bgmView = [[NoticeBgmView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 95+15)];
        [self addSubview:_bgmView];
        _bgmView.headerV.backgroundColor = self.functionView.backgroundColor;
        _bgmView.needAutoRecoder = self.neeAutoRecoder;
     
        //录音的同时播放音乐就要设置这个AVAudioSessionCategoryMultiRoute

        __weak typeof(self) weakSelf = self;
        _bgmView.stopMusicTapBlock = ^(BOOL stop) {
            weakSelf.choiceMusic = nil;
            weakSelf.noReplay = YES;
            weakSelf.bgmLineView.hidden = YES;
            [weakSelf.audioPlayer stopPlaying];
        };

        _bgmView.musicTapBlock = ^(NSString * _Nonnull url) {
  
            weakSelf.choiceMusic = url;
            weakSelf.noReplay = NO;
            [weakSelf.audioPlayer startPlayWithUrlandRecoding:weakSelf.choiceMusic isLocalFile:NO];
            weakSelf.bgmLineView.hidden = NO;
            weakSelf.photolistView.hidden = YES;
            weakSelf.bgmView.custumeMusicView.hidden = YES;
            weakSelf.imageShowView.hidden = YES;
        };
        
        _bgmView.choiceZdyBlock = ^(NoticeTextZJMusicModel * _Nonnull currentM) {
            if (weakSelf.isRecoding && weakSelf.bgmView.custumeMusicView.hidden) {
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recod.surecut"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        [weakSelf.bgmView refresStop:currentM];
                        [weakSelf openmusicClick];
                        [weakSelf rerecoderClick];
                    }
                };
                [alerView showXLAlertView];
                return;
            }
            [weakSelf openmusicClick];
            [weakSelf rerecoderClick];
        };
       
        _bgmView.useMusicBlock = ^(NoticeCustumMusiceModel * _Nonnull model) {
            weakSelf.currentModel = model;
            weakSelf.noReplay = YES;
            weakSelf.bgmLineView.hidden = YES;
            weakSelf.choiceMusic = model.song_url;
            if (model.status < 1) {
                model.status = 1;
                [weakSelf.audioPlayer startPlayWithUrlandRecoding:weakSelf.choiceMusic isLocalFile:NO];
            }else if (model.status == 1){
                model.status = 2;
                [weakSelf.audioPlayer pause:YES];
            }else if(model.status == 2){
                model.status = 1;
                [weakSelf.audioPlayer pause:NO];
            }
        };
   
        _bgmView.musicCurrentIDBlock = ^(NoticeTextZJMusicModel * _Nonnull musicM) {
            weakSelf.musicId = musicM.bgmM.bgmId;
            weakSelf.bgmLineView.hidden = NO;
            weakSelf.bgmLineView.musicM = musicM;
            weakSelf.markL.text = musicM.bgmM.tips;
            
            weakSelf.photolistView.hidden = YES;
            weakSelf.bgmView.custumeMusicView.hidden = YES;
            weakSelf.imageShowView.hidden = YES;
        };
        _bgmView.stopRecoderIngBlock = ^(BOOL stop) {
            [weakSelf rerecoderClick];
        };
        _bgmView.pauseMusicTapBlock = ^(BOOL pause) {
            if (!weakSelf.isPauseRecoding) {//之前是暂停录音的话，现在继续录音
                if (weakSelf.startRecoder) {
                    [weakSelf pauseRecoder];
                }
            }
        };
    }
    return _bgmView;
}

- (NoticeBgmLineView *)bgmLineView{
    if (!_bgmLineView) {
        _bgmLineView = [[NoticeBgmLineView alloc] initWithFrame:CGRectMake(0, self.bgmView.frame.origin.y-99, DR_SCREEN_WIDTH, 92)];
        [self addSubview:_bgmLineView];
        _bgmLineView.hidden = YES;
    }
    return _bgmLineView;
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        
        _audioPlayer = [[LGAudioPlayer alloc] init];
        //_audioPlayer.player.volume = 0.3;
        __weak typeof(self) weakSelf = self;
        _audioPlayer.playComplete = ^{
            if (!weakSelf.noReplay && weakSelf.choiceMusic) {//如果可以继续循环播放，则继续播放
                DRLog(@"播放完成进行继续播放");
                [weakSelf.audioPlayer startPlayWithUrlandRecoding:weakSelf.choiceMusic isLocalFile:NO];
            }else{
                DRLog(@"播放完成不再播放");
            }
        };
        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (weakSelf.neeAutoRecoder) {
                weakSelf.neeAutoRecoder = NO;
                [weakSelf startOrStop];
            }
        };
    }
    return _audioPlayer;
}
@end

