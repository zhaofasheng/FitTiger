//
//  NoticeDrawLikeListController.m
//  NoticeXi
//
//  Created by li lei on 2019/7/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawLikeListController.h"
#import "DrawLikeCell.h"
#import "UIImage+Color.h"
#import "NoticeUserInfoCenterController.h"
@interface NoticeDrawLikeListController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeDrawLikeListController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"喜欢";
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.dataArr = [NSMutableArray new];
    self.tableView.frame = CGRectMake(0, 1, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView registerClass:[DrawLikeCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 22, 44);
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"btn_nav_white"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line];
}

- (void)backToPageAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DrawLikeModel *model = self.dataArr[indexPath.row];
    if ([model.like_type isEqualToString:@"1"]) {
        return;
    }
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = model.from_user_id;
    ctl.isOther = YES;
     [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DrawLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.likeModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"users/%@/artworkLike/%@",[[NoticeSaveModel getUserInfo] user_id],self.artId];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"users/%@/artworkLike/%@?lastId=%@",[[NoticeSaveModel getUserInfo] user_id],self.artId,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"users/%@/artworkLike/%@",[[NoticeSaveModel getUserInfo] user_id],self.artId];
        }
        
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v3.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                DrawLikeModel *model = [DrawLikeModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                DrawLikeModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.likeId;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    __weak NoticeDrawLikeListController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
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
@end
