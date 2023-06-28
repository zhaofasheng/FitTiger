//
//  NoticeGroupRqueestController.m
//  NoticeXi
//
//  Created by li lei on 2020/9/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeGroupRqueestController.h"
#import "NoticeStayCell.h"
#import "NoticeCheckGroupReplyController.h"
@interface NoticeGroupRqueestController ()
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeGroupRqueestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.frame = CGRectMake(0, 1, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeStayCell class] forCellReuseIdentifier:@"cell1"];
    self.tableView.rowHeight = 70;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}
- (void)createRefesh{

    __weak NoticeGroupRqueestController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"manage/requestList?confirmPasswd=%@",self.managerCode];
    }else{
        url = [NSString stringWithFormat:@"manage/requestList?confirmPasswd=%@&lastId=%@",self.managerCode,self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeManagerGroupReplyModel *model = [NoticeManagerGroupReplyModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeManagerGroupReplyModel  *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.replyId;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCheckGroupReplyController *ctl = [[NoticeCheckGroupReplyController alloc] init];
    ctl.replyModel = self.dataArr[indexPath.row];
    ctl.managerCode = self.managerCode;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeStayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.groupModel = self.dataArr[indexPath.row];
    return cell;
}
@end
