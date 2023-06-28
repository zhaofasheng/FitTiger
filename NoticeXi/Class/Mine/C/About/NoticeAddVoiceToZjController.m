//
//  NoticeAddVoiceToZjController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/21.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddVoiceToZjController.h"
#import "NoticeWhtieSelfVoiceCellCell.h"
#import "NoticeChoiceVoiceTimeController.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
@interface NoticeAddVoiceToZjController ()<NoticeWhiteSelfVoiceListClickDelegate,NoticeRecordDelegate,NewSendTextDelegate>
@property (nonatomic, strong) NoticeVoiceChoiceView *typeChoiceView;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UILabel *choiceLabel;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, assign) NSInteger shareType;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *mon;
@property (nonatomic, strong) NSString *fromDay;
@property (nonatomic, strong) NSString *toDay;
@property (nonatomic, assign) NSInteger voiceType;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@end

@implementation NoticeAddVoiceToZjController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NoticeVoiceChoiceView *choiceView = [[NoticeVoiceChoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 460)];
    self.typeChoiceView = choiceView;
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"intro.addxqtzj"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeleteChat:) name:@"DELETECHATENotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddChat:) name:@"ADDNotification" object:nil];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    [self.tableView registerClass:[NoticeWhtieSelfVoiceCellCell class] forCellReuseIdentifier:@"cell"];

    self.dataArr = [NSMutableArray new];
    [self createRefesh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getAddChat:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.dialog_num = [NSString stringWithFormat:@"%d",voiceM.dialog_num.intValue+1];
                        [self.tableView reloadData];
                        DRLog(@"执行一次");
                        break;
                    }
                }
            }
        }
    }
}

- (void)getDeleteChat:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.dialog_num = [NSString stringWithFormat:@"%d",voiceM.dialog_num.intValue-1];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}


- (void)selfChatNumView{
    NewReplyVoiceView *replyView = [[NewReplyVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    replyView.voiceM = self.hsVoiceM;
    [replyView show];
}


- (void)clickHS:(NoticeVoiceListModel *)hsVoiceModel{
    self.hsVoiceM = hsVoiceModel;
    
    [self reSetPlayerData];
    if ([self.hsVoiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]){//自己的
        if (self.hsVoiceM.chat_num.intValue) {
            [self selfChatNumView];
        }else{
            [self showToastWithText:[NoticeTools getLocalStrWith:@"movie.nohs"]];
        }
        return;
    }

    NoticeNewChatVoiceView *chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    chatView.voiceM = self.hsVoiceM;
    chatView.userId = self.hsVoiceM.subUserModel.userId;
    chatView.chatId = self.hsVoiceM.chat_id;
    chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId];
    __weak typeof(self) weakSelf = self;
    chatView.hsBlock = ^(BOOL hs) {
        [weakSelf hs];
    };
    chatView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        NSMutableDictionary *sendDic = [NSMutableDictionary new];
        [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,weakSelf.hsVoiceM.subUserModel.userId] forKey:@"to"];
        [sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:weakSelf.hsVoiceM.voice_id forKey:@"voiceId"];
        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
        [messageDic setObject:@"2" forKey:@"dialogContentType"];
        [messageDic setObject:url forKey:@"dialogContentUri"];
        [messageDic setObject:@"0" forKey:@"dialogContentLen"];
        [sendDic setObject:messageDic forKey:@"data"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:weakSelf userInfo:@{@"voiceId":weakSelf.hsVoiceM.voice_id}];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:sendDic];
        [weakSelf.tableView reloadData];
    };
    chatView.textBlock = ^(BOOL hs) {
        [weakSelf longTapToSendText];
    };
    [chatView show];
}

- (void)reRecoderLocalVoice{
    [self hs];
}

- (void)hs{
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:GETTEXTWITE(@"chat.limit")];
    recodeView.isHS = YES;
    recodeView.needLongTap = YES;
    recodeView.hideCancel = NO;
    recodeView.delegate = self;
    recodeView.isReply = YES;
    recodeView.startRecdingNeed = YES;
    [recodeView show];
}

- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.hsVoiceM.subUserModel.nick_name];
    inputView.isReply = YES;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if ([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.hsVoiceM.subUserModel.nick_name]) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.hsVoiceM.subUserModel.nick_name], 0.9) path:pathMd5 text:str];
    }
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    //__weak typeof(self) weakSelf = self;
   // [_topController showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self.hsVoiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
            [messageDic setObject:text forKey:@"dialogContentText"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.hsVoiceM.voice_id}];
            [self.tableView reloadData];
        }else{
           // [self->_topController hideHUD];
           // [self->_topController showToastWithText:errorMessage];
        }
    }];
}

//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self.hsVoiceM.voice_id forKey:@"voiceId"];
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [weakSelf hideHUD];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.hsVoiceM.voice_id}];
            [self.tableView reloadData];
        }else{
            [weakSelf showToastWithText:Message];
            [weakSelf hideHUD];
        }
    }];
}


- (void)createRefesh{
    
    __weak NoticeAddVoiceToZjController *ctl = self;
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


- (NSString *)choiceType:(NSString *)choiceFor{
    if (self.voiceType == 1) {//语音
        choiceFor = [NSString stringWithFormat:@"%@&contentType=1",choiceFor];
        if (self.shareType == 1) {//已共享
            choiceFor = [NSString stringWithFormat:@"%@&voiceIdentity=1",choiceFor];
        }else if(self.shareType == 2){//未共享
            choiceFor = [NSString stringWithFormat:@"%@&voiceIdentity=2",choiceFor];
        }else if(self.shareType == 3){//未共享
            choiceFor = [NSString stringWithFormat:@"%@&voiceIdentity=3",choiceFor];
        }
    }else if(self.voiceType == 2){//文字
        choiceFor = [NSString stringWithFormat:@"%@&contentType=2",choiceFor];
        if (self.status) {
            choiceFor = [NSString stringWithFormat:@"%@&stateCategoryId=%@",choiceFor,self.status];
        }
    }
    return choiceFor;
}

- (void)request{

    NSString *url = nil;
    
    NSString *userId = [[NoticeSaveModel getUserInfo] user_id];
    
    NSString *choiceFor = @"";
    
    if (self.type) {
        if (self.type == 1) {//按年筛选
            choiceFor = [NSString stringWithFormat:@"&voiceYear=%@",self.year];
            choiceFor = [self choiceType:choiceFor];
        }else if (self.type == 2){//按月筛选
            choiceFor = [NSString stringWithFormat:@"&voiceMonth=%@",self.mon];
            choiceFor = [self choiceType:choiceFor];
        }else{//按日筛选
            choiceFor = [NSString stringWithFormat:@"&voiceStartDay=%@&voiceEndDay=%@",self.fromDay,self.toDay];
            choiceFor = [self choiceType:choiceFor];
        }
    }else{
        choiceFor = [self choiceType:choiceFor];
    }
    
    if (self.isDown) {
        [self reSetPlayerData];
        if (choiceFor.length) {
            url = [NSString stringWithFormat:@"users/%@/voices?moduleId=2%@&albumVoiceId=%@",userId,choiceFor,self.zjmodelId];
        }else{
            url = [NSString stringWithFormat:@"users/%@/voices?moduleId=2&albumVoiceId=%@",userId,self.zjmodelId];
        }
    }else{
        if (self.lastId) {
            if (choiceFor.length) {
                url = [NSString stringWithFormat:@"users/%@/voices?lastId=%@&moduleId=2%@&albumVoiceId=%@",userId,self.lastId,choiceFor,self.zjmodelId];
            }else{
                url = [NSString stringWithFormat:@"users/%@/voices?lastId=%@&moduleId=2&albumVoiceId=%@",userId,self.lastId,self.zjmodelId];
            }
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    }

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isrefreshNewToPlayer = NO;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
                self.isPushMoreToPlayer = NO;
            }
            BOOL hasNewData = NO;
            
            for (NSDictionary *dic in dict[@"data"]) {
                self.canLoad = YES;
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
          
                [self.dataArr addObject:model];
                hasNewData = YES;
            }
            
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
                NoticeVoiceListModel *firstM = self.dataArr[0];
                if ([NoticeTools getLocalType] == 1) {
                    self.numL.text = [NSString stringWithFormat:@"%@ hasn't been added",firstM.voiceNum];
                }else if ([NoticeTools getLocalType] == 2){
                    self.numL.text = [NSString stringWithFormat:@"%@ が追加されていません",firstM.voiceNum];
                }else{
                    self.numL.text = [NSString stringWithFormat:@"%@ %@条",@"未添加到心情",firstM.voiceNum];
                }
                
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.is_private.boolValue && !model.statusM  && !model.topicName) {
        return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]]-54+10;
    }
    return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeWhtieSelfVoiceCellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isAddToZj = YES;
    cell.albumId = self.zjmodelId;
    __weak typeof(self) weakSelf = self;
    cell.joinSuccessBlock = ^(BOOL join) {
        [weakSelf.tableView reloadData];
        if (weakSelf.joinSuccessBlock) {
            weakSelf.joinSuccessBlock(YES);
        }
    };
    cell.zjmodelId = self.zjmodelId;
    cell.voiceM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}
- (void)clickShareVoice:(NoticeVoiceListModel *)editModel{
    [self.tableView reloadData];
}
#pragma 共享和取消共享
- (void)hasClickShareWith:(NSInteger)tag{
  [self.tableView reloadData];
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
        NoticeVoiceListModel *model = self.dataArr[self.floatView.currentTag];
        if (model.content_type.intValue != 1) {
            return;
        }
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
        NoticeVoiceListModel *oldM = self.oldModel;
        oldM.nowTime = oldM.voice_len;
        oldM.nowPro = 0;
        oldM.isPlaying = NO;
        [self.tableView reloadData];
    }else{
        DRLog(@"点击的是当前视图");
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.oldModel = model;
    if (self.isReplay) {
        self.canReoadData = YES;
        appdel.floatView.voiceArr = self.dataArr.mutableCopy;
        appdel.floatView.currentTag = tag;
        appdel.floatView.currentModel = model;
        self.isReplay = NO;
        self.isPasue = NO;
        appdel.floatView.isPasue = self.isPasue;
        appdel.floatView.isReplay = YES;
        appdel.floatView.isNoRefresh = YES;
        [appdel.floatView playClick];
        [self addPlayNum:model];
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
        model.nowTime = model.voice_len;
        [weakSelf.tableView reloadData];
    };
    
    appdel.floatView.playNext = ^{
        weakSelf.canReoadData = NO;
    };
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
    appdel.floatView.playingBlock = ^(CGFloat currentTime) {
        NoticeWhtieSelfVoiceCellCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if (weakSelf.canReoadData) {
            cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            cell.playerView.slieView.progress = weakSelf.progross > 0?weakSelf.progross: currentTime/model.voice_len.floatValue;
            model.nowTime = [NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime];
            model.nowPro = currentTime/model.voice_len.floatValue;
        }else{
            cell.playerView.timeLen = model.voice_len;
            cell.playerView.slieView.progress = 0;
            model.nowPro = 0;
            model.nowTime = model.voice_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
        }
    };
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView reloadData];
}

- (UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 60)];
        _sectionView.userInteractionEnabled = YES;
        _sectionView.backgroundColor = self.view.backgroundColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 60-15-18, 200, 18)];
        self.numL = label;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        label.font = XGEightBoldFontSize;
        [_sectionView addSubview:label];
        
        UILabel *choiceL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-200, 0, 200, 60)];
        choiceL.font = TWOTEXTFONTSIZE;
        choiceL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        choiceL.textAlignment = NSTextAlignmentRight;
        choiceL.text = [NoticeTools getLocalStrWith:@"mineme.shaixuan"];
        self.choiceLabel = choiceL;
        [_sectionView addSubview:choiceL];
        choiceL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap)];
        [choiceL addGestureRecognizer:tap];
    }
    return _sectionView;
}

- (void)choiceTap{
    NoticeChoiceVoiceTimeController *ctl = [[NoticeChoiceVoiceTimeController alloc] init];
    ctl.typeChoiceView = self.typeChoiceView;
    ctl.type = self.type;
    ctl.shareType = self.shareType;
    ctl.year = self.year;
    ctl.status = self.status;
    ctl.mon = self.mon;
    ctl.fromDay = self.fromDay;
    ctl.toDay = self.toDay;
    ctl.voiceType = self.voiceType;
    __weak typeof(self) weakSelf = self;
    ctl.newViewBlock = ^(NoticeVoiceChoiceView * _Nonnull ChoiceView) {
        weakSelf.typeChoiceView = ChoiceView;
    };
    ctl.typeBlock = ^(NSInteger timeType, NSString * _Nonnull yaer, NSString * _Nonnull mon, NSString * _Nonnull fromDay, NSString * _Nonnull toDay, NSInteger voiceType, NSInteger shareType, NSString * _Nonnull status) {
        weakSelf.type = timeType;
        weakSelf.year = yaer;
        weakSelf.mon = mon;
        weakSelf.fromDay = fromDay;
        weakSelf.toDay = toDay;
        weakSelf.voiceType = voiceType;
        weakSelf.shareType = shareType;
        weakSelf.status = status;
        [weakSelf.tableView.mj_header beginRefreshing];
        
        
        NSInteger typeNum = 0;
        
        if (timeType) {
            typeNum++;
        }
        if (voiceType) {
            typeNum++;
        }
        if (shareType) {
            typeNum++;
        }
        if (status) {
            typeNum++;
        }
        if (typeNum) {
            self.choiceLabel.text = [NSString stringWithFormat:@"%@%ld",[NoticeTools getLocalStrWith:@"mineme.shaixuan"],typeNum];
        }else{
            self.choiceLabel.text = [NoticeTools getLocalStrWith:@"mineme.shaixuan"];
        }
        self.choiceLabel.textColor = [UIColor colorWithHexString:typeNum? @"#0099E6":@"#5C5F66"];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
