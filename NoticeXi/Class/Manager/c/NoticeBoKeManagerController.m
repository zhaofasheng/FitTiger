//
//  NoticeBoKeManagerController.m
//  NoticeXi
//
//  Created by li lei on 2022/9/29.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeManagerController.h"
#import "NoticeShopChuliCell.h"
#import "NoticeSendBoKeController.h"
@interface NoticeBoKeManagerController ()
@property (nonatomic, assign) BOOL isDown;// YES 下拉
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeBoKeManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44-40);
    self.tableView.rowHeight = 76;
    self.dataArr = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[NoticeShopChuliCell class] forCellReuseIdentifier:@"cell"];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSendBoKeController *ctl = [[NoticeSendBoKeController alloc] init];
    ctl.bokeModel = self.dataArr[indexPath.row];
    ctl.isCheck = YES;
    ctl.managerCode = self.managerCode;
    __weak typeof(self) weakSelf = self;
    ctl.refreshDataBlock = ^(BOOL refresh) {
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeShopChuliCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.type >= 2) {
        cell.userM = self.dataArr[indexPath.row];
    }else{
        cell.boKeModel = self.dataArr[indexPath.row];
    }
    __weak typeof(self) weakSelf = self;
    cell.outWhiteBlock = ^(NoticeAbout * _Nonnull userM) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:self.type==3?@"确定移出黑名单吗？" : @"确定移出白名单吗？" message:nil sureBtn:@"确定" cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"admin/podcast/role/%@/0?confirmPasswd=%@",userM.userId,weakSelf.managerCode] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        [weakSelf.dataArr removeObject:userM];
                        [weakSelf.tableView reloadData];
                    }
                } fail:^(NSError *error) {
                    [weakSelf hideHUD];
                }];
            }
        };
        [alerView showXLAlertView];
    };
    if (self.type==3) {
        [cell.noBtn setTitle:@"移出黑名单" forState:UIControlStateNormal];
    }
    cell.managerCode = self.managerCode;
    return cell;
}

- (void)createRefesh{
    
    __weak NoticeBoKeManagerController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"admin/podcast/%@?confirmPasswd=%@",self.type==1?@"2":@"1",self.managerCode];
    }else{
        url = [NSString stringWithFormat:@"admin/podcast/%@?confirmPasswd=%@&pageNo=%ld",self.type==1?@"2":@"1",self.managerCode,self.pageNo];
    }
    if (self.type == 2 || self.type == 3) {
        if (self.isDown) {
            url = [NSString stringWithFormat:@"admin/podcast/role/list?confirmPasswd=%@&status=%@",self.managerCode,self.type==2?@"1":@"2"];
        }else{
            url = [NSString stringWithFormat:@"admin/podcast/role/list?confirmPasswd=%@&pageNo=%ld&status=%@",self.managerCode,self.pageNo,self.type==2?@"1":@"2"];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                if (self.type>=2) {
                    NoticeAbout *userM = [NoticeAbout mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:userM];
                }else{
                    NoticeDanMuModel *banM = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:banM];
                }
            
            }
  
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
