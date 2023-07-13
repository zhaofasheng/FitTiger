//
//  NoticerTopicSearchResultNewController.m
//  NoticeXi
//
//  Created by li lei on 2020/3/31.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticerTopicSearchResultNewController.h"
#import "FSCustomButton.h"
#import "NoticeNoDataView.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeWhiteNewListCell.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
@interface NoticerTopicSearchResultNewController ()<LCActionSheetDelegate,NoticeWhiteNewVoiceListClickDelegate,NoticeRecordDelegate,NewSendTextDelegate>
@property (nonatomic, strong) FSCustomButton *likeTopicBtn;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, assign) BOOL oldType;
@property (nonatomic, strong) NoticeVoiceListModel *priModel;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, strong) UILabel *topicL;
@property (nonatomic, strong) UIView *headV;
@end

@implementation NoticerTopicSearchResultNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.topicId) {
        self.topicId = @"0";
    }
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeleteChat:) name:@"DELETECHATENotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddChat:) name:@"ADDNotification" object:nil];
}



- (void)initUI{
    
    self.dataArr = [NSMutableArray new];
    [self createRefesh];

    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48-44);
    [self.tableView registerClass:[NoticeWhiteNewListCell class] forCellReuseIdentifier:@"cell"];
    
    if (!self.fromSearch) {
        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }else{
        self.navBarView.hidden = YES;
    }
    
    self.oldType = YES;
    self.isNew = YES;
    self.page = 1;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30+6+17+10)];
    self.tableView.tableHeaderView = headerView;
    self.headV = headerView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,10, 20, 20)];
    imageView.image = UIImageNamed(@"Image_huatitu");
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+2, 10, DR_SCREEN_WIDTH-20-20-20-2, 20)];
    label.text = self.topicName;
    label.font = XGSIXBoldFontSize;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    [headerView addSubview:label];
    self.topicL = label;
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+2,CGRectGetMaxY(label.frame)+6,200, 17)];
    self.numL.font = TWOTEXTFONTSIZE;
    self.numL.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
    [headerView addSubview:self.numL];
    

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
}

- (FSCustomButton *)likeTopicBtn{
    if(!_likeTopicBtn){
        _likeTopicBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-66-15, (self.headV.frame.size.height-24)/2, 66, 24)];
        _likeTopicBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [_likeTopicBtn setTitle:@"收藏话题" forState:UIControlStateNormal];
        [_likeTopicBtn setTitleColor:[UIColor colorWithHexString:@"#456DA0"] forState:UIControlStateNormal];
        [_likeTopicBtn setImage:UIImageNamed(@"img_sctoipc") forState:UIControlStateNormal];
        _likeTopicBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [_likeTopicBtn addTarget:self action:@selector(likeTopic) forControlEvents:UIControlEventTouchUpInside];
        [self.headV addSubview:_likeTopicBtn];
    }
    return _likeTopicBtn;
}

- (void)setTopicName:(NSString *)topicName{
    _topicName = topicName;
    self.topicL.text = topicName;
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshList{
    self.isDown = YES;
    if (!self.isNew) {
        self.page = 1;
    }
    [self request];
}

- (void)createRefesh{
    
    __weak NoticerTopicSearchResultNewController *ctl = self;
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

- (void)likeTopic{
    if(!self.topicName){
        return;
    }
    //
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.isCollection?@"2":@"1" forKey:@"type"];
    [parm setObject:self.topicName forKey:@"topicName"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topicCollection" Accept:@"application/vnd.shengxi.v5.5.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEREFRESHTOPICNOTICE" object:nil];
            self.isCollection = self.isCollection?NO:YES;
            if(self.isCollection){
                [self.likeTopicBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [self.likeTopicBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
                [self.likeTopicBtn setImage:UIImageNamed(@"img_sctoipcn") forState:UIControlStateNormal];
            }else{
                [self.likeTopicBtn setTitle:@"收藏话题" forState:UIControlStateNormal];
                [self.likeTopicBtn setTitleColor:[UIColor colorWithHexString:@"#456DA0"] forState:UIControlStateNormal];
                [self.likeTopicBtn setImage:UIImageNamed(@"img_sctoipc") forState:UIControlStateNormal];
            }
        }
        [self hideHUD];
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)request{
    
    NSString *url = nil;
    if (!self.topicId) {
        self.topicId = @"0";
    }

    NSString *topName = [self.topicName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]];
    if (self.isDown) {
        [self reSetPlayerData];
        url = [NSString stringWithFormat:@"topics/%@/voices?topicName=%@&sortType=1&contentType=%@",self.topicId,topName,self.isTextVoice?@"2":@"1"];
    }else{
        if (self.lastId) {
            url = [NSString stringWithFormat:@"topics/%@/voices?topicName=%@&sortType=1&lastId=%@&contentType=%@",self.topicId,topName,self.lastId,self.isTextVoice?@"2":@"1"];
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
            
            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            NSString *num = allM.total;
            NSString *str = [NSString stringWithFormat:@"%d%@",num.intValue,[NoticeTools getLocalStrWith:@"search.num"]];
            self.isCollection = allM.is_collcetion.boolValue;
            if(allM.is_collcetion.boolValue){
                [self.likeTopicBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [self.likeTopicBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
                [self.likeTopicBtn setImage:UIImageNamed(@"img_sctoipcn") forState:UIControlStateNormal];
            }else{
                [self.likeTopicBtn setTitle:@"收藏话题" forState:UIControlStateNormal];
                [self.likeTopicBtn setTitleColor:[UIColor colorWithHexString:@"#456DA0"] forState:UIControlStateNormal];
                [self.likeTopicBtn setImage:UIImageNamed(@"img_sctoipc") forState:UIControlStateNormal];
            }
            if (self.isDown == YES) {
                self.numL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:num beginSize:0];
                self.isPushMoreToPlayer = NO;
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            BOOL hasNewData = NO;
            for (NSDictionary *dic in dict[@"data"][@"list"]) {
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
                self.tableView.tableFooterView = nil;
            }else{
                self.queshenView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height);
                self.queshenView.titleImageV.image = UIImageNamed(@"Image_quesy4");
                self.queshenView.titleStr = [NoticeTools getLocalType] == 1?@" No shared moods yet":@"还没有相关话题的心情哦~";
                self.tableView.tableFooterView = self.queshenView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
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
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    if (model.content_type.intValue == 2) {
        NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
        ctl.voiceM = model;
        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }else{
        NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
        ctl.voiceM = model;
        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeWhiteNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.noPushTopic = YES;
    cell.isShareVoice = YES;
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
//共享或者取消共享成功
- (void)clickShareVoice:(NoticeVoiceListModel *)editModel{
    [self.tableView reloadData];
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
    chatView.textBlock = ^(BOOL hs) {
        [weakSelf longTapToSendText];
    };
    chatView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        NSMutableDictionary *sendDic = [NSMutableDictionary new];
        [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId] forKey:@"to"];
        [sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:self.hsVoiceM.voice_id forKey:@"voiceId"];
        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
        [messageDic setObject:@"2" forKey:@"dialogContentType"];
        [messageDic setObject:url forKey:@"dialogContentUri"];
        [messageDic setObject:@"0" forKey:@"dialogContentLen"];
        [sendDic setObject:messageDic forKey:@"data"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.hsVoiceM.voice_id}];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:sendDic];
        [weakSelf.tableView reloadData];
    };
    [chatView show];
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

- (void)reRecoderLocalVoice{
    [self hs];
}

- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.isReply = YES;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.hsVoiceM.subUserModel.nick_name];
    inputView.saveKey = [NSString stringWithFormat:@"qqchat%@%@%@",[NoticeTools getuserId],self.hsVoiceM.voice_id,self.hsVoiceM.subUserModel.userId];
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
@end
