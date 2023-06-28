//
//  NoticeMyLikeSongController.m
//  NoticeXi
//
//  Created by li lei on 2023/2/25.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyLikeSongController.h"
#import "NoticeMyOwnMusicListController.h"
#import "NoticeMusicLikeHistoryController.h"
#import "NoticeMusicLikeShowCell.h"
#import "NoticeCustumMusiceModel.h"
#import "NoticeSongLikesController.h"

@interface NoticeMyLikeSongController ()
@property (nonatomic, strong) UILabel *songNumL;
@property (nonatomic, strong) UILabel *likeNumL;
@property (nonatomic, strong) UILabel *addLikeL;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NoticeMusicLikeModel *currentModel;
@property (nonatomic, assign) BOOL isPush;
@end

@implementation NoticeMyLikeSongController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navBarView.titleL.text = [NoticeTools chinese:@"喜欢排行" english:@"Ranking" japan:@"ランキング"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 100)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[NoticeMusicLikeShowCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 80;
    
    NSArray *btnTextArr = @[[NoticeTools getLocalStrWith:@"songlist.mygedan"],[NoticeTools chinese:@"喜欢历史" english:@"History" japan:@"気に入った歴史"]];
    for (int i = 0; i < 2; i++) {
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(15+(DR_SCREEN_WIDTH-30)/2*i, 0, (DR_SCREEN_WIDTH-30)/2, 100)];
        tapView.tag = i;
        tapView.userInteractionEnabled = YES;
        [headerView addSubview:tapView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,(DR_SCREEN_WIDTH-30)/2, 33)];
        label.font = [UIFont fontWithName:XGBoldFontName size:24];
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.textAlignment = NSTextAlignmentCenter;
        [tapView addSubview:label];
        label.text = @"0";
        label.userInteractionEnabled = YES;
        label.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFun:)];
        [label addGestureRecognizer:tap];
        if (i==0) {
            self.songNumL = label;
        }else{
            self.likeNumL = label;
        }
        
        FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(12, 53, (DR_SCREEN_WIDTH-30)/2-12, 17)];
        [btn setImage:UIImageNamed(@"gedaninto_img") forState:UIControlStateNormal];
        btn.tag = i;
        btn.buttonImagePosition = FSCustomButtonImagePositionRight;
        [btn setTitle:btnTextArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = TWOTEXTFONTSIZE;
        [btn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        [tapView addSubview:btn];
        [btn addTarget:self action:@selector(tapvTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.dataArr = [[NSMutableArray alloc] init];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    [self requestAllNum];
    
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusic) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
}

- (void)stopMusic{
    [self.audioPlayer stopPlaying];
    self.currentModel.status = 0;
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
    if (!self.isPush) {
        [self.audioPlayer stopPlaying];
        self.currentModel.status = 0;
        self.isPush = NO;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMusicLikeShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.index = indexPath.row;
    cell.likeModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.gotoLikeTapBlock = ^(NoticeMusicLikeModel * _Nonnull model) {
        NoticeSongLikesController *ctl = [[NoticeSongLikesController alloc] init];
        ctl.musicModel = model;
        [weakSelf.navigationController pushViewController:ctl animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMusicLikeModel *model = self.dataArr[indexPath.row];
    if (model.status < 1) {//没有播放则执行播放
        self.currentModel.status = 0;
        self.currentModel = model;
        
        if (self.currentModel.playUrl) {
            model.status = 1;
            [self.audioPlayer startPlayWithUrl:model.playUrl isLocalFile:NO];
            [self.tableView reloadData];
        }else{
            [self showHUD];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"parsingMusic/%@/1",model.likeId] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    NoticeCustumMusiceModel *cuM = [NoticeCustumMusiceModel mj_objectWithKeyValues:dict[@"data"]];
                    model.playUrl = cuM.songUrl;
                    model.status = 1;
                    [self.audioPlayer startPlayWithUrl:model.playUrl isLocalFile:NO];
                    [self.tableView reloadData];
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
    }else if (self.currentModel.status == 2){//暂停中，则执行播放
        self.currentModel.status = 1;
        [self.audioPlayer pause:NO];
        [self.tableView reloadData];
    }
}

- (void)requestMusiceLike{
    NSString *url = @"";
    url = [NSString stringWithFormat:@"music/getLikeList?pageNo=%ld",self.pageNo];
    if (self.isDown) {
        [self.audioPlayer stopPlaying];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMusicLikeModel *model = [NoticeMusicLikeModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
                self.defaultL.text = [NoticeTools chinese:@"嘻嘻 歌曲还在精心挑选" english:@"Make a playlist now" japan:@"今すぐプレイリストを作成"];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    
    __weak NoticeMyLikeSongController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestMusiceLike];
        
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl requestMusiceLike];
    }];
}

- (void)requestAllNum{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"music/getLikeStatistics" Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeMusicLikeModel *model = [NoticeMusicLikeModel mj_objectWithKeyValues:dict[@"data"]];
            self.songNumL.text = model.musicNum.intValue?model.musicNum:@"0";
            self.likeNumL.text = model.likeNum.intValue?model.likeNum:@"0";
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)tapvTag:(FSCustomButton *)tap{
    [self clickWithTag:tap.tag];

}

- (void)tapFun:(UITapGestureRecognizer *)tap{
    UILabel *tapV = (UILabel *)tap.view;
    [self clickWithTag:tapV.tag];
}

- (void)clickWithTag:(NSInteger)tag{
    self.isPush = YES;
    if (tag == 0) {
        NoticeMyOwnMusicListController *ctl = [[NoticeMyOwnMusicListController alloc] init];
        __weak typeof(self) weakSelf = self;
        ctl.addMusicBlock = ^(BOOL add) {
            [weakSelf requestAllNum];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        ctl.playBlock = ^(NoticeCustumMusiceModel * _Nonnull playCurrentModel) {
            for (NoticeMusicLikeModel *model in weakSelf.dataArr) {
                if ([playCurrentModel.songId isEqualToString:model.likeId]) {
                    self.currentModel.status = 0;
                    model.status = playCurrentModel.status;
                    model.playUrl = playCurrentModel.playUrl;
                    weakSelf.currentModel = model;
                    [weakSelf.tableView reloadData];
                    break;
                }
            }
        };
        ctl.playModel = self.currentModel;
        ctl.audioPlayer = self.audioPlayer;
        ctl.noStopPlay = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeMusicLikeHistoryController *ctl = [[NoticeMusicLikeHistoryController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}
@end
