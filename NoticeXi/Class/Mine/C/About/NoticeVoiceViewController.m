//
//  NoticeVoiceViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceViewController.h"
#import "NoticeClipImage.h"
#import "NoticeWhtieSelfVoiceCellCell.h"
#import "NewReplyVoiceView.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
#import "NoticeWhiteNewListCell.h"
#import "UIView+Frame.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeChoiceVoiceTimeController.h"
#import "NoticeTextVoiceDetailController.h"
@interface NoticeVoiceViewController ()<NoticeWhiteNewVoiceListClickDelegate,NoticeRecordDelegate,NewSendTextDelegate,NoticeWhiteSelfVoiceListClickDelegate>
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) NoticeVoiceChoiceView *typeChoiceView;
@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL hasNewChoice;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger shareType;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *mon;
@property (nonatomic, strong) NSString *fromDay;
@property (nonatomic, strong) NSString *toDay;
@property (nonatomic, assign) NSInteger voiceType;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, strong) UILabel *choiceLabel;
@property (nonatomic, strong) UIImageView *choiceImageV;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation NoticeVoiceViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[NoticeWhtieSelfVoiceCellCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NoticeWhiteNewListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);

    self.navigationItem.title = self.navName?self.navName: [NoticeTools getLocalStrWith:@"yl.xinqing"];
    self.needBackGroundView = YES;
    
    self.dataArr = [[NSMutableArray alloc] init];

    [self createRefesh];
    self.isDown = YES;
    [self.tableView.mj_header beginRefreshing];

    if (self.isDate) {
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }
    if (self.isTietie) {
        self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
    }
}

- (void)refreshList{
    self.isDown = YES;
    [self request];
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
- (void)createRefesh{
    
    __weak NoticeVoiceViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
    
     //设置颜色
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

- (void)request{

    NSString *url = nil;

    if (self.isDown) {
        [self reSetPlayerData];
        if (self.isDate) {//按日历查心情
            url = [NSString stringWithFormat:@"users/voices/calendar/%@?pageNo=1",self.dateName];
        }
        if (self.isTietie) {
            url = @"users/collection/voices?pageNo=1";
        }
    }else{
        if (self.isDate) {
            url = [NSString stringWithFormat:@"users/voices/calendar/%@?pageNo=%ld",self.dateName,self.pageNo];
        }
        if (self.isTietie) {
            url = [NSString stringWithFormat:@"users/collection/voices?pageNo=%ld",self.pageNo];
        }
    }

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.isTietie?@"application/vnd.shengxi.v5.4.9+json": @"application/vnd.shengxi.v5.4.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                if (model.content_type.intValue == 2 && model.title) {
                    model.voice_content = [NSString stringWithFormat:@"%@\n%@",model.title,model.voice_content];
                }
                [self.dataArr addObject:model];
                hasNewData = YES;
            }
            
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
                self.defaultL.text = self.isTietie? [NoticeTools chinese:@"想贴贴的心情怎么还没出现" english:@"You haven't liked any post yet" japan:@"お気に入りの投稿はまだありません"]:[NoticeTools chinese:@"欸 这里空空的" english:@"Nothing yet" japan:@"まだ何もありません"];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isTietie) {
        NoticeVoiceListModel *model = self.dataArr[indexPath.row];
        if (model.is_private.boolValue && !model.statusM  && !model.topicName) {
            return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]]-54+10;
        }
        return [NoticeComTools voiceSelfCellHeight:self.dataArr[indexPath.row]];
    }
    if (indexPath.row <= self.dataArr.count-1) {
        NoticeVoiceListModel *model = self.dataArr[indexPath.row];
    
        return [NoticeComTools voiceCellHeight:model]-5;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isTietie) {
        NoticeWhtieSelfVoiceCellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.voiceM = self.dataArr[indexPath.row];
        cell.index = indexPath.row;
        [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
        cell.delegate = self;
        return cell;
    }
    NoticeWhiteNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.voiceM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    [cell.playerView.playButton setImage:UIImageNamed(![self.dataArr[indexPath.row] isPlaying] ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    NoticeVoiceListModel *model = self.dataArr[indexPath.row];

    if (model.content_type.intValue == 2) {
        NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
        ctl.voiceM = model;
        ctl.noPushToUserCenter = YES;

        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        ctl.reEditBlock = ^(NoticeVoiceListModel * _Nonnull voiceM) {
            NoticeVoiceListModel * choicemodel =weakSelf.dataArr[indexPath.row];
            choicemodel = voiceM;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }else{
        NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
        ctl.voiceM = model;
        ctl.noPushToUserCenter = YES;
        ctl.replySuccessBlock = ^(NSString * _Nonnull dilaNum) {
            model.dialog_num = dilaNum;
        };
        ctl.reEditBlock = ^(NoticeVoiceListModel * _Nonnull voiceM) {
            NoticeVoiceListModel * choicemodel =weakSelf.dataArr[indexPath.row];
            choicemodel = voiceM;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:NO];
    }
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
        DRLog(@"点击的不是当前视图%ld",tag);
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
        if (!weakSelf.isTietie) {
            
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
        }else{
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

- (void)clickShareVoice:(NoticeVoiceListModel *)editModel{
    [self.tableView reloadData];
}

@end
