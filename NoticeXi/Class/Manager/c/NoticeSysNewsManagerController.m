//
//  NoticeSysNewsManagerController.m
//  NoticeXi
//
//  Created by li lei on 2021/5/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSysNewsManagerController.h"
#import "NoticeSendSysMessageManagerController.h"
#import "NoticeSysCell.h"
#import "NoticeManagerSendController.h"
@interface NoticeSysNewsManagerController ()
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@end

@implementation NoticeSysNewsManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@""];
    
    self.navigationItem.title = self.isDs?@"定时消息": [NoticeTools getLocalStrWith:@"push.ce9"];
    
    self.pageNo = 1;
    
    UIButton *btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn11.frame = CGRectMake(DR_SCREEN_WIDTH-50-5, STATUS_BAR_HEIGHT, 50, 50);
    [btn11 setImage:UIImageNamed(@"Image_addtozj") forState:UIControlStateNormal];
    [btn11 addTarget:self action:@selector(newsClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn11];
    self.dataArr = [NSMutableArray new];
    [self.tableView registerClass:[NoticeSysCell class] forCellReuseIdentifier:@"cell1"];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)newsClick{
    NoticeSendSysMessageManagerController *ctl = [[NoticeSendSysMessageManagerController alloc] init];
    ctl.managerCode = self.managerCode;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMessage *model = self.dataArr[indexPath.row];
    return 44*2+20+45+model.contentHeight+15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(NoticeMessage * _Nonnull msgM) {
        [weakSelf deleteMsg:msgM];
    };
    cell.editBlock = ^(NoticeMessage * _Nonnull msgM) {
        [weakSelf editMsg:msgM];
    };
    cell.isManager = YES;
    cell.message = self.dataArr[indexPath.row];
    return cell;
}

- (void)editMsg:(NoticeMessage *)msgM{
    if (!msgM.category_id.intValue) {
        [self showToastWithText:@"老版本发的系统消息不支持编辑"];
        return;
    }
    NoticeManagerSendController *ctl = [[NoticeManagerSendController alloc] init];
    ctl.type = msgM.category_id.intValue;
    ctl.managerCode = self.managerCode;
    ctl.messageM = msgM;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)deleteMsg:(NoticeMessage *)msgM{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"py.issueredel"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf showHUD];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:weakSelf.managerCode forKey:@"confirmPasswd"];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/sysmsgs/%@",msgM.msgId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    for (NoticeMessage *oldM in weakSelf.dataArr) {
                        if ([oldM.msgId isEqualToString:msgM.msgId]) {
                            [weakSelf.dataArr removeObject:oldM];
                            [weakSelf.tableView reloadData];
                            break;
                        }
                    }
                }
                [weakSelf hideHUD];
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];

        }
    };
    [alerView showXLAlertView];
}

- (void)createRefesh{
    
    __weak NoticeSysNewsManagerController *ctl = self;
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

- (void)request{
    NSString *url = nil;
    
    if (self.isDown) {
        url = [NSString stringWithFormat:@"messages/%@/1",[[NoticeSaveModel getUserInfo]user_id]];
        if (self.isDs) {
            url = [NSString stringWithFormat:@"admin/waitSendSmg?pageNo=1&confirmPasswd=%@",self.managerCode];
        }
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"messages/%@/1?lastId=%@",[[NoticeSaveModel getUserInfo]user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"messages/%@/1",[[NoticeSaveModel getUserInfo]user_id]];
        }
        if (self.isDs) {
            url = [NSString stringWithFormat:@"admin/waitSendSmg?pageNo=%ld&confirmPasswd=%@",self.pageNo,self.managerCode];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isDs?nil: @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
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
                NoticeMessage *model = [NoticeMessage mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeMessage *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.msgId;
                self.tableView.tableFooterView = nil;
            }
            
            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
    }];
}

@end
