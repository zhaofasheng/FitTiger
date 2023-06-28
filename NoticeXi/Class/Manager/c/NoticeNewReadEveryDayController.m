//
//  NoticeNewReadEveryDayController.m
//  NoticeXi
//
//  Created by li lei on 2021/6/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewReadEveryDayController.h"
#import "NoticeAddReadController.h"
#import "NoticeReadEveryDayCell.h"
@interface NoticeNewReadEveryDayController ()
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeNewReadEveryDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-58-BOTTOM_HEIGHT-48-34-50);
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[NoticeReadEveryDayCell class] forCellReuseIdentifier:@"cell"];
    
    self.dataArr = [[NSMutableArray alloc] init];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-243)/2, CGRectGetMaxY(self.tableView.frame), 243, 50)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    addBtn.layer.cornerRadius = 25;
    addBtn.layer.masksToBounds = YES;
    [addBtn setTitle:@"添加定时任务" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    
    addBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.rowHeight = 118;
}

- (void)createRefesh{
    
    __weak NoticeNewReadEveryDayController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestArticle];
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

- (void)requestArticle{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"article" Accept:@"application/vnd.shengxi.v4.9.20+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.dataArr removeAllObjects];
            if ([NoticeBannerModel mj_objectWithKeyValues:dict[@"data"]]) {
                [self.dataArr addObject:[NoticeBannerModel mj_objectWithKeyValues:dict[@"data"]]];
            }
            
            [self request];
        }
    } fail:^(NSError * _Nullable error) {
        [self request];
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"admin/article?confirmPasswd=%@",self.mangagerCode];
    }else{
        url = [NSString stringWithFormat:@"admin/article?confirmPasswd=%@&lastId=%@",self.mangagerCode,self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeBannerModel *banM = [NoticeBannerModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:banM];
            }
            if (self.dataArr.count) {
                NoticeBannerModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.bannerId;
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAddReadController *ctl = [[NoticeAddReadController alloc] init];
    ctl.mangagerCode = self.mangagerCode;
    ctl.bannerM = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeReadEveryDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.index = indexPath.row;
    cell.bannerM = self.dataArr[indexPath.row];
    return cell;
}

- (void)addClick{
    NoticeAddReadController *ctl = [[NoticeAddReadController alloc] init];
    ctl.mangagerCode = self.mangagerCode;
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
