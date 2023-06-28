//
//  NoticeClockMyClockController.m
//  NoticeXi
//
//  Created by li lei on 2019/10/16.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockMyClockController.h"
#import "NoticeXi-Swift.h"
#import "NoticePyCell.h"
#import "UIView+Frame.h"
#import "NoticeClockTimeChoiceController.h"
#import "UNNotificationsManager.h"
#import "NoticeSetVoiceController.h"
#import "SPMultipleSwitch.h"
#import "NoticeCllockTagView.h"
@interface NoticeClockMyClockController ()<NoticeClockClickDelegate>

@property (nonatomic, strong) NoticeCllockTagView *tagView;

@property (nonatomic, strong) NoticeClockHeader *headerView;
@property (nonatomic, assign) CGFloat offsetWithY;
@property (nonatomic, strong) NoticeColockSetModel *setMoel;

@property (nonatomic, assign) BOOL isOffLast;//判断上一次是否是关闭，以提醒弹窗
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSMutableArray *cheaArr;
@property (nonatomic, strong) NSMutableArray *requestArr;
@property (nonatomic, strong) NSMutableArray *freeArr;
@property (nonatomic, strong) NSString *lastId2;
@property (nonatomic, strong) NSString *lastId3;
@property (nonatomic, strong) NoticeClockPyModel *oldModel;
@property (nonatomic, strong) NoticeNoDataView *noDataView;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@end

@implementation NoticeClockMyClockController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = GetColorWithName(VBackColor);

    self.offsetWithY = 0;

    self.headerView = [[NoticeClockHeader alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 159+21+23)];
    [self.headerView.openBtn addTarget:self action:@selector(openClock:) forControlEvents:UIControlEventValueChanged];
    [self.headerView.setBtn addTarget:self action:@selector(setTimeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.songBtn addTarget:self action:@selector(choiceVoiceClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 158, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.headerView addSubview:line];
    [self.view addSubview:self.headerView];

    if ([NoticeComTools getCloclSetModel]) {
        self.setMoel = [NoticeComTools getCloclSetModel];
    }else{
        self.setMoel = [[NoticeColockSetModel alloc] init];
        self.setMoel.hour = @"06";
        self.setMoel.min = @"30";
        self.setMoel.isOpen = @"0";
    }

    [self refreshClockStatus];

    self.headerView.timeL.text = [NSString stringWithFormat:@"%@:%@",self.setMoel.hour,self.setMoel.min];
    self.isOffLast = !self.setMoel.isOpen.boolValue;


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshClockStatus) name:@"NOTICATIONCLOCK" object:nil];


    self.tagView = [[NoticeCllockTagView alloc] initWithFrame:CGRectMake(15,self.headerView.frame.size.height-21/2-23, 84+36+88, 23)];
    __weak typeof(self) weakSelf = self;
    self.tagView.setTagBlock = ^(NSInteger clockTag) {
        weakSelf.tcTagType = clockTag;
    };
    [self.headerView addSubview:self.tagView];
    self.tableView.tableHeaderView = self.headerView;
    
    self.canShowAssest = YES;
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
    
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58-5-(DR_SCREEN_WIDTH-20)*95/355);
    self.tableView.backgroundColor = GetColorWithName(VBackColor);
    [self.tableView registerClass:[NoticePyCell class] forCellReuseIdentifier:@"pyCell"];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
    self.line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:self.line];
    
    self.dataArr = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCache) name:@"postHasDianZanInPageCheace" object:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *str = [NoticeTools isSimpleLau]?@"闹钟配音：自定义":@"鬧鐘配音：自定義";
    if (![[NoticeComTools getColockVoiceChaceModel] count]) {
        [self.headerView.songBtn setTitle:[NoticeTools isSimpleLau]?@"闹钟配音：默认":@"鬧鐘配音：默認" forState:UIControlStateNormal];
    }else if([[NoticeComTools getColockVoiceChaceModel] count] == 1){
        NoticeClockChaceModel *model = [NoticeComTools getColockVoiceChaceModel][0];
        if ([model.pyIdAndUserId isEqualToString:@"moren"]) {
            [self.headerView.songBtn setTitle:[NoticeTools isSimpleLau]?@"闹钟配音：默认":@"鬧鐘配音：默認" forState:UIControlStateNormal];
        }else{
            [self.headerView.songBtn setTitle:[NSString stringWithFormat:@"%@x%ld",str,(long)[[NoticeComTools getColockVoiceChaceModel] count]] forState:UIControlStateNormal];
        }
    }else{
        [self.headerView.songBtn setTitle:[NSString stringWithFormat:@"%@x%ld",str,(long)[[NoticeComTools getColockVoiceChaceModel] count]] forState:UIControlStateNormal];
    }
}

//刷新闹钟开关状态
- (void)refreshClockStatus{
    if (!self.setMoel.day6.integerValue && !self.setMoel.day7.integerValue && !self.setMoel.day5.integerValue && !self.setMoel.day4.integerValue && !self.setMoel.day3.integerValue && !self.setMoel.day2.integerValue && !self.setMoel.day1.integerValue && self.setMoel.isOpen.boolValue){//非重复的,已经打开的闹钟前提下,判断是否已经过了闹钟时间,过了闹钟时间就要关闭闹钟
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        NSString *curTime = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"HHmmss"];
        NSString *clockTime = [NSString stringWithFormat:@"%@%@ss",self.setMoel.hour,self.setMoel.min];
        if (curTime.integerValue > clockTime.integerValue) {
            self.setMoel.isOpen = @"0";
            [NoticeComTools saveClockModel:self.setMoel];
        }
    }
    [self.headerView.openBtn setOn:self.setMoel.isOpen.boolValue?YES:NO];
}

- (void)setTimeClick{
    NoticeClockTimeChoiceController *ctl = [[NoticeClockTimeChoiceController alloc] init];
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionDefault
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    __weak typeof(self) weakSelf = self;
    ctl.setTimeBlock = ^(NoticeColockSetModel * _Nonnull timeModel) {

        weakSelf.setMoel = timeModel;
        [NoticeComTools saveClockModel:timeModel];
        weakSelf.headerView.timeL.text = [NSString stringWithFormat:@"%@:%@",timeModel.hour,timeModel.min];
       [weakSelf openClock:weakSelf.headerView.openBtn];
    };
    if ([NoticeComTools getCloclSetModel]) {
        self.setMoel = [NoticeComTools getCloclSetModel];
    }else{
        self.setMoel = [[NoticeColockSetModel alloc] init];
        self.setMoel.hour = @"06";
        self.setMoel.min = @"30";
        self.setMoel.isOpen = @"0";
    }
    ctl.setModel = self.setMoel;
    [self.navigationController pushViewController:ctl animated:NO];
}

//选择音频
- (void)choiceVoiceClick{
    NoticeSetVoiceController *ctl = [[NoticeSetVoiceController alloc] init];
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionDefault
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)openClock:(ZQTCustomSwitch *)switchBtn{
    if (switchBtn.isOn) {
        [[UNUserNotificationCenter currentNotificationCenter]getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                // 用户未授权通知
                dispatch_async(dispatch_get_main_queue(), ^{
                    [switchBtn setOn:NO];
                    self.setMoel.isOpen = @"0";
                    [NoticeComTools saveClockModel:self.setMoel];
                    NoticePinBiView *NoticeView = [[NoticePinBiView alloc] initWithNoticeView];
                    [NoticeView showPinbView];
                });
            }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    [NoticeComTools setCloclWithModel:self.setMoel];
                    if ([NoticeTools isFirstOpenClock]) {
                        if (self.isOffLast) {
                            NoticePinBiView *NoticeView = [[NoticePinBiView alloc] initWithNoticeViewWarn];
                            [NoticeView showPinbView];
                            self.isOffLast = NO;
                        }
                    }
                });
            }
        }];

    }else{
        self.isOffLast = YES;
        self.setMoel.isOpen = @"0";
        [NoticeComTools saveClockModel:self.setMoel];
        [UNNotificationsManager removeAllNotification];//移除本地通知
    }
}

- (void)setTcTagType:(NSInteger)tcTagType{
    _tcTagType =tcTagType;
    self.lastPlayerTag = 0;
    self.isReplay = YES;
    self.stopAutoPlayerForDissapear = YES;
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
    if (tcTagType == 2) {
        if (!self.requestArr.count) {
            [self.tableView.mj_header beginRefreshing];
        }else{
            self.tableView.tableFooterView = nil;
        }
    }else if (tcTagType == 3){
        if (!self.freeArr.count) {
            [self.tableView.mj_header beginRefreshing];
        }else{
            self.tableView.tableFooterView = nil;
        }
       
    }else{
        if (!self.dataArr.count) {
            [self.tableView.mj_header beginRefreshing];
        }else{
            self.tableView.tableFooterView = nil;
        }
    }
     [self.tableView reloadData];
}


//刷新下载的本地音频，判断当前音频是否被下载了
- (void)refreshCache{
    self.cheaArr = [NoticeComTools getColockChaceModel];//获取缓存数据
    for (NoticeClockPyModel *pyModel in self.dataArr) {
        pyModel.hasDownLoad = NO;
    }
    if (!self.cheaArr.count) {
        [self.tableView reloadData];
        return;
    }
    for (NoticeClockChaceModel *model in self.cheaArr) {
        for (NoticeClockPyModel *pyModel in self.dataArr) {
            if ([model.pyIdAndUserId isEqualToString:[NSString stringWithFormat:@"%@%@",pyModel.pyId,pyModel.from_user_id]]) {
                pyModel.hasDownLoad = YES;
            }
        }
        for (NoticeClockPyModel *pyModel in self.requestArr) {
            if ([model.pyIdAndUserId isEqualToString:[NSString stringWithFormat:@"%@%@",pyModel.pyId,pyModel.from_user_id]]) {
                pyModel.hasDownLoad = YES;
            }
        }
        for (NoticeClockPyModel *pyModel in self.freeArr) {
            if ([model.pyIdAndUserId isEqualToString:[NSString stringWithFormat:@"%@%@",pyModel.pyId,pyModel.from_user_id]]) {
                pyModel.hasDownLoad = YES;
            }
        }
    }
    [self.tableView reloadData];
}


- (void)request{
    NSString *url = @"";
    if (self.isDown) {
        [self reSetPlayerData];
        
        url = @"dubbings/downloadlog";
        if (self.tcTagType == 2) {
            url = @"dubbings/downloadlog?tagId=1";
        }else if (self.tcTagType == 3){
            url = @"dubbings/downloadlog?tagId=2";
        }
    }else{
        url = [NSString stringWithFormat:@"dubbings/downloadlog?lastId=%@",self.lastId];
        if (self.tcTagType == 2) {
            url = [NSString stringWithFormat:@"dubbings/downloadlog?lastId=%@&tagId=1",self.lastId2];
        }else if (self.tcTagType == 3){
            url = [NSString stringWithFormat:@"dubbings/downloadlog?lastId=%@&tagId=2",self.lastId3];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.stopAutoPlayerForDissapear = NO;
        self.isrefreshNewToPlayer = NO;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown == YES) {
                if (self.tcTagType == 2) {
                    [self.requestArr removeAllObjects];
                }else if (self.tcTagType == 3){
                    [self.freeArr removeAllObjects];
                }else{
                    [self.dataArr removeAllObjects];
                }
                
                self.isPushMoreToPlayer = NO;
                self.isDown = NO;
            }
                        BOOL hasNewData = NO;
               for (NSDictionary *dic in dict[@"data"]) {
                   NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
                   if (self.tcTagType == 2) {
                       [self.requestArr addObject:model];
                   }else if (self.tcTagType == 3){
                       [self.freeArr addObject:model];
                   }else{
                       [self.dataArr addObject:model];
                   }
                   
                   hasNewData = YES;
               }
            BOOL noData = NO;
            if (self.tcTagType == 2 || self.tcTagType == 3) {
                if (self.tcTagType == 2 && !self.requestArr.count) {
                    noData = YES;
                }else if (self.tcTagType == 3 && !self.freeArr.count){
                    noData = YES;
                }
            }else if (!self.dataArr.count){
                noData = YES;
            }
            
            if (!noData) {
                if (self.tcTagType == 2 && self.requestArr.count) {
                    self.lastId2 = [self.requestArr[self.requestArr.count-1] tcId];
                }
                if (self.tcTagType == 3 && self.freeArr.count) {
                    self.lastId3 = [self.freeArr[self.freeArr.count-1] tcId];
                }
                if (self.dataArr.count) {
                    self.lastId = [self.dataArr[self.dataArr.count-1] tcId];
                }
                
                self.tableView.tableFooterView = nil;

            }else{
                self.tableView.tableFooterView =  self.noDataView;
            }
            [self refreshCache];
            if (hasNewData && self.isPushMoreToPlayer) {
                self.isPushMoreToPlayer = NO;
                [self nextForAssest];
            }else if (!hasNewData && self.isPushMoreToPlayer){
                if (self.tcTagType == 2) {
                    if (self.requestArr.count) {
                        self.isPlayFromFirst = YES;
                        [self nextForAssest];
                    }
                }else if (self.tcTagType == 3){
                    if (self.freeArr.count) {
                        self.isPlayFromFirst = YES;
                        [self nextForAssest];
                    }
                }else{
                    if (self.dataArr.count) {
                        self.isPlayFromFirst = YES;
                        [self nextForAssest];
                    }
                }
            }

            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)createRefesh{
 
    __weak NoticeClockMyClockController *ctl = self;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tcTagType == 2) {
        return 175+[self.requestArr[indexPath.row] contentHeight]+21;
    }else if (self.tcTagType == 3){
        return 175+[self.freeArr[indexPath.row] contentHeight]+21;
    }
    return 175+[self.dataArr[indexPath.row] contentHeight]+21;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tcTagType == 2) {
        return self.requestArr.count;
    }else if (self.tcTagType == 3){
        return  self.freeArr.count;
    }
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticePyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];

    cell.index = indexPath.row;
    cell.isTcPage = NO;
    cell.playerView.tag = indexPath.row;
    cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
    
    cell.delegate = self;
    if (self.tcTagType == 2) {
        cell.pyModel = self.requestArr[indexPath.row];
        cell.playerView.timeLen = [self.requestArr[indexPath.row] dubbing_len];
        [cell.playerView.playButton setImage:GETUIImageNamed([self.requestArr[indexPath.row] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        cell.playerView.timeLen = [self.requestArr[indexPath.row] dubbing_len];
    }else if (self.tcTagType == 3){
        cell.pyModel = self.freeArr[indexPath.row];
        [cell.playerView.playButton setImage:GETUIImageNamed([self.freeArr[indexPath.row] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        cell.playerView.timeLen = [self.freeArr[indexPath.row] dubbing_len];
        cell.playerView.timeLen = [self.freeArr[indexPath.row] dubbing_len];
    }else{
        cell.pyModel = self.dataArr[indexPath.row];
        [cell.playerView.playButton setImage:GETUIImageNamed([self.dataArr[indexPath.row] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        cell.playerView.timeLen = [self.dataArr[indexPath.row] dubbing_len];
        cell.playerView.timeLen = [self.dataArr[indexPath.row] dubbing_len];
    }
    
    return cell;
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro{
    self.progross = pro;
    self.tableView.scrollEnabled = YES;
    __weak typeof(self) weakSelf = self;
    [self.audioPlayer pause:NO];
    [self.audioPlayer.player seekToTime:CMTimeMake(self.draFlot, 1) completionHandler:^(BOOL finished) {
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
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
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
         [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    
    NoticeClockPyModel *model = self.tcTagType == 2?self.requestArr[tag] :(self.tcTagType == 3?self.freeArr[tag]: self.dataArr[tag]);
    
    self.oldModel = model;
    if (self.isReplay) {
        
        [self.audioPlayer startPlayWithUrl:model.dubbing_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        weakSelf.lastPlayerTag = tag;
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            model.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        model.isPlaying = NO;
        model.nowPro = 0;
        //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        NoticePyCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.dubbing_len.integerValue) {
            currentTime = model.dubbing_len.integerValue;
        }
        
        if ([[NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.dubbing_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.dubbing_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.dubbing_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.dubbing_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.audioPlayer.playComplete = ^{
                cell.playerView.timeLen = model.dubbing_len;
                cell.playerView.slieView.progress = 0;
                model.nowPro = 0;
                model.nowTime = model.dubbing_len;
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [weakSelf.tableView reloadData];
                if (weakSelf.isAutoPlayer && !self.isrefreshNewToPlayer) {
                    [weakSelf nextForAssest];
                }
                if (weakSelf.isrefreshNewToPlayer) {
                    weakSelf.isrefreshNewToPlayer = NO;
                }
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.dubbing_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.dubbing_len.integerValue-currentTime];
        model.nowPro = currentTime/model.dubbing_len.floatValue;
    };
}

#pragma 信息流助手方法
- (void)stopOrPlayerForAssest{
    if (self.tcTagType == 2) {
        if (!self.requestArr.count) {
            return;
        }
        if (self.oldSelectIndex > 200 || self.lastPlayerTag == 0) {
            self.oldSelectIndex = 0;
        }
        if (self.oldSelectIndex > self.requestArr.count-1) {
            return;
        }
        [self startPlayAndStop:self.oldSelectIndex];
    }else if (self.tcTagType == 3){
        if (!self.freeArr.count) {
            return;
        }
        if (self.oldSelectIndex > 200 || self.lastPlayerTag == 0) {
            self.oldSelectIndex = 0;
        }
        if (self.oldSelectIndex > self.freeArr.count-1) {
            return;
        }
        [self startPlayAndStop:self.oldSelectIndex];
    }else{
        if (!self.dataArr.count) {
            return;
        }
        if (self.oldSelectIndex > 200 || self.lastPlayerTag == 0) {
            self.oldSelectIndex = 0;
        }
        if (self.oldSelectIndex > self.dataArr.count-1) {
            return;
        }
        [self startPlayAndStop:self.oldSelectIndex];
    }

}

- (void)nextForAssest{
    if (self.isPlayFromFirst) {
        self.isPlayFromFirst = NO;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self startPlayAndStop:0];
        return;
    }
    if (self.stopAutoPlayerForDissapear) {
        return;
    }
    if (self.tcTagType == 2) {
        if (!self.requestArr.count) {
            return;
        }
        if (self.requestArr.count-1 <= self.lastPlayerTag) {//不能越界
            self.isPushMoreToPlayer = YES;
            [self.tableView.mj_footer beginRefreshing];
            return;
        }
    }else if (self.tcTagType == 3){
        if (!self.freeArr.count) {
            return;
        }
        if (self.freeArr.count-1 <= self.lastPlayerTag) {//不能越界
            self.isPushMoreToPlayer = YES;
            [self.tableView.mj_footer beginRefreshing];
            return;
        }
    }else{
        if (!self.dataArr.count) {
            return;
        }
        if (self.dataArr.count-1 <= self.lastPlayerTag+1) {//不能越界
            self.isPushMoreToPlayer = YES;
            [self.tableView.mj_footer beginRefreshing];
            return;
        }
    }

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self startPlayAndStop:self.lastPlayerTag+1];

}

- (void)proForAssest{
    if (self.lastPlayerTag == 0) {
        return;
    }
    if (self.tcTagType == 2) {
        if (!self.requestArr.count) {
            return;
        }
    }else if(self.tcTagType == 3){
        if (!self.freeArr.count) {
            return;
        }
    }else{
        if (!self.dataArr.count) {
            return;
        }
    }

    if (!self.lastPlayerTag) {
        self.lastPlayerTag = 1 ;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self startPlayAndStop:self.lastPlayerTag-1];
}

- (void)autoOrNoAutoForAssest{
    self.isAutoPlayer = [NoticeTools isAutoPlayer];
}

- (void)deleteSuccessFor:(NoticeClockPyModel *)deleM{
    NoticeClockPyModel *tcModel = deleM;
    if (tcModel.isPlaying) {
        [self.audioPlayer stopPlaying];
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

    if (self.requestArr.count) {
        NSInteger num1 = 0;
        for (NoticeClockPyModel *tcM in self.requestArr) {
            if ([tcModel.tcId isEqualToString:tcM.tcId]) {
                if (self.requestArr.count >= num1+1) {
                    [self.requestArr removeObjectAtIndex:num1];
                }
                break;
            }
            num1++;
        }
    }
    
    if (self.freeArr.count) {
        NSInteger num1 = 0;
        for (NoticeClockPyModel *tcM in self.freeArr) {
            if ([tcModel.tcId isEqualToString:tcM.tcId]) {
                if (self.freeArr.count >= num1+1) {
                    [self.freeArr removeObjectAtIndex:num1];
                }
                break;
            }
            num1++;
        }
    }
    [self.tableView reloadData];
}

- (NoticeNoDataView *)noDataView{
    if (!_noDataView) {//
        _noDataView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,(137+15+50+15))];
        _noDataView.titleImageV.frame = CGRectMake((DR_SCREEN_WIDTH-123)/2,45,123, 123);
    
        _noDataView.backgroundColor = GetColorWithName(VBackColor);
        _noDataView.titleImageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_nodownpy":@"Image_nodownpyy");
        _noDataView.titleL.hidden = YES;
        _noDataView.actionButton.hidden = NO;
        UIButton *sendTCBtn = _noDataView.actionButton;
        sendTCBtn.frame = CGRectMake((DR_SCREEN_WIDTH-345)/2,CGRectGetMaxY(_noDataView.titleImageV.frame)+15, 345, 44);
        [sendTCBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_shishimore_b":@"Image_shishimore_y") forState:UIControlStateNormal];
        [sendTCBtn setTitle:[NoticeTools isSimpleLau]?@"发现配音设为闹铃":@"發現配音設為鬧鈴" forState:UIControlStateNormal];
        [sendTCBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        sendTCBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        [sendTCBtn addTarget:self action:@selector(discoverpyClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _noDataView;
}


- (void)discoverpyClick{
    if (self.setHotBlock) {
        self.setHotBlock(YES);
    }
}

- (NSMutableArray *)requestArr{
    if (!_requestArr) {
        _requestArr = [NSMutableArray new];
    }
    return _requestArr;
}

- (NSMutableArray *)freeArr{
    if (!_freeArr) {
        _freeArr = [NSMutableArray new];
    }
    return _freeArr;
}

@end
