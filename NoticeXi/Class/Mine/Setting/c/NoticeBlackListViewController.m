//
//  NoticeBlackListViewController.m=
//  NoticeXi
//
//  Created by li lei on 2018/11/2.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBlackListViewController.h"
#import "NoticeNearSearchPersonCell.h"
#import "NoticeUserInfoCenterController.h"

@interface NoticeBlackListViewController ()<NoticeDeleteFriendDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"black.title1"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.tableView registerClass:[NoticeNearSearchPersonCell class] forCellReuseIdentifier:@"cell1"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 45)];
    self.tableView.tableHeaderView = headerView;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,0, DR_SCREEN_WIDTH-35,45)];
    label.font = TWOTEXTFONTSIZE;
    label.numberOfLines = 0;
    label.text = self.type == 1? [NoticeTools getLocalStrWith:@"black.mark1"]: ([NoticeTools getLocalType]?@"Users in your greylist won’t be able to follow you": @"加入灰名单的用户无法欣赏你，取消后才能欣赏");
    if ([NoticeTools getLocalType] == 2) {
        label.text = @"グレーリストのユーザはフォローできない";
    }
    label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    [headerView addSubview:label];
    headerView.backgroundColor = self.view.backgroundColor;
    

    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.backgroundColor = self.view.backgroundColor;
}

- (void)deleteFriendIn:(NSInteger)index{
    [self showHUD];
    NoticeNearPerson *person = self.dataArr[index];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.type==1? @"0":@"5" forKey:@"blackType"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/blacklist/%@",[[NoticeSaveModel getUserInfo]user_id],person.user_id] Accept:self.type!=1? @"application/vnd.shengxi.v5.1.0+json":nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.dataArr removeObjectAtIndex:index];
            [self.tableView reloadData];
            [self showToastWithText:[NoticeTools getLocalStrWith:@"black.delsus"]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    NoticeNearPerson *model = self.dataArr[indexPath.row];
    ctl.userId = model.user_id;
    ctl.isOther = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNearSearchPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.type = self.type;
    if (self.type == 2) {
        cell.isGrayList = YES;
    }
    cell.index = indexPath.row;
    cell.blackPerson = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeBlackListViewController *ctl = self;
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

- (void)request{
    NSString *url = nil;
    
    if (self.isDown) {
        
        url = [NSString stringWithFormat:@"users/%@/blacklist?blackType=5",[[NoticeSaveModel getUserInfo] user_id]];
        if (self.type == 1) {
            url = [NSString stringWithFormat:@"users/%@/blacklist",[[NoticeSaveModel getUserInfo] user_id]];
        }
        
    }else{
        
        if (self.lastId) {
            url = [NSString stringWithFormat:@"users/%@/blacklist?lastId=%@&blackType=5",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"users/%@/blacklist?blackType=5",[[NoticeSaveModel getUserInfo] user_id]];
        }
        
        if (self.type==1) {
            url = [NSString stringWithFormat:@"users/%@/blacklist?lastId=%@",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                [self showToastWithText:@"后台返回错误"];
                return;
            }
            
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeNearPerson *model = [NoticeNearPerson mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeNearPerson *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.blackId;
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
