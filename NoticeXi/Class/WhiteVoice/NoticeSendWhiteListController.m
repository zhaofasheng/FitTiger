//
//  NoticeSendWhiteListController.m
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendWhiteListController.h"
#import "NoticeNearSearchPersonCell.h"
#import "NoticeOtherUserInfoViewController.h"
#import "NoticeUserInfoCenterController.h"
@interface NoticeSendWhiteListController ()
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) UIView *noDataView;
@end

@implementation NoticeSendWhiteListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"bz.sd"];
    self.pageNo = 1;
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView registerClass:[NoticeNearSearchPersonCell class] forCellReuseIdentifier:@"cell"];
    
    self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height);
    self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy20");
    self.queshenView.titleStr = [NoticeTools getLocalStrWith:@"bz.havnno"];
}


- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"users/%@/famousQuotesCardLogs",[NoticeTools getuserId]];
    }else{
        url = [NSString stringWithFormat:@"users/%@/famousQuotesCardLogs?lastId=%@&pageNo=%ld",[NoticeTools getuserId],self.lastId,self.pageNo];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeSendCardRecord *model = [NoticeSendCardRecord mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] recordId];
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.queshenView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSendCardRecord *model = self.dataArr[indexPath.row];
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = model.fromUserInfo.userId;
    ctl.isOther = YES;
    [self.navigationController pushViewController:ctl animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNearSearchPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.recodM = self.dataArr[indexPath.row];
    return cell;
}

- (void)createRefesh{
    
    __weak NoticeSendWhiteListController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];
}


@end
