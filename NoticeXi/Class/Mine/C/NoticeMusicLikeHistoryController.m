//
//  NoticeMusicLikeHistoryController.m
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeMusicLikeHistoryController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeSonglikeCell.h"
@interface NoticeMusicLikeHistoryController ()
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@end

@implementation NoticeMusicLikeHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navBarView.titleL.text = [NoticeTools chinese:@"喜欢历史" english:@"History" japan:@"気に入った歴史"];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeSonglikeCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSonglikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isHistory = YES;
    cell.likeModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    NoticeMusicLikeModel *model = self.dataArr[indexPath.row];
    ctl.isOther = YES;
    ctl.userId = model.likeId;
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)requestMusiceLike{
    NSString *url = @"";
    url = [NSString stringWithFormat:@"music/getLikePeople/%@?pageNo=%ld",@"0",self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMusicLikeModel *model = [NoticeMusicLikeModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
                self.defaultL.text = @"啊呀 没有歌曲点不了喜欢啊";
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    
    __weak NoticeMusicLikeHistoryController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestMusiceLike];
        
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl requestMusiceLike];
    }];
}

@end
