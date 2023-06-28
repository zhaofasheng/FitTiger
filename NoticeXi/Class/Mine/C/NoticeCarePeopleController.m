//
//  NoticeCarePeopleController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCarePeopleController.h"
#import "NoticeCarePeopleCell.h"
#import "NoticeUserInfoCenterController.h"
@interface NoticeCarePeopleController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeCarePeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = self.isOfCared?[NoticeTools getLocalStrWith:@"xs.title1"]:[NoticeTools getLocalStrWith:@"xs.title2"];

    if (self.isLikeEachOther) {
        self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"xs.title3"];
    }
    
    self.pageNo = 1;
    self.dataArr = [NSMutableArray new];
    
    [self.tableView registerClass:[NoticeCarePeopleCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 68;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    if (!self.isOfCared) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 24)];
        button.layer.cornerRadius = 12;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6].CGColor;
        button.layer.borderWidth = 1;
        [button setTitle:[NoticeTools getLocalStrWith:@"xs.clear"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button.titleLabel.font = ELEVENTEXTFONTSIZE;
        [button addTarget:self action:@selector(celanClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
}

- (void)celanClick{
    __weak typeof(self) weakSelf = self;

    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xs.suerqingchu"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"main.sure"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
      
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/clearAdmireDynamic" Accept:@"application/vnd.shengxi.v5.2.0+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    for (NoticeFriendAcdModel *mode in self.dataArr) {
                        mode.is_update = @"0";
                    }
                    [self.tableView reloadData];
                }
                [weakSelf hideHUD];
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)request{
    NSString *type = @"";
    NSString *url = @"";
    if (self.isLikeEachOther) {
        type = @"3";
    }else{
        type = self.isOfCared?@"2":@"1";
    }
    
    if (self.isDown) {
        url = [NSString stringWithFormat:@"users/%@/newAdmires?type=%@&pageNo=1",[NoticeTools getuserId],type];
    }else{
        url = [NSString stringWithFormat:@"users/%@/newAdmires?type=%@&pageNo=%ld",[NoticeTools getuserId],type,self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.titleImageV.image = UIImageNamed(self.isOfCared?@"Image_quesy2": @"Image_quesy1");
                self.queshenView.titleStr =[NoticeTools getLocalStrWith:@"xs.tosats"];
                self.tableView.tableFooterView = self.queshenView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    if (self.clearNotice) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@/2",[[NoticeSaveModel getUserInfo]user_id]] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
            }
        } fail:^(NSError *error) {
        }];
    }
}

- (void)createRefesh{
    
    __weak NoticeCarePeopleController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];

    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCarePeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!self.isOfCared) {
        cell.type = 1;
    }
    cell.isOfCared = self.isOfCared;
    cell.resourceId = self.resourceId;
    cell.isLikeEachOther = self.isLikeEachOther;
    __weak typeof(self) weakSelf = self;
    cell.cancelCareBlock = ^(NoticeFriendAcdModel * _Nonnull careM) {
        [weakSelf deleteCareM:careM];
    };
    cell.careModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)deleteCareM:(NoticeFriendAcdModel *)careM{
    for (NoticeFriendAcdModel *oldM in self.dataArr) {
        if ([oldM.userId isEqualToString:careM.userId]) {
            [self.dataArr removeObject:oldM];
            break;
        }
    }
    [self.tableView reloadData];
    if (self.dataArr.count) {
        self.tableView.tableFooterView = nil;
    }else{
        self.queshenView.titleImageV.image = UIImageNamed(self.isOfCared?@"Image_quesy2": @"Image_quesy1");
        self.queshenView.titleStr =self.isOfCared?[NoticeTools getLocalStrWith:@"xs.tosats"]: [NoticeTools getLocalStrWith:@"xs.tosats"];
        self.tableView.tableFooterView = self.queshenView;
    }
}
@end
