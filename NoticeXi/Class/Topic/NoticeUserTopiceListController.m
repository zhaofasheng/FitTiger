//
//  NoticeUserTopiceListController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/23.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserTopiceListController.h"
#import "FSCustomButton.h"
#import "NoticeVoiceListCell.h"
#import "NoticeSendViewController.h"
#import "JMDropMenu.h"
#import "NoticeNoDataView.h"
#import "NoticeTextVoiceController.h"
@interface NoticeUserTopiceListController ()<NoticeVoiceListClickDelegate,LCActionSheetDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIView *buttonV;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) UIView *tableFoot;
@end

@implementation NoticeUserTopiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    
    self.tableView.frame = CGRectMake(0,56, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-56);
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"voiceCell"];

    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, DR_SCREEN_WIDTH, 44)];
    btnView.backgroundColor = GetColorWithName(VBackColor);
    [self.view addSubview:btnView];
    _buttonV = btnView;
    _numL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15-5, 44)];
    _numL.font = FOURTHTEENTEXTFONTSIZE;
    _numL.textColor = GetColorWithName(VMainTextColor);//"topic.voicenum" = "条声昔 包含此话题";
    [btnView addSubview:_numL];
//
    UIView *tableFootV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 58+BOTTOM_HEIGHT+35+10)];
    self.tableFoot = tableFootV;
    self.tableView.tableFooterView = tableFootV;
    
    UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-58)/2,DR_SCREEN_HEIGHT-58-35-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT,58, 58)];
    btnImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"send_topic_b":@"send_topic_y");
    btnImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendClick)];
    [btnImageView addGestureRecognizer:tap];
    [self.view addSubview:btnImageView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.3;
    [btnImageView addGestureRecognizer:longPress];
    
    self.canShowAssest = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestCount];
    [self.tableView.mj_header beginRefreshing];
}

- (void)longPressGestureRecognized:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (longPressState == UIGestureRecognizerStateBegan) {
        NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
        ctl.topicName = self.topicName;
        ctl.topicId = self.topicId;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)sendClick{
    __weak typeof(self) weakSelf = self;
    NoticeChoiceRecoderView *choiceView = [[NoticeChoiceRecoderView alloc] initWithShowChoiceSendType];
    choiceView.choiceTag = ^(NSInteger tag) {
        if (tag == 2) {
            NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
            ctl.topicName = self.topicName;
            ctl.topicId = self.topicId;
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }else{
            NoticeSendViewController *ctl = [[NoticeSendViewController alloc] init];
            ctl.isLongTime = tag == 1? YES:NO;
            ctl.soonRecoder = YES;
            ctl.topicName = self.topicName;
            ctl.topicId = self.topicId;
            ctl.noNeedBanner = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }
        
    };
    [choiceView showChoiceView];
}


- (void)createRefesh{
    
    __weak NoticeUserTopiceListController *ctl = self;
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
- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        [self reSetPlayerData];
        if ([NoticeTools voiceType] == 1) {
            url = [NSString stringWithFormat:@"users/%@/favorite/topics/%@/voices?contentType=1",self.userId,self.topicId];
        }else if ([NoticeTools voiceType] == 2){
            url = [NSString stringWithFormat:@"users/%@/favorite/topics/%@/voices?contentType=2",self.userId,self.topicId];
        }else{
          url = [NSString stringWithFormat:@"users/%@/favorite/topics/%@/voices",self.userId,self.topicId];
        }
        
    }else{
        if (self.lastId) {
            if ([NoticeTools voiceType] == 1) {
                url = [NSString stringWithFormat:@"users/%@/favorite/topics/%@/voices?contentType=1&lastId=%@",self.userId,self.topicId,self.lastId];
            }else if ([NoticeTools voiceType] == 2){
                url = [NSString stringWithFormat:@"users/%@/favorite/topics/%@/voices?contentType=2&lastId=%@",self.userId,self.topicId,self.lastId];
            }else{
                url = [NSString stringWithFormat:@"users/%@/favorite/topics/%@/voices&lastId=%@",self.userId,self.topicId,self.lastId];
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
            }
            [self.tableView reloadData];
            if (hasNewData && self.isPushMoreToPlayer) {
                self.isPushMoreToPlayer = NO;
                [self nextForAssest];
            }else if (!hasNewData && self.isPushMoreToPlayer){
                if (self.dataArr.count) {
                    self.isPlayFromFirst = YES;
                    [self nextForAssest];
                }
            }
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma 信息流助手方法
- (void)clickChangeVoiceType:(NSInteger)type{
    [self.tableView.mj_header beginRefreshing];
}
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
    if (!self.dataArr.count || [NoticeTools voiceType] == 2) {
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
    if (!self.dataArr.count || [NoticeTools voiceType] == 2) {
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

- (void)requestCount{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/favorite/topics/%@",self.userId,self.topicId] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            NSString *str2 = [NoticeTools isSimpleLau]?@"条心情包含此话题":@"條心情包含此話題";
            self.numL.text = [NSString stringWithFormat:@"%@  %@%@%@",self.nickName,[NoticeTools getLocalStrWith:@"groupImg.g"],[NSString stringWithFormat:@"%@",dict[@"data"][@"total"]],str2];
        }
    } fail:^(NSError *error) {
    }];
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
    [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    [self.tableView reloadData];
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
        NoticeVoiceListModel *oldM = self.oldModel;
        oldM.nowTime = oldM.voice_len;
        oldM.nowPro = 0;
        [self.tableView reloadData];
        DRLog(@"点击的不是当前视图");
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
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1)|| (model.voice_len.intValue == 120 && [[NSString stringWithFormat:@"%.f",currentTime]integerValue] >= 118)) {
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            //cell.playerView.lineImageView.frame = CGRectMake(cell.playerView.slieView.progress*cell.playerView.frame.size.width, 0, 10, cell.playerView.frame.size.width);
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            if ((model.voice_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            weakSelf.audioPlayer.playComplete = ^{
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
        cell.playerView.slieView.progress = weakSelf.progross > 0? weakSelf.progross: currentTime/model.voice_len.floatValue;
        //cell.playerView.lineImageView.frame = CGRectMake(cell.playerView.slieView.progress*cell.playerView.frame.size.width, 0, 10, cell.playerView.frame.size.width);
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
            model.played_num = [NSString stringWithFormat:@"%ld",model.played_num.integerValue+1];
            [self.tableView reloadData];
            
        }
    } fail:^(NSError *error) {
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
    
    cell.worldM = self.dataArr[indexPath.row];
    
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model) {
        cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
        [cell.playerView.playButton setImage:GETUIImageNamed(model.isPlaying ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        if ([model.topic_name isEqualToString:self.topicName]) {
            cell.topiceLabel.userInteractionEnabled = NO;
        }else{
            cell.topiceLabel.userInteractionEnabled = YES;
        }
        if (indexPath.row == self.dataArr.count-1) {
            cell.buttonView.line.hidden = YES;
        }else{
            cell.buttonView.line.hidden = NO;
        }
        cell.playerView.timeLen = model.voice_len;
        cell.index = indexPath.row;
        cell.delegate = self;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    return [NoticeComTools voiceCellHeight:model needFavie:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

@end
