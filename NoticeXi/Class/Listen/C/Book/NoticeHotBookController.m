//
//  NoticeHotBookController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHotBookController.h"
#import "NoticeAllHotCell.h"
#import "NoticeBookDetailController.h"
@interface NoticeHotBookController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger page;
@end

@implementation NoticeHotBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"book.hot"];
    self.dataArr = [NSMutableArray new];
    [self.tableView registerClass:[NoticeAllHotCell class] forCellReuseIdentifier:@"hotCell"];
    self.tableView.rowHeight = 125;
    self.page = 1;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.needBackGroundView = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBookDetailController *ctl = [[NoticeBookDetailController alloc] init];
    ctl.book = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAllHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    cell.book = self.dataArr[indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeHotBookController *ctl = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        self.page = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        ctl.isDown = NO;
        [ctl request];
    }];
}
- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = @"resources/2?sortType=2&recentDay=30";
    }else{
        url = [NSString stringWithFormat:@"resources/2?sortType=2&pageNo=%ld&recentDay=30",self.page];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (![dict[@"data"] count]) {
                return ;
            }
            
            if (self.isDown) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeBook *model = [NoticeBook mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
