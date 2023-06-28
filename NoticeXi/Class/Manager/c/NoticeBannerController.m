//
//  NoticeBannerController.m
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBannerController.h"
#import "NoticeBannerCell.h"
#import "NoticeSetBanneerView.h"
@interface NoticeBannerController ()
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeBannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.frame = CGRectMake(0, 1, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-60-BOTTOM_HEIGHT-BOTTOM_HEIGHT-60);
    [self.tableView registerClass:[NoticeBannerCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 110+DR_SCREEN_WIDTH+10;
    self.pageNo = 1;
    [self createRefesh];
    self.isDown = YES;
    [self requestList];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.tableView.frame), DR_SCREEN_WIDTH-30, 45)];
    addBtn.backgroundColor = GetColorWithName(VMainThumeColor);
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.masksToBounds = YES;
    [addBtn setTitle:@"添加定时任务" forState:UIControlStateNormal];
    [addBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    addBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
}

- (void)clickAdd{
    NoticeSetBanneerView *bannerView = [[NoticeSetBanneerView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    bannerView.managerCode = self.managerCode;
    __weak typeof(self) weakSelf = self;
    bannerView.refreshBlock = ^(BOOL refresh) {
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.view addSubview:bannerView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.managerCode = self.managerCode;
    __weak typeof(self) weakSelf = self;
    cell.refreshBlock = ^(BOOL refresh) {
        [weakSelf.tableView.mj_header beginRefreshing];
        [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
    };
    cell.changeBlock = ^(NSString * _Nonnull bannerId) {
        NoticeSetBanneerView *bannerView = [[NoticeSetBanneerView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        bannerView.managerCode = weakSelf.managerCode;
        bannerView.bannerId = bannerId;
        bannerView.refreshBlock = ^(BOOL refresh) {
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [weakSelf.view addSubview:bannerView];
    };
    cell.bannerM = self.dataArr[indexPath.row];
    return cell;
}

- (void)requestList{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"admin/banners?confirmPasswd=%@",self.managerCode];
    }else{
        url = [NSString stringWithFormat:@"admin/banners?confirmPasswd=%@&lastId=%@&pageNo=%ld",self.managerCode,self.lastId,self.pageNo];
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
                 NoticeBannerModel *model = [NoticeBannerModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] bannerId];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)createRefesh{
    
    __weak NoticeBannerController *ctl = self;

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
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl requestList];
    }];
}
@end
