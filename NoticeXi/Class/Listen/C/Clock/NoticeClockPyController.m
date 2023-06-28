//
//  NoticeClockPyController.m
//  NoticeXi
//
//  Created by li lei on 2019/10/16.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockPyController.h"
#import "NoticePyCell.h"
#import "NoticeWhitePyCell.h"
#import "NoticeCllockTagView.h"
#import "NoticeBdController.h"

@interface NoticeClockPyController ()<NoticeClockClickDelegate,NoticewhiteClockClickDelegate>

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) BOOL isDown1;//YES  下拉
@property (nonatomic, assign) BOOL isDown2;//YES  下拉
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, strong) NoticeClockPyModel *oldModel;
@property (nonatomic, strong) NSMutableArray *cheaArr;
@property (nonatomic, strong) NoticeNoDataView *noDataView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIView *footBtnView;
@property (nonatomic, strong) NoticeClockPyModel *pickerClockModel;
@property (nonatomic, strong) NoticeCllockTagView *tagView;
@property (nonatomic, strong) UIView *sectionView;
@end

@implementation NoticeClockPyController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isAppear = YES;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isAppear = NO;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);

    [self.tableView registerClass:[NoticePyCell class] forCellReuseIdentifier:@"pyCell"];
    [self.tableView registerClass:[NoticeWhitePyCell class] forCellReuseIdentifier:@"whitepyCell"];
    
    self.dataArr = [NSMutableArray new];
    
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"CHANGETHEROOTSELECTARTPY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"postHasDianZanInPage" object:nil];
    
    self.pageNo = 1;
    self.isDown1 = YES;
    self.isDown2 = YES;

    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    self.sectionView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    
    
    self.tagView = [[NoticeCllockTagView alloc] initWithFrame:CGRectMake(20,6, DR_SCREEN_WIDTH-40, 38)];
    __weak typeof(self) weakSelf = self;
    self.tagView.setTagBlock = ^(NSInteger clockTag) {
        weakSelf.tcTagType = clockTag;
    };
    [self.sectionView addSubview:self.tagView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 24+88)];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 24, DR_SCREEN_WIDTH-40, 88)];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.clipsToBounds = YES;
    imageV.userInteractionEnabled = YES;
    imageV.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"Image_pytcheader"]);
    [headerView addSubview:imageV];
    self.tableView.tableHeaderView = headerView;
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bdTap)];
    [headerView addGestureRecognizer:tap];
}

- (void)bdTap{
    NoticeBdController *ctl = [[NoticeBdController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)setTcTagType:(NSInteger)tcTagType{
    _tcTagType =tcTagType;
    self.lastPlayerTag = 0;
    self.isReplay = YES;
    self.stopAutoPlayerForDissapear = YES;
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

//通知中心传值确保点赞数据同步
-(void)action:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    if (nameDictionary) {
        
        NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:nameDictionary];
        for (int i = 0; i < self.dataArr.count; i++) {
            NoticeClockPyModel *oldM = self.dataArr[i];
            if ([oldM.pyId isEqualToString:model.pyId]) {
                oldM.vote_id = model.vote_id;
                oldM.vote_option = model.vote_option;
                oldM.vote_option_one = model.vote_option_one;
                oldM.vote_option_two = model.vote_option_two;
                oldM.vote_option_three = model.vote_option_three;
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)refresh{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    self.isDown = YES;
    self.pageNo = 1;
    if (self.tcTagType >=2) {
        [self requestHot];
    }else{
        [self request];
    }
    
}

- (void)requestHot{
    [self reSetPlayerData];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"dubbings/top" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.dataArr removeAllObjects];
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            return ;
        }
        for (NSDictionary *dic in dict[@"data"]) {
            NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
            model.isPicker = YES;
            [self.dataArr addObject:model];
        }
        self.isDown = YES;
        [self request];
    } fail:^(NSError * _Nullable error) {
        [self.dataArr removeAllObjects];
        [self.tableView reloadData];
        self.isDown = YES;
        [self request];
    }];
}

//第一部分算法数据
- (void)request{
    
    NSString *url = @"";
    if (self.isDown) {
        [self reSetPlayerData];
        url = @"dubbings";
        if (self.tcTagType == 2) {
            url = @"dubbings?tagId=1";
        }else if (self.tcTagType == 3){
            url = @"dubbings?tagId=2";
        }
    }else{
        url = [NSString stringWithFormat:@"dubbings?lastId=%@",self.lastId];
        if (self.tcTagType == 2) {
            url = [NSString stringWithFormat:@"dubbings?lastId=%@&tagId=1",self.lastId];
        }else if (self.tcTagType == 3){
            url = [NSString stringWithFormat:@"dubbings?lastId=%@&tagId=2",self.lastId];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES && self.tcTagType >= 2) {
                [self.dataArr removeAllObjects];
                
            }
            if (self.isDown) {
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
               self.lastId = [self.dataArr[self.dataArr.count-1] tcId];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if([NoticeComTools pareseError:error]){
            [self.noNetWorkView show];
        }
    }];
}


- (void)createRefesh{
    __weak NoticeClockPyController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        if (ctl.tcTagType < 2) {
            [ctl requestHot];
        }else{
            [ctl request];
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.dataArr.count) {
        return 0;
    }
    if (indexPath.row <= self.dataArr.count-1) {
        return 173+[self.dataArr[indexPath.row] contentHeight]+55+([[self.dataArr[indexPath.row] comArr] count]?50:0);
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.needBackGround) {
        NoticePyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"whitepyCell"];
        cell.isDisappear = !self.isAppear;
        cell.index = indexPath.row;
        cell.isTcPage = NO;
        cell.playerView.tag = indexPath.row;

        __weak typeof(self) weakSelf = self;
        cell.deletePyBlock = ^(NoticeClockPyModel * _Nonnull pyModel) {
            [weakSelf deleteSuccessFor:pyModel];
        };
        
        cell.delegate = self;
        
        if (indexPath.row <= self.dataArr.count-1 && self.dataArr.count) {
            cell.pyModel = self.dataArr[indexPath.row];
            [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
        }
        return cell;
    }
    NoticePyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];
    cell.isDisappear = !self.isAppear;
    cell.index = indexPath.row;
    cell.isTcPage = NO;
    cell.playerView.tag = indexPath.row;

    __weak typeof(self) weakSelf = self;
    cell.deletePyBlock = ^(NoticeClockPyModel * _Nonnull pyModel) {
        [weakSelf deleteSuccessFor:pyModel];
    };
    
    cell.delegate = self;
    
    if (indexPath.row <= self.dataArr.count-1 && self.dataArr.count) {
        cell.pyModel = self.dataArr[indexPath.row];
        [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    self.progross = pro;
    self.tableView.scrollEnabled = YES;
    __weak typeof(self) weakSelf = self;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer pause:NO];
    [appdel.floatView.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            weakSelf.progross = 0;
        }
    }];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    self.draFlot = dratNum;
}

#pragma Mark - 音频播放模块
- (void)startRePlayer:(NSInteger)tag{//重新播放
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.floatView.audioPlayer stopPlaying];
    self.isReplay = YES;
    [appdel.floatView.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
}


- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing{
   
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.dataArr.count && (self.floatView.currentTag <= self.dataArr.count-1) && appdel.floatView.currentTag == self.oldSelectIndex) {
        NoticeClockPyModel *model = self.dataArr[self.floatView.currentTag];
        if (playing) {
            self.isPasue = !pause;
            model.isPlaying = !pause;
            [self.tableView reloadData];
        }
    }
}
//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{
    
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
        NoticeClockPyModel *oldM = self.oldModel;
        oldM.nowTime = oldM.dubbing_len;
        oldM.nowPro = 0;
        oldM.isPlaying = NO;
        [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeClockPyModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        self.canReoadData = YES;
        appdel.floatView.pyArr = self.dataArr.mutableCopy;
        appdel.floatView.currentTag = tag;
        appdel.floatView.currentPyModel = model;
        self.isReplay = NO;
        self.isPasue = NO;
        appdel.floatView.isPasue = self.isPasue;
        appdel.floatView.isReplay = YES;
        appdel.floatView.isNoRefresh = YES;
        [appdel.floatView playClick];
      
    }else{
        [appdel.floatView playClick];
    }
    
    __weak typeof(self) weakSelf = self;
    appdel.floatView.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        weakSelf.lastPlayerTag = tag;
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            if (self.canReoadData) {
                model.isPlaying = YES;
                [weakSelf.tableView reloadData];
            }
        }
    };
    
    appdel.floatView.playComplete = ^{
        weakSelf.canReoadData = NO;
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        model.nowTime = model.dubbing_len;
        [weakSelf.tableView reloadData];
    };
    
    appdel.floatView.playNext = ^{
        weakSelf.canReoadData = NO;
    };
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    appdel.floatView.playingBlock = ^(CGFloat currentTime) {
        if (!self.needBackGround) {
            NoticeWhitePyCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (weakSelf.canReoadData) {
                cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
                cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.dubbing_len.floatValue;
                model.nowTime = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
                model.nowPro = currentTime/model.dubbing_len.floatValue;
            }else{
                cell.playerView.timeLen = model.dubbing_len;
                cell.playerView.slieView.progress = 0;
                model.nowPro = 0;
                model.nowTime = model.dubbing_len;
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            }
        }else{
            NoticePyCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (weakSelf.canReoadData) {
                cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
                cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.dubbing_len.floatValue;
                model.nowTime = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
                model.nowPro = currentTime/model.dubbing_len.floatValue;
            }else{
                cell.playerView.timeLen = model.dubbing_len;
                cell.playerView.slieView.progress = 0;
                model.nowPro = 0;
                model.nowTime = model.dubbing_len;
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            }
        }

    };
}

- (void)deleteSuccessFor:(NoticeClockPyModel *)deleM{
    NoticeClockPyModel *tcModel = deleM;
    if (tcModel.isPlaying) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        
    }
    if (self.dataArr.count) {
        NSInteger num1 = 0;
        for (NoticeClockPyModel *tcM in self.dataArr) {
            if ([tcModel.tcId isEqualToString:tcM.tcId]) {
                if (self.dataArr.count >= num1+1) {
                    [self.dataArr removeObjectAtIndex:num1];
                }
                break;
            }
            num1++;
        }
    }
    [self.tableView reloadData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.dataArr.count && !self.isHot) {
        return;
    }
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 5;
    
    if(y > h + reload_distance) {
        if (self.canLoad) {
            self.canLoad = NO;
            [self.tableView.mj_footer beginRefreshing];
        }
    }
}

@end
