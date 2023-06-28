//
//  NoticeBeforeBBSController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBeforeBBSController.h"
#import "NoticeBeforeBBSCell.h"
#import "NoticeBBSDetailController.h"
#import "NoticeSendBBSController.h"
@interface NoticeBeforeBBSController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSString *lastSort;
@end

@implementation NoticeBeforeBBSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"往期";
    self.tableView.rowHeight = 128;
    [self.tableView registerClass:[NoticeBeforeBBSCell class] forCellReuseIdentifier:@"bbsCell"];
    
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];

}

- (void)sendClick{
    NoticeSendBBSController *ctl = [[NoticeSendBBSController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)createRefesh{
    
    __weak NoticeBeforeBBSController *ctl = self;

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
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl requestList];
    }];
}

- (void)requestList{
    NSString *url = @"";
    if (self.isDown) {
        url = @"posts?&lastSort=999";
    }else{
        url = [NSString stringWithFormat:@"posts?lastId=%@&pageNo=%ld&lastSort=%@",self.lastId,self.pageNo,self.lastSort];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
                self.pageNo = 1;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeBBSModel *model = [NoticeBBSModel mj_objectWithKeyValues:dic];
                model.post_id = model.cagaoId;
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeBBSModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.post_id;
                self.lastSort = lastM.post_sort;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBeforeBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bbsCell"];
    cell.bbsModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSModel *bbsModel = self.dataArr[indexPath.row];
    NoticeBBSDetailController *ctl = [[NoticeBBSDetailController alloc] init];
    ctl.bbsModel = bbsModel;
    [self.navigationController pushViewController:ctl animated:YES];
}
@end
