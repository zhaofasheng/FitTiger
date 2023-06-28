//
//  NoticeOrderJubaoCheckController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/20.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeOrderJubaoCheckController.h"
#import "NoticeJuBaoShopChatCell.h"
#import "NoticeShopChatController.h"
#import "NoticeVoiceChatOfJuBaoController.h"
@interface NoticeOrderJubaoCheckController ()
@property (nonatomic, assign) BOOL isDown;// YES 下拉
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeOrderJubaoCheckController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 76;
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-48-50-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeJuBaoShopChatCell class] forCellReuseIdentifier:@"cell"];
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)request{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"admin/shopReportOrder?pageNo=%ld&type=%@&confirmPasswd=%@",self.pageNo,self.hasChuli?@"2":@"1",self.mangagerCode];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
        
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeJuBaoShopChatModel *model = [NoticeJuBaoShopChatModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeJuBaoShopChatModel *model = self.dataArr[indexPath.row];
    if(model.room_id.intValue){
        NoticeVoiceChatOfJuBaoController *ctl = [[NoticeVoiceChatOfJuBaoController alloc] init];
        ctl.jubaoM = self.dataArr[indexPath.row];
        ctl.mangagerCode = self.mangagerCode;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeShopChatController *ctl = [[NoticeShopChatController alloc] init];
        ctl.jubaoM = self.dataArr[indexPath.row];
        ctl.mangagerCode = self.mangagerCode;
        [self.navigationController pushViewController:ctl animated:YES];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeJuBaoShopChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.jubaoModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)createRefesh{
 
    __weak NoticeOrderJubaoCheckController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
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
