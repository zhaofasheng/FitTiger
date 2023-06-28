//
//  NoticeTeamWorkShowController.m
//  NoticeXi
//
//  Created by li lei on 2023/6/27.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamWorkShowController.h"
#import "NoticeManageTeamMemberCell.h"
@interface NoticeTeamWorkShowController ()
@property (nonatomic, assign) BOOL isDown;// YES 下拉
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeTeamWorkShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-48-50-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeManageTeamMemberCell class] forCellReuseIdentifier:@"cell"];
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)request{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"%@%ld&confirmPasswd=%@",self.isOut?@"admin/massMember/removeRecord?pageNo=":@"admin/massManager/removeManagerRecord?pageNo=",self.pageNo,self.mangagerCode];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
                NoticeTeamManageMemberModel *model = [NoticeTeamManageMemberModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isOut){
        return 116;
    }
    NoticeTeamManageMemberModel *model = self.dataArr[indexPath.row];
    return model.reasonHeight+43+32;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeManageTeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isOut = self.isOut;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)createRefesh{
 
    __weak NoticeTeamWorkShowController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
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
@end
