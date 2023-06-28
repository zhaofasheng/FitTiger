//
//  NoticeMusicBaseController.m
//  NoticeXi
//
//  Created by li lei on 2020/5/8.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeMusicBaseController.h"
#import "NoticeSearchSongController.h"
#import "NoticeSongDetail.h"
#import "NoticeNewListCell.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeMySongController.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
@interface NoticeMusicBaseController ()<NoticeNewVoiceListClickDelegate,NoticeRecordDelegate,NewSendTextDelegate>
@property (nonatomic, strong) NoticeSongDetail *hotListView;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@end

@implementation NoticeMusicBaseController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hotListView = [[NoticeSongDetail alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,66+155+45+10+10-35)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeleteChat:) name:@"DELETECHATENotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddChat:) name:@"ADDNotification" object:nil];
    self.tableView.tableHeaderView = self.hotListView;
    [self.hotListView.searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.dataArr = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopPlayer" object:nil];

    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerClass:[NoticeNewListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    [self createRefesh];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"REFRESHUSERINFORNOTICATION" object:nil];
    
    [self refresh];
  
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    

    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    backV.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:appdel.backImg?0:1];
    [self.view addSubview:backV];
    
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"main.song"];

    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-32, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, 32, 32)];
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.cornerRadius = 16;
    iconImageView.layer.masksToBounds = YES;
    [self.navBarView addSubview:iconImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [iconImageView addGestureRecognizer:tap];
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[[NoticeSaveModel getUserInfo] avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    UIView *mbViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    mbViews.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [iconImageView addSubview:mbViews];
    
    self.navBarView.backgroundColor = self.hotListView.payView.backgroundColor;
    self.needHideNavBar = YES;
    self.needBackGroundView = YES;
    self.navBarView.hidden = NO;
}


- (void)searchClick{
    NoticeSearchSongController *ctl = [[NoticeSearchSongController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)iconTap{
    NoticeMySongController *ctl = [[NoticeMySongController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)refresh{
    self.isDown = YES;
    [self request];
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
        NoticeNewListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
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

//点击了悄悄话录音的时候暂停当前播放的语音
- (void)hasClickReplyWith:(NSInteger)tag{
    NoticeVoiceListModel *model = self.dataArr[tag];
    self.isReplay = YES;
    self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    model.isPlaying = NO;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.content_type.intValue == 2) {
        NoticeMbsDetailTextController *ctl = [[NoticeMbsDetailTextController alloc] init];
        ctl.voiceM = model;
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    NoticeMBSDetailVoiceController *ctl = [[NoticeMBSDetailVoiceController alloc] init];
    ctl.voiceM = model;

    ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
        model.dialog_num = dilaNum;
    };
    [self.navigationController pushViewController:ctl animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isGoToMovie = YES;
    cell.voiceM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    return [NoticeComTools voiceCellHeight:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (void)createRefesh{
    
    __weak NoticeMusicBaseController *ctl = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl request];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        [self reSetPlayerData];
        url = @"club/3/voices";
    }else{
        url = [NSString stringWithFormat:@"club/3/voices?lastId=%@",self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
     
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                self.isDown = NO;
                self.isPushMoreToPlayer = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
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

#pragma 共享和取消共享
- (void)hasClickShareWith:(NSInteger)tag{
  [self.tableView reloadData];
}

//屏蔽成功回调
- (void)otherPinbSuccess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self reStopPlay];
    [self.dataArr removeObjectAtIndex:self.choicemoreTag];
    [self.tableView reloadData];
}
//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    [self reStopPlay];
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
@end
