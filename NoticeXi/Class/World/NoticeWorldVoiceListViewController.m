//
//  NoticeWorldVoiceListViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/30.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeWorldVoiceListViewController.h"
#import "NoticeWhiteNewListCell.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTuiJianCareView.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
#import "NoticeTextVoiceController.h"

@interface NoticeWorldVoiceListViewController ()<NoticeWhiteNewVoiceListClickDelegate,NoticeRecordDelegate,NewSendTextDelegate>

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeader;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) UIView *leadToView;
@property (nonatomic, assign) BOOL canAutoLoad;
@property (nonatomic, assign) BOOL noData;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation NoticeWorldVoiceListViewController


- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopPlay];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.dataArr.count) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)changeSkin{
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
    self.tableView.backgroundColor = self.view.backgroundColor;
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
    chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId];
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
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.hsVoiceM.subUserModel.nick_name];
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

- (void)stopPlay{
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageNo = 1;

    self.dataArr = [NSMutableArray new];
    self.isReplay = YES;
    self.oldSelectIndex = 9999997;
    
    self.tableView.frame = CGRectMake(0,(self.isTestGround?0: NAVIGATION_BAR_HEIGHT), DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.tableView.backgroundColor =  self.view.backgroundColor;

    [self.tableView registerClass:[NoticeWhiteNewListCell class] forCellReuseIdentifier:@"cell"];
    [self.line removeFromSuperview];
    
    [self createRefesh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeleteChat:) name:@"DELETECHATENotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddChat:) name:@"ADDNotification" object:nil];
        
    if (self.isTestGround) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"REFRESHUSERINFORNOTICATION" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"GETNEWSHENGXINOTICETION" object:nil];
        
        self.view.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"main.textGround"];
   
        [self.navBarView.rightButton setImage:UIImageNamed(@"Img_sendtexts") forState:UIControlStateNormal];
        [self.navBarView.rightButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (!self.fromMain) {
            self.needBackGroundView = YES;
            self.needHideNavBar = YES;
            self.navBarView.hidden = NO;
        }else{
            self.navBarView.hidden = YES;
        }
        
        self.view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.tableView.backgroundColor = self.view.backgroundColor;
        if (!self.fromMain) {
            self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        }
    }
    
    if (self.isVoice) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"GETNEWSHENGXINOTICETION" object:nil];
    }
    
    if (self.isHotLovePlan) {
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58-BOTTOM_HEIGHT);
    }
    if (self.isSame) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"REFRESHUSERINFORNOTICATION" object:nil];
        if (!self.fromMain) {
            self.needBackGroundView = YES;
        }
 
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"my.samep"];
  
        self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        if (!self.fromMain) {
            self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        }
        self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.tableView.backgroundColor = self.view.backgroundColor;
    }
    
    if (self.isPager) {
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }
}


- (UIView *)leadToView{
    if (!_leadToView) {
        _leadToView = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-30-112, STATUS_BAR_HEIGHT, 112, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        label.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.7];
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalType]?@"Click here\n post text": @"点这可发表\n文字心情哦～";
        if ([NoticeTools getLocalType] == 2) {
            label.text = @"ここで投稿";
        }
        [_leadToView addSubview:label];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, (_leadToView.frame.size.height-24)/2, 24, 24)];
        imageV.image = UIImageNamed(@"Image_knowzjchangeyb");
        [_leadToView addSubview:imageV];
        
        _leadToView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(knowTap)];
        [_leadToView addGestureRecognizer:tap];
    }
    return _leadToView;
}

- (void)knowTap{
    [self.leadToView removeFromSuperview];
    [NoticeTools setsendFortext];
}

- (void)refreshList{
    [self.tableView.mj_header beginRefreshing];
}

- (UIView *)titleHeadView{
    if (!_titleHeadView) {
        _titleHeadView = [[UIView alloc] initWithFrame:CGRectMake(20,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 54)];
        _titleHeadView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.08];
        _titleHeadView.layer.cornerRadius = 5;
        _titleHeadView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,DR_SCREEN_WIDTH-60, 54)];
        label.font = TWOTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:self.isSame?@"my.sametost": @"text.hs"];
        label.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        label.numberOfLines = 0;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_titleHeadView.frame.size.width-5-40, 0, 43, 54)];
        [button setImage:UIImageNamed(@"Image_sendXXtm") forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(clickXX) forControlEvents:UIControlEventTouchUpInside];
        [_titleHeadView addSubview:button];
        [_titleHeadView addSubview:label];
        [self.view addSubview:_titleHeadView];
    }
    return _titleHeadView;
}

- (void)clickXX{
    if (self.isSame) {
        [NoticeTools setMarkForsameSend];
    }else{
        [NoticeTools setMarkForworldSend];
    }
    
    [self.titleHeadView removeFromSuperview];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
}

- (void)sendAction{
    NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
    ctl.isFromGround = YES;
    [self.navigationController pushViewController:ctl animated:YES];
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
        NoticeWhiteNewListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
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
    [self.audioPlayer stopPlaying];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.dataArr.count) {
        return;
    }
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.content_type.intValue == 2) {
        NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
        ctl.voiceM = model;

        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        [self.navigationController pushViewController:ctl animated:NO];
        return;
    }
    
    NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
    ctl.voiceM = model;
    ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
        model.dialog_num = dilaNum;
    };
    [self.navigationController pushViewController:ctl animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeWhiteNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row <= self.dataArr.count-1) {
        cell.isShareVoice = YES;
        cell.isHotLove = YES;
        cell.voiceM = self.dataArr[indexPath.row];
        cell.index = indexPath.row;
        [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
        cell.delegate = self;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count >= 10) {
        if (indexPath.row == self.dataArr.count-3 && self.canAutoLoad && !self.noData) {
            self.pageNo++;
            self.isDown = NO;
            [self request];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= self.dataArr.count-1) {
        NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    
        return [NoticeComTools voiceCellHeight:model]-5;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)createRefesh{
    
    __weak NoticeWorldVoiceListViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        if (ctl.isTestGround || ctl.isVoice) {
            [ctl getTopDate];
        }else{
            [ctl request];
        }
        
    }];
    // 设置颜色
    header.stateLabel.textColor = GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = GetColorWithName(VMainTextColor);
    _refreshHeader = header;
    self.tableView.mj_header = header;
    if (!self.isSpec) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //上拉
            ctl.pageNo++;
            ctl.isDown = NO;
            [ctl request];
        }];
    }
}

- (void)getTopDate{
    [self reSetPlayerData];
    if (self.isSame) {
        [self request];
        return;
    }
    self.canNotLoadNewData = YES;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices/top" Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (self.isDown == YES) {
            [self.dataArr removeAllObjects];
            self.isDown = NO;
        }
        if (success) {
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                model.topAt = @"4567890";
                model.isTop = YES;
                self.lastId = model.voice_id;
                [self.dataArr addObject:model];
            }
        }
        if (!self.dataArr.count) {
            self.isDown = YES;
        }
        [self request];
    } fail:^(NSError * _Nullable error) {
        if (self.isDown == YES) {
            self.isPushMoreToPlayer = NO;
            [self.dataArr removeAllObjects];
            self.isDown = NO;
        }
        if (!self.dataArr.count) {
            self.isDown = YES;
        }
        [self request];
    }];
}

- (void)request{
    NSString *url = nil;
    if (self.isDown) {
        [self reSetPlayerData];
        url = @"getMeet/voices?pageNo=1";
        if (self.isTestGround) {
            url = @"getTextSquare/voices?pageNo=1";
        }
        if (self.isHotLovePlan) {
            url = [NSString stringWithFormat:@"admin/warm/voices?confirmPasswd=%@&pageNo=1",self.passWd];
            if (self.isHotLovePlanMark) {
                url = [NSString stringWithFormat:@"admin/warm/getMarkVoice?confirmPasswd=%@&pageNo=1",self.passWd];
            }
        }
        if (self.isSame) {
            url = @"voice/getMutual?pageNo=1";
        }
        if (self.isVoice) {
            url = @"voices/list?pageNo=1";
        }
    }else{
        
        if (!self.canAutoLoad && self.pageNo != 1) {//接口正在加载中，无需重复请求
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        self.canAutoLoad = NO;
        
        url = [NSString stringWithFormat:@"%@?pageNo=%ld", @"getMeet/voices",self.pageNo];
        if (self.isTestGround) {
            url = [NSString stringWithFormat:@"getTextSquare/voices?pageNo=%ld",self.pageNo];
        }
        if (self.isHotLovePlan) {
            url = [NSString stringWithFormat:@"admin/warm/voices?confirmPasswd=%@&pageNo=%ld",self.passWd,self.pageNo];
            if (self.isHotLovePlanMark) {
                url = [NSString stringWithFormat:@"admin/warm/getMarkVoice?confirmPasswd=%@&pageNo=%ld",self.passWd,self.pageNo];
            }
        }
        if (self.isSame) {
            url = [NSString stringWithFormat:@"voice/getMutual?pageNo=%ld",self.pageNo];
        }
        if (self.isVoice) {
            url = [NSString stringWithFormat:@"voices/list?pageNo=%ld",self.pageNo];
        }
    }
    NSString *accet = self.isHotLovePlan?nil: @"application/vnd.shengxi.v5.1.0+json";
    if (self.isSame) {
        accet = @"application/vnd.shengxi.v5.3.0+json";
    }
    if (self.isVoice) {
        accet = @"application/vnd.shengxi.v5.2.0+json";
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accet isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isrefreshNewToPlayer = NO;
        self.canNotLoadNewData = NO;
        self.canAutoLoad = YES;
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
                BOOL isHasSame = NO;
                for (NoticeVoiceModel *hasM in self.dataArr) {
                    if ([model.voice_id isEqualToString:hasM.voice_id]) {
                        isHasSame = YES;
                        break;
                    }
                }
                if (!isHasSame) {
                    [self.dataArr addObject:model];
                }
                hasData = YES;
            }
            
            self.noData = !hasData;
            
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
                if (!self.isHotLovePlan && !self.isTestGround && !self.isSame) {
                    self.defaultL.text = [NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
                }
                if (self.isSame) {
                    self.defaultL.text = [NoticeTools chinese:@"互相欣赏的人怎么还不来" english:@"Follow more to create a stream" japan:@"もっとフォローしてストリームを作成する"];
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([NoticeComTools pareseError:error]){
            [self.noNetWorkView show];
            
        }
    }];
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

//共享或者取消共享成功
- (void)clickShareVoice:(NoticeVoiceListModel *)editModel{
    [self.tableView reloadData];
}

//屏蔽成功回调
- (void)otherPinbSuccess{
    if (self.isSame) {
        self.isDown = YES;
        [self request];
        return;
    }
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
    if (!self.dataArr.count) {
        return;
    }
    if (self.dataArr.count-1 >= self.choicemoreTag) {
        [self.dataArr removeObjectAtIndex:self.choicemoreTag];
        [self.tableView reloadData];
    }
}

//点击更多设置私密回调
- (void)moreClickSetPriSucess{
    [self.tableView reloadData];
}

- (void)moreMarkSuccess{
    [self.tableView reloadData];
}

@end
