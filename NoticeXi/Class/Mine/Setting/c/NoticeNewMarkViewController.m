//
//  NoticeNewMarkViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewMarkViewController.h"
#import "NoticeLabelAndSwitchCell.h"
#import "NoticeNoticenterModel.h"
#import "NoticeChatStyleSetController.h"
@interface NoticeNewMarkViewController ()<SwitchChoiceDelegate>

@property (nonatomic, strong) NoticeNoticenterModel *noticeM;
@property (nonatomic, strong) NoticeAbout *aboutM;
@end

@implementation NoticeNewMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"push.title"];

    [self.tableView registerClass:[NoticeLabelAndSwitchCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.rowHeight = 55;
    [self requestData];
}

- (void)requestData{
    [self showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.noticeM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
            [self.tableView reloadData];
        }else{
            [self showToastWithText:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/settings?settingTag=notice",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self.aboutM = [NoticeAbout new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeAbout *setM = [NoticeAbout mj_objectWithKeyValues:dic];
                if ([setM.setting_name isEqualToString:@"about_artwork"]) {//灵魂画手
                    self.aboutM.about_artwork = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"resource_subscription"]){//书影音订阅开关
                    self.aboutM.resource_subscription = setM.setting_value;
                }else if ([setM.setting_name isEqualToString:@"about_clock_vote"]){//闹钟配音开关
                    self.aboutM.about_clock_vote = setM.setting_value;
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

#pragma SwitchChoiceDelegate
- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section{

    if (isOn) {
        [self changeWithSection:section tag:tag isOn:isOn];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *str = nil;
    if (section == 0) {
        if (tag == 0) {
            str = [NoticeTools getLocalStrWith:@"push.mark1"];
        }else{
            str = [NoticeTools getLocalStrWith:@"push.mark2"];
        }
    }else if(section == 1){
        if (tag == 0) {
            str = [NoticeTools getLocalStrWith:@"push.mark3"];
        }else if (tag == 1) {
            str = [NoticeTools getLocalStrWith:@"push.mark4"];
        }else if(tag == 2){
            str = [NoticeTools getLocalStrWith:@"push.mark5"];
        }else if(tag == 3){
            str = [NoticeTools getLocalStrWith:@"push.mark7"];
        }else if(tag == 4){
            str = [NoticeTools getLocalStrWith:@"push.mark8"];
        }else if(tag == 5){
            str = @"确定关闭店铺评价通知吗？";
        }
    }else if(section == 2){
        if (tag == 0) {
            str = [NoticeTools getLocalStrWith:@"push.mark9"];
        }else if(tag == 1){
            str = [NoticeTools getLocalStrWith:@"push.mark10"];
        }else if(tag == 2){
            str = [NoticeTools getLocalStrWith:@"push.mark11"];
        }
    }
    
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.sureclose"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf changeWithSection:section tag:tag isOn:isOn];
        }else{
            [self.tableView reloadData];
        }
    };
    [alerView showXLAlertView];
}

- (void)changeWithSection:(NSInteger)section tag:(NSInteger)tag isOn:(BOOL)isOn{
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (section == 0 || (section == 1 && (tag == 2 || tag == 1 || tag == 0 || tag == 4 || tag == 5)) || section == 2) {
        if (section == 0) {
            if (tag == 0) {
                [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"chatRemind"];
            }else{
                [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"chatPriRemind"];
            }
        }else if(section == 2){
            if (tag == 0) {
                [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"sysRemind"];
            }
        }
        else if(section == 1){
            if (tag == 0) {
                [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"admirersRenew"];
            }
            else if (tag == 1) {
                [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"newFriendRemind"];
            } else if (tag == 4) {
                [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"musicPush"];
            }else if (tag == 5) {
                [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"shopCommentRemind"];
            }
            else{
                [parm setObject:[NSString stringWithFormat:@"%d",isOn] forKey:@"otherRemind"];
            }
        }

        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/setting",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                [self requestData];
            }else{
                [self showToastWithText:dict[@"msg"]];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
        return;
    }else if (section == 1){
        if (tag == 1) {
            [self hideHUD];
        }else if(tag == 3){
            [parm setValue:@"notice" forKey:@"settingTag"];
            [parm setValue:@"about_clock_vote" forKey:@"settingName"];
            [parm setValue:isOn ? @"1":@"2" forKey:@"settingValue"];
        }
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@/settings",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                [self requestData];
                [self.tableView reloadData];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeLabelAndSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.choiceTag = indexPath.row;
    cell.choiceSection = indexPath.section;
    cell.delegate = self;
    cell.line.hidden = NO;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce1"];
            cell.switchButton.on = self.noticeM.chat_remind.boolValue;
        }else{
            cell.line.hidden = YES;
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce2"];
            cell.switchButton.on = self.noticeM.chat_pri_remind.boolValue;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce3"];
            cell.switchButton.on = self.noticeM.admirers_renew.boolValue;
        }else if (indexPath.row == 1) {
            cell.mainL.text = [NoticeTools getLocalStrWith:@"message.likeNotice"];
            cell.switchButton.on = self.noticeM.newfriend_remind.boolValue;
        }else if(indexPath.row == 2){
            cell.switchButton.on = self.noticeM.other_remind.boolValue;
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce5"];
        }else if(indexPath.row == 3){
            cell.switchButton.on = self.aboutM.about_clock_vote.integerValue == 2 ?NO:YES;
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce7"];
        }else if(indexPath.row == 4){
            cell.switchButton.on = self.noticeM.music_push.boolValue;
            cell.line.hidden = YES;
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce8"];
        }else{
            cell.switchButton.on = self.noticeM.shop_comment_remind.boolValue;
            cell.line.hidden = YES;
            cell.mainL.text = @"店铺订单评价通知";
        }
    }
    else{
        if (indexPath.row == 0) {
            cell.switchButton.on = self.noticeM.sys_remind.boolValue;
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce9"];
        }else if(indexPath.row == 1){
            cell.switchButton.on = self.noticeM.assoc_remind.boolValue;
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce10"];
        }else{
            cell.line.hidden = YES;
            cell.switchButton.on = self.noticeM.assoc_chat_remind.boolValue;
            cell.mainL.text = [NoticeTools getLocalStrWith:@"push.ce11"];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 6;
    }
   return  1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return [UIView new];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,DR_SCREEN_WIDTH-35, 45)];
    label.text = [NoticeTools getLocalStrWith:@"push.tx"];
    label.font = TWOTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 45;
    }
    return 8;
}


@end
