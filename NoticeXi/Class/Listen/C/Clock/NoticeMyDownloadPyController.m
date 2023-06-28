//
//  NoticeMyDownloadPyController.m
//  NoticeXi
//
//  Created by li lei on 2020/4/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyDownloadPyController.h"
#import "NoticeXi-Swift.h"
#import "NoticePyCell.h"
#import "NoticeWhitePyCell.h"
#import "UIView+Frame.h"
#import "UNNotificationsManager.h"
#import "SPMultipleSwitch.h"
@interface NoticeMyDownloadPyController ()<NoticeClockClickDelegate,NoticewhiteClockClickDelegate>
@property (nonatomic, strong) NoticeClockPyModel *oldModel;
@property (nonatomic, strong) NSMutableArray *cheaArr;
@property (nonatomic, strong) NoticeNoDataView *noDataView;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isDown;// YES 下拉
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) UIView *footV;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UILabel *numL;
@end

@implementation NoticeMyDownloadPyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRefesh];
    
    self.pageNo = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);

    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[NoticePyCell class] forCellReuseIdentifier:@"pyCell"];
    [self.tableView registerClass:[NoticeWhitePyCell class] forCellReuseIdentifier:@"whitepyCell"];

    if (self.isDownload) {
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-44-48);
    }
    self.dataArr = [NSMutableArray new];


    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
    headerV.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 44)];
    self.numL.font = FOURTHTEENTEXTFONTSIZE;
    self.numL.textColor = self.needBackGround? [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8] :[UIColor colorWithHexString:@"#5C5F66"];
    [headerV addSubview:self.numL];
    
    if (!self.isUserCenter) {
        self.tableView.tableHeaderView = headerV;
    }
    if (self.isUserPy && !self.isUserCenter) {
        SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"py.zuixin"],[NoticeTools getLocalStrWith:@"py.zuihot"]]];
        switch1.titleFont = TWOTEXTFONTSIZE;
        switch1.frame = CGRectMake(DR_SCREEN_WIDTH-20-64*2,10,64*2,24);
        [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
        if (self.needBackGround) {
            self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
            self.tableView.backgroundColor = self.view.backgroundColor;
            switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
            switch1.titleColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
            switch1.trackerColor = [UIColor colorWithHexString:@"#F7F8FC"];
            switch1.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
        }else{
            switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
            switch1.titleColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
            switch1.trackerColor = [UIColor colorWithHexString:@"#FFFFFF"];
            switch1.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
        }
        [headerV addSubview:switch1];
        
        if (self.isOther) {
            self.isOrderByHot = YES;
            [switch1 setSelectedSegmentIndex:1];
        }
    }
    [self.tableView.mj_header beginRefreshing];
    if (self.isUserCenter) {
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-44);
    }
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    self.isOrderByHot = swithbtn.selectedSegmentIndex==1?YES:NO;
    [self.tableView.mj_header beginRefreshing];
}

- (void)request{
    
    NSString *url = @"";
    if (self.isDown) {
        [self reSetPlayerData];
        
        url = [NSString stringWithFormat:@"users/%@/dubbings?pageNo=1&type=%d&isAnonymous=%@",self.isOther?self.userId:[NoticeTools getuserId],self.isOrderByHot?2:1,self.isFromUserCenter?@"2":@"1"];
        if (self.isDownload) {
            url = @"downloadlog";
        }
    }else{
        url = [NSString stringWithFormat:@"users/%@/dubbings?pageNo=%ld&type=%d&isAnonymous=%@",self.isOther?self.userId:[NoticeTools getuserId],self.pageNo,self.isOrderByHot?2:1,self.isFromUserCenter?@"2":@"1"];
        if (self.isDownload) {
            url = [NSString stringWithFormat:@"downloadlog?lastId=%@",self.lastId];
        }

    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isUserPy?@"application/vnd.shengxi.v5.3.6+json": @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeMJIDModel *model = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.isDown == YES) {
                self.numL.text = [NSString stringWithFormat:@"%@%@",model.total,[NoticeTools getLocalStrWith:@"py.ofnum"]];
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            BOOL hasNewData = NO;
            
            
            for (NSDictionary *dic in model.list) {
                NoticeClockPyModel *model = [NoticeClockPyModel mj_objectWithKeyValues:dic];
                model.pyId = model.dubbing_id;
                [self.dataArr addObject:model];
                hasNewData = YES;
            }
            BOOL noData = NO;
            if (!self.dataArr.count){
                noData = YES;
            }
            
            if (!noData) {
                if (self.dataArr.count) {
                    self.lastId = [self.dataArr[self.dataArr.count-1] tcId];
                }
                self.tableView.tableFooterView = nil;
            }else{
                if (self.isUserCenter){
                    self.tableView.tableFooterView = self.footV;
                }else{
                    self.tableView.tableFooterView = self.defaultL;
                    self.defaultL.text = [NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
                }
                
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UIView *)footV{
    if (!_footV) {
        _footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-40)*180/335)];
        
        UIImageView *iamgeV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)*180/335)];
        iamgeV.image = UIImageNamed(@"Image_noshare");
        [_footV addSubview:iamgeV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-40, iamgeV.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.7];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.text = [NoticeTools chinese:@"哦豁 什么都没有" english:@"Post something to create a stream" japan:@"何かを投稿してストリームを作成する"];
      
        [iamgeV addSubview:label];
    }
    return _footV;
}

- (void)createRefesh{
 
    __weak NoticeMyDownloadPyController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 173+[self.dataArr[indexPath.row] contentHeight]+55+([[self.dataArr[indexPath.row] comArr] count]?50:0)-(self.isUserCenter?20:0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    if (self.needBackGround) {
        NoticePyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pyCell"];
        cell.isUserCenter = self.isUserCenter;
        cell.isUserPy = self.isUserPy;
        if (self.isUserPy) {
            cell.isGoToUserCenter = YES;
        }
        cell.index = indexPath.row;
        cell.isTcPage = NO;
        cell.playerView.tag = indexPath.row;
        cell.delegate = self;
        cell.pyModel = self.dataArr[indexPath.row];
        [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
        return cell;
    }else{
        NoticeWhitePyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"whitepyCell"];
        cell.isUserPy = self.isUserPy;
        if (self.isUserPy) {
            cell.isGoToUserCenter = YES;
        }
        cell.index = indexPath.row;
        cell.isTcPage = NO;
        cell.playerView.tag = indexPath.row;
        cell.delegate = self;
        cell.pyModel = self.dataArr[indexPath.row];
        [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
        return cell;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPCUTUSMEMUSICPALY" object:nil];
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
        if (self.needBackGround) {
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
        }else{
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

@end
