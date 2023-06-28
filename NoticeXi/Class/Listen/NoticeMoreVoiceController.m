//
//  NoticeMoreVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2020/1/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeMoreVoiceController.h"
#import "NoticeVoiceListCell.h"
#import "NoticeUserVoiceCell.h"
#import "NoticeBackVoiceViewController.h"

@interface NoticeMoreVoiceController ()<NoticeVoiceListClickDelegate,LCActionSheetDelegate,NoticeUserVoiceClickDelegate>

@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, assign) BOOL isPush;

@end

@implementation NoticeMoreVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isCalclderVoice) {
        self.navigationItem.title = self.isOther? [NoticeTools getTextWithSim:@"Ta的电影心情" fantText:@"Ta的電影心情"]:[NoticeTools getTextWithSim:@"我的电影心情" fantText:@"我的電影心情"];
        if (self.resourceType.intValue == 2) {
            self.navigationItem.title = self.isOther? [NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"movie.hisbook"] fantText:@"Ta的書籍心情"]:[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"movie.mybook"] fantText:@"我的書籍心情"];
        }else if (self.resourceType.intValue == 3){
            self.navigationItem.title = self.isOther? [NoticeTools getTextWithSim:@"Ta的音乐心情" fantText:@"Ta的音乐心情"]:[NoticeTools getTextWithSim:@"我的音乐心情" fantText:@"我的音乐心情"];
        }
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"REFRESHUSERINFORNOTICATION" object:nil];
    }

    [self createRefesh];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"voiceCell"];
    [self.tableView registerClass:[NoticeUserVoiceCell class] forCellReuseIdentifier:@"cell"];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y, DR_SCREEN_WIDTH, 1)];
    
    [self.view addSubview:line];
    self.line = line;
    self.line.backgroundColor = GetColorWithName(VlistColor);
    [self.view bringSubviewToFront:line];
    
    if (!self.dataArr.count) {
        self.dataArr = [NSMutableArray new];
        [self.tableView.mj_header beginRefreshing];
    }else{
        NoticeVoiceListModel *model = self.dataArr[self.dataArr.count-1];
        self.lastId = model.voice_id;
        [self.tableView reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];

    [self.tableView reloadData];
}

- (void)refreshList{
    [self.tableView.mj_header beginRefreshing];
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
    if (self.choicemoreTag <= self.dataArr.count-1) {
        [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    }
    [self.tableView reloadData];
}
//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];
    if (self.choicemoreTag <= self.dataArr.count-1) {
        [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    }
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
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
}
//播放暂停
- (void)startPlayAndStop:(NSInteger)tag{
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        if (self.dataArr.count && self.oldModel) {
            NoticeVoiceListModel *oldM = self.oldModel;
            oldM.nowTime = oldM.voice_len;
            oldM.nowPro = 0;
            [self.tableView reloadData];
        }
        
        self.oldSelectIndex = tag;
        self.isReplay = YES;
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
        
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1)) {
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
         
            [weakSelf.tableView reloadData];
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

- (void)userstartRePlayer:(NSInteger)tag{
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self userstartPlayAndStop:tag];
}
- (void)userstartPlayAndStop:(NSInteger)tag{
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        if (self.dataArr.count && self.oldModel) {
            NoticeVoiceListModel *oldM = self.oldModel;
            oldM.nowTime = oldM.voice_len;
            oldM.nowPro = 0;
            [self.tableView reloadData];
        }
        
        self.oldSelectIndex = tag;
        self.isReplay = YES;
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
        NoticeUserVoiceCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voice_len.integerValue) {
            currentTime = model.voice_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1)) {
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCalclderVoice) {
        NoticeUserVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.voiceM = self.dataArr[indexPath.row];
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
        [cell.playerView.playButton setImage:GETUIImageNamed([self.dataArr[indexPath.row] isPlaying] ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        return cell;
    }else{
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
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCalclderVoice) {
        NoticeVoiceListModel *model = self.dataArr[indexPath.row];
        if (model.content_type.intValue == 2) {
            if (model.img_list.count) {
                if (model.img_list.count == 1) {
                    return 72+((model.topicName.length && model.rememberTextHeight > 34)? 19 : 0) + DR_SCREEN_WIDTH*0.448+15+model.rememberBetTextHeight+(model.titleHeight>0?23:0);
                }else if (model.img_list.count == 2){
                    return 72+((model.topicName.length && model.rememberTextHeight > 34) ? 19 : 0) + DR_SCREEN_WIDTH*0.373+15+model.rememberBetTextHeight+(model.titleHeight>0?23:0);
                }else{
                    return 72+((model.topicName.length && model.rememberTextHeight > 34)? 19 : 0) + (DR_SCREEN_WIDTH-46)/3+15+model.rememberBetTextHeight+(model.titleHeight>0?23:0);
                }
            }
            
            if ([model.resource_type isEqualToString:@"1"] || [model.resource_type isEqualToString:@"2"]) {
                return 72+ 155+model.rememberBetTextHeight;
            }
            if ([model.resource_type isEqualToString:@"3"]) {
                return 72 + 115+model.rememberBetTextHeight;
            }
            
            return 72+((model.topicName.length && model.rememberTextHeight > 34) ? 19 : 0)+model.rememberBetTextHeight+(model.titleHeight>0?23:0);
        }else{
            if (model.img_list.count) {
                if (model.img_list.count == 1) {
                    return 78+(model.topicName.length ? 19 : 0) + DR_SCREEN_WIDTH*0.448+15;
                }else if (model.img_list.count == 2){
                    return 78+(model.topicName.length ? 19 : 0) + DR_SCREEN_WIDTH*0.373+15;
                }else{
                    return 78+(model.topicName.length ? 19 : 0) + (DR_SCREEN_WIDTH-46)/3+15;
                }
            }
            
            if ([model.resource_type isEqualToString:@"1"] || [model.resource_type isEqualToString:@"2"]) {
                return 78+(model.topicName.length ? 19 : 0) + 155;
            }
            if ([model.resource_type isEqualToString:@"3"]) {
                return 78+(model.topicName.length ? 19 : 0) + 115;
            }
            
            return 78+(model.topicName.length ? 19 : 0);
        }
    }
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    return [NoticeComTools voiceCellHeight:model needFavie:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isCalclderVoice) {
        self.isPush = YES;
        NoticeVoiceListModel *model = self.dataArr[indexPath.row];
        NoticeBackVoiceViewController *ctl = [[NoticeBackVoiceViewController alloc] init];
        ctl.voiceM = model;
        [self.audioPlayer stopPlaying];
        self.isReplay = YES;
        self.oldSelectIndex = 78798;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{

    __weak NoticeMoreVoiceController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{

    if (self.isCalclderVoice) {
        NSString *url = nil;
        if (self.isDown) {
            url = [NSString stringWithFormat:@"users/%@/voices/calendar/%@",[NoticeTools getuserId],self.dataString];
        }else{
            url = [NSString stringWithFormat:@"users/%@/voices/calendar/%@?lastId=%@",[NoticeTools getuserId],self.dataString,self.lastId];
        }
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
                
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                    if (model) {
                        [self.dataArr addObject:model];
                    }
                }
                if (self.dataArr.count) {
                    NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                    self.lastId = lastM.voice_id;
                    self.tableView.tableFooterView = nil;
                }
                
                [self.tableView reloadData];
            }
        } fail:^(NSError * _Nullable error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
        return;
    }
    
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"review/users/%@/%@/%@",self.userId,self.resourceType,self.resourceId];
    }else{
        url = [NSString stringWithFormat:@"review/users/%@/%@/%@?lastId=%@",self.userId,self.resourceType,self.resourceId,self.lastId];
    }

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model) {
                    [self.dataArr addObject:model];
                }
            }
            
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
