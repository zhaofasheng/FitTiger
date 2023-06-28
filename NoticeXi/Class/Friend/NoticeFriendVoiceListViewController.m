//
//  NoticeFriendVoiceListViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/30.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeFriendVoiceListViewController.h"
#import "NoticeVoiceListCell.h"
#import "NoticeNoDataView.h"
#import "NoticeNearViewController.h"
#import "NoticeViewModel.h"
#import "NoticeSendViewController.h"
#import "NoticePickertureController.h"
#import "NoticeWebViewController.h"
@interface NoticeFriendVoiceListViewController ()<NoticeVoiceListClickDelegate,LCActionSheetDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, assign) BOOL needScroToTop;
@property (nonatomic, assign) BOOL isQuickLuyin;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation NoticeFriendVoiceListViewController
{
    CAEmitterLayer * rainEmitterLayer;
    CAEmitterCell * rainCell;
    UIView * bgView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (!_footView && !self.dataArr.count) {
        [self.tableView.mj_header beginRefreshing];
    }
 
    [self changeColor];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 115)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-345)/2, 10, 345, 95)];
    imgView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_comClock":@"Image_comClocky");
    [self.headerView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calcelColock)];
    [imgView addGestureRecognizer:tap];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
}

- (void)changeColor{
    _footView.titleImageV.image = UIImageNamed([NoticeTools isWhiteTheme]? @"synodataimage":@"synodataimagey");
    _footView.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    self.line.backgroundColor = [GetColorWithName(VlineColor) colorWithAlphaComponent:[NoticeTools getType] == 0?1:0];
    self.tableView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    self.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    [self.tableView reloadData];
    _refreshHeader.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    _refreshHeader.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
}


- (void)calcelColock{
    [self.audioPlayer stopPlaying];
    self.tableView.tableHeaderView = nil;
    //self.audioPlayer = nil;
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
}

//点击推送后回根视图
- (void)goRoot{
    if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)recesiveNotice{
    if (!self.tableView.tableHeaderView) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)stopPlay{
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.needQuickRecorder) {
        NoticeSendViewController *ctl = [[NoticeSendViewController alloc] init];
        ctl.goRecoderAndLook = YES;
        [self.navigationController pushViewController:ctl animated:NO];
        appdel.needQuickRecorder = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:@"CHANGETHEMCOLORNOTICATION" object:nil];
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"voiceCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:@"stopPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:@"stopPlayerworld" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goRoot) name:@"NOTICATIONCLOCKCLICK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recesiveNotice) name:@"NOTICATIONCLOCK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calcelColock) name:@"NOTICATIONCLOCKCANCEL" object:nil];

    if (!self.dataArr.count) {
        [self.tableView.mj_header beginRefreshing];
    }

    [self.line removeFromSuperview];
    
    if ([NoticeTools isOpenVoice]) {
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 100)];
        headerV.userInteractionEnabled = YES;
        UIImageView *headImageV = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-310)/2, 0, 310, 100)];
        headImageV.image = UIImageNamed(@"Image_voicelheader");
        [headerV addSubview:headImageV];
        self.tableView.tableHeaderView = headerV;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liikTap)];
        [headerV addGestureRecognizer:tap];
    }
}

- (void)liikTap{
    self.tableView.tableHeaderView = nil;
    [NoticeTools setVoiceOpenVoice];
    NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
    NoticeWeb *web = [[NoticeWeb alloc] init];
    web.html_id = @"50";
    webctl.web = web;
    [self.navigationController pushViewController:webctl animated:YES];
//    NoticePickertureController *controller = [[NoticePickertureController alloc] init];
//    controller.isheader = YES;
//    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
//                                                                    withSubType:kCATransitionFromLeft
//                                                                       duration:0.3f
//                                                                 timingFunction:kCAMediaTimingFunctionLinear
//                                                                           view:self.navigationController.view];
//    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
//    [self.navigationController pushViewController:controller animated:NO];
}


#pragma 共享和取消共享
- (void)hasClickShareWith:(NSInteger)tag{

    [self.tableView reloadData];
}

//屏蔽成功回调
- (void)otherPinbSuccess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];
    [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    [self.tableView reloadData];
}
//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];
    if (!self.dataArr.count) {
        return;
    }
    if (self.dataArr.count-1 >= self.choicemoreTag) {
        [self.dataArr removeObjectAtIndex:self.choicemoreTag];
        [self.tableView reloadData];
        if (!self.dataArr.count) {
            self.tableView.tableFooterView = self.footView;
        }
    }
}
//点击更多设置私密回调
- (void)moreClickSetPriSucess{
    [self.tableView reloadData];
}

//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
    if (tag > self.dataArr.count-1) {
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.choicemoreTag = tag;
    if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人
        return;
    }
    [self.clickMore voiceClickMoreWith:model];
    
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
        NoticeVoiceListModel *oldM = self.oldModel;
        oldM.nowTime = oldM.voice_len;
        oldM.nowPro = 0;
        [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }

    NoticeVoiceListModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.voice_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        [self addNumbers:model];
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
        if (!self.isPasue) {
            [self addNumbers:model];
        }
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
        NoticeVoiceListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voice_len.integerValue) {
            currentTime = model.voice_len.integerValue;
        }
        
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1) || (model.voice_len.intValue == 120 && [[NSString stringWithFormat:@"%.f",currentTime]integerValue] >= 118)) {
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.voice_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.audioPlayer.playComplete = ^{
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
    
                model.nowPro = 0;
                cell.playerView.timeLen = model.voice_len;
      
                [weakSelf.tableView reloadData];
                if (weakSelf.isAutoPlayer && !self.isrefreshNewToPlayer) {
                    [weakSelf nextForAssest];
                }
                if (weakSelf.isrefreshNewToPlayer) {
                    weakSelf.isrefreshNewToPlayer = NO;
                }
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.voice_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
        model.nowPro = currentTime/model.voice_len.floatValue;

        if (model.moveSpeed > 0) {
            [cell.playerView refreshMoveFrame:model.moveSpeed*currentTime];
        }
    };
}

//增加收听数
- (void)addNumbers:(NoticeVoiceListModel *)choiceModel{
    
    NoticeVoiceListModel *model = choiceModel;
    
    NSString *url = [NSString stringWithFormat:@"users/%@/voices/%@",choiceModel.subUserModel.userId,model.voice_id];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
                return;
            }
            model.played_num = [NSString stringWithFormat:@"%ld",(long)(model.played_num.integerValue+1)];
            [self.tableView reloadData];
            
        }
    } fail:^(NSError *error) {
    }];
}

#pragma 信息流助手方法

- (void)stopOrPlayerForAssest{
    if (!self.dataArr.count) {
        return;
    }
    if (self.oldSelectIndex > 200 || self.lastPlayerTag == 0) {
        self.oldSelectIndex = 0;
    }
    if (self.oldSelectIndex > self.dataArr.count-1) {
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[self.oldSelectIndex];
    if (model.content_type.intValue == 2) {
        self.lastPlayerTag++;
        [self nextForAssest];
        return;
    }
    [self startPlayAndStop:self.oldSelectIndex];
}

- (void)nextForAssest{
    if (self.isPlayFromFirst) {
        self.isPlayFromFirst = NO;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self startRePlayer:0];
        return;
    }
    if (self.stopAutoPlayerForDissapear) {
        return;
    }
    if (!self.dataArr.count) {
         return;
     }
    if (self.dataArr.count-1 <= self.lastPlayerTag+1) {//不能越界
        self.isPushMoreToPlayer = YES;
        [self.tableView.mj_footer beginRefreshing];
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[self.lastPlayerTag+1];
    if (model.content_type.intValue == 2) {
        self.lastPlayerTag++;
        [self nextForAssest];
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self startRePlayer:self.lastPlayerTag+1];

}

- (void)proForAssest{
    if (self.lastPlayerTag == 0) {
        return;
    }
    if (!self.dataArr.count) {
         return;
     }
    if (!self.lastPlayerTag) {
        self.lastPlayerTag = 1 ;
    }
    NoticeVoiceListModel *model = self.dataArr[self.lastPlayerTag-1];
    if (model.content_type.intValue == 2) {
        self.lastPlayerTag--;
        [self proForAssest];
        return;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastPlayerTag-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self startRePlayer:self.lastPlayerTag-1];
}

- (void)autoOrNoAutoForAssest{
    self.isAutoPlayer = [NoticeTools isAutoPlayer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
    cell.friendM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    cell.playerView.tag = indexPath.row;
    cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
    cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
    [cell.playerView.playButton setImage:GETUIImageNamed([self.dataArr[indexPath.row] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    if (indexPath.row == self.dataArr.count-1) {
        cell.buttonView.line.hidden = YES;
    }else{
        cell.buttonView.line.hidden = NO;
    }
    cell.playerView.timeLen = [self.dataArr[indexPath.row] voice_len];
    
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    cell.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    cell.buttonView.backgroundColor = cell.contentView.backgroundColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    return [NoticeComTools voiceCellHeight:model needFavie:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{

    __weak NoticeFriendVoiceListViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    _refreshHeader = header;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)clickChangeVoiceType:(NSInteger)type{
    [self.tableView.mj_header beginRefreshing];
}

- (void)request{

    NSString *url = nil;
    if (self.isDown) {
        [self reSetPlayerData];
        if ([NoticeTools voiceType] == 1) {
            url = @"dorm/voices?contentType=1";
        }else if ([NoticeTools voiceType] == 2){
            url = @"dorm/voices?contentType=2";
        }else{
          url =  @"dorm/voices";
        }
    }else{
        if (self.lastId) {
            if ([NoticeTools voiceType] == 1) {
                url = [NSString stringWithFormat:@"%@&lastId=%@", @"dorm/voices?contentType=1",self.lastId];
            }else if ([NoticeTools voiceType] == 2){
                url = [NSString stringWithFormat:@"%@&lastId=%@", @"dorm/voices?contentType=2",self.lastId];
            }else{
              url = [NSString stringWithFormat:@"%@?lastId=%@", @"dorm/voices",self.lastId];
            }
            
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isrefreshNewToPlayer = NO;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                self.isPushMoreToPlayer = NO;
                [self.dataArr removeAllObjects];
                self.isPushMoreToPlayer = NO;
                self.isDown = NO;
            }
            
            BOOL hasNewData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
                if (model) {
                    [self.dataArr addObject:model];
                    hasNewData = YES;
                }
            }
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
            
            if (hasNewData && self.isPushMoreToPlayer) {
                self.isPushMoreToPlayer = NO;
                [self nextForAssest];
            }
            if (self.needScroToTop) {
                self.needScroToTop = NO;
                if (self.dataArr.count) {
                  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
