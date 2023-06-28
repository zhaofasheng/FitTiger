//
//  NoticeBBSController.m
//  NoticeXi
//
//  Created by li lei on 2020/11/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSController.h"
#import "NoticeBBSheaderView.h"
#import "NoticeBBSTitleSection.h"
#import "NoticeNodataSection.h"
#import "NoticeClickMoreBBSCell.h"
#import "NoticeBBSComentCell.h"
#import "JMDropMenu.h"
#import "NoticeSendBBSController.h"
#import "NoticeBeforeBBSController.h"
#import "NoticeSendBBSRecoderController.h"
#import "NoticrBBSManagerController.h"
#import "NoticeManager.h"
#import "NoticeBBSDetailController.h"
#import "NoticeWebViewController.h"
@interface NoticeBBSController ()<JMDropMenuDelegate,NoticeManagerUserDelegate>

@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) NoticeBBSheaderView *headerView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSString *lastSort;

@end

@implementation NoticeBBSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    backView.backgroundColor = [NoticeTools getWhiteColor:@"#FFCBAB" NightColor:@"#4B4C89"];
    [self.view addSubview:backView];
    
    self.setButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT, 50,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [self.setButton setTitle:[NoticeTools getLocalStrWith:@"movie.more"] forState:UIControlStateNormal];
    self.setButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [self.setButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.setButton];
    
    if ([NoticeTools isManager]) {
        FSCustomButton *btn1 = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-10-44,STATUS_BAR_HEIGHT,44,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [btn1 setImage:UIImageNamed(@"Image_managerc") forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn1];
    }
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-100, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    self.titleL.font = EIGHTEENTEXTFONTSIZE;
    self.titleL.textColor = GetColorWithName(VMainThumeWhiteColor);
    [self.view addSubview:self.titleL];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.alpha = 0;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    self.headerView = [[NoticeBBSheaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 130)];
    self.tableView.tableHeaderView = self.headerView;
    
    self.titleL.text = self.headerView.titleLabel.text;
    
    [self.tableView registerClass:[NoticeBBSComentCell class] forCellReuseIdentifier:@"comentCell"];
    [self.tableView registerClass:[NoticeBBSTitleSection class] forHeaderFooterViewReuseIdentifier:@"headerCell"];
    [self.tableView registerClass:[NoticeNodataSection class] forCellReuseIdentifier:@"nodataCell"];
    [self.tableView registerClass:[NoticeClickMoreBBSCell class] forCellReuseIdentifier:@"moreCell"];
    

    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)createRefesh{
    
    __weak NoticeBBSController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestList];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
}

- (void)requestList{
    NSString *url = @"";
    if (self.isDown) {
        url = @"posts";
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


- (void)managerClick{
    self.magager.type = @"管理员登陆";
    [self.magager show];
}

- (void)sureManagerClick:(NSString *)code{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            NoticrBBSManagerController *ctl = [[NoticrBBSManagerController alloc] init];
            ctl.mangagerCode = code;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}
- (void)sendClick{
    NoticeSendBBSController *ctl = [[NoticeSendBBSController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NoticeBBSModel *model = self.dataArr[section];
    if (model.comments.count == 1) {//如果只有一条留言,显示一条留言
        return 1;
    }else if (model.comments.count > 1){//大于一条留言，显示一个查看更多按钮
        if (model.comments.count > 2) {//如果超过俩留言，只显示俩留言
            return 3;
        }
        return model.comments.count+1;
    }else{//没有留言 系那是没有留言UI
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSModel *model = self.dataArr[indexPath.section];
    
    if (indexPath.row == 0) {
        if (model.comments.count) {//如果存在留言
            NoticeBBSComent *comM = model.commentArr[0];
            return 65+comM.twoTextHeight+10;
        }else{//不存在留言则显示缺省页高度
            return 120;
        }
    }else if (indexPath.row == 1){//这个时候肯定存在超过2条留言
        NoticeBBSComent *comM = model.commentArr[1];
        return 65+comM.twoTextHeight+10;
    }else{//第三个的时候肯定是查看更多
        return 40;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSModel *bbsModel = self.dataArr[indexPath.section];
    NoticeBBSDetailController *ctl = [[NoticeBBSDetailController alloc] init];
    ctl.bbsModel = bbsModel;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBBSModel *model = self.dataArr[indexPath.section];
    if (model.comments.count) {//如果存在留言
        if (indexPath.row == 0) {
            NoticeBBSComentCell *comCell = [tableView dequeueReusableCellWithIdentifier:@"comentCell"];
            comCell.commentTwoM = model.commentArr[0];
            return comCell;
        }else if (indexPath.row == 1){//第二个肯定是留言
            NoticeBBSComentCell *comCell = [tableView dequeueReusableCellWithIdentifier:@"comentCell"];
            comCell.commentTwoM = model.commentArr[1];
            return comCell;
        }else{//第三个cell就是查看更多
            NoticeClickMoreBBSCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
            return moreCell;
        }
    }else{//没有留言就是缺省页
        NoticeNodataSection *nodataCell = [tableView dequeueReusableCellWithIdentifier:@"nodataCell"];
        return nodataCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NoticeBBSModel *model = self.dataArr[section];
    return 72+model.titleHeight+model.fiveTextHeight+15+model.imgHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeBBSTitleSection *sectionHeaer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerCell"];
    sectionHeaer.line.hidden = section==0?YES:NO;
    sectionHeaer.bbsModel = self.dataArr[section];
    return sectionHeaer;
}

- (void)moreClick{
    [JMDropMenu showDropMenuFrame:CGRectMake(self.view.frame.size.width - 128, NAVIGATION_BAR_HEIGHT, 120,3*40+10) ArrowOffset:102.f TitleArr:@[@"往期  ",@"投稿记录",@"投稿规则"] ImageArr:@[@"",@"",@""] Type:JMDropMenuTypeQQ LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
}

- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image{
    if (index == 0) {
        NoticeBeforeBBSController *ctl = [[NoticeBeforeBBSController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (index == 1){
        NoticeSendBBSRecoderController *ctl = [[NoticeSendBBSRecoderController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (index == 2){
        NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
        NoticeWeb *web = [[NoticeWeb alloc] init];
        web.html_id = @"35";
        webctl.web = web;
        webctl.isBbs = YES;
        [self.navigationController pushViewController:webctl animated:YES];
    }
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > 30) {
        self.titleL.alpha = 1;
        self.headerView.titleLabel.alpha = 0;
    }else{
        self.titleL.alpha = 0;
        self.headerView.titleLabel.alpha = 1;
    }
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}
@end
