//
//  NoticePrivacyViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticePrivacyViewController.h"
#import "NoticeNoticenterModel.h"
#import "NoticeUserListController.h"
#import "NoticeSetLikeTopicController.h"
#import "NoriceCenterSetPriController.h"
#import "NoticeListenPriSetController.h"
#import "NoticeMBSViewController.h"
@interface NoticePrivacyViewController ()
@property (nonatomic, strong) NSArray *titArr;
@property (nonatomic, strong) NSArray *titArr1;
@property (nonatomic, strong) NSArray *boolArr;
@property (nonatomic, strong) NSArray *setArr;
@property (nonatomic, strong) NSArray *keyArr;
@property (nonatomic, strong) NSArray *nextBoolArr;
@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@end

@implementation NoticePrivacyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"set.yins");
    self.keyArr = @[@"chatWith",@"chatPriWith",@"gpsSwitch"];//后面补充同话题心情
    self.setArr = @[@[Localized(@"privacy.all"),Localized(@"privacy.limit")],@[Localized(@"privacy.all"),Localized(@"privacy.limit")],@[Localized(@"privacy.open"),Localized(@"privacy.close")]];
    self.titArr = @[Localized(@"privacy.sendVoice"),Localized(@"privacy.chat"),@"我的心情簿",[NoticeTools isSimpleLau]?@"黑名单、白名单":@"黑名單、白名單",@"俱乐部",@"成就"];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0,65, 25);
    [btn1 setTitle:@" 开发者" forState:UIControlStateNormal];
    [btn1 setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_listenkf_b":@"Image_listenkf_y") forState:UIControlStateNormal];
    [btn1 setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    btn1.titleLabel.font = THRETEENTEXTFONTSIZE;
    [btn1 addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-15-BOTTOM_HEIGHT-44);
    
    UIButton *reSetBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-15-55-BOTTOM_HEIGHT, DR_SCREEN_WIDTH-30, 55)];
    [reSetBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_ab_setw":@"Image_ab_sety") forState:UIControlStateNormal];
    [reSetBtn setTitle:[NoticeTools getTextWithSim:@"恢复默认设置" fantText:@"恢復默認設置"] forState:UIControlStateNormal];
    reSetBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [reSetBtn setTitleColor:[NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#72727F"] forState:UIControlStateNormal];
    [reSetBtn addTarget:self action:@selector(reSetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reSetBtn];
}

- (void)reSetClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"是否恢复默认隐私设置?" message:@"此操作只恢复初始开关和选项，不会影\n响到你的黑名单/白名单/最喜欢的话题" sureBtn:@"恢复默认" cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings/init",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    [self showToastWithText:@"已恢复默认设置"];
                    [weakSelf requestData];
                }
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }
    };
    
    [alerView showXLAlertView];
}

- (void)kefuClick{
    [NoticeComTools connectXiaoer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)requestData{

    [self showHUD];
    self.noticeM = [[NoticeNoticenterModel alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeNoticenterModel *noticeModel = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            self.noticeM.chantWithName = noticeModel.chantWithName;
            self.noticeM.chantPriWithName = noticeModel.chantPriWithName;
            self.noticeM.ditanceName = noticeModel.ditanceName;
            self.noticeM.strange_view = noticeModel.strange_view;
            self.noticeM.chat_with = noticeModel.chat_with;
            self.noticeM.chat_pri_with = noticeModel.chat_pri_with;
            self.noticeM.gps_switch = noticeModel.gps_switch;
            
            self.boolArr = @[self.noticeM.chantWithName,self.noticeM.chantPriWithName,self.noticeM.ditanceName];
            self.nextBoolArr = @[self.noticeM.chat_with,self.noticeM.chat_pri_with,self.noticeM.gps_switch];
            [NoticeComTools saveSetCacha:self.noticeM.strange_view];
            [self.tableView reloadData];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=other&settingName=achievement_visibility",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.noticeM.achievement_visibility = setM.setting_value;
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=other&settingName=voice_collection_visibility",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.noticeM.voice_collection_visibility = setM.setting_value;
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        NoticePrivacySetViewController *ctl = [[NoticePrivacySetViewController alloc] init];
        ctl.titArr = self.setArr[indexPath.row];
        ctl.headerTitle = self.titArr[indexPath.row];
        ctl.keyString = self.keyArr[indexPath.row];
        ctl.boolStr = self.nextBoolArr[indexPath.row];
        ctl.tag = indexPath.row;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 2){
        NoriceCenterSetPriController *ctl = [[NoriceCenterSetPriController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 3){
        NoticeUserListController *ctl = [[NoticeUserListController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 4){
        NoticeListenPriSetController *ctl = [[NoticeListenPriSetController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 5){
         __weak typeof(self) weakSelf = self;
        NoticeMBSViewController *ctl = [[NoticeMBSViewController alloc] init];
        ctl.setName = @"achievement_visibility";
        ctl.isShowAch = self.noticeM.achievement_visibility.intValue == 2? NO:YES;
        ctl.isAch = YES;
        ctl.openBlock = ^(BOOL open) {
            if (open) {
                weakSelf.noticeM.achievement_visibility = @"1";
            }else{
                weakSelf.noticeM.achievement_visibility = @"2";
            }
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mainL.text = self.titArr[indexPath.row];
    if (self.boolArr.count) {
        if (indexPath.row < 2) {
            cell.subL.text = self.boolArr[indexPath.row];
        }
    }
    cell.line.hidden = (indexPath.row == self.titArr.count-1) ? YES:NO;
    if (indexPath.row == 4 || indexPath.row == 2) {
        cell.subL.text = @"";
    }else if (indexPath.row == 5){
        cell.subL.text = self.noticeM.achievement_visibility.integerValue == 2 ? @"不展示":@"展示";
    }
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return  self.titArr.count;
}

@end
