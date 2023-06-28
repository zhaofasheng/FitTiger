//
//  NoticeTeamsController.m
//  NoticeXi
//
//  Created by li lei on 2023/5/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamsController.h"
#import "NoticeGroupListCell.h"
#import "NoticeTeamChatController.h"

@interface NoticeTeamsController ()<UITableViewDelegate,UITableViewDataSource,NoticeReceveMessageSendMessageDelegate>
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) BOOL isInCurrentView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *identity;
@end

@implementation NoticeTeamsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    UIImageView *backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT)];
    backImageV.image = UIImageNamed(@"groupBackiMG");
    [self.view addSubview:backImageV];
    
    self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*212/375)];
    self.titleImageView.image = UIImageNamed(@"grouptitleimg");

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 108+15;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    [_tableView registerClass:[NoticeGroupListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    self.tableView.tableHeaderView = self.titleImageView;

    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.listDelegate = self;
}

- (void)didReceiveListGroupChat:(NoticeOneToOne *)message{
    
    if(!self.isInCurrentView){
        return;
    }
    
    NoticeTeamChatModel *chat = [NoticeTeamChatModel mj_objectWithKeyValues:message.data];

    if ([message.action isEqualToString:@"revoke"] || [message.action isEqualToString:@"delete"]) {//撤回消息
        return;
    }
    
    if ([message.action isEqualToString:@"managerRemove"]) {//管理员身份被取消
        if([chat.to_user_id isEqualToString:[NoticeTools getuserId]]){
            self.identity = @"1";
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"你的管理员身份已被取消" message:nil cancleBtn:@"知道了"];
            [alerView showXLAlertView];
        }
        return;
    }
    
    if([message.action isEqualToString:@"memberRemove"] || [message.action isEqualToString:@"memberQuit"]){//移出社团成员
      
        if([chat.to_user_id isEqualToString:[NoticeTools getuserId]]){//被移出的人是自己
            for (NoticeGroupListModel *groupM in self.dataArr) {
                if([groupM.teamId isEqualToString:chat.mass_id]){
                    groupM.is_join = @"0";
                    [self.tableView reloadData];
                }
            }
        }
    }
    
    if(chat.call_id.intValue){
        for (NoticeGroupListModel *team in self.dataArr) {
            if([team.teamId isEqualToString:chat.mass_id]){
                if(!team.call_id.intValue){//如果存在未查看的，不再重新赋值
                    team.call_id = chat.call_id;
                }
                [self.tableView reloadData];
                break;
            }
        }
    }

    if(chat.contentType){
        for (int i = 0; i < self.dataArr.count; i++) {
            NoticeGroupListModel *team = self.dataArr[i];
            if([team.teamId isEqualToString:chat.mass_id]){
                team.unread_num = chat.unread_num;
                team.lastMsgModel = chat;
                if(i != 0){
                    [self.dataArr exchangeObjectAtIndex:0 withObjectAtIndex:i];
                }
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    [self request];
    self.isInCurrentView = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isInCurrentView = NO;
}

- (void)request{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"mass" Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
  
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            [self.dataArr removeAllObjects];
            
            NoticeGroupListModel *arrModel = [NoticeGroupListModel mj_objectWithKeyValues:dict[@"data"]];
            self.identity = arrModel.identity;
            for (NSDictionary *joinDic in arrModel.joins) {
                [self.dataArr addObject:[NoticeGroupListModel mj_objectWithKeyValues:joinDic]];
            }
            
            for (NSDictionary *nojoinDic in arrModel.not_joins) {
                [self.dataArr addObject:[NoticeGroupListModel mj_objectWithKeyValues:nojoinDic]];
            }

            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
 
    __weak NoticeTeamsController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row <= (self.dataArr.count-1)){
        NoticeTeamChatController *ctl = [[NoticeTeamChatController alloc] init];
        ctl.identity = self.identity;
        ctl.teamModel = self.dataArr[indexPath.row];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(indexPath.row <= (self.dataArr.count-1)){
        cell.groupModel = self.dataArr[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundEffect = nil;
        appperance.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];//设置导航条颜色
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = [[UIColor greenColor] colorWithAlphaComponent:0];
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],NSFontAttributeName:XGTwentyBoldFontSize}];
        UINavigationBar *navgationBar = self.navigationController.navigationBar;
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }else{
    
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];//设置阴影图片
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //透明
        self.navigationController.navigationBar.translucent = YES;
    }

}

@end
