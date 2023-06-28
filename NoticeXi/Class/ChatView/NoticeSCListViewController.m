//
//  NoticeSCListViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSCListViewController.h"
#import "NoticeStayCell.h"
#import "NoticeNoDataView.h"
#import "NoticeSCViewController.h"
#import "NoticeTestViewController.h"
#import "NoticeReTestViewController.h"

@interface NoticeSCListViewController ()

@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSString *personality_id;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) NoticeStaySys *chatToModel;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UILabel *messageNumL;

@end

@implementation NoticeSCListViewController

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"message.chat"];
    [self.navBarView.rightButton setImage:UIImageNamed(@"img_clearmsg") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
    
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"message.chat"];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.tableView.rowHeight = 70;
    [self.tableView registerClass:[NoticeStayCell class] forCellReuseIdentifier:@"cell1"];
    [self createRefesh];
   
    if (![[NoticeTools getuserId] isEqualToString:@"1"]) {
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatList) name:@"REFRESHCHATLISTNOTICION" object:nil];
    }
    [self refreshChatList];

}

- (void)clearClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定清除所有交流未读消息吗？" english:@"Clear all unreads?" japan:@"未読メッセージをクリアしますか？"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] cancleBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf showHUD];
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"2" forKey:@"type"];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"messages/%@",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v5.4.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [weakSelf hideHUD];
                [weakSelf refreshNoUnread];
            } fail:^(NSError * _Nullable error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESHCHATLISTNOTICION" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

    if (self.chatToModel) {
        [self.tableView reloadData];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"chats/2/%@/0",self.chatToModel.with_user_id] Accept: @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        } fail:^(NSError *error) {
        }];
        self.chatToModel = nil;
    }
}

- (void)refreshNoUnread{
    for (NoticeStaySys *model in self.dataArr) {
        model.un_read_num = @"0";
    }
    [self.tableView reloadData];
}

- (void)refreshChatList{
    self.isDown = YES;
    [self requestList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeStayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.contentView.tag = 2000+indexPath.row;
    cell.canTap = YES;
    cell.isSL = YES;
    cell.stay = self.dataArr[indexPath.row];
    cell.line.hidden = indexPath.row == self.dataArr.count-1?YES:NO;
    __weak typeof(self) weakSelf = self;
    cell.longtapBlock = ^(NoticeStaySys * _Nonnull stay) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:@"0" forKey:@"isVisible"];
                [[DRNetWorking shareInstance]requestWithPatchPath:[NSString stringWithFormat:@"chats/%@",stay.chat_id] Accept:@"application/vnd.shengxi.v3.1+json" parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEBDGEVLAUEPUSHrew" object:nil];
                    for (NoticeStaySys *model in weakSelf.dataArr) {
                        if ([model.chat_id isEqualToString:stay.chat_id]) {
                            [weakSelf.dataArr removeObject:model];
                            break;
                        }
                        
                    }
                    [weakSelf.tableView reloadData];
                } fail:^(NSError *error) {
                }];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.dele"]]];

        [sheet show];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeStaySys *model = self.dataArr[indexPath.row];
    self.chatToModel = model;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeSCViewController *ctl = [[NoticeSCViewController alloc] init];
    ctl.toUserId = model.with_user_id;
    ctl.lelve = model.levelImgName;
    ctl.navigationItem.title = model.with_user_name;
    ctl.toUser = model.with_user_socket_id;
    ctl.identType = model.identity_type;
    [self.navigationController pushViewController:ctl animated:NO];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (void)createRefesh{
    
    __weak NoticeSCListViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestList];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    _refreshHeader = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestList];
    }];
}

- (void)requestList{
    
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"chats/users/%@/2",[[NoticeSaveModel getUserInfo] user_id]];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"chats/users/%@/2?lastId=%@",[[NoticeSaveModel getUserInfo] user_id],self.lastId];
        }else{
            url = [NSString stringWithFormat:@"chats/users/%@/2",[[NoticeSaveModel getUserInfo] user_id]];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeStaySys *model = [NoticeStaySys mj_objectWithKeyValues:dic];
                if (![[NoticeTools getuserId] isEqualToString:@"1"]) {
                    model.topic_type = @"0";
                }
                BOOL alerady = NO;
                for (NoticeStaySys *olM in self.dataArr) {//判断是否有重复数据
                    if ([olM.chat_id isEqualToString:model.chat_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                    [self.dataArr addObject:model];
                }
            }
            if (self.dataArr.count) {
                NoticeStaySys *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.last_dialog_id;
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy4");
                self.queshenView.titleStr =[NoticeTools getLocalType]?@"Friends bring joy in life": @"生活的乐趣，一半儿是来自朋友。";
                self.tableView.tableFooterView = self.queshenView;
            }
            
            if (self.isDown) {
                self.isDown = NO;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)sxClick{
    [NoticeComTools connectXiaoer];
}

@end
