//
//  NoticeHeJiListController.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHeJiListController.h"
#import "NoticeReadHeJiCell.h"
#import "NoticeVoiceReadHeaderView.h"
#import "NoticeReadAllContentView.h"

@interface NoticeHeJiListController ()
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NoticeReadAllContentView *readingView;
@end

@implementation NoticeHeJiListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.pageNo = 1;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[NoticeReadHeJiCell class] forCellReuseIdentifier:@"cell"];
    self.dataArr = [[NSMutableArray alloc] init];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.tableView.rowHeight = 140;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    NoticeVoiceReadHeaderView *headerView = [[NoticeVoiceReadHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 143)];
    headerView.readModel = self.readModel;
    self.tableView.tableHeaderView = headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceReadModel *model = self.dataArr[indexPath.row];
    model.title = self.readModel.title;
    model.author = self.readModel.author;
    self.readingView.readModel = model;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = YES;
    self.readingView.hidden = NO;
    [CoreAnimationEffect animationEaseIn:self.readingView];
}

- (NoticeReadAllContentView *)readingView{
    if (!_readingView) {
        _readingView = [[NoticeReadAllContentView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [self.view addSubview:_readingView];
        _readingView.hidden = YES;
    }
    return _readingView;;
}

- (void)createRefesh{
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        weakSelf.pageNo = 1;
        [weakSelf request];
        
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isDown = NO;
        weakSelf.pageNo++;
        [weakSelf request];
    }];
}

- (void)request{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"readAloud/getCollection/%@?pageNo=%ld",self.readModel.readId,self.pageNo] Accept:@"application/vnd.shengxi.v5.3.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceReadModel *model = [NoticeVoiceReadModel mj_objectWithKeyValues:dic];
                model.title = self.readModel.title;
                model.type = self.readModel.type;
                model.cover_url = self.readModel.cover_url;
                model.show_at = self.readModel.show_at;
                model.author = self.readModel.author;
                [self.dataArr addObject:model];
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
    NoticeReadHeJiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.readModel = self.dataArr[indexPath.row];
    cell.numL.text = [NSString stringWithFormat:@"%02ld",indexPath.row+1];
    __weak typeof(self) weakSelf = self;
    cell.readingBlock = ^(NoticeVoiceReadModel * _Nonnull readM) {
        if (weakSelf.readingBlock) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            weakSelf.readingBlock(readM, YES);
        }
    };
    return cell;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = YES;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    appdel.noPop = NO;
}

@end
