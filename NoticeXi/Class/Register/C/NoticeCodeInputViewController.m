//
//  NoticeCodeInputViewController.m
//  NoticeXi
//
//  Created by 赵小二 on 2018/10/20.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeCodeInputViewController.h"
#import "NoticeCodeInputViewController.h"
#import "JJCPayCodeTextField.h"
#import "UITextField+LXPToolbar.h"
#import "CQCountdownButton.h"
#import "NoticeAreaModel.h"
#import "AppDelegate+Notification.h"
#import "NoticeVideoViewController.h"
#import "NoticeYunXin.h"
#import "NoticeSetSecondPWController.h"
#import "NoticeChoiceReasonController.h"
#import "NoticeVideoViewController.h"
#import "NoticeWhiteVoiceListModel.h"
#import "NoticeDesTroyView.h"
@interface NoticeCodeInputViewController ()<CQCountDownButtonDataSource, CQCountDownButtonDelegate>
@property (strong, nonatomic)  UILabel *topMarkL;
@property (strong, nonatomic)  UIView *codeView;
@property (strong, nonatomic)  UILabel *markL;
@property (strong, nonatomic)  CQCountdownButton *sendButton;
@end

@implementation NoticeCodeInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
    [NoticeSaveModel setUUIDIFNO];
    
    self.topMarkL = [[UILabel alloc] initWithFrame:CGRectMake(0, 47+30,DR_SCREEN_WIDTH, 23)];
    self.topMarkL.textAlignment = NSTextAlignmentCenter;
    self.topMarkL.font = [UIFont systemFontOfSize:23];
    self.topMarkL.textColor = GetColorWithName(VMainTextColor);
    self.topMarkL.text = Localized(@"hnP-Qt-ev0.text");
    [self.view addSubview:self.topMarkL];
    
    self.markL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topMarkL.frame)+20,DR_SCREEN_WIDTH, 13)];
    self.markL.textAlignment = NSTextAlignmentCenter;
    self.markL.font = [UIFont systemFontOfSize:13];
    self.markL.textColor = GetColorWithName(VDarkTextColor);
    [self.view addSubview:self.markL];
    self.markL.text = [NSString stringWithFormat:@"%@ %@",Localized(@"sQ4-bF-jeJ.text"),self.phone];

    self.codeView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-282)/2, CGRectGetMaxY(self.markL.frame)+74, 282, 40)];
    self.codeView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.codeView];
        
    JJCPayCodeTextField *codeField = [[JJCPayCodeTextField alloc] initWithFrame:CGRectMake(0, 0, self.codeView.frame.size.width, self.codeView.frame.size.height) TextFieldType:JJCPayCodeTextFieldTypeSpaceBorder];
    codeField.borderSpace = 10;
    codeField.borderColor = [UIColor clearColor];
    codeField.textFieldNum = 6;
    codeField.isShowTrueCode = YES;
    codeField.textField.keyboardType = UIKeyboardTypePhonePad;
    [codeField.textField setupToolbarToDismissRightButton];
    [self.codeView addSubview:codeField];
    
    __weak typeof(self) weakSelf = self;
    codeField.finishedBlock = ^(NSString *payCodeString) {//验证码输入完毕
        //这里执行注册
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:[NoticeSaveModel getDeviceInfo] forKey:@"deviceInfo"];
        [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
        [parm setObject:@"2" forKey:@"platformId"];
        [parm setObject:payCodeString forKey:@"smsCode"];
        [parm setObject:self.areaModel.area_code forKey:self.isLogin?@"countryCode": @"areaCode"];
        [parm setObject:weakSelf.phone forKey:@"mobile"];
        [parm setObject:[NoticeTools arrayToJSONString:[NSMutableArray arrayWithArray:@[@"B",self.isRemember?@"A":@"B",@"A"]]] forKey:@"answers"];
        if ([NoticeTools getIDFA]) {
            [parm setObject:[NoticeTools getIDFA] forKey:@"deviceId"];
        }else{
            [parm setObject:self.phone forKey:@"deviceId"];
        }
        if (!self.isLogin) {
            [weakSelf regerUser:parm];
            return;
        }
        [weakSelf showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isLogin ? @"users/login" : @"users/register" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            if (!success) {
                [weakSelf hideHUD];
                return ;
            }
            if (success) {
                [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
                NoticeUserInfoModel *userInfo = [NoticeUserInfoModel mj_objectWithKeyValues:dict[@"data"]];
                [NoticeSaveModel saveUserInfo:userInfo];
                [NoticeSaveModel saveToken:userInfo.token];
                
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",userInfo.user_id] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                        [NoticeSaveModel saveUserInfo:userIn];
                        
                        if ([userInfo.need_login_check isEqualToString:@"1"]) {//如果需要二次验证
                            [NoticeTools saveNeedSecondCheckForLogin:@"1"];
                            NoticeSetSecondPWController *ctl = [[NoticeSetSecondPWController alloc] init];
                            ctl.isCheck = YES;
                            [self.navigationController pushViewController:ctl animated:YES];
                            return;
                        }
                        //执行引导页
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        //上传成功，执行引导页
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                    }
                } fail:^(NSError *error) {
                    [weakSelf hideHUD];
                }];
            }
        } fail:^(NSError *error) {
            [weakSelf hideHUD];
        }];
    };
    
    self.sendButton = [[CQCountdownButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-282)/2, CGRectGetMaxY(self.codeView.frame)+35, 282, 40)];
    self.sendButton.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.masksToBounds = YES;
    [self.sendButton setTitle:[NoticeTools getLocalStrWith:@"msg.resend"] forState:UIControlStateNormal];
    [self.view addSubview:self.sendButton];
    [self.sendButton setAction];
    self.sendButton.backgroundColor = [UIColor colorWithHexString:WHITEBUTTONGRAYCOLOR];
    self.sendButton.dataSource = self;
    self.sendButton.delegate = self;
    [self.sendButton onClick];

}

- (void)regerUser:(NSMutableDictionary *)parm{
    [self showHUD];
    if (self.isThird) {
        [parm setObject:self.regModel.openId forKey:@"openId"];
        [parm setObject:self.regModel.unionId?self.regModel.unionId:@"876543hgfde" forKey:@"unionId"];
        [parm setObject:self.regModel.authType forKey:@"authType"];
        [parm setObject:self.regModel.gender forKey:@"gender"];
        [parm setObject:self.regModel.thirdnickname forKey:@"nickName"];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isThird?@"thirds/register": @"users/register" Accept:@"application/vnd.shengxi.v4.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
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
                    [self uploadAac:self.locapath timeLen:self.timeLength];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)getWhiteCard:(NSString *)cardId{
    if (!cardId) {
        return;
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"famousQuotesCards/%@",cardId] Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeWhiteVoiceListModel *carM = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            if (!carM.card_url) {
                return ;
            }
            NoticeTostWhtieVoiceView *tostView = [[NoticeTostWhtieVoiceView alloc] initWithShow:carM];
            [tostView showCardView];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}
//上传声昔文件
- (void)uploadAac:(NSString *)path timeLen:(NSString *)timeLen{

    [self showHUD];
    if (self.text) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        
        [parm setObject:@"2" forKey:@"contentType"];
        [parm setObject:[NSString stringWithFormat:@"%ld",self.text.length] forKey:@"contentLen"];
        [parm setObject:self.text forKey:@"voiceContent"];
        [parm setObject:@"0" forKey:@"isPrivate"];
        [parm setObject: @"2" forKey:@"voiceType"];
        [parm setObject:@"0" forKey:@"titleId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices" Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                [self hideHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success2) {
                    [self hideHUD];
                    NoticeWhiteVoiceListModel *whitem = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                    [self getWhiteCard:whitem.card_no];
                    if (success2) {
                        [NoticeComTools saveFromeFromeRegister:@"1"];
                        NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                        [NoticeSaveModel saveUserInfo:userIn];
                        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        appdel.needLeaderPage = YES;
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                        return ;
                    }
                } fail:^(NSError *error) {
                    [self hideHUD];
                }];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
        return;
    }
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"2" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:path parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"2" forKey:@"voiceType"];
            [parm setObject:@"1" forKey:@"contentType"];
            [parm setObject:self.timeLength forKey:@"contentLen"];
            [parm setObject:Message forKey:@"voiceContent"];
            [parm setObject:@"1" forKey:@"lengthType"];
            [parm setObject:@"0" forKey:@"isPrivate"];
            if (bucketId) {
                [parm setObject:bucketId forKey:@"bucketId"];
            }else{
                [parm setObject:@"0" forKey:@"bucketId"];
            }
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices" Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success2) {
                    [self hideHUD];
                    if (success2) {
                        [NoticeComTools saveFromeFromeRegister:@"1"];
                        NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                        [NoticeSaveModel saveUserInfo:userIn];
                        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        appdel.needLeaderPage = YES;
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                        return ;
                    }
                } fail:^(NSError *error) {
                    [self hideHUD];
                }];
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }else{
            [self showToastWithText:Message];
            [self hideHUD];
        }
    }];
}

// 倒计时按钮点击
- (void)countdownButtonDidClick:(CQCountdownButton *)countdownButton {
    if([self.areaModel.area_code isEqualToString:@"CN"]){
        [self sendsmsCode:nil key:nil ButtonDidClick:countdownButton];
    }else{
        __weak typeof(self) weakSelf = self;
        NoticeDesTroyView *view = [[NoticeDesTroyView alloc] initWithShowSendSMS];
        view.sureCodeBlock = ^(NSString * _Nonnull code, NSString * _Nonnull key) {
            [weakSelf sendsmsCode:code key:key ButtonDidClick:countdownButton];
        };
    
        [view showDestroyView];
    }
}

- (void)sendsmsCode:(NSString *)code key:(NSString *)key ButtonDidClick:(CQCountdownButton *)countdownButton{
    [self showHUD];
    
    NSString *url = [NSString stringWithFormat:@"users/code/%@/%@/%@",self.areaModel.area_code,self.phone,[NoticeSaveModel getUUID]];
    NSString *accept = nil;
    if(![self.areaModel.area_code isEqualToString:@"CN"]){
        url = [NSString stringWithFormat:@"users/code/%@/%@/%@?captchaCode=%@&captchaKey=%@",self.areaModel.area_code,self.phone,[NoticeSaveModel getUUID],code,key];
        accept = @"application/vnd.shengxi.v5.5.1+json";
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            // 按钮点击后将enabled设置为NO
            countdownButton.enabled = NO;
            countdownButton.backgroundColor = [UIColor colorWithHexString:WHITEBUTTONGRAYCOLOR];
            // 请求短信验证码
            [countdownButton startCountDown];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

// 倒计时进行中
- (void)countdownButtonDidCountdown:(CQCountdownButton *)countdownButton withRestCountdownNum:(NSInteger)restCountdownNum {
    NSString *title = [NSString stringWithFormat:@"%@ (%ld)",Localized(@"zj8-Sd-rus.normalTitle"),(long)restCountdownNum];
    [countdownButton setTitle:title forState:UIControlStateNormal];
}

// 倒计时结束
- (void)countdownButtonDidEndCountdown:(CQCountdownButton *)countdownButton {
    [countdownButton setTitle:Localized(@"zj8-Sd-rus.normalTitle") forState:UIControlStateNormal];
    countdownButton.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    countdownButton.enabled = YES;
}
// 设置倒计时总秒数
- (NSInteger)startCountdownNumOfCountdownButton:(CQCountdownButton *)countdownButton {
    return 60;
}

- (void)dealloc{
    [self.sendButton releaseTimer];
}

@end
