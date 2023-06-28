//
//  NoticeRecoderStoryController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeRecoderStoryController.h"
#import "NoticeDuiHuanRecoderCell.h"
@interface NoticeRecoderStoryController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeRecoderStoryController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.rowHeight = 90;
    [self.tableView registerClass:[NoticeDuiHuanRecoderCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.pageNo = 1;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"zb.duihjilu"];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    self.navBarView.hidden = NO;
    self.needHideNavBar = YES;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
}


- (void)request{

    NSString *url = @"";

    if (self.isDown) {
        url = @"exchangeCode/getRecords?pageNo=1";
    }else{
        url = [NSString stringWithFormat:@"exchangeCode/getRecords?pageNo=%ld",self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
                NoticeDuiHRecoderModel *model = [NoticeDuiHRecoderModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height);
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy21");
                self.queshenView.titleStr = [NoticeTools getLocalType]?[NoticeTools getLocalStrWith:@"no.payreco"]:@"还没有兑换记录哦~";
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
    
    __weak NoticeRecoderStoryController *ctl = self;
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
    NoticeDuiHuanRecoderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.dModel = self.dataArr[indexPath.row];
    return cell;
}
@end
