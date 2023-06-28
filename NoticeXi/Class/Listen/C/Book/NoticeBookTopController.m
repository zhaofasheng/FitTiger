//
//  NoticeBookTopController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBookTopController.h"
#import "NoticeMovieTopCell.h"
#import "NoticeBookDetailController.h"
@interface NoticeBookTopController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger page;
@end

@implementation NoticeBookTopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"book.bd"]:@"圖書榜";
    self.dataArr = [NSMutableArray new];
    [self.tableView registerClass:[NoticeMovieTopCell class] forCellReuseIdentifier:@"hotCell"];
    self.tableView.rowHeight = 170;
    [self createRefesh];
    self.page = 1;
    [self.tableView.mj_header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBookDetailController *ctl = [[NoticeBookDetailController alloc] init];
    ctl.book = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMovieTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    cell.book = self.dataArr[indexPath.row];
    if (indexPath.row == self.dataArr.count-1) {
        cell.line.hidden = YES;
    }else{
        cell.line.hidden = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeBookTopController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.page = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ctl.page ++;
        ctl.isDown = NO;
        [ctl request];
    }];
}
- (void)request{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"leaderboard/resources/2?pageNo=%ld",(long)self.page] Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
