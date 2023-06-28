//
//  NoticePayRecodController.m
//  NoticeXi
//
//  Created by li lei on 2021/12/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePayRecodController.h"
#import "NoticePayRecodCell.h"
@interface NoticePayRecodController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticePayRecodController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0,0,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-48);
    [self.tableView registerClass:[NoticePayRecodCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 114+15;
    self.pageNo = 1;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
}


- (void)request{

    NSString *url = @"";

    if (self.isDown) {
        url = [NSString stringWithFormat:@"recharge?pageNo=1&type=%@",!self.isSend?@"1":@"2"];
    }else{
        url = [NSString stringWithFormat:@"recharge?pageNo=%ld&type=%@",self.pageNo,!self.isSend?@"1":@"2"];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.3.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
                NoticePayReodModel *model = [NoticePayReodModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height);
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy21");
                self.queshenView.titleStr = [NoticeTools getLocalStrWith:@"no.payreco"];
                self.tableView.tableFooterView = self.queshenView;
            }
            [self.tableView reloadData];
        
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}

- (void)createRefesh{
    
    __weak NoticePayRecodController *ctl = self;
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
    NoticePayRecodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isSend = self.isSend;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
@end
