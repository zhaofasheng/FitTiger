//
//  NoticeTopTenController.m
//  NoticeXi
//
//  Created by li lei on 2019/11/11.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeTopTenController.h"
#import "NoticeWhitePyCell.h"//
@interface NoticeTopTenController ()<NoticewhiteClockClickDelegate>

@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NoticeClockPyModel *oldModel;
@property (nonatomic, strong) NSMutableArray *cheaArr;

@end

@implementation NoticeTopTenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    if (self.navTitle) {
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"py.replyofpy"];
        
    }else{
        if (!self.pyId && self.voteType.intValue) {
            NSString *titleFirst = self.voteType.intValue == 1?@"天使":(self.voteType.intValue == 2 ? @"恶魔":@"神");
            NSString *titleSecond = self.type.intValue==0?@"Top3":(self.type.intValue>1?@"Top10":@"Top5");
            NSArray *titleArr = @[@"今日",@"本周",@"本月",@""];
            self.navigationItem.title = [NSString stringWithFormat:@"%@%@%@",titleArr[self.type.intValue],titleFirst,titleSecond];
        }else{
            self.navigationItem.title = [NoticeTools getLocalStrWith:@"main.py"];
        }
    }
    
    if (self.isPicker) {
        self.tableView.frame = CGRectMake(0, 44, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-44);
        self.navigationItem.title = [NoticeTools getTextWithSim:@"声昔君Pick" fantText:@"聲昔君Pick"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15, 44)];
        label.textColor = GetColorWithName(VDarkTextColor);
        label.font = ELEVENTEXTFONTSIZE;
        [self.view addSubview:label];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"dubbings/%@/pickStatus",self.pyId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
                if (model.pick_status.intValue == 2) {
                    label.text = [NoticeTools getLocalStrWith:@"py.pickeOfpy"];
                }else{
                    label.text = [NoticeTools getLocalStrWith:@"py.pickingOfpy"];
                }
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
    }else{
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }
    
    [self.tableView registerClass:[NoticeWhitePyCell class] forCellReuseIdentifier:@"pyCell"];
    
    self.dataArr = [NSMutableArray new];
    if (self.topType == 1) {
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"py.bestpyoftoday"];
        if (self.currentModel) {
            [self.dataArr addObject:self.currentModel];
        }
    }else{
        if (self.mangagerCode.integerValue) {
            self.navigationItem.title = @"被举报的配音";
            [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.pyDic]];
            [self.tableView reloadData];
        }else{
            [self createRefesh];
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

//刷新下载的本地音频，判断当前音频是否被下载了
- (void)refreshCache{
    self.cheaArr = [NoticeComTools getColockChaceModel];//获取缓存数据
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
    }
    [self.tableView reloadData];
}

- (void)request{
    NSString *url = @"";
    if (self.pyId) {
        url = [NSString stringWithFormat:@"dubbings/%@",self.pyId];
    }else{
        if (self.type.intValue == 0) {
            url = [NSString stringWithFormat:@"leaderboard/dubbings/%@/top?type=day&toUserId=%@",self.voteType,self.userId];
        }else if (self.type.intValue == 1){
            url = [NSString stringWithFormat:@"leaderboard/dubbings/%@/top?type=week&toUserId=%@",self.voteType,self.userId];
        }else if (self.type.intValue == 2){
            url = [NSString stringWithFormat:@"leaderboard/dubbings/%@/top?type=month&toUserId=%@",self.voteType,self.userId];
        }else{
            url = [NSString stringWithFormat:@"leaderboard/dubbings/%@/top?toUserId=%@",self.voteType,self.userId];
        }
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown == YES) {
                if (self.dataArr.count) {
                    self.isReplay = YES;
                    [self.audioPlayer pause:YES];
                    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                }
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            if (self.pyId) {
                NoticeUserInfoModel *userInfo = [NoticeUserInfoModel mj_objectWithKeyValues:dict[@"data"][@"user_info"]];
                NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
                if (self.isPicker) {
                    model.isPicker = YES;
                }
//                if (model.tag_id.intValue == 2) {
//                    model.line_content = [NSString stringWithFormat:@"#求freestyle#%@",model.line_content];
//                }else{
//                    model.line_content = [NSString stringWithFormat:@"#求配音#%@",model.line_content];
//                }
                if (!model.pyUserInfo) {
                    model.pyUserInfo = userInfo;
                }
                [self.dataArr addObject:model];
            }else{
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:model];
                }
            }
            [self refreshCache];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    __weak NoticeTopTenController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175+[self.dataArr[indexPath.row] contentHeight]+21;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeWhitePyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];
    if (self.mangagerCode.integerValue) {
        cell.managerCode = self.mangagerCode;
    }
    if (self.isPicker) {
        cell.isHot = YES;
    }
    cell.index = indexPath.row;
    cell.isTcPage = NO;
    cell.isNeedPost = YES;
    cell.playerView.tag = indexPath.row;
    cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
    [cell.playerView.playButton setImage:GETUIImageNamed([self.dataArr[indexPath.row] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    cell.pyModel = self.dataArr[indexPath.row];
    cell.playerView.timeLen = [self.dataArr[indexPath.row] dubbing_len];
    if (self.isPicker) {
        cell.timeL.hidden = YES;
        cell.nickNameL.frame = CGRectMake(cell.nickNameL.frame.origin.x, cell.iconImageView.frame.origin.y, cell.nickNameL.frame.size.width, cell.iconImageView.frame.size.height);
    }
    return cell;
}

- (void)deletePy:(NoticeClockPyModel *)model{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/dubbings/%@",model.pyId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            model.dubbing_status = @"3";
            self.pyDic = model.mj_keyValues;
            [self.dataArr removeAllObjects];
            [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.pyDic]];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageManagerPy" object:self userInfo:self.pyDic];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)huifuPy:(NoticeClockPyModel *)model{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
    [parm setObject:@"1" forKey:@"dubbingStatus"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/dubbings/%@",model.pyId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            model.dubbing_status = @"1";
            self.pyDic = model.mj_keyValues;
            [self.dataArr removeAllObjects];
            [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.pyDic]];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageManagerPy" object:self userInfo:self.pyDic];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

//管理员处理配音回调
- (void)editManager:(NSInteger)tag{
    NoticeClockPyModel *model = self.dataArr[0];
    [self showHUD];
    if (tag == 1) {
        if ([model.dubbing_status isEqualToString:@"1"]) {
            [self deletePy:model];
        }else{
            [self huifuPy:model];
        }
    }else if (tag == 2){//删除台词和配音
        if (model.line_status.intValue == 1 && model.dubbing_status.intValue != 1) {//只需要恢复配音
            [self huifuPy:model];
        }else if(model.line_status.intValue != 1){//需要回复配音和台词
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
            [parm setObject:@"1" forKey:@"lineStatus"];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/lines/%@",model.line_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                 [self hideHUD];
                if (success) {
                    model.line_status = @"1";
                    [self huifuPy:model];
                }
            } fail:^(NSError * _Nullable error) {
                 [self hideHUD];
            }];
        }else if (model.line_status .intValue == 1 && model.dubbing_status.intValue == 1){//删除台词即可
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/lines/%@",model.line_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    model.line_status = @"0";
                    model.dubbing_status = @"0";
                    self.pyDic = model.mj_keyValues;
                    [self.dataArr removeAllObjects];
                    [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.pyDic]];
                    [self.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageManagerPy" object:self userInfo:self.pyDic];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }
    }
    else{
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.mangagerCode forKey:@"confirmPasswd"];
        [parm setObject:model.hide_at.integerValue? @"0" : [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]] forKey:@"hideAt"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/dubbings/%@",model.pyId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                model.hide_at = model.hide_at.integerValue? @"0" : @"45678";
                self.pyDic = model.mj_keyValues;
                [self.dataArr removeAllObjects];
                [self.dataArr addObject:[NoticeClockPyModel mj_objectWithKeyValues:self.pyDic]];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageManagerPy" object:self userInfo:self.pyDic];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }
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
- (void)delegateSuccess:(NSInteger)index{
    if (self.dataArr.count >= index+1) {
        [self.dataArr removeObjectAtIndex:index];
        [self.tableView reloadData];
    }
}
@end
