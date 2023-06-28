//
//  NoticeHotSongController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHotSongController.h"
#import "NoticeAllHotCell.h"
#import "NoticeSongDetailController.h"
@interface NoticeHotSongController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger page;
@end

@implementation NoticeHotSongController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"music.hot"];
    self.dataArr = [NSMutableArray new];
    [self.tableView registerClass:[NoticeAllHotCell class] forCellReuseIdentifier:@"hotCell"];
    
    self.tableView.rowHeight = 84+15;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.needBackGroundView = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSongDetailController *ctl = [[NoticeSongDetailController alloc] init];
    ctl.song = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeAllHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
    cell.song = self.dataArr[indexPath.row];
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
    
    __weak NoticeHotSongController *ctl = self;
    
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
        url = @"resources/3?sortType=2&recentDay=30";
    }else{
        url = [NSString stringWithFormat:@"resources/3?sortType=2&pageNo=%ld&recentDay=30",(long)self.page];
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
                NoticeSong *model = [NoticeSong mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeSong *song = self.dataArr[self.dataArr.count-1];
                self.lastId = song.albumId;
            }
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
