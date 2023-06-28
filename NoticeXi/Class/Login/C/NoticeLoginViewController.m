//
//  NoticeLoginViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLoginViewController.h"
#import "FSCustomButton.h"
#import "NoticeAreaViewController.h"
#import "NoticeCheckModel.h"
#import "NoticeCodeInputViewController.h"
#import "NoticeVideoViewController.h"
#import "DDHAttributedMode.h"
#import "NoticeXieYiViewController.h"
#import "NoticeWebViewController.h"
#import "NoticeSetSecondPWController.h"
#import "NoticeChoiceReasonController.h"
#import "NoticeNoNet.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "AppDelegate+Notification.h"
#import "NoticeChangePhoneViewController.h"
#import "NoticeSaveLoginStory.h"
#import "NoticeSetSecondPWController.h"
#import "NoticeLoginHelpController.h"
#import "JVERIFICATIONService.h"
#import "LRShineLabel.h"
#import "NoticeCustumeNavView.h"
@interface NoticeLoginViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏

@property (strong, nonatomic) UILabel *mainL;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UILabel *proL;
@property (strong, nonatomic) UILabel *thirdMarkL;
@property (strong, nonatomic) UILabel *agreeProL;
@property (strong, nonatomic) UILabel *secrProL;
@property (strong, nonatomic) NoticeAreaModel *areaModel;
@property (nonatomic, assign) BOOL canNotPush;
@property (nonatomic, assign) BOOL isAgree;
@property (nonatomic, strong) UILabel *appleIDInfoLabel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *headerTitleView;
@property (nonatomic, strong) UIView *inputBackView;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *yunyName;
@property (nonatomic, strong) NSString *contryNum;
@property (nonatomic, strong) UIImageView *hasHistoryView;
@end

@implementation NoticeLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
    JVAuthConfig *config = [[JVAuthConfig alloc] init];
    config.appKey = @"73a728a890f7850c1c9a33b6";
    config.authBlock = ^(NSDictionary *result) {
        DRLog(@"初始化结果 result:%@", result);
    };
    [JVERIFICATIONService setupWithConfig:config];
    
    self.isAgree = YES;
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.headerImageView.image = UIImageNamed(@"Image_loginback");
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    [self.view addSubview:self.headerImageView];

  
    UILabel *titlleL = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 62)];
    titlleL.font = [UIFont fontWithName:XGBoldFontName size:44];
    titlleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    titlleL.textAlignment = NSTextAlignmentCenter;
    titlleL.text = [NoticeTools getLocalStrWith:@"system.sx"];
    [self.headerImageView addSubview:titlleL];
    
    UILabel *subtitlleL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(titlleL.frame)+4, DR_SCREEN_WIDTH, 20)];
    subtitlleL.font = FOURTHTEENTEXTFONTSIZE;
    subtitlleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    subtitlleL.textAlignment = NSTextAlignmentCenter;
    subtitlleL.text = [NoticeTools chinese:@"你需要的时候我们都在" english:@"你需要的时候我们都在" japan:@"你需要的时候我们都在"];
    [self.headerImageView addSubview:subtitlleL];
    
    UIImageView *titlImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH/3-10, CGRectGetMaxY(subtitlleL.frame)+30, DR_SCREEN_WIDTH/3+20, DR_SCREEN_WIDTH/3+20)];
    [self.headerImageView addSubview:titlImageView];
    titlImageView.image = UIImageNamed(@"Image_ligintitle");
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-256-BOTTOM_HEIGHT-40, DR_SCREEN_WIDTH, 256)];
    [self.view addSubview:textView];
    textView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    self.inputBackView = textView;
        
    self.areaModel = [[NoticeAreaModel alloc] init];
    self.areaModel.phone_code = @"86";
    self.areaModel.area_code = @"CN";
    self.areaModel.area_name = @"中国大陆";
    [NoticeSaveModel saveArea:self.areaModel];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(45, (ISIPHONEXORLATER?0:35)+29+20, DR_SCREEN_WIDTH-90, 50)];
    self.loginBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 25;
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [self.loginBtn setTitle:[NoticeTools chinese:@"手机号登录注册" english:@"Log in by phone number" japan:@"電話番号によるログイン"] forState:UIControlStateNormal];
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.inputBackView addSubview:self.loginBtn];
    
    CGFloat widthStr =[NoticeTools getLocalType]?GET_STRWIDTH(@"Login means agree Agreement ", 9, 30) + GET_STRWIDTH(@"and Privacy Policy ", 9, 30) : GET_STRWIDTH(@"登录即代表同意 用户协议 ", 9, 30) + GET_STRWIDTH(@"和 隐私政策 ", 9, 30);
    CGFloat wdith1 = [NoticeTools getLocalType]?GET_STRWIDTH(@"Login means agree Agreement ", 9, 30): GET_STRWIDTH(@"登录即代表同意 用户协议 ", 9, 30);
    self.agreeProL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-widthStr)/2,CGRectGetMaxY(self.loginBtn.frame)+(ISIPHONEXORLATER? 129:95), wdith1,30)];
    self.agreeProL.textAlignment = NSTextAlignmentCenter;
    self.agreeProL.font = [UIFont systemFontOfSize:9];
    self.agreeProL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
    [self.inputBackView addSubview:self.agreeProL];
    self.agreeProL.attributedText = [DDHAttributedMode setColorString:@"登录即代表同意 用户协议 " setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:@" 用户协议 " beginSize:7];
    if ([NoticeTools getLocalType]) {
        self.agreeProL.attributedText = [DDHAttributedMode setColorString:@"Login means agree Agreement " setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:@" Agreement " beginSize:17];
    }
    self.agreeProL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xieyiTap)];
    [self.agreeProL addGestureRecognizer:tap];
    
    CGFloat width2 = [NoticeTools getLocalType]? GET_STRWIDTH(@"and Privacy Policy ",9, 30) : GET_STRWIDTH(@"和 隐私政策 ", 9, 30);
    
    self.secrProL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.agreeProL.frame), self.agreeProL.frame.origin.y,width2,30)];
    self.secrProL.textAlignment = NSTextAlignmentCenter;
    self.secrProL.font = [UIFont systemFontOfSize:9];
    self.secrProL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
    [self.inputBackView addSubview:self.secrProL];
    self.secrProL.attributedText = [DDHAttributedMode setColorString:@"和 隐私政策 " setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:@" 隐私政策 " beginSize:1];
    if ([NoticeTools getLocalType]) {
        self.secrProL.attributedText = [DDHAttributedMode setColorString:@"and Privacy Policy " setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:@" Privacy Policy " beginSize:3];
    }
    self.secrProL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yinsiTap)];
    [self.secrProL addGestureRecognizer:tap1];
    
    if (@available(iOS 13.0, *)) {
        NSArray *imgArr = @[@"btn_login_weixin",@"btn_login_qq",@"btn_login_weibo"];
        for (int i = 0; i < 4; i++) {
            if (i == 3) {
                ASAuthorizationAppleIDButton *appBtn = [[ASAuthorizationAppleIDButton alloc]initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleBlack];
                [appBtn addTarget:self action:@selector(signInWithApple) forControlEvents:UIControlEventTouchUpInside];
                appBtn.center = self.view.center;
                appBtn.frame = CGRectMake((DR_SCREEN_WIDTH-220)/2+60*i,CGRectGetMaxY(self.loginBtn.frame)+(ISIPHONEXORLATER? 65:35), 40, 40);
                appBtn.layer.cornerRadius = 20;
                appBtn.layer.masksToBounds = YES;
                appBtn.layer.borderWidth = 0.8;
                [self.inputBackView addSubview:appBtn];
                UIImageView *fgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                fgImageView.image = UIImageNamed(@"Image_pingguo");
                [appBtn addSubview:fgImageView];
            }else{
                UIButton *logB = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-220)/2+60*i,CGRectGetMaxY(self.loginBtn.frame)+(ISIPHONEXORLATER? 65:35), 40, 40)];
                logB.tag = i;
                [logB setBackgroundImage:UIImageNamed(imgArr[i]) forState:UIControlStateNormal];
                [logB addTarget:self action:@selector(logImgClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.inputBackView addSubview:logB];
            }
        }
    }else{
        NSArray *imgArr = @[@"btn_login_weixin",@"btn_login_qq",@"btn_login_weibo"];
        for (int i = 0; i < 3; i++) {
            UIButton *logB = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-160)/2+60*i,CGRectGetMaxY(self.loginBtn.frame)+(ISIPHONEXORLATER? 65:35), 40, 40)];
            logB.tag = i;
            [logB setBackgroundImage:UIImageNamed(imgArr[i]) forState:UIControlStateNormal];
            [logB addTarget:self action:@selector(logImgClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.inputBackView addSubview:logB];
        }
    }
    NoticeSaveLoginStory *info = [NoticeSaveModel getLoginInfo];
    if (info.mobile || info.openId) {
        [self.view addSubview:self.hasHistoryView];
    }
    
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-65, STATUS_BAR_HEIGHT+5, 65, 30)];
    [helpBtn setImage:UIImageNamed(@"Image_helpbutton") forState:UIControlStateNormal];
    [helpBtn setTitle:[NSString stringWithFormat:@" %@",[NoticeTools getLocalStrWith:@"Login.help"]] forState:UIControlStateNormal];
    helpBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [helpBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
    [self.view addSubview:helpBtn];
    [helpBtn addTarget:self action:@selector(helpClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = YES;
    if (appdel.floatView.isPlaying) {
        [appdel.floatView.audioPlayer stopPlaying];
    }
    [appdel.floatView.voiceArr removeAllObjects];
    [appdel.floatView.pyArr removeAllObjects];
}

- (void)helpClick{
    NoticeLoginHelpController *ctl = [[NoticeLoginHelpController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UIImageView *)hasHistoryView{
    if (!_hasHistoryView) {
        _hasHistoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _hasHistoryView.image = UIImageNamed(@"Image_loginhader");
        _hasHistoryView.userInteractionEnabled = YES;

        UIImageView *welComeImg = [[UIImageView alloc] initWithFrame:CGRectMake(35, NAVIGATION_BAR_HEIGHT, 173, 42)];
        welComeImg.image = UIImageNamed(@"Image_welcome");
        [_hasHistoryView addSubview:welComeImg];
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-88-43-40-20, DR_SCREEN_WIDTH-40, 88)];
        infoView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        infoView.layer.cornerRadius = 8;
        infoView.layer.masksToBounds = YES;
        [_hasHistoryView addSubview:infoView];
        
        NoticeSaveLoginStory *info = [NoticeSaveModel getLoginInfo];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 56, 56)];
        iconImageView.layer.cornerRadius = 8;
        iconImageView.layer.masksToBounds = YES;
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:info.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
        [infoView addSubview:iconImageView];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(79, 20, infoView.frame.size.width-79-50-15, 22)];
        nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        nameL.font = XGSIXBoldFontSize;
        nameL.text = info.nick_name?info.nick_name:@"这个默认名字不适合我";
        [infoView addSubview:nameL];
        
        UILabel *typeL = [[UILabel alloc] initWithFrame:CGRectMake(79, 50, nameL.frame.size.width, 17)];
        typeL.font = TWOTEXTFONTSIZE;
        typeL.textColor = [UIColor colorWithHexString:@"#25262E"];
        typeL.text = info.loginType;
        [infoView addSubview:typeL];
        
        UIButton *loginB = [[UIButton alloc] initWithFrame:CGRectMake(infoView.frame.size.width-15-50, 19, 50, 50)];
        [loginB setBackgroundImage:UIImageNamed(@"Image_fastlogin") forState:UIControlStateNormal];
        [infoView addSubview:loginB];
        [loginB addTarget:self action:@selector(fastLoginClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *otherLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(infoView.frame)+10, DR_SCREEN_WIDTH, 43)];
        [otherLogin setTitle:[NoticeTools getLocalStrWith:@"ohterlogintype"] forState:UIControlStateNormal];
        [otherLogin setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        otherLogin.titleLabel.font = TWOTEXTFONTSIZE;
        [otherLogin addTarget:self action:@selector(otherClick) forControlEvents:UIControlEventTouchUpInside];
        [_hasHistoryView addSubview:otherLogin];
    }
    return _hasHistoryView;
}

- (void)fastLoginClick{

    NoticeSaveLoginStory *info = [NoticeSaveModel getLoginInfo];

    [self fastrequestLogin:info];
}

//快速登录
- (void)fastrequestLogin:(NoticeSaveLoginStory*)info{
    if (info.openId) {
        SSDKUser *ssUser = [[SSDKUser alloc] init];
        ssUser.uid = info.openId;
        ssUser.credential.uid = info.unionId;
        [self logiWithThird:ssUser type:info.type];
        return;
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:[NoticeSaveModel getDeviceInfo] forKey:@"deviceInfo"];
    [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
    [parm setObject:@"2" forKey:@"platformId"];
    [parm setObject:info.countryCode?info.countryCode:@"CN" forKey:@"countryCode"];
  
    if ([NoticeTools getIDFA]) {
        [parm setObject:[NoticeTools getIDFA] forKey:@"deviceId"];
    }else{
        [parm setObject:info.mobile forKey:@"deviceId"];
    }
    [parm setObject:info.mobile forKey:@"mobile"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"users/loginNoSmsCode" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
            NoticeUserInfoModel *userInfo = [NoticeUserInfoModel mj_objectWithKeyValues:dict[@"data"]];
            [NoticeSaveModel saveUserInfo:userInfo];
            [NoticeSaveModel saveToken:userInfo.token];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",userInfo.user_id] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
                [self hideHUD];
                if (success) {
                    NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                    [NoticeSaveModel saveUserInfo:userIn];
                    //保存登录痕迹
                    NoticeSaveLoginStory *loginInfo = [[NoticeSaveLoginStory alloc] init];
                    loginInfo.nick_name = userIn.nick_name;
                    loginInfo.avatar_url = userIn.avatar_url;
                    loginInfo.mobile = userIn.mobile;
                    loginInfo.loginType = [NoticeTools getLocalStrWith:@"Login.loginWithPhone"];
                    loginInfo.countryCode = self.areaModel.area_code;
                    [NoticeSaveModel saveLogin:loginInfo];
                    
                    if ([userInfo.need_login_check isEqualToString:@"1"]) {//如果需要二次验证
                        [NoticeTools saveNeedSecondCheckForLogin:@"1"];
                        NoticeSetSecondPWController *ctl = [[NoticeSetSecondPWController alloc] init];
                        ctl.isCheck = YES;
                        [self.navigationController pushViewController:ctl animated:YES];
                        return;
                    }
                    //上传成功，执行引导页
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                }else{
                     [self hideHUD];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self hideHUD];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)otherClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.hasHistoryView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.hasHistoryView removeFromSuperview];
    }];
}

#pragma mark- 点击登录
-(void)signInWithApple API_AVAILABLE(ios(13.0))
{
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest * request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
    
    ASAuthorizationController *vc= [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
    vc.delegate = self;
    vc.presentationContextProvider = self;
    
    [vc performRequests];
}

-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
API_AVAILABLE(ios(13.0)){
   return  self.view.window;
}

#pragma mark- 授权成功的回调
-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential * credential = (ASAuthorizationAppleIDCredential*)authorization.credential;
        
        NSString * userID = credential.user;
        
        SSDKUser *appRegM = [[SSDKUser alloc] init];
        appRegM.uid = userID;
        appRegM.nickname = @"声昔宿舍新人";
        appRegM.gender = 3;
        [self checkIsExit:appRegM type:@"4"];
    }
}
 
#pragma mark- 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
API_AVAILABLE(ios(13.0)){
    
    NSString * errorMsg = nil;
    
    switch (error.code) {
            case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
            case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
            case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
            case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
            case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    
    }
    [self showToastWithText:errorMsg];
}

- (void)xieyiTap{
    NoticeXieYiViewController * webctl = [[NoticeXieYiViewController alloc] init];
    [self.navigationController pushViewController:webctl animated:YES];
}

- (void)yinsiTap{
    NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
    webctl.type = @"1";
    webctl.isAboutSX = YES;
    [self.navigationController pushViewController:webctl animated:YES];
}

- (void)regiserClick{
    if (!self.isAgree) {
        [self showToastWithText:@"请先勾选我已阅读并同意用户协议和隐私政策"];
        return;
    }
    NoticeChoiceReasonController *ctl = [[NoticeChoiceReasonController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)inputClick{
    [self fasggetPhone];

}

- (void)gotoInput{
    NoticeChangePhoneViewController *ctl = [[NoticeChangePhoneViewController alloc] init];
    ctl.type = 2;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)changePhoneloginClick{
    [JVERIFICATIONService dismissLoginControllerAnimated:NO completion:^{
        //授权页隐藏完成
    }];
    [self gotoInput];
}

- (void)backClick{
 
    [JVERIFICATIONService dismissLoginControllerAnimated:NO completion:^{
        //授权页隐藏完成
    }];
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _navBarView.titleL.text = @"";
        [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

- (void)fasggetPhone{
    
    if(![JVERIFICATIONService checkVerifyEnable] || [NoticeTools getLocalType]) {
        [self gotoInput];
        DRLog(@"当前网络环境不支持认证！");
        return;
    }
    
    JVUIConfig *uiconfig = [[JVUIConfig alloc] init];
    uiconfig.navCustom = YES;
    uiconfig.shouldAutorotate = YES;
    uiconfig.autoLayout = YES;
    uiconfig.navReturnHidden = NO;
    uiconfig.privacyTextFontSize = 12;

    uiconfig.logoImg = UIImageNamed(@"Image_fastlogoimg");

    //logo
    CGFloat logoWidth = 247;
    CGFloat logoHeight = 42;
    JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-230+NAVIGATION_BAR_HEIGHT];
    JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
    JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
    uiconfig.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
    uiconfig.logoHorizontalConstraints = uiconfig.logoConstraints;

    //号码栏
    JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-90+NAVIGATION_BAR_HEIGHT];
    JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:DR_SCREEN_WIDTH];
    JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];
    uiconfig.numberConstraints = @[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
    uiconfig.numberHorizontalConstraints = uiconfig.numberConstraints;
    uiconfig.numberSize = 24;
    uiconfig.numberColor = [UIColor colorWithHexString:@"#25262E"];
    
    //slogan展示
    JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-50+NAVIGATION_BAR_HEIGHT];
    JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:DR_SCREEN_WIDTH];
    JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:15];
    uiconfig.sloganConstraints = @[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
    uiconfig.sloganHorizontalConstraints = uiconfig.sloganConstraints;
    uiconfig.sloganFont = [UIFont systemFontOfSize:10];
    uiconfig.sloganTextColor = [UIColor colorWithHexString:@"#8A8F99"];
    
    //登录按钮
    UIImage *login_nor_image = UIImageNamed(@"Image_yijiandenglu");
    UIImage *login_dis_image = UIImageNamed(@"Image_yijiandenglu");
    UIImage *login_hig_image = UIImageNamed(@"Image_yijiandenglu");
    if (login_nor_image && login_dis_image && login_hig_image) {
        uiconfig.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    }
    CGFloat loginButtonWidth = login_nor_image.size.width?:100;
    CGFloat loginButtonHeight = login_nor_image.size.height?:100;
    JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-50+20+50+NAVIGATION_BAR_HEIGHT];
    JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    uiconfig.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    uiconfig.logBtnHorizontalConstraints = uiconfig.logBtnConstraints;
    uiconfig.logBtnText = @"";
    
    //勾选框
    UIImage * uncheckedImg = UIImageNamed(@"Image_nochoice");
    UIImage * checkedImg = UIImageNamed(@"Image_signmark_b");
    CGFloat checkViewWidth = uncheckedImg.size.width;
    CGFloat checkViewHeight = uncheckedImg.size.height;
    uiconfig.uncheckedImg = uncheckedImg;
    uiconfig.checkedImg = checkedImg;
    JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeCenterY multiplier:1 constant:-BOTTOM_HEIGHT+21.5- (ISIPHONEXORLATER?0: 30)];
    JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
    JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
    uiconfig.checkViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
    uiconfig.checkViewHorizontalConstraints = uiconfig.checkViewConstraints;
    
    //隐私
    CGFloat spacing = checkViewWidth + 20 + 5;
    uiconfig.privacyState = YES;
    JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:spacing];
    JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-spacing];
    JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:(ISIPHONEXORLATER?-280: -230)+NAVIGATION_BAR_HEIGHT];
    JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:40];
    uiconfig.privacyConstraints = @[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
    uiconfig.privacyHorizontalConstraints = uiconfig.privacyConstraints;
    uiconfig.privacyTextFontSize = 9;
    uiconfig.appPrivacyColor = @[[UIColor colorWithHexString:@"#5C5F66"],[UIColor colorWithHexString:@"#0099E6"]];
    
    uiconfig.agreementNavTextColor = [UIColor colorWithHexString:@"#F7F8FC"];
    uiconfig.agreementNavBackgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    uiconfig.agreementNavReturnImage = UIImageNamed(@"Image_blackBack");
    
    NSAttributedString *agreementNavtext1 = [[NSAttributedString alloc]initWithString:@"用户协议" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0099E6"],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    NSAttributedString *agreementNavtext2 = [[NSAttributedString alloc]initWithString:@"隐私政策" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0099E6"],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    uiconfig.appPrivacys = @[
        @"登录即同意",//头部文字
        @[@"和",@"用户协议",@"http://priapi.byebyetext.com/agreement.html",agreementNavtext1],
        @[@"以及",@"隐私政策",@"http://priapi.byebyetext.com/privacy.html",agreementNavtext2],
    ];
    [JVERIFICATIONService customUIWithConfig:uiconfig customViews:^(UIView *customAreaView) {
        
        customAreaView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        [button setTitle:@"换个手机号登录" forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button addTarget:self action:@selector(changePhoneloginClick) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:button];
        
        [self.navBarView removeFromSuperview];
        [customAreaView addSubview:self.navBarView];
    }];
    
    __weak typeof(self) weakSelf = self;
    [JVERIFICATIONService getAuthorizationWithController:self hide:NO animated:YES timeout:5*1000 completion:^(NSDictionary *result) {
        DRLog(@"一键登录 result:%@", result);
        NoticeCheckModel *checkM = [NoticeCheckModel mj_objectWithKeyValues:result];
        if (checkM.code.intValue == 6000 && checkM.loginToken) {//获取登录token成功
            [weakSelf checkForFastToken:checkM.loginToken];
        }else{
            if (checkM.code.intValue != 6002) {
                [weakSelf gotoInput];
            }
        }
    } actionBlock:^(NSInteger type, NSString *content) {
        if (type == 7) {
            XLAlertView *alertView = [[XLAlertView alloc] initWithTitle:@"没有同意用户协议等隐私政策， 无法进行登录哦" message:@"" cancleBtn:[NoticeTools getLocalStrWith:@"group.knowjoin"]];

            [alertView showXLAlertView];
        }
        if (type > 8 || type < 0) {//无法获取手机号
            [weakSelf gotoInput];
        }
    }];
}

//一键登录校验token并且获取手机号
- (void)checkForFastToken:(NSString *)token{
  
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:token forKey:@"loginToken"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"jpush/getNumber" Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeCheckModel *phoneM = [NoticeCheckModel mj_objectWithKeyValues:dict[@"data"]];
           
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/%@",@"CN",phoneM.phone] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                [JVERIFICATIONService dismissLoginControllerAnimated:NO completion:^{
                    //授权页隐藏完成
                }];
                if (success) {
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                        return ;
                    }
                    NoticeCheckModel *checkM = [NoticeCheckModel mj_objectWithKeyValues:dict[@"data"]];
                    if ([checkM.is_exist isEqualToString:@"0"]) {//不存在则执行注册
                        NoticeChangePhoneViewController *ctl = [[NoticeChangePhoneViewController alloc] init];
                        ctl.type = 2;
                        ctl.phone = phoneM.phone;
                        [self.navigationController pushViewController:ctl animated:YES];
                        return;
                    }
                    
                    if ([checkM.is_forbid isEqualToString:@"1"]) {
                        [self showToastWithText:Localized(@"cantLoginMsg")];
                        return;
                    }
                    
                    NoticeSaveLoginStory *loginM = [[NoticeSaveLoginStory alloc] init];
                    loginM.mobile = phoneM.phone;
                    [self fastrequestLogin:loginM];
                    
                }else{
                    [self hideHUD];
                    [self showToastWithText:dict[@"msg"]];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self hideHUD];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)loginClick{
   
    if (!self.phone) {
        [self fasggetPhone];
        return;
    }
}

- (void)choiceNumTypeClick{
    NoticeAreaViewController *ctl = [[NoticeAreaViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    ctl.adressBlock = ^(NoticeAreaModel *adressModel) {
        weakSelf.areaModel = adressModel;
        [NoticeSaveModel saveArea:adressModel];
       // [weakSelf.choiceBtn setTitle:[NSString stringWithFormat:@"+%@ ",weakSelf.areaModel.phone_code] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)logImgClick:(UIButton *)btn{
    if (!self.isAgree) {
        [self showToastWithText:@"请先勾选我已阅读并同意用户协议和隐私政策"];
        return;
    }
    if (btn.tag == 2) {
        [self weiboClick];
    }else if (btn.tag == 0){
        [self weixinClick];
    }
    else if(btn.tag == 1){
        [self qqClick];
    }
}

- (void)weiboClick{
    [self showHUD];

    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Sinaweibo://"]]) {
        [self hideHUD];
    }
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         [self hideHUD];
         if (state == SSDKResponseStateSuccess)
         {
             if (!user.credential) {
                 return;
             }
             [self checkIsExit:user type:@"3"];
             [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo result:^(NSError *error) {
             }];
         }
     }];
}

- (void)weixinClick{

    [self showHUD];
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
    {
        [self hideHUD];
    }
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
        [self hideHUD];
        if (state == SSDKResponseStateSuccess)
         {
             if (!user.credential) {
                 return;
             }
             user.uid = [NSString stringWithFormat:@"%@",user.rawData[@"openid"]];
             [self checkIsExit:user type:@"1"];
             [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat result:^(NSError *error) {
                 
             }];
         }
        
     }];
    

}

//检测第三方账号是否已经注册过
- (void)checkIsExit:(SSDKUser *)user type:(NSString *)type{

    [self showHUD];
    NSString *url = nil;
    if (user.credential.uid) {
        url = [NSString stringWithFormat:@"thirds/checkRegister?authType=%@&openId=%@&unionId=%@",type,user.uid,user.credential.uid];
    }else{
       url = [NSString stringWithFormat:@"thirds/checkRegister?authType=%@&openId=%@",type,user.uid];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:dict[@"data"]];
            if (userM.forbidden.intValue) {
                [self showToastWithText:@"该账号被禁用"];
                return ;
            }
            if (userM.exists.intValue) {
                [self logiWithThird:user type:type];
            }else{
                
                __weak typeof(self) weakSelf = self;
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"账号未注册\n是否注册新账号?" message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:@"注册" right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 2) {
                        NoticeUserInfoModel *regM = [[NoticeUserInfoModel alloc] init];
                        regM.openId = user.uid;
                        regM.unionId = user.credential.uid;
                        regM.thirdnickname = user.nickname;
                        regM.authType = type;
                        if (user.gender == 0) {
                            regM.gender = @"1";
                        }else if (user.gender == 1){
                            regM.gender = @"2";
                        }else{
                            regM.gender = @"0";
                        }
                        NoticeChangePhoneViewController *ctl = [[NoticeChangePhoneViewController alloc] init];
                        ctl.regModel = regM;
                        ctl.isThird = YES;
                        [weakSelf.navigationController pushViewController:ctl animated:YES];
                        
                    }
                };
                [alerView showXLAlertView];

            }
        }
    } fail:^(NSError * _Nullable error) {
         [self showToastWithText:[NSString stringWithFormat:@"检测第三方是否注册报错%@\n%@",url,error.description]];
        [self hideHUD];
    }];
}

- (void)logiWithThird:(SSDKUser *)user type:(NSString *)type{
    
    [self showHUD];
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:user.uid forKey:@"openId"];
    if (user.credential.uid) {
        [parm setObject:user.credential.uid?user.credential.uid:@"ghjkl" forKey:@"unionId"];
    }
    if (user.nickname) {
        [parm setObject:user.nickname?user.nickname:@"" forKey:@"nickName"];
    }
    if (user.icon) {
        [parm setObject:user.icon?user.icon:@"" forKey:@"avatarUrl"];
    }
    
    [parm setObject:type forKey:@"authType"];
    [parm setObject:[NoticeSaveModel getDeviceInfo] forKey:@"deviceInfo"];
    [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
    [parm setObject:@"2" forKey:@"platformId"];
    if ([NoticeTools getIDFA]) {
        [parm setObject:[NoticeTools getIDFA] forKey:@"deviceId"];
    }else{
        [parm setObject:@"" forKey:@"deviceId"];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"users/third/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userInfo = [NoticeUserInfoModel mj_objectWithKeyValues:dict[@"data"]];
            [NoticeSaveModel saveUserInfo:userInfo];
            [NoticeSaveModel saveToken:userInfo.token];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",userInfo.user_id] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
                [self hideHUD];
                if (success) {
                    
                    [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
                    NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                    [NoticeSaveModel saveUserInfo:userIn];
                    
                    //保存登录痕迹
                    NoticeSaveLoginStory *loginInfo = [[NoticeSaveLoginStory alloc] init];
                    loginInfo.nick_name = userIn.nick_name;
                    loginInfo.avatar_url = userIn.avatar_url;
                    if (type.intValue == 1) {
                        loginInfo.loginType = [NoticeTools getLocalStrWith:@"bdphone.wxlo1"];
                    }else if(type.intValue == 2){
                        loginInfo.loginType = [NoticeTools getLocalStrWith:@"bdphone.qqlo"];
                    }else{
                        loginInfo.loginType = [NoticeTools getLocalStrWith:@"bdphone.welo"];
                    }
                    loginInfo.openId = user.uid;
                    loginInfo.type = type;
                    loginInfo.unionId = user.credential.uid?user.credential.uid:@"ghjkl";
                    [NoticeSaveModel saveLogin:loginInfo];
                    if ([userInfo.need_login_check isEqualToString:@"1"]) {//如果需要二次验证
                        [NoticeTools saveNeedSecondCheckForLogin:@"1"];
                        NoticeSetSecondPWController *ctl = [[NoticeSetSecondPWController alloc] init];
                        ctl.isCheck = YES;
                        [self.navigationController pushViewController:ctl animated:YES];
                        return;
                    }
                    
                    //上传成功，执行引导页
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self hideHUD];
        }
    } fail:^(NSError *error) {
        [self showToastWithText:error.description];
    }];
}

- (void)qqClick{

    [self showHUD];
    BOOL wechat = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"mqqapi://"]];
    if (!wechat) {
        [self hideHUD];
    }
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
    
        [self hideHUD];
        if (state == SSDKResponseStateSuccess)
        {
            if (!user.credential) {
                return;
            }
            [self checkIsExit:user type:@"2"];
            [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ result:^(NSError *error) {
                
            }];
            
        }
        else
        {
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    NoticeSaveLoginStory *info = [NoticeSaveModel getLoginInfo];
    if (info.mobile || info.openId) {
        [self.hasHistoryView removeFromSuperview];
        [self.view addSubview:self.hasHistoryView];
    }else{
        [_hasHistoryView removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
