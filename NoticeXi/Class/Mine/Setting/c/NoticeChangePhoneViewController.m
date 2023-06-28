//
//  NoticeChangePhoneViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangePhoneViewController.h"
#import "NoticeAreaViewController.h"
#import "CQCountdownButton.h"
#import "NoticeCheckModel.h"
#import "NoticeSetSecondPWController.h"
#import "NoticeSetRegNameController.h"
#import "NoticeAlreadlyUserView.h"
#import "NoticeDesTroyView.h"
#import "NoticeVideoViewController.h"
@interface NoticeChangePhoneViewController ()<CQCountDownButtonDataSource, CQCountDownButtonDelegate>
@property (strong, nonatomic) UITextField *codeView;
@property (strong, nonatomic) UITextField *phoneView;
@property (nonatomic, strong) NoticeAreaModel *areaModel;
@property (strong, nonatomic) UIButton *areaBtn;
@property (strong, nonatomic) CQCountdownButton *getCodeBtn;
@property (nonatomic, strong) UIView *showBackView;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) NoticeCheckModel *checkM;
@end

@implementation NoticeChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text =[[[NoticeSaveModel getUserInfo] mobile] length] > 5? [NoticeTools getLocalStrWith:@"bdphone.changephon"] : [NoticeTools getLocalStrWith:@"bdphone.title"];
    
    
    if (self.type == 2) {
        self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"Login.phone"];
        self.areaModel = [[NoticeAreaModel alloc] init];
        self.areaModel.phone_code = @"86";
        self.areaModel.area_code = @"CN";
        self.areaModel.area_name = @"中国大陆";
        [NoticeSaveModel saveArea:self.areaModel];
    }
    
    for (int i = 0; i < 2; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20+(56+15)*i+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 56)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
        [self.view addSubview:backView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 69, 56)];
        titleL.font = SIXTEENTEXTFONTSIZE;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:titleL];
        if (i == 0) {
            titleL.text = [NoticeTools getLocalStrWith:@"Login.number"];
            
            self.areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 58, 56)];
            self.areaBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            [backView addSubview:self.areaBtn];
            [self.areaBtn addTarget:self action:@selector(choiceArea) forControlEvents:UIControlEventTouchUpInside];
            self.areaModel = [NoticeSaveModel getArea];
            [self.areaBtn setTitle:[NSString stringWithFormat:@"+%@",self.areaModel.phone_code] forState:UIControlStateNormal];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.areaBtn.frame), 17, 1, 22)];
            line.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
            [backView addSubview:line];
            
            self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+5, 0, backView.frame.size.width-CGRectGetMaxX(line.frame)-5, 56)];
            self.phoneView.keyboardType = UIKeyboardTypePhonePad;
            [self.phoneView setupToolbarToDismissRightButton];
            self.phoneView.textColor = [UIColor colorWithHexString:@"#25262E"];
            self.phoneView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
            self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"Login.phone"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
            [backView addSubview:self.phoneView];
            if (self.phone) {
                self.phoneView.text = self.phone;
            }
            self.phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
        }else{
            titleL.text = [NoticeTools getLocalStrWith:@"Login.smsCode"];
            self.codeView = [[UITextField alloc] initWithFrame:CGRectMake(74, 0,160, 56)];
            self.codeView.keyboardType = UIKeyboardTypePhonePad;
            [self.codeView setupToolbarToDismissRightButton];
            self.codeView.textColor = [UIColor colorWithHexString:@"#25262E"];
            self.codeView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"Login.inSmsCode"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
            self.codeView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
            [backView addSubview:self.codeView];
            
            self.getCodeBtn = [[CQCountdownButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-100, 0, 100, 56)];
            [self.getCodeBtn setAction];
            self.getCodeBtn.titleLabel.font = TWOTEXTFONTSIZE;
            [self.getCodeBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
            [self.getCodeBtn setTitle:[NoticeTools getLocalStrWith:@"Login.getsmsCode"] forState:UIControlStateNormal];
            self.getCodeBtn.dataSource = self;
            self.getCodeBtn.delegate = self;
            [backView addSubview:self.getCodeBtn];
            self.showBackView = backView;
            
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(69, 17, 1, 22)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
        [backView addSubview:line];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(68,56*2+107+NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH-68*2, 56);
        [btn setTitle:[[[NoticeSaveModel getUserInfo] mobile] length] > 5? [NoticeTools getLocalStrWith:@"bdphone.surechange"] : [NoticeTools getLocalStrWith:@"bdphone.surebd"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        btn.layer.cornerRadius = 56/2;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [btn addTarget:self action:@selector(upDataClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (self.type) {
            [btn setTitle:[NoticeTools getLocalStrWith:@"Login.loginAndReg"] forState:UIControlStateNormal];
        }
        
        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.showBackView.frame)+13, 20, 20)];
        self.markImageView.image = UIImageNamed(@"Image_errrimg");
        [self.view addSubview:self.markImageView];
        self.markImageView.hidden = YES;
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.markImageView.frame), self.markImageView.frame.origin.y, 200, 20)];
        self.markL.font = TWOTEXTFONTSIZE;
        self.markL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        [self.view addSubview:self.markL];
        self.markL.hidden = YES;
    }
}

- (void)upDataClick{
    
    if (!self.phoneView.text.length) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"Login.phone"]];
        return;
    }
    
    if (!self.codeView.text.length) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"Login.inSmsCode"]];
        return;
    }
    
    [self.codeView resignFirstResponder];
    if (self.isThird && self.type == 2) {
        __weak typeof(self) weakSelf = self;
        NoticeAlreadlyUserView *showV = [[NoticeAlreadlyUserView alloc] initWithShowUserInfo];
        NSString *str = [NSString stringWithFormat:@"该手机号已绑定 %@",self.checkM.userM.nick_name];
        showV.nickNameL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#FFFFFF"] setLengthString:[NoticeTools getLocalStrWith:@"bdphone.hasbd"] beginSize:0];
        [showV.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.checkM.userM.avatar_url] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
        showV.choicebtnTag = ^(NSInteger tag) {
            if (tag == 1) {
                [weakSelf loginOrReg];
            }else{
                self.phoneView.text = @"";
                self.codeView.text = @"";
                [self.getCodeBtn releaseTimer];
                [self.getCodeBtn removeFromSuperview];
                self.getCodeBtn = [[CQCountdownButton alloc] initWithFrame:CGRectMake(self.showBackView.frame.size.width-100, 0, 100, 56)];
                [self.getCodeBtn setAction];
                self.getCodeBtn.titleLabel.font = TWOTEXTFONTSIZE;
                [self.getCodeBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
                [self.getCodeBtn setTitle:[NoticeTools getLocalStrWith:@"Login.getsmsCode"] forState:UIControlStateNormal];
                self.getCodeBtn.dataSource = self;
                self.getCodeBtn.delegate = self;
                [self.showBackView addSubview:self.getCodeBtn];
            }
        };
        [showV showInfoView];
        return;
    }else if (self.isThird){
        [self thirdReg];
        return;
    }

    if (self.type) {
        [self loginOrReg];
        return;
    }
    
    [self showHUD];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.phoneView.text forKey:@"mobile"];
    [parm setObject:self.codeView.text forKey:@"smsCode"];
    [parm setObject:self.areaModel.area_code forKey:@"countryCode"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success1) {
                [self hideHUD];
                if (success1) {
                    NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                    [NoticeSaveModel saveUserInfo:userIn];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } fail:^(NSError *error) {
                [self hideHUD];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            self.markL.hidden = NO;
            self.markImageView.hidden = NO;
            self.markL.text = [NSString stringWithFormat:@"%@",dict[@"msg"]];
             [self hideHUD];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)choiceArea {
    NoticeAreaViewController *ctl = [[NoticeAreaViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    ctl.adressBlock = ^(NoticeAreaModel *adressModel) {
        weakSelf.areaModel = adressModel;
        [weakSelf.areaBtn setTitle:[NSString stringWithFormat:@"+%@",weakSelf.areaModel.phone_code] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)thirdReg{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:[NoticeSaveModel getDeviceInfo] forKey:@"deviceInfo"];
    [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
    [parm setObject:@"2" forKey:@"platformId"];
    [parm setObject:self.codeView.text forKey:@"smsCode"];
    [parm setObject:self.areaModel.area_code forKey:@"areaCode"];
    [parm setObject:self.phoneView.text forKey:@"mobile"];
    [parm setObject:[NoticeTools arrayToJSONString:[NSMutableArray arrayWithArray:@[@"B",@"B",@"A"]]] forKey:@"answers"];
    if ([NoticeTools getIDFA]) {
        [parm setObject:[NoticeTools getIDFA] forKey:@"deviceId"];
    }else{
        [parm setObject:self.phoneView.text forKey:@"deviceId"];
    }
    
    [self showHUD];
    if (self.isThird) {
        [parm setObject:self.regModel.openId forKey:@"openId"];
        [parm setObject:self.regModel.unionId?self.regModel.unionId:@"876543hgfde" forKey:@"unionId"];
        [parm setObject:self.regModel.authType forKey:@"authType"];
        [parm setObject:self.regModel.gender forKey:@"gender"];
        [parm setObject:self.regModel.thirdnickname forKey:@"nickName"];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"thirds/register" Accept:@"application/vnd.shengxi.v4.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (!success) {
            [self hideHUD];
            return ;
        }
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
                    NoticeSetRegNameController *ctl = [[NoticeSetRegNameController alloc] init];
                    [self.navigationController pushViewController:ctl animated:YES];
                    
                    //保存登录痕迹
                    NoticeSaveLoginStory *loginInfo = [[NoticeSaveLoginStory alloc] init];
                    loginInfo.nick_name = userIn.nick_name;
                    loginInfo.avatar_url = userIn.avatar_url;
                    loginInfo.mobile = userIn.mobile;
                    if (self.regModel.authType.intValue == 1) {
                        loginInfo.loginType = [NoticeTools getLocalStrWith:@"bdphone.wxlo1"];
                    }else if(self.regModel.authType.intValue == 2){
                        loginInfo.loginType = [NoticeTools getLocalStrWith:@"bdphone.qqlo"];
                    }else{
                        loginInfo.loginType = [NoticeTools getLocalStrWith:@"bdphone.welo"];
                    }
                    loginInfo.countryCode = self.areaModel.area_code;
                    [NoticeSaveModel saveLogin:loginInfo];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)loginuser:(NSMutableDictionary *)parm{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.type==2 ? @"users/login" : @"users/register" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
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
                    
                    if (self.type == 2) {
                        
                    }else{
                        NoticeSetRegNameController *ctl = [[NoticeSetRegNameController alloc] init];
                        [self.navigationController pushViewController:ctl animated:YES];
                        return;
                    }
                    
                    if ([userInfo.need_login_check isEqualToString:@"1"]) {//如果需要二次验证
                        [NoticeTools saveNeedSecondCheckForLogin:@"1"];
                        NoticeSetSecondPWController *ctl = [[NoticeSetSecondPWController alloc] init];
                        ctl.isCheck = YES;
                        [self.navigationController pushViewController:ctl animated:YES];
                        return;
                    }
                    //执行引导页
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    //上传成功，执行引导页
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                }else{
                    self.markL.hidden = NO;
                    self.markImageView.hidden = NO;
                    self.markL.text = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)loginOrReg{
    //这里执行注册
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:[NoticeSaveModel getDeviceInfo] forKey:@"deviceInfo"];
    [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
    [parm setObject:@"2" forKey:@"platformId"];
    [parm setObject:self.codeView.text forKey:@"smsCode"];
    [parm setObject:self.areaModel.area_code forKey:@"countryCode"];
    [parm setObject:self.phoneView.text forKey:@"mobile"];
    if ([NoticeTools getIDFA]) {
        [parm setObject:[NoticeTools getIDFA] forKey:@"deviceId"];
    }else{
        [parm setObject:self.phoneView.text forKey:@"deviceId"];
    }
    if ([self.phoneView.text isEqualToString:@"10998776554"] || [self.phoneView.text isEqualToString:@"13433329742"]) {//固定验证码接口也需要调用获取验证码接口
        [self showHUD];
        NSString *url = [NSString stringWithFormat:@"users/code/%@/%@/%@",self.areaModel.area_code,self.phoneView.text,[NoticeSaveModel getUUID]];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            [self loginuser:parm];
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
        return;
    }
    [self loginuser:parm];
}

// 倒计时按钮点击
- (void)countdownButtonDidClick:(CQCountdownButton *)countdownButton {
    
    if (!self.phoneView.text.length) {
        return;
    }

    if (self.type ||  self.isThird) {//先验证手机号是否已经注册过，注册过，执行登录验证码，没注册，执行登录验证码
        if([self.areaModel.area_code isEqualToString:@"CN"]){
            [self checkIsAlready:countdownButton smscode:nil key:nil];
        }else{
            __weak typeof(self) weakSelf = self;
            NoticeDesTroyView *view = [[NoticeDesTroyView alloc] initWithShowSendSMS];
            view.sureCodeBlock = ^(NSString * _Nonnull code, NSString * _Nonnull key) {
                [weakSelf checkIsAlready:countdownButton smscode:code key:key];
            };
            [view showDestroyView];
        }
        
        return;
    }

    if([self.areaModel.area_code isEqualToString:@"CN"]){
        // 按钮点击后将enabled设置为NO
        countdownButton.enabled = NO;
        // 请求短信验证码
        [countdownButton startCountDown];
        [self sendSMS:nil key:nil];
    }else{
        __weak typeof(self) weakSelf = self;
        NoticeDesTroyView *view = [[NoticeDesTroyView alloc] initWithShowSendSMS];
        view.sureCodeBlock = ^(NSString * _Nonnull code, NSString * _Nonnull key) {
            // 按钮点击后将enabled设置为NO
            countdownButton.enabled = NO;
            // 请求短信验证码
            [countdownButton startCountDown];
            [weakSelf sendSMS:code key:key];
        };
    }
}

- (void)sendSMS:(NSString *)code key:(NSString *)key{
    NSString *url = [NSString stringWithFormat:@"code/%@/%@/1",self.areaModel.area_code,self.phoneView.text];
    NSString *accept = nil;
    if(![self.areaModel.area_code isEqualToString:@"CN"]){
        url = [NSString stringWithFormat:@"code/%@/%@/1?captchaCode=%@&captchaKey=%@",self.areaModel.area_code,self.phoneView.text,code,key];
        accept = @"application/vnd.shengxi.v5.5.1+json";
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
      
        }else{
            self.markL.hidden = NO;
            self.markImageView.hidden = NO;
            self.markL.text = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            [self hideHUD];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)checkIsAlready:(CQCountdownButton *)countdownButton smscode:(NSString *)code key:(NSString *)key{
    [self showHUD];
    // 按钮点击后将enabled设置为NO
    countdownButton.enabled = NO;
    // 请求短信验证码
    [countdownButton startCountDown];
    //检测手机是否注册过
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/%@",self.areaModel.area_code?self.areaModel.area_code :[[NoticeSaveModel getArea] area_code],self.phoneView.text] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeCheckModel *checkM = [NoticeCheckModel mj_objectWithKeyValues:dict[@"data"]];
            self.checkM = checkM;
            if (checkM.is_forbid.boolValue) {
                [self showToastWithText:[NoticeTools getLocalStrWith:@"bdphone.fh"]];
                return;
            }
            if (checkM.is_exist.boolValue) {
                self.type = 2;
            }else{
                self.type = 1;
            }
            
            [self showHUD];
            [self.codeView becomeFirstResponder];
            NSString *url = [NSString stringWithFormat:@"users/code/%@/%@/%@",self.areaModel.area_code,self.phoneView.text,[NoticeSaveModel getUUID]];
            NSString *accept = nil;
            if(![self.areaModel.area_code isEqualToString:@"CN"]){
                url = [NSString stringWithFormat:@"users/code/%@/%@/%@?captchaCode=%@&captchaKey=%@",self.areaModel.area_code,self.phoneView.text,[NoticeSaveModel getUUID],code,key];
                accept = @"application/vnd.shengxi.v5.5.1+json";
            }
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
     
                }else{
                    self.markL.hidden = NO;
                    self.markImageView.hidden = NO;
                    self.markL.text = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                    [self hideHUD];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
            
        }else{
            [self hideHUD];
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
        [self showHUD];
        [self.codeView becomeFirstResponder];
        NSString *url = [NSString stringWithFormat:@"users/code/%@/%@/%@",self.areaModel.area_code,self.phoneView.text,[NoticeSaveModel getUUID]];
        NSString *accept = nil;
        if(![self.areaModel.area_code isEqualToString:@"CN"]){
            url = [NSString stringWithFormat:@"users/code/%@/%@/%@?captchaCode=%@&captchaKey=%@",self.areaModel.area_code,self.phoneView.text,[NoticeSaveModel getUUID],code,key];
            accept = @"application/vnd.shengxi.v5.5.1+json";
        }
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
           
            }else{
                self.markL.hidden = NO;
                self.markImageView.hidden = NO;
                self.markL.text = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                [self hideHUD];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }];
}

// 倒计时进行中
- (void)countdownButtonDidCountdown:(CQCountdownButton *)countdownButton withRestCountdownNum:(NSInteger)restCountdownNum {

    NSString *title = [NSString stringWithFormat:@"%lds%@", (long)restCountdownNum,[NoticeTools getLocalStrWith:@"bdphone."]];
    [countdownButton setAttributedTitle:[DDHAttributedMode setColorString:title setColor:[UIColor colorWithHexString:@"#8A8F99"] setLengthString:[NSString stringWithFormat:@"s%@",[NoticeTools getLocalStrWith:@"bdphone."]] beginSize:[[NSString stringWithFormat:@"%ld", (long)restCountdownNum] length]] forState:UIControlStateNormal];

}

// 倒计时结束
- (void)countdownButtonDidEndCountdown:(CQCountdownButton *)countdownButton {
    [countdownButton setAttributedTitle:[DDHAttributedMode setColorString:[NoticeTools getLocalStrWith:@"Login.getsmsCode"] setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:[NoticeTools getLocalStrWith:@"Login.getsmsCode"] beginSize:0] forState:UIControlStateNormal];
    [countdownButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
    countdownButton.enabled = YES;
}
// 设置倒计时总秒数
- (NSInteger)startCountdownNumOfCountdownButton:(CQCountdownButton *)countdownButton {
    return 60;
}

- (void)dealloc{
    [self.getCodeBtn releaseTimer];
}



@end
