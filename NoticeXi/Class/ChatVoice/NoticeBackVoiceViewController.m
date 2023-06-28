//
//  NoticeBackVoiceViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBackVoiceViewController.h"
#import "NoticeReplyVoiceCell.h"
@interface NoticeBackVoiceViewController ()<NoticeVoiceListClickDelegate,NoticeReplyDeleteAndPoliceDeleage,LCActionSheetDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UIView *noDataFootView;
@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, strong) UIView *cancelMarkView;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger oldtag;
@property (nonatomic, strong) NoticeVoiceChat *oldChat;
@property (nonatomic, strong) NoticeVoiceChat *choiceChat;
@end

@implementation NoticeBackVoiceViewController
{
    BOOL _needMark;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.headHeight = 33;
    
    [self.audioPlayer stopPlaying];
    
    [self.tableView registerClass:[NoticeVoiceListCell class] forCellReuseIdentifier:@"voiceCell"];
    [self.tableView registerClass:[NoticeReplyVoiceCell class] forCellReuseIdentifier:@"chatCell"];
    self.navigationItem.title =@"心情";
    
    
    self.dataArr = [NSMutableArray new];
    
    _needMark =  [NoticeTools isFirstLoginOnThisDeveiceForSX];

    _cancelMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 44)];
    _cancelMarkView.backgroundColor = GetColorWithName(VlistColor);
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 22, 22)];
    imageV.image = UIImageNamed(@"detail_info");
    [_cancelMarkView addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+11, 0, 230, 44)];
    label.textColor = GetColorWithName(VDarkTextColor);
    label.font = TWOTEXTFONTSIZE;
    label.text = GETTEXTWITE(@"mark.longtap");
    [_cancelMarkView addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-43.5, 0, 43.5, 43.5)];
    [button setImage:UIImageNamed(@"detail_close") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleHisClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelMarkView addSubview:button];
    [self createRefesh];
    if (self.needRequest || self.isManager) {
    }else{
        [self.tableView.mj_header beginRefreshing];
    }

    if (self.voiceM.voice_id || self.voiceId) {
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",self.voiceM.voice_id?self.voiceM.voice_id:self.voiceId] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                [self.tableView.mj_header beginRefreshing];
                [self.tableView reloadData];
            }
        } fail:^(NSError *error) {
            [self hideHUD];
        }];
    }
    
    self.oldSelectIndex = 6789;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
}

- (void)deleHisClick{
    [NoticeTools setMarkForClick];
    _needMark = !_needMark;
    [self.tableView reloadData];
}


- (void)requestData{
    NSString *url = nil;
    if (self.isDown) {
        url = [NSString stringWithFormat:@"voices/%@/chats",self.voiceM.voice_id];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"voices/%@/chats?lastId=%@",self.voiceM.voice_id,self.lastId];
        }else{
            url = [NSString stringWithFormat:@"voices/%@/chats",self.voiceM.voice_id];
        }
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                self.isReplay = YES;
                [self.audioPlayer pause:YES];
                self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceChat *model = [NoticeVoiceChat mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeVoiceChat *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.chat_id;
            }
            if (!self.dataArr.count) {
                if ([self.voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
                    self.tableView.tableFooterView = self.noDataFootView;
                }
            }else{
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)createRefesh{
    
    __weak NoticeBackVoiceViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestData];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl requestData];
    }];
}

- (void)startRePlayer:(NSInteger)tag{//重新播放
    [self.audioPlayer stopPlaying];
    //self.audioPlayer = nil;
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag];
}

#pragma Mark - 音频播放模块
- (void)setAleryRead:(NoticeVoiceChat *)chat{
    //chat.read_at = [self getNowTimeTimestamp];
    [self.tableView reloadData];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:[NoticeTools getNowTimeTimestamp] forKey:@"readAt"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"chats/%@/%@",chat.chat_id,chat.dialog_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            
        }
    } fail:^(NSError *error) {
    }];
}

- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section{
    if (!self.section) {
        self.voiceM.nowTime = self.voiceM.voice_len;
        self.voiceM.nowPro = 0;
        self.voiceM.isPlaying = NO;
        self.isReplay = YES;
        [self.audioPlayer stopPlaying];
        [self.tableView reloadData];
    }
    
    if (tag != self.oldtag) {
        if (self.dataArr.count && self.oldChat) {
            NoticeVoiceChat *oldM = self.oldChat;
            oldM.isPlaying = NO;
            oldM.nowPro = 0;
            oldM.nowTime = oldM.resource_len;
            [self.tableView reloadData];
        }
        self.oldtag = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }

    self.section = section;
    
    NoticeVoiceChat *model = self.dataArr[tag];
    self.oldChat = model;
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.resource_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        [self setAleryRead:model];
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:1];
        NoticeReplyVoiceCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.resource_len.integerValue) {
            currentTime = model.resource_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.resource_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            if ((model.resource_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.audioPlayer.playComplete = ^{
                [weakSelf.audioPlayer stopPlaying];
                weakSelf.isReplay = YES;
                model.isPlaying = NO;
                model.nowPro = 0;
                cell.playerView.timeLen = model.resource_len;
                //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
                [weakSelf.tableView reloadData];
            };
        }
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.resource_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        model.nowPro = currentTime/model.resource_len.floatValue;
    };
}

- (void)startRePlayAndStop:(NSInteger)tag section:(NSInteger)section{
    DRLog([NoticeTools getLocalStrWith:@"sendTextt.replay"]);
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    self.oldSelectIndex = 100500;//设置个很大 数值以免冲突
    [self startPlayAndStop:tag section:section];
}

- (void)startPlayAndStop:(NSInteger)tag{
    if (self.section) {
        [self.audioPlayer stopPlaying];
        if (self.dataArr.count && self.oldChat) {
            NoticeVoiceChat *oldM = self.oldChat;
            oldM.isPlaying = NO;
            oldM.nowPro = 0;
            oldM.nowTime = oldM.resource_len;
            [self.tableView reloadData];
        }
    }

    self.section = 0;
    
    NoticeVoiceListModel *model = self.voiceM;
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
        //weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        [weakSelf.tableView reloadData];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        NoticeVoiceListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voice_len.integerValue) {
            currentTime = model.voice_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.voice_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            if ((model.voice_len.integerValue-currentTime)<-3) {
                [weakSelf.audioPlayer stopPlaying];
            }
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            [weakSelf.tableView reloadData];
        }else{
            cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            cell.playerView.slieView.progress = currentTime/model.voice_len.floatValue;
            model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            model.nowPro = currentTime/model.voice_len.floatValue;
        }

        if (model.moveSpeed > 0) {
            [cell.playerView refreshMoveFrame:model.moveSpeed*currentTime];
        }
    };
}

- (void)beginDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag{
    self.tableView.scrollEnabled = YES;
    [self.audioPlayer pause:self.isPasue];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag{
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
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
    if (indexPath.section == 0) {
        NoticeVoiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
        cell.isNeedAllContent = YES;
        cell.worldM = self.voiceM;
        cell.playerView.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#318F91"];
        cell.playerView.timeL.textColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"];
        [cell.playerView.playButton setImage:GETUIImageNamed(self.voiceM.isPlaying ? @"btnstop" : @"btnplay") forState:UIControlStateNormal];
        cell.index = indexPath.row;
        cell.playerView.timeLen = self.voiceM.voice_len;
        cell.delegate = self;
        if ([self.voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
            [cell.buttonView refreshColor];
        }
        
        if ([self.voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
            cell.buttonView.replyBytton.enabled = NO;
        }
        //cell.buttonView.replyBytton.enabled = NO;
        if (!self.dataArr.count) {
            cell.buttonView.line.hidden = YES;
        }else{
            if (self.toUserId) {
                //CGRect frame = cell.buttonView.line.frame;
                //cell.buttonView.line.frame = CGRectMake(0, frame.origin.y, DR_SCREEN_WIDTH, 1);
            }
            
            if (_needMark) {
                cell.buttonView.line.hidden = YES;
            }else{
                cell.buttonView.line.hidden = NO;
            }
        }
       
        
        return cell;
    }else{
        NoticeReplyVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
        cell.section = indexPath.section;
        cell.chat = self.dataArr[indexPath.row];
        cell.voiceM = self.voiceM;
        cell.delegate = self;
        cell.index = indexPath.row;
        if (cell.chat.isPlaying) {
            [cell.playerView.playButton.imageView startAnimating];
        }else{
            [cell.playerView.playButton.imageView stopAnimating];
        }
        if (indexPath.row == self.dataArr.count-1) {
            cell.line.hidden = YES;
        }else{
            cell.line.hidden = NO;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NoticeVoiceChat *chat = self.dataArr[indexPath.row];
        return 123+5+5+(chat.content_type.intValue == 1?0:115);
    }
    NoticeVoiceListModel *model = self.voiceM;
    return [NoticeComTools voiceAllCellHeight:model needFavie:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if (!self.dataArr.count) {
        return 0;
    }
    
    return _needMark? 44:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return [UIView new];
    }
    return _needMark? _cancelMarkView : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    if (!self.dataArr.count) {
        return 0;
    }
    
    return _needMark? 44:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 33)];
        return view1;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 33)];
    view.backgroundColor = GetColorWithName(VBackColor);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15, 33)];
    label.font = THRETEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    label.text = GETTEXTWITE(@"chat.marks");
    [view addSubview:label];
    return view;
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
    [self.navigationController popViewControllerAnimated:YES];
}
//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self.audioPlayer stopPlaying];
    [self.navigationController popViewControllerAnimated:YES];
}
//点击更多设置私密回调
- (void)moreClickSetPriSucess{
    [self.tableView reloadData];
}

//点击更多
- (void)hasClickMoreWith:(NSInteger)tag{
 
    NoticeVoiceListModel *model = self.voiceM;
    self.choicemoreTag = tag;
    if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人
        return;
    }
    
    [self.clickMore voiceClickMoreWith:model];
    
}

- (void)longTapWithIndex:(NSInteger)index{
    NoticeVoiceChat *model = self.dataArr[index];
    self.choiceChat = model;
    __weak typeof(self) weakSelf = self;
    if ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:self.voiceM.subUserModel.userId]) {//声昔是自己的
        LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
           if (buttonIndex2 == 2){
                [weakSelf deleteModel:model tag:index];
            }
        } otherButtonTitleArray:@[[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"chat.jubao"] fantText:@"舉報"],[NoticeTools getLocalStrWith:@"py.dele"]]];
        sheet2.delegate = self;
        [sheet2 show];
    }else{
        [self deleteModel:model tag:index];
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [self jubao:self.choiceChat];
    }
}

- (void)deleteModel:(NoticeVoiceChat *)chat tag:(NSInteger)tag{

    __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet2 = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex2) {
        if (buttonIndex2 ==2 ) {
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"chats/%@",chat.chat_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    [weakSelf.dataArr removeObjectAtIndex:tag];
                    [weakSelf.tableView reloadData];
                    [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                    //对话或者悄悄话数量
                    if ([self.voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
                    
                        self.voiceM.chat_num = [NSString stringWithFormat:@"%ld",self.voiceM.chat_num.integerValue-1];
                    }else{
                    
                        self.voiceM.dialog_num = [NSString stringWithFormat:@"%ld",self.voiceM.dialog_num.integerValue-1];
                    }
                    [self.tableView reloadData];
                }
            } fail:^(NSError *error) {
                [weakSelf hideHUD];
            }];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"hh.surescdh"],[NoticeTools getLocalStrWith:@"main.sure"]]];
    [sheet2 show];
}

- (void)jubao:(NoticeVoiceChat *)chat{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = chat.dialog_id;
    juBaoView.reouceType = @"3";
    [juBaoView showView];
}

- (UIView *)noDataFootView{
    if (!_noDataFootView) {
        _noDataFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50+40)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(25, 5, 50, 50)];
        [btn setImage:UIImageNamed(@"tishi") forState:UIControlStateNormal];
        [_noDataFootView addSubview:btn];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x+15, CGRectGetMaxY(btn.frame), DR_SCREEN_WIDTH-btn.frame.origin.x-15, 40)];
        label.font = TWOTEXTFONTSIZE;
        label.numberOfLines = 2;
        label.text = GETTEXTWITE(@"chat.replays");
        label.textColor = GetColorWithName(VDarkTextColor);
        [_noDataFootView addSubview:label];
    }
    return _noDataFootView;
}
@end
