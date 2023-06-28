//
//  NoticeTeamMemberListController.m
//  NoticeXi
//
//  Created by li lei on 2023/6/19.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamMemberListController.h"
#import "NoticeAtPersonCell.h"
#import "UIView+CLSetRect.h"
#import "NoticeHeaderView.h"
#import "UITableView+SCIndexView.h"
#import "SCIndexViewConfiguration.h"
#import "NoticeClickHeaderTeamView.h"
#import "NoticeXi-Swift.h"
#import "NoticeSuperMangerClickPersongController.h"
@interface NoticeTeamMemberListController ()
@property (nonatomic, assign) BOOL canChoiceMore;
@property (nonatomic, strong) NoticeClickHeaderTeamView *iconClickView;
@property (nonatomic, strong) YYPersonItem *oldPerson;
@end

@implementation NoticeTeamMemberListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBarView.hidden = NO;
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.titleL.text = self.isMamger ?@"管理成员":@"社团成员";
    if(self.isMamger){
        self.navBarView.rightButton.frame = CGRectMake(DR_SCREEN_WIDTH-15-66, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 66, 28);
        self.navBarView.rightButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        [self.navBarView.rightButton setTitle:@"移出" forState:UIControlStateNormal];
        self.navBarView.rightButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        
        [self.navBarView.rightButton setAllCorner:14];
        [self.navBarView.rightButton addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
        self.canChoiceMore = YES;
    }
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 40;
    [self.tableView registerClass:NoticeAtPersonCell.class forCellReuseIdentifier:@"cell"];
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configuration];
    configuration.indicatorHeight = 30;
    configuration.indicatorTextColor = [UIColor colorWithHexString:@"#0099E6"];
    configuration.indexItemTextColor =  [UIColor colorWithHexString:@"#A1A7B3"];
    configuration.indexItemSelectedBackgroundColor = [UIColor whiteColor];
    configuration.indexItemsSpace = 3;
    configuration.indexItemSelectedTextFont = THRETEENTEXTFONTSIZE;
    configuration.indexItemTextFont = ELEVENTEXTFONTSIZE;
    configuration.indicatorTextFont = XGSIXBoldFontSize;
    configuration.indexItemSelectedTextColor = [UIColor colorWithHexString:@"#0099E6"];
    self.tableView.sc_indexViewConfiguration = configuration;
    [self.tableView registerClass:[NoticeHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    
    self.tableView.sc_indexViewDataSource = self.syArr;
    self.tableView.sc_startSection = 0;
    
    if (self.personArr.count) {
        [self.tableView reloadData];
    }else{
        self.personArr = [[NSMutableArray alloc] init];
        [self requestPerson];
    }

    
}

- (NoticeClickHeaderTeamView *)iconClickView{
    if(!_iconClickView){
        _iconClickView = [[NoticeClickHeaderTeamView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _iconClickView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYPersonItem *item = self.personArr[indexPath.section];
    YYPersonItem *person = item.personArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if (self.isMamger) {
        if([person.userId isEqualToString:[NoticeTools getuserId]]){
            return;
        }
        if(self.identity.intValue == 3){
            if(person.identity.intValue == 3){
                return;
            }
        }
        if(self.identity.intValue == 2 && person.identity.intValue > 1){
            return;
        }
        if([self.oldPerson.userId isEqualToString:person.userId]){//点击的是同一个
            person.isAt = !person.isAt;
        }else{
            if(self.oldPerson.isAt){
                self.oldPerson.isAt = NO;
            }
            person.isAt = YES;
        }
        
        self.oldPerson = person;
        if(!self.oldPerson.isAt){
            self.navBarView.rightButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
            [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        }else{
            self.navBarView.rightButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        return;
    }
    
    if(self.identity.intValue == 3){
        NoticeSuperMangerClickPersongController *ctl = [[NoticeSuperMangerClickPersongController alloc] init];
        ctl.identity = self.identity;
        ctl.person = person;
        ctl.clickButtonTagBlock = ^(NSString * _Nonnull clickStr) {
           if ([clickStr isEqualToString:@"移出本社团"]){
                [weakSelf outPeopleWithNojoin:NO userId:person.userId];
            }else if ([clickStr isEqualToString:@"移出并禁止加入本社团"]){
                [weakSelf outPeopleWithNojoin:YES userId:person.userId];
            }
        };
        ctl.cancelManageBlock = ^(NSString * _Nonnull userId) {
            [weakSelf manageUserId:userId];
        };
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    self.iconClickView.identity = self.identity;
    self.iconClickView.person = person;
    
    self.iconClickView.clickButtonTagBlock = ^(NSString * _Nonnull clickStr) {
        if([clickStr isEqualToString:@"举报"]){
            [weakSelf jubaoyOnhu:person.userId];
        }else if ([clickStr isEqualToString:@"交流"]){
            [NoticeComTools connectXiaoer];
        }else if ([clickStr isEqualToString:@"移出本社团"]){
            [weakSelf outPeopleWithNojoin:NO userId:person.userId];
        }else if ([clickStr isEqualToString:@"移出并禁止加入本社团"]){
            [weakSelf outPeopleWithNojoin:YES userId:person.userId];
        }
    };
    [self.iconClickView showIconView];
}


- (void)outPeopleWithNojoin:(BOOL)noJoin userId:(NSString *)userid{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.isOutPerson = YES;
    juBaoView.titleL.text = @"移出理由";
    [juBaoView.pinbBtn setTitle:@"移出" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    juBaoView.outBlock = ^(NSInteger type) {
        [weakSelf outPersonNojoin:noJoin type:[NSString stringWithFormat:@"%ld",type] userId:userid];
    };
    [juBaoView showView];
}

- (void)outPersonNojoin:(BOOL)noJoin type:(NSString *)type userId:(NSString *)userid{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.teamModel.teamId forKey:@"massId"];
    [parm setObject:userid forKey:@"userId"];
    [parm setObject:type forKey:@"reasonType"];
    [parm setObject:noJoin?@"1":@"0" forKey:@"isForbid"];
    [self showHUD];
    [self remvokUserId:userid];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"mass/member/remove" Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [[NoticeTools getTopViewController] showToastWithText:@"已移出"];
   
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)remvokUserId:(NSString *)userId{
    for (YYPersonItem *item in self.personArr) {
        for (YYPersonItem *person in item.personArr) {
            if([person.userId isEqualToString:userId]){
                [item.personArr removeObject:person];
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)manageUserId:(NSString *)userId{
    for (YYPersonItem *item in self.personArr) {
        for (YYPersonItem *person in item.personArr) {
            if([person.userId isEqualToString:userId]){
                item.identity = @"1";
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)jubaoyOnhu:(NSString *)userid{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = userid;
    juBaoView.reouceType = @"4";
    [juBaoView showView];
}

- (void)requestPerson{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"mass/member/%@",self.teamModel.teamId] Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            NSMutableArray *syArr = [[NSMutableArray alloc] init];
        
            YYPersonItem *allData = [YYPersonItem mj_objectWithKeyValues:dict[@"data"]];
            [self.personArr removeAllObjects];
            if(allData.administrators.count){
                YYPersonItem *adminItem = [[YYPersonItem alloc] init];
                adminItem.title = @"超级管理员";
                [self.personArr addObject:adminItem];
                [syArr addObject:@"管"];
 
                for (NSDictionary *dic in allData.administrators) {
                    YYPersonItem *personItem = [YYPersonItem mj_objectWithKeyValues:dic];
                    [adminItem.personArr addObject:personItem];
             
                }
            }
   
            for (NSDictionary *dic in allData.members) {
                YYPersonItem *personItem = [YYPersonItem mj_objectWithKeyValues:dic];
            
                [self.personArr addObject:personItem];
                [syArr addObject:personItem.title];
            }

            self.syArr = syArr;
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeHeaderView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.backgroundColor = [UIColor whiteColor];
    headV.contentView.backgroundColor = [UIColor whiteColor];
    headV.mainTitleLabel.frame = CGRectMake(20, 0, 120,30);
    headV.mainTitleLabel.font = FOURTHTEENTEXTFONTSIZE;
    headV.mainTitleLabel.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    YYPersonItem *personItem = self.personArr[section];
    headV.mainTitleLabel.text = personItem.title;
    return headV;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAtPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.canChoiceMore = self.canChoiceMore;
    cell.identity = self.identity;
    cell.listView = YES;
    YYPersonItem *personItem = self.personArr[indexPath.section];
    cell.person = personItem.personArr[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.personArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YYPersonItem *sectionItem = self.personArr[section];
    return sectionItem.personArr.count;
}


- (void)outClick{
    if(self.oldPerson.isAt){
        NoticeGroupJuBaoSwift *outTypeView = [[NoticeGroupJuBaoSwift alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        outTypeView.outBlock = ^(NSInteger type) {
            [weakSelf outPeopleWithNojoin:type==1?NO:YES userId:self.oldPerson.userId];
        };
        [outTypeView showView];
    }
}


@end
