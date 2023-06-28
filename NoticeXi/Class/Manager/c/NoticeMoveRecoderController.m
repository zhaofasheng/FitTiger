//
//  NoticeMoveRecoderController.m
//  NoticeXi
//
//  Created by li lei on 2020/9/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeMoveRecoderController.h"
#import "NoticeStayCell.h"
@interface NoticeMoveRecoderController ()
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeMoveRecoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.frame = CGRectMake(0, 1, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeStayCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 70;
    [self createRefesh];
    self.isDown = YES;
    [self requestList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeStayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.moveModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)requestList{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"manage/removeList?confirmPasswd=%@",self.managerCode];
    }else{
       url = [NSString stringWithFormat:@"manage/removeList?confirmPasswd=%@&lastId=%@",self.managerCode,self.lastId];
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
                 NoticeMoveMemberModel *model = [NoticeMoveMemberModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] moveId];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)createRefesh{
    
    __weak NoticeMoveRecoderController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestList];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestList];
    }];
}
@end
