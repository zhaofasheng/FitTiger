//
//  NoticeHasServeredController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeHasServeredController.h"
#import "NoticeOrderListBaseController.h"
#import "NoticeOrderComDetailController.h"
#import "NoticeShopOrderMsgCell.h"
@interface NoticeHasServeredController ()
@property (nonatomic, strong) UILabel *finishL;
@property (nonatomic, strong) UILabel *expreL;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, assign) BOOL isDown;// YES 下拉
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeHasServeredController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = @"服务过的";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 122)];
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-30, 110)];
    backV.layer.cornerRadius = 10;
    backV.layer.masksToBounds = YES;
    backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [headerView addSubview:backV];
    self.tableView.tableHeaderView = headerView;
    
    for (int i = 0; i < 2; i++) {
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(backV.frame.size.width/2*i, 0, backV.frame.size.width/2, 110)];
        tapView.userInteractionEnabled = YES;
        tapView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTap:)];
        [backV addSubview:tapView];
        [tapView addGestureRecognizer:tap];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, backV.frame.size.width/2, 26)];
        numL.textAlignment = NSTextAlignmentCenter;
        numL.font = XGTwentyTwoBoldFontSize;
        numL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [tapView addSubview:numL];
        numL.text = @"0";
        
        UILabel *numL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, backV.frame.size.width/2, 20)];
        numL1.textAlignment = NSTextAlignmentCenter;
        numL1.font = FOURTHTEENTEXTFONTSIZE;
        numL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [tapView addSubview:numL1];
        
        if(i == 0){
            self.finishL = numL;
            numL1.text = @"已完成";
        }else{
            self.expreL = numL;
            numL1.text = @"已失效";
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/getOrderNum" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            NoticeByOfOrderModel *orderNumM = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
            self.finishL.text = [NSString stringWithFormat:@"%d",orderNumM.completeNum.intValue];
            self.expreL.text = [NSString stringWithFormat:@"%d",orderNumM.failNum.intValue];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    self.dataArr = [[NSMutableArray alloc] init];
    [self.tableView registerClass:[NoticeShopOrderMsgCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 106;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}


- (void)request{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"shopGoodsOrder/getShopComment/%@?type=2&pageNo=%ld",[NoticeTools getuserId],self.pageNo];
    
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
                NoticeShopCommentModel *model = [NoticeShopCommentModel mj_objectWithKeyValues:dic];

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
 
    __weak NoticeHasServeredController *ctl = self;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopCommentModel *model = self.dataArr[indexPath.row];
    NoticeOrderComDetailController *ctl = [[NoticeOrderComDetailController alloc] init];
    ctl.orderId = model.order_id;
    ctl.goodsUrl = model.goods_img_url;
    ctl.isVoice = model.room_id.intValue?YES:NO;
    ctl.orderName = model.goods_name;
    ctl.time = model.order_created_at;
    ctl.second = model.second;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopOrderMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (UIView *)sectionView{
    if(!_sectionView){
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        _sectionView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
        label.text = @"订单消息";
        label.font = XGSIXBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_sectionView addSubview:label];
    }
    return _sectionView;
}

- (void)orderTap:(UITapGestureRecognizer *)tap{
    UIView *tapView = (UIView *)tap.view;
    NoticeOrderListBaseController *ctl = [[NoticeOrderListBaseController alloc] init];
    ctl.isExpre = tapView.tag == 0?NO:YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
