//
//  NoticeUserQuestionController.m
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserQuestionController.h"
#import "NoticeUserQuestionCell.h"
#import "NoticeQuestionDetailController.h"
@interface NoticeUserQuestionController ()
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeUserQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58-BOTTOM_HEIGHT-48);
    [self.tableView registerClass:[NoticeUserQuestionCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 80;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeQuestionDetailController *ctl = [[NoticeQuestionDetailController alloc] init];
    ctl.questionM = self.dataArr[indexPath.row];
    ctl.managerCode = self.managerCode;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeUserQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!(self.type >0)) {
        cell.needMark = YES;
    }
    cell.questionM = self.dataArr[indexPath.row];
    return cell;
}

- (void)createRefesh{
    
    __weak NoticeUserQuestionController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
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
        url = [NSString stringWithFormat:@"admin/feedback?confirmPasswd=%@&type=%ld",self.managerCode,self.type];
    }else{
       url = [NSString stringWithFormat:@"admin/feedback?confirmPasswd=%@&lastId=%@&type=%ld",self.managerCode,self.lastId,self.type];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                 NoticeUserQuestionModel *model = [NoticeUserQuestionModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] questionId];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}
@end
