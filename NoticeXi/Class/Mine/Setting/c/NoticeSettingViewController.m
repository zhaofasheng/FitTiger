//
//  NoticeSettingViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSettingViewController.h"
#import "NoticeTitleAndImageCell.h"
#import "NoticeCountSafeViewController.h"
#import "NoticeNewMarkViewController.h"
#import "NoticePrivacyViewController.h"
#import "NoticeFAQViewController.h"
#import <SDImageCache.h>
#import "UIImage+Color.h"
#import "AppDelegate+Notification.h"
#import "NoticeEditViewController.h"
#import "NoticeSCViewController.h"
#import "NoticeCacheManagerController.h"
#import "NoticeChangeServerAreaController.h"
#import "NoticeMBSViewController.h"
#import "NoticeNoticenterModel.h"
#import <Contacts/Contacts.h>
#import "NoticeManagerController.h"
#import "NoticeBlackBaseController.h"
#import "NoticeManager.h"
#import "AFHTTPSessionManager.h"
#import "NoticeVersionController.h"
#import "NoticeNewLeadController.h"
#import "NoticeExchangeController.h"
#import "NoticeNewUserOrderController.h"
#import "NoticeCaoGaoController.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
@interface NoticeSettingViewController ()<NoticeManagerUserDelegate>

@property (nonatomic, strong) NSArray *cellTitleArr;
@property (nonatomic, strong) UIButton *outLignBtn;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, strong) UISwitch *switchButton1;
@property (nonatomic, strong) UISwitch *switchButton2;
@property (nonatomic, strong) UISwitch *switchButton3;
@property (nonatomic, assign) BOOL hasNewVoerisc;
@property (nonatomic, strong) NSString *VoieceName;
@property (nonatomic, assign) BOOL addresBookOpen;
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@property (nonatomic, strong) NoticeManager *magager;
@end

@implementation NoticeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"groupManager.set"];

    self.cellTitleArr = @[[NoticeTools getLocalStrWith:@"set.cell1"],[NoticeTools getLocalStrWith:@"set.cell3"],[NoticeTools getLocalStrWith:@"push.title"],[NoticeTools getLocalStrWith:@"set.cell5"],@"听筒模式(开启后不外放)",[NoticeTools getLocalStrWith:@"black.title1"],@"屏蔽通讯录(开启后通讯录好友不可见)",[NoticeTools getLocalStrWith:@"aboutsx.title"]];
    
    _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-18-44,14,44,24)];
    _switchButton.onTintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    _switchButton.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _switchButton.tintColor = [UIColor colorWithHexString:@"#8A8F99"];
    [_switchButton setOn:![NoticeTools isOpen]];
    [_switchButton addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventValueChanged];
    
    _switchButton2 = [[UISwitch alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-18-44,14,44,24)];
    _switchButton2.onTintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    _switchButton2.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _switchButton2.tintColor = [UIColor colorWithHexString:@"#8A8F99"];
    [_switchButton2 addTarget:self action:@selector(changeVale2:) forControlEvents:UIControlEventValueChanged];
    
    _switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
    _switchButton1.transform = CGAffineTransformMakeScale(0.75, 0.75);
    _switchButton2.transform = CGAffineTransformMakeScale(0.75, 0.75);
    _switchButton3.transform = CGAffineTransformMakeScale(0.75, 0.75);
        
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 56;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35,20,DR_SCREEN_WIDTH-70, 56);
    self.outLignBtn = btn;
    [btn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    btn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    btn.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    btn.layer.cornerRadius = 56/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(outLoginClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 90)];
    [footView addSubview:btn];
    self.footView = footView;
    self.tableView.tableFooterView = footView;
    [self.outLignBtn setTitle:[NoticeTools getLocalStrWith:@"set.outlogin"] forState:UIControlStateNormal];

    [self.navBarView.rightButton setImage:UIImageNamed(@"Image_duiuan") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(duihuanClick) forControlEvents:UIControlEventTouchUpInside];
    [self requestConast];
    
    [self hsUpdateApp];
    
}

- (void)duihuanClick{
    NoticeExchangeController *ctl = [[NoticeExchangeController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)managerClick{
    self.magager.type = @"管理员登陆";
    [self.magager show];
}

- (void)sureManagerClick:(NSString *)code{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            NoticeManagerController *ctl = [[NoticeManagerController alloc] init];
            ctl.mangagerCode = code;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestConast{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            [self.tableView reloadData];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)changeVale:(UISwitch *)switchbutton{
    if (switchbutton.isOn) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//听筒模式 
        [NoticeTools setVoiceOpen:NO];
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];//扬声器模式
        [NoticeTools setVoiceOpen:YES];
    }
    [self.tableView reloadData];
}

- (void)changeVale2:(UISwitch *)switchbutton{
    
    if (switchbutton.isOn) {
        [self requestContactAuthorAfterSystemVersion9];
    }else{
        [self showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:@"0" forKey:@"addressBookSwitch"];
        [self showHUD];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                self.noticeM.address_book_switch = @"0";
                [self.tableView reloadData];
            }else{
                [self showToastWithText:dict[@"msg"]];
    
            }
        } fail:^(NSError *error) {
      
            [self hideHUD];
        }];
    }

}

#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                DRLog(@"授权失败");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //放在主线程中
                    [self getSetingVC];
                    
                });
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //放在主线程中
                    [self openContact];
                    
                });
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        [self getSetingVC];
        
        DRLog(@"用户拒绝权限");
 
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        [self getSetingVC];
        DRLog(@"用户拒绝权限");
       
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
    
}

- (void)getSetingVC{
    [_switchButton2 setOn:NO];
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"set.notongxunlu"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
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

//有通讯录权限-- 进行下一步操作
- (void)openContact{
 // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    NSMutableArray *arr = [NSMutableArray new];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {

        NSArray *phoneNumbers = contact.phoneNumbers;
        //        CNPhoneNumber  * cnphoneNumber = contact.phoneNumbers[0];
        //        NSString * phoneNumber = cnphoneNumber.stringValue;
        for (CNLabeledValue *labelValue in phoneNumbers) {

            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue;
            
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"小二" forKey:@"name"];
            [parm setObject:string?string:@"" forKey:@"mobile"];
            [arr addObject:parm];
            
        }
    }];
    if (!arr.count) {
        [self showToastWithText:@"没有获取到数据，请重试"];
        return;
    }
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:[NoticeTools arrayToJSONString:arr] forKey:@"contacts"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"addressBook" Accept:@"application/vnd.shengxi.v4.8.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
        if (success) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"1" forKey:@"addressBookSwitch"];
            [self showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    self.noticeM.address_book_switch = @"1";
                    [self.tableView reloadData];
                }else{
                    [self showToastWithText:dict[@"msg"]];
                    [_switchButton2 setOn:NO];
                }
            } fail:^(NSError *error) {
                [_switchButton2 setOn:NO];
                [self hideHUD];
            }];
        }else{
            [self hideHUD];
            [_switchButton2 setOn:NO];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self showToastWithText:@"通讯录设置失败"];
         [_switchButton2 setOn:NO];
    }];
}


- (void)backToPageAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Action
- (void)outLoginClick{
    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"logininfo"];
            [weakSelf outLogin];
        }else if(buttonIndex == 1){
            [weakSelf outLogin];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"set.justout"],[NoticeTools getLocalStrWith:@"set.cleanandout"]]];
    [sheet show];
}

- (void)outLogin{
    
    [NoticeSaveModel outLoginClearData];
    [(AppDelegate *)[UIApplication sharedApplication].delegate deleteAlias];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager.timer invalidate];
    [appdel.socketManager.webSocket close];
    appdel.socketManager = nil;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATIONNEEDACTION" object:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-20-130, 0,130, 55);
    if (!self.cellTitleArr.count) {
        return cell;
    }
    cell.subL.text = @"";
    cell.leftImageV.hidden = NO;
    if (indexPath.section == 0) {
        cell.mainL.text = self.cellTitleArr[indexPath.row];
    }else if (indexPath.section == 1){
        if (indexPath.row == 3) {
            cell.mainL.text = [NoticeTools getLocalStrWith:@"cao.title"];
        }else{
            cell.mainL.text = self.cellTitleArr[1+indexPath.row];
        }
    }else if (indexPath.section == 2){
        cell.subL.text = @"";
        if (indexPath.row == 0) {
            cell.subImageV.hidden = YES;
            [_switchButton removeFromSuperview];
            [cell addSubview:_switchButton];
            if ([NoticeTools getLocalType]) {
                cell.mainL.text = @"Speaker off";
                if ([NoticeTools getLocalType] == 2) {
                    cell.mainL.text = @"受話器モード";
                }
            }else{
                cell.mainL.attributedText = [DDHAttributedMode setSizeAndColorString:@"听筒模式(开启后不外放)" setColor:[UIColor colorWithHexString:@"#8A8F99"] setSize:12 setLengthString:@"(开启后不外放)" beginSize:4];
            }
            
        }
       else if (indexPath.row == 1) {
           cell.subImageV.hidden = YES;
           [_switchButton2 removeFromSuperview];
           [_switchButton2 setOn:self.noticeM.address_book_switch.intValue?YES:NO];
           [cell addSubview:_switchButton2];
           if ([NoticeTools getLocalType]) {
               if ([NoticeTools getLocalType] == 2) {
                   cell.mainL.text = @"連絡先ブロック";
               }else{
                   NSMutableAttributedString *attStr = [DDHAttributedMode setSizeAndColorString:@"Stealth mode(Hide from Contacts)" setColor:[UIColor colorWithHexString:@"#8A8F99"] setSize:12 setLengthString:@"(Hide from Contacts)" beginSize:12];
                   cell.mainL.attributedText = cell.mainL.attributedText = attStr;
               }

           }else{
               NSMutableAttributedString *attStr = [DDHAttributedMode setSizeAndColorString:@"屏蔽通讯录(通讯录好友玩声昔时彼此看不着)" setColor:[UIColor colorWithHexString:@"#8A8F99"] setSize:12 setLengthString:@"(通讯录好友玩声昔时彼此看不着)" beginSize:5];
               cell.mainL.attributedText = cell.mainL.attributedText = attStr;
           }

        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            cell.subL.frame = CGRectMake(DR_SCREEN_WIDTH-20-130-15, 0,130, 55);
            cell.mainL.text = [NoticeTools getLocalStrWith:@"version.title"];
            if (self.hasNewVoerisc) {
                cell.subL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"set.hasnew"],self.VoieceName];
                cell.subL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
            }else{
                cell.subL.text = [NoticeTools getLocalStrWith:@"set.isnew"];
            }
        }else if(indexPath.row == 1){
            cell.mainL.text = [NoticeTools getLocalStrWith:@"setcell9."];
        }
        else if(indexPath.row == 2){
            cell.mainL.text = [NoticeTools chinese:@"新手指南" english:@"Guide" japan:@"ガイド"];
        }else{
            cell.mainL.text = [NoticeTools getLocalStrWith:@"set.cac"];
        }
    }else{
        cell.mainL.text = [NoticeTools getLocalStrWith:@"set.outsea"];
    }
    return cell;
}

- (void)hsUpdateApp{
    NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
    [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *results = responseObject[@"results"];
        if (results && results.count > 0) {
            NSDictionary *response = results.firstObject;
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];// 软件的当前版本
            NSString *lastestVersion = response[@"version"];// AppStore 上软件的最新版本
    
            if ([lastestVersion compare:currentVersion] == NSOrderedDescending) {
                self.hasNewVoerisc = YES;
                self.VoieceName = lastestVersion;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *ctl = nil;
    if (indexPath.row == 0 && indexPath.section == 0) {
        ctl = [[NoticeEditViewController alloc] init];
    }

    if (indexPath.section == 3 && indexPath.row == 3) {
        ctl = [[NoticeCacheManagerController alloc] init];
    }
    if (indexPath.section == 3 && indexPath.row == 2) {
        ctl = [[NoticeNewLeadController alloc] init];
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        ctl = [[NoticeFAQViewController alloc] init];
    }
    if (indexPath.row == 0 && indexPath.section == 1) {
        ctl = [[NoticeCountSafeViewController alloc] init];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        ctl = [[NoticeNewMarkViewController alloc] init];
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        ctl = [[NoticeCaoGaoController alloc] init];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        NoticeBlackBaseController *ctl1 = [[NoticeBlackBaseController alloc] init];
        [self.navigationController pushViewController:ctl1 animated:YES];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        NoticeVersionController *ctl = [[NoticeVersionController alloc] init];
        ctl.hasNewVersion = self.hasNewVoerisc;
        ctl.versionName = self.VoieceName;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    
    if (indexPath.section == 4) {
        ctl = [[NoticeChangeServerAreaController alloc] init];
    }
    
    if (ctl) {
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ( section == 2){
        return 2;
    }
    if (section == 1) {
        return 4;
    }
    if (section == 3) {
        return 4;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 10)];
    view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}
@end
