//
//  NoticeUserBBSManagerController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserBBSManagerController.h"
#import "NoticeManagerBBSCell.h"
#import "NoticeUseOrDeleteBBSController.h"

@interface NoticeUserBBSManagerController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeUserBBSManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    [self.line removeFromSuperview];
    
    [self.tableView registerClass:[NoticeManagerBBSCell class] forCellReuseIdentifier:@"bbsCell"];
    self.tableView.rowHeight = 40;
    
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createRefesh{
    
    
    


    
    __weak NoticeUserBBSManagerController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestList];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl requestList];
    }];
}

- (void)requestList{
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"admin/contributions?confirmPasswd=%@",self.mangagerCode];
    }else{
        url = [NSString stringWithFormat:@"admin/contributions?confirmPasswd=%@&lastId=%@&pageNo=%ld",self.mangagerCode,self.lastId,self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
                self.pageNo = 1;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeContributionModel *model = [NoticeContributionModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeContributionModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.tougaoId;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeManagerBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bbsCell"];
    cell.contriM = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeUseOrDeleteBBSController *ctl = [[NoticeUseOrDeleteBBSController alloc] init];
    NoticeBBSModel *bbsModel = [[NoticeBBSModel alloc] init];
    
    NoticeContributionModel *model = self.dataArr[indexPath.row];
    bbsModel.draft_from = model.draft_from;
    bbsModel.title =model.contribution_title;
    bbsModel.textContent = model.contribution_content;
    bbsModel.userInfo = model.userInfo;
    bbsModel.annexsArr = model.annexsArr;
    bbsModel.contribution_id = model.tougaoId;
    ctl.bbsModel = bbsModel;
    ctl.mangagerCode = self.mangagerCode;
    __weak typeof(self) weakSelf = self;
    ctl.managerTypeBlock = ^(NSInteger type, NSString * _Nonnull postId) {
        if (type == 2) {
            model.contribution_status = @"2";
        }else{
            model.post_id = postId;
            
        }
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}
@end
