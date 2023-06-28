//
//  NoticeOrderListController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeOrderListController.h"
#import "NoticeOrderListCell.h"
#import "NoticeOrderDetailController.h"
@interface NoticeOrderListController ()
@property (nonatomic, assign) BOOL isDown;// YES 下拉
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    [self.tableView registerClass:[NoticeOrderListCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.rowHeight = 164;
    
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isUser = self.userType.intValue == 2?YES:NO;
    cell.orderM = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeOrderDetailController *ctl = [[NoticeOrderDetailController alloc] init];
    ctl.orderM = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)request{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"shopGoodsOrder/order/%@/%@?pageNo=%ld",self.userType,self.type,self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
                NoticeOrderListModel *model = [NoticeOrderListModel mj_objectWithKeyValues:dic];
                if (!self.isFinished && self.userType.intValue == 1) {//卖家失效订单
                    model.isNoFinish = YES;
                }
        
                if(model.order_type.intValue == 8 && model.is_fault.intValue == 2){//被举报后卖家过错，交易失败
                    model.isNoFinish = YES;
                }
                
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
                self.defaultL.text = @"欸 这里空空的";
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
 
    __weak NoticeOrderListController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
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


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}


@end
