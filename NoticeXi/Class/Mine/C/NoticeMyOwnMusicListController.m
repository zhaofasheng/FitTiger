//
//  NoticeMyOwnMusicListController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/31.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyOwnMusicListController.h"
#import "NoticeCustumeMusiceCell.h"
#import "NoticeAddCustumeMusicView.h"

@interface NoticeMyOwnMusicListController ()
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) BOOL isOther;//别人的歌单
@property (nonatomic, strong) NoticeAddCustumeMusicView *custumeMusicView;
@property (nonatomic, strong) NoticeCustumMusiceModel *currentModel;

@end

@implementation NoticeMyOwnMusicListController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.userId) {
        self.isOther = [self.userId isEqualToString:[NoticeTools getuserId]]?NO:YES;
    }else{
        self.isOther = NO;
    }
    
    
   self.navBarView.titleL.text = self.isOther?[NoticeTools chinese:@"Ta的歌单" english:@"Playlist" japan:@"プレイリスト"]: [NoticeTools getLocalStrWith:@"songlist.mygedan"];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeCustumeMusiceCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 56;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 20)];
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    

    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if (!self.isOther) {
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT+5, DR_SCREEN_WIDTH-40, 40)];
        addBtn.layer.cornerRadius = 8;
        addBtn.layer.masksToBounds = YES;
        addBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [addBtn setTitle:[NoticeTools getLocalStrWith:@"gedan.add"] forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.view addSubview:addBtn];
        [addBtn addTarget:self action:@selector(addMusicClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusic) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
}

- (void)stopMusic{
    self.currentModel.status = 0;
    [self.audioPlayer stopPlaying];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
    if (!self.noStopPlay) {
        self.currentModel.status = 0;
        [self.audioPlayer stopPlaying];
    }
}

- (void)addMusicClick{
    self.currentModel.status = 0;
    [self.tableView reloadData];
    [self.audioPlayer stopPlaying];
    if (self.playBlock) {
        self.playBlock(self.currentModel);
    }
    
    _custumeMusicView = [[NoticeAddCustumeMusicView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    _custumeMusicView.isFromeCenter = YES;
    __weak typeof(self) weakSelf = self;
    _custumeMusicView.addMusicBlock = ^(BOOL add) {//刷新歌单列表
        if (weakSelf.addMusicBlock) {
            weakSelf.addMusicBlock(YES);
        }
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.custumeMusicView show];
}

- (void)createRefesh{
    
    __weak NoticeMyOwnMusicListController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestMusiceList];
        
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl requestMusiceList];
    }];
}

- (void)requestMusiceList{
    NSString *url = @"";
    if (self.isDown) {
        if (!self.playModel) {
            [self.audioPlayer stopPlaying];
        }
        
        url = [NSString stringWithFormat:@"myMusic/%@?pageNo=%d",self.isOther?self.userId: [NoticeTools getuserId],1];
    }else{
        url = [NSString stringWithFormat:@"myMusic/%@?pageNo=%ld",self.isOther?self.userId: [NoticeTools getuserId],self.pageNo];
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
                NoticeCustumMusiceModel *model = [NoticeCustumMusiceModel mj_objectWithKeyValues:dic];
                if (self.playModel) {
                    if ([model.songId isEqualToString:self.playModel.likeId]) {
                        model.status = self.playModel.status;
                        model.playUrl = self.playModel.playUrl;
                        self.currentModel = model;
                    }
                }
                [self.dataArr addObject:model];
            }
            self.playModel = nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCustumMusiceModel *model = self.dataArr[indexPath.row];
    if (model.status < 1) {//没有播放则执行播放
        self.currentModel.status = 0;
        self.currentModel = model;
        
        if (self.currentModel.playUrl) {
            model.status = 1;
            [self.audioPlayer startPlayWithUrl:model.playUrl isLocalFile:NO];
            [self.tableView reloadData];
            if (self.playBlock) {
                self.playBlock(model);
            }
        }else{
            [self showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"parsingMusic/%@/1",model.songId] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    NoticeCustumMusiceModel *cuM = [NoticeCustumMusiceModel mj_objectWithKeyValues:dict[@"data"]];
                    model.playUrl = cuM.songUrl;
                    model.status = 1;
                    [self.audioPlayer startPlayWithUrl:model.playUrl isLocalFile:NO];
                    [self.tableView reloadData];
                    if (self.playBlock) {
                        self.playBlock(model);
                    }
                }
                [self hideHUD];
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
        }

    }else if (self.currentModel.status == 1){//播放中，则执行暂停
        self.currentModel.status = 2;
        [self.audioPlayer pause:YES];
        [self.tableView reloadData];
        if (self.playBlock) {
            self.playBlock(model);
        }
    }else if (self.currentModel.status == 2){//暂停中，则执行播放
        self.currentModel.status = 1;
        [self.audioPlayer pause:NO];
        [self.tableView reloadData];
        if (self.playBlock) {
            self.playBlock(model);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeCustumeMusiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isOther = self.isOther;
    cell.userId = self.userId;
    cell.isMyMusicList = YES;
    cell.musicModel = self.dataArr[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.deletesMusicBlock = ^(NoticeCustumMusiceModel * _Nonnull model) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"songList.suredele"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf deleteCancel:model];
            }
        };
        [alerView showXLAlertView];
    };
    return cell;
}

- (void)deleteCancel:(NoticeCustumMusiceModel *)model{
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"joinOnly/%@",model.songId] Accept:nil parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            for (NoticeCustumMusiceModel *oldM in self.dataArr) {
                if ([oldM.songId isEqualToString:model.songId]) {
                    [self.dataArr removeObject:oldM];
                    break;
                }
            }
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEREFRESHMUSIC" object:nil];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

@end
