//
//  NoticeReadBookController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/14.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeReadBookController.h"
#import "NoticeListenCell.h"
#import "NoticeWebViewController.h"
@interface NoticeReadBookController ()
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;
@end

@implementation NoticeReadBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"message.artcle"];
    [self.tableView registerClass:[NoticeListenCell class] forCellReuseIdentifier:@"cell1"];
    
    self.isDown = YES;
    self.pageNo = 1;
    self.tableView.rowHeight = 190+30;
    self.dataArr = [NSMutableArray new];
    [self request];
    [self createRefesh];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@/6",[[NoticeSaveModel getUserInfo]user_id]] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
        }
    } fail:^(NSError *error) {
    }];
}

- (void)createRefesh{
    
    __weak NoticeReadBookController *ctl = self;
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
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"h5/type?htmlType=4&pageNo=%ld",self.pageNo] Accept:@"application/vnd.shengxi.v5.3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeWeb *model = [NoticeWeb mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > self.dataArr.count-1) {
        return;
    }
    NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
    ctl.isFromListen = YES;
 
    NoticeWeb *web = self.dataArr[indexPath.row];
    web.is_new = @"0";
    [self.tableView reloadData];
    ctl.web = web;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeWeb *web = self.dataArr[indexPath.row];
    if (web.newbanner_url.length > 10) {
        return 190+15;
    }
    return 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeListenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.web = self.dataArr[indexPath.row];
    cell.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    return cell;
}

@end
