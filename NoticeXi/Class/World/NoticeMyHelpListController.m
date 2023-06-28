//
//  NoticeMyHelpListController.m
//  NoticeXi
//
//  Created by li lei on 2022/11/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyHelpListController.h"
#import "NoticreSendHelpController.h"
#import "NoticeHelpListCell.h"
#import "NoticreSendHelpController.h"
#import "NoticeHelpDetailController.h"
@interface NoticeMyHelpListController ()
@property (nonatomic, assign) BOOL isDown;// YES下拉
@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation NoticeMyHelpListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navBarView.rightButton setImage:UIImageNamed(@"sendhelpImg") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(sendHelpClick) forControlEvents:UIControlEventTouchUpInside];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.titleL.text = [NoticeTools chinese:@"我的求助帖" english:@"My Posts" japan:@"投稿"];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeHelpListCell class] forCellReuseIdentifier:@"cell"];
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.backgroundColor = self.view.backgroundColor;
}

- (void)sendHelpClick{
    __weak typeof(self) weakSelf = self;
    NoticreSendHelpController *ctl = [[NoticreSendHelpController alloc] init];
    ctl.upSuccess = ^(BOOL success) {
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)requestTop{
    if (self.isDown) {
        self.isDown = NO;
        [self.dataArr removeAllObjects];
    }
    [self request];
}

- (void)request{
    
    NSString *url = @"";

    url = [NSString stringWithFormat:@"myInvitation?pageNo=%ld",self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
           
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeHelpListModel *model = [NoticeHelpListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (!self.dataArr.count) {
                self.tableView.tableHeaderView = self.defaultL;
                self.defaultL.text = [NoticeTools chinese:@"欸 还没尝试过匿名求助吧" english:@"No posts made by you yet" japan:@"あなたからの投稿はまだありません"];
            }else{
                self.tableView.tableHeaderView = nil;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
 
    __weak NoticeMyHelpListController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
        [ctl requestTop];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHelpListModel *model = self.dataArr[indexPath.row];
    return (model.isMoreFiveLines?model.fiveTextHeight: model.textHeight)+15+48+40 + (model.isHot?30:0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHelpListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.dataArr.count > indexPath.row) {
        cell.helpModel = self.dataArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeHelpDetailController *ctl = [[NoticeHelpDetailController alloc] init];
    ctl.helpModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    ctl.deleteSuccess = ^(NSString * _Nonnull tieId) {
        for (NoticeHelpListModel *model in weakSelf.dataArr) {
            if ([model.tieId isEqualToString:tieId]) {
                [weakSelf.dataArr removeObject:model];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
