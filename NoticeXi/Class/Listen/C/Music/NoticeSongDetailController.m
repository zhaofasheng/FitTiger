//
//  NoticeSongDetailController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSongDetailController.h"
#import "FSCustomButton.h"
#import "JMDropMenu.h"
#import "NoticeVoiceListCell.h"
#import "NoticeSongController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeManager.h"
#import "NoticeHandAddSongController.h"
#import "NoticeTextVoiceController.h"
#import "NoticeSendMovieViewController.h"
#import "NoticeNewListCell.h"
#import "NoticeMusicBaseController.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
@interface NoticeSongDetailController ()<NoticewTextDelegate,NoticeNewVoiceListClickDelegate,LCActionSheetDelegate,NoticeManagerUserDelegate,NoticeRecordDelegate,NewSendTextDelegate>
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSMutableArray *hotArr;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) FSCustomButton *choiceBtn;
@property (nonatomic, assign) CGFloat offsetWithY;
@property (nonatomic, assign) BOOL oldType;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, assign) BOOL needRefresh;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) UIView *tableFoot;
@end

@implementation NoticeSongDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"music.detail"]:@"歌曲詞條";
    self.detialView = [[NoticeMovieDetail alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,130)];
    self.detialView.isSong = YES;
    if (!self.songId) {
        self.detialView.song = self.song;
    }
    
    self.detialView.delegate = self;
    self.tableView.tableHeaderView = self.detialView;
    [self requestde];
    
    self.dataArr = [NSMutableArray new];
    self.isNew = YES;
    self.oldType = YES;
    self.offsetWithY = 0;
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[NoticeNewListCell class] forCellReuseIdentifier:@"cell"];
    [self createRefesh];
    

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 42, 44);
    [backButton setTitle:@"    " forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    if ([NoticeTools isManager]) {
        FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0,44,44)];
        [btn setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"zjset_img":@"zjset_imgy") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        btn.buttonImagePosition = FSCustomButtonImagePositionRight;
        [btn setTitle:@"    " forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }

    self.needBackGroundView = YES;
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"REFREDETAILSHUSERINFORNOTICATION" object:nil];

}

- (void)refreshList{
    [self.tableView.mj_header beginRefreshing];
}

- (void)sendClick{
    NoticeSendMovieViewController *ctl = [[NoticeSendMovieViewController alloc] init];
    ctl.song = self.song;
    ctl.type = 2;
    ctl.isLongTime = YES;
    ctl.soonRecoder = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)editClick{
    if (self.passCode) {
        NoticeHandAddSongController *ctl = [[NoticeHandAddSongController alloc] init];
        ctl.isEdit = YES;
        ctl.song = self.song;
        ctl.passCode = self.passCode;
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    self.magager.type = [NoticeTools isSimpleLau]?@"编辑词条":@"編輯詞條";
    [self.magager show];
}

- (void)sureManagerClick:(NSString *)code{
    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            NoticeHandAddSongController *ctl = [[NoticeHandAddSongController alloc] init];
            ctl.isEdit = YES;
            ctl.song = self.song;
            ctl.passCode = code;
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (void)backToPageAction{
    if (!self.isFromAdd) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    __block UIViewController *pushVC;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NoticeMusicBaseController class]]) {//返回到指定界面
            pushVC = obj;
        }
    }];
    if (pushVC) {
        [self.navigationController popToViewController:pushVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (self.isFromAdd) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)openmoreClickDelegate{
    [UIView animateWithDuration:0.5 animations:^{
        self.detialView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 240+self.detialView.infoL.frame.size.height+10+30);
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)requestde{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"resources/3/%@",self.songId?self.songId: self.song.albumId] Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            self.song = [NoticeSong mj_objectWithKeyValues:dict[@"data"]];
            if (self.song.subscription) {
                self.song.subscription_id = [NSString stringWithFormat:@"%@",self.song.subscription[@"id"]];
                self.song.subscription_type = [NSString stringWithFormat:@"%@",self.song.subscription[@"subscription_type"]];
            }
            if (self.song) {
                self.detialView.song = self.song;
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 55)];
    view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:appdel.backImg?0:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 200, 25)];
    label.text = [NSString stringWithFormat:@"书歌声 %@",self.num.intValue?self.num:@""];
    if ([NoticeTools getLocalType] == 1) {
        label.text = [NSString stringWithFormat:@"Posts %@",self.num.intValue?self.num:@""];
    }else if ([NoticeTools getLocalType] == 2){
        label.text = [NSString stringWithFormat:@"内容 %@",self.num.intValue?self.num:@""];
    }
    label.font = EIGHTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [view addSubview:label];

    return view;
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
    [self reStopPlay];
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
    cell.isNoShowResouce = YES;
    if (indexPath.row <= self.dataArr.count-1) {
        cell.voiceM = self.dataArr[indexPath.row];
        cell.index = indexPath.row;
        [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
        cell.delegate = self;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= self.dataArr.count-1) {
        NoticeVoiceListModel *model = self.dataArr[indexPath.row];
        return [NoticeComTools voiceCellHeight:model] - 78;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= self.detialView.frame.size.height) {
        self.offsetWithY = offsetY;
    }else{
        self.offsetWithY = self.detialView.frame.size.height;
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

- (void)createRefesh{
    
    __weak NoticeSongDetailController *ctl = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
    
        ctl.needRefresh = YES;
        [ctl requestde];
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
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
        url = [NSString stringWithFormat:@"resources/3/%@/comment",self.song.albumId];
    }else{
        url = [NSString stringWithFormat:@"resources/3/%@/comment?sortType=1&lastId=%@",self.song.albumId,self.lastId];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.isrefreshNewToPlayer = NO;
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeMJIDModel *idM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.isDown == YES) {
                self.num = idM.total;
                self.isPushMoreToPlayer = NO;
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            BOOL hasNewData = NO;
            for (NSDictionary *dic in idM.list) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                hasNewData = YES;
            }
            
            if (self.dataArr.count) {
                NoticeVoiceListModel *lastM = self.dataArr[self.dataArr.count-1];
                self.lastId = lastM.voice_id;
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height-self.detialView.frame.size.height);
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy8");
                self.queshenView.titleStr = [NoticeTools getLocalStrWith:@"music.nopeoplesong"];
                self.tableView.tableFooterView = self.queshenView;
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
@end
