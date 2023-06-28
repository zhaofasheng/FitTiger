//
//  NoticeSongLikesController.m
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeSongLikesController.h"
#import "NoticeSonglikeCell.h"
#import "NoticeUserInfoCenterController.h"
@interface NoticeSongLikesController ()
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@end

@implementation NoticeSongLikesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = [NSString stringWithFormat:@"%@%@",self.musicModel.song_tile,[NoticeTools chinese:@"的喜好" english:@"likes" japan:@"気に入った"]];
    self.view.backgroundColor = [UIColor whiteColor];
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
    url = [NSString stringWithFormat:@"music/getLikePeople/%@?pageNo=%ld",self.musicModel.likeId,self.pageNo];
    
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
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    
    __weak NoticeSongLikesController *ctl = self;
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
