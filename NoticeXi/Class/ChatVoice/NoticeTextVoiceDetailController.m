//
//  NoticeTextVoiceDetailController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextVoiceDetailController.h"
#import "NoticeNewTextVoieceCell.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeBingGanListView.h"
#import "NoticeVoicePinbi.h"
#import "NoticeZJDetailController.h"
#import "NoticeSaveVoiceTools.h"
@interface NoticeTextVoiceDetailController ()<NoticeRecordDelegate,NewSendTextDelegate>

@property (nonatomic, strong) NoticeNewChatVoiceView *chatView;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) UIView *backView;

@end

@implementation NoticeTextVoiceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noNeedReceComment = YES;
    self.backGroundImageView.svagPlayer.hidden = YES;
    [self.backGroundImageView.svagPlayer stopAnimation];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    self.tableView.rowHeight = DR_SCREEN_HEIGHT;
    [self.tableView registerClass:[NoticeNewTextVoieceCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [moreBtn setImage:UIImageNamed(@"morebuttonimgw") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    
    if (self.toUserId) {
        _chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _chatView.voiceM = self.voiceM;
        _chatView.userId = self.toUserId;
        _chatView.chatId = self.voiceM.chat_id;
        _chatView.stayChat = self.stayChat;
        self.chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.toUserId.length?self.toUserId:self.voiceM.subUserModel.userId];
        __weak typeof(self) weakSelf = self;
        _chatView.hsBlock = ^(BOOL hs) {
            [weakSelf hs];
        };
        _chatView.reSendBlock = ^(NoticeChats * _Nonnull reChat) {
            [weakSelf reSendWith:reChat];
        };
        _chatView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,weakSelf.toUserId.length?weakSelf.toUserId:weakSelf.voiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:weakSelf.voiceM.voice_id forKey:@"voiceId"];
            [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:url forKey:@"dialogContentUri"];
            [messageDic setObject:@"0" forKey:@"dialogContentLen"];
            [sendDic setObject:messageDic forKey:@"data"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:weakSelf userInfo:@{@"voiceId":weakSelf.voiceM.voice_id}];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [weakSelf.tableView reloadData];
        };
        _chatView.textBlock = ^(BOOL hs) {
            [weakSelf longTapToSendText];
        };
        _chatView.hideBlock = ^(BOOL ish) {
            weakSelf.toUserName = nil;
        };
        [_chatView show];
    }else{
        if (self.isHs) {
            [self hsRecoderView];
        }
        if (self.isSelfHs) {
            [self selfChatNumView];
        }
    }
    self.dataArr = [[NSMutableArray alloc] init];
    if (self.isSelfBG) {
        NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        listView.voiceM = self.voiceM;
        [listView showTost];
    }
    if (self.voiceM) {
        [self.dataArr addObject:self.voiceM];
        [self.tableView reloadData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNew) name:@"REFRESHUSERINFORNOTICATIONtext" object:nil];
}

- (void)requestNew{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",self.voiceM.voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
     
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            [self.dataArr removeAllObjects];
            [self.dataArr addObject:model];
            self.voiceM = model;
            self.chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.toUserId.length?self.toUserId:self.voiceM.subUserModel.userId];
            [self.tableView reloadData];
            
        }
    } fail:^(NSError *error) {
    }];
}

- (void)zjDetailtap{
    if (self.voiceM.albumArr.count) {
        NoticeZjModel *zjM = self.voiceM.albumArr[0];
        NoticeZJDetailController *ctl = [[NoticeZJDetailController alloc] init];
        ctl.zjModel = zjM;
        ctl.userId = [NoticeTools getuserId];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)addZjClick{
    if (self.voiceM.albumArr.count) {
        NoticeZjModel *zjModel = self.voiceM.albumArr[0];
        NoticeZJDetailController *ctl = [[NoticeZJDetailController alloc] init];
        ctl.zjModel = zjModel;
        ctl.userId = [NoticeTools getuserId];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        [self sureAdd];
    }
}

- (void)sureAdd{
    NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    _listView.choiceM = self.voiceM;
    __weak typeof(self) weakSelf = self;
    _listView.addSuccessBlock = ^(NoticeZjModel * _Nonnull model) {
        if (weakSelf.voiceM.albumArr.count) {
            [weakSelf.voiceM.albumArr insertObject:model atIndex:0];
        }else{
            [weakSelf.voiceM.albumArr addObject:model];
        }
        [weakSelf.tableView reloadData];
    };
    [_listView show];
}


- (void)moreClickEditSusscee:(NoticeVoiceListModel *)editModel{
    self.voiceM = editModel;
    [self.tableView reloadData];
    if (self.reEditBlock) {
        self.reEditBlock(editModel);
    }
}

- (void)selfChatNumView{
    NewReplyVoiceView *replyView = [[NewReplyVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    replyView.voiceM = self.voiceM;
    [replyView show];
}

- (void)hsRecoderView{
    if ([_voiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]){//自己的
        if (self.voiceM.chat_num.intValue) {
            [self selfChatNumView];
        }else{
            [self showToastWithText:[NoticeTools getLocalStrWith:@"movie.nohs"]];
        }
        return;
    }
    _chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    _chatView.voiceM = self.voiceM;
    _chatView.userId = self.voiceM.subUserModel.userId;
    _chatView.stayChat = self.stayChat;
    _chatView.chatId = self.voiceM.chat_id;
    _chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.toUserId.length?self.toUserId:self.voiceM.subUserModel.userId];
    __weak typeof(self) weakSelf = self;
    _chatView.hsBlock = ^(BOOL hs) {
        [weakSelf hs];
    };
    _chatView.reSendBlock = ^(NoticeChats * _Nonnull reChat) {
        [weakSelf reSendWith:reChat];
    };
    _chatView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        NSMutableDictionary *sendDic = [NSMutableDictionary new];
        [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,weakSelf.toUserId.length?weakSelf.toUserId:weakSelf.voiceM.subUserModel.userId] forKey:@"to"];
        [sendDic setObject:@"singleChat" forKey:@"flag"];
        NSMutableDictionary *messageDic = [NSMutableDictionary new];
        [messageDic setObject:weakSelf.voiceM.voice_id forKey:@"voiceId"];
        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
        [messageDic setObject:@"2" forKey:@"dialogContentType"];
        [messageDic setObject:url forKey:@"dialogContentUri"];
        [messageDic setObject:@"0" forKey:@"dialogContentLen"];
        [sendDic setObject:messageDic forKey:@"data"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:weakSelf userInfo:@{@"voiceId":weakSelf.voiceM.voice_id}];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdel.socketManager sendMessage:sendDic];
        [weakSelf.tableView reloadData];
    };
    _chatView.textBlock = ^(BOOL hs) {
        [weakSelf longTapToSendText];
    };
    [_chatView show];
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

- (void)reSendWith:(NoticeChats *)chat{
   
    if (chat.content_type.intValue == 1) {
        [self recoderSureWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:chat.resource_url] time:chat.resource_len];
    }else{
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:chat.resource_url];
        NSData *data = [fileHandle readDataToEndOfFile];
        [fileHandle closeFile];
        UIImage *image  = [[UIImage alloc] initWithData:data];
        if (!image) {
            [self showToastWithText:[NoticeTools getLocalStrWith:@"cace.noimg"]];
            return;
        }
        //UIImage转换为NSData
        NSData *imageData = UIImageJPEGRepresentation(image,0.8);//第二个参数为压缩倍数
        [self upLoadHeader:imageData path:nil text:chat.text];
    }
}

- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.isReply = YES;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",self.voiceM.subUserModel.nick_name];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if (!str) {
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:str forKey:@"keyword"];
    [parm setObject:@"2" forKey:@"type"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"getKeyword" Accept:@"application/vnd.shengxi.v5.3.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            
            UIImage *image = [NoticeClipImage clipImageWithText:aboutM.keyword fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.toUserName?self.toUserName: self.voiceM.subUserModel.nick_name];
            if (image) {
                [self upLoadHeader:UIImageJPEGRepresentation(image, 0.7) path:nil text:str];
            }
           
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
    path = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    __weak typeof(self) weakSelf = self;
   // [_topController showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            if (weakSelf.chatView.reSendChat) {
                [weakSelf.chatView deleteSave:weakSelf.chatView.reSendChat];
            }
            
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self->_voiceM.voice_id}];

        }else{
            if (!weakSelf.chatView.reSendChat) {
                [weakSelf saveImg:image str:text path:path];
            }
        }
    }];
}
//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]],[locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            if (weakSelf.chatView.reSendChat) {
                [weakSelf.chatView deleteSave:weakSelf.chatView.reSendChat];
            }
            
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self->_voiceM.voice_id}];
            if (weakSelf.replySuccessBlock) {
                weakSelf.replySuccessBlock(weakSelf.voiceM.dialog_num);
            }
        }else{
            if (!weakSelf.chatView.reSendChat) {
                [weakSelf saveVoice:timeLength path:locaPath];
            }
            [weakSelf showToastWithText:Message];
            [weakSelf hideHUD];
        }
    }];
}

//缓存音频
- (void)saveVoice:(NSString *)time path:(NSString *)path{
    NSString *voicePath = [NSString stringWithFormat:@"%@.%@",[NoticeSaveVoiceTools getNowTmp],[path pathExtension]];
    NSMutableArray *alreadyArr = [NoticeTools gethsChatArrarychatId:[NSString stringWithFormat:@"%@%@",self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId,self.voiceM.voice_id]];
    if ([NoticeSaveVoiceTools copyItemAtPath:path toPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:voicePath]]) {
        NoticeChatSaveModel *saveM = [[NoticeChatSaveModel alloc] init];
        saveM.pathName = [NSString stringWithFormat:@"%@.aac",[NoticeSaveVoiceTools getNowTmp]];
        saveM.voiceTimeLen = time;
        saveM.chatId = self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId;
        saveM.saveId = [NoticeSaveVoiceTools getNowTmp];
        saveM.type = @"1";
        saveM.voiceFilePath = voicePath;
        [alreadyArr addObject:saveM];
        [NoticeTools savehsChatArr:alreadyArr chatId:[NSString stringWithFormat:@"%@%@",self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId,self.voiceM.voice_id]];
        
        NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
        NoticeChats *locaChat = [[NoticeChats alloc] init];
        locaChat.from_user_id = selfUser.user_id;
        locaChat.content_type = saveM.type;
        locaChat.resource_url = saveM.voiceFilePath;
        locaChat.isSaveCace = YES;
        locaChat.avatar_url = selfUser.avatar_url;
        locaChat.resource_type = saveM.type;
        locaChat.resource_len = saveM.voiceTimeLen;
        locaChat.saveId = saveM.saveId;
        [self.chatView.localdataArr addObject:locaChat];
        [self.chatView.tableView reloadData];
        [self.chatView scroToBottom];
    }
}

//缓存发送失败的图片
- (void)saveImg:(NSData *)imgData str:(NSString *)text path:(NSString *)path{
    NSMutableArray *alreadyArr = [NoticeTools gethsChatArrarychatId:[NSString stringWithFormat:@"%@%@",self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId,self.voiceM.voice_id]];
    NSString *pathName = [NSString stringWithFormat:@"/%@",path];
    NSString * Pathimg = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:pathName];
    BOOL result = [imgData writeToFile:Pathimg atomically:YES];
    if (!result) {
        [self showToastWithText:@"消息缓存失败"];
        return;
    }
    NoticeChatSaveModel *saveM = [[NoticeChatSaveModel alloc] init];
    saveM.imagePath = pathName;
    saveM.chatId = self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId;
    saveM.text = text;
    saveM.saveId = [NoticeSaveVoiceTools getNowTmp];
    saveM.type = text.length? @"2":@"3";
    saveM.imgUpPath = Pathimg;
    [alreadyArr addObject:saveM];
    [NoticeTools savehsChatArr:alreadyArr chatId:[NSString stringWithFormat:@"%@%@",self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId,self.voiceM.voice_id]];
    
    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
    NoticeChats *locaChat = [[NoticeChats alloc] init];
    locaChat.from_user_id = selfUser.user_id;
    locaChat.content_type = saveM.type;
    locaChat.resource_url = saveM.imgUpPath;
    locaChat.isSaveCace = YES;
    locaChat.avatar_url = selfUser.avatar_url;
    locaChat.resource_type = saveM.type;
    locaChat.resource_len = @"456";
    locaChat.saveId = saveM.saveId;
    locaChat.text = text;
    locaChat.isText = text.length?@"1":@"0";
    [self.chatView.localdataArr addObject:locaChat];
    [self.chatView.tableView reloadData];
    [self.chatView scroToBottom];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeNewTextVoieceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.noPushToUserCenter = self.noPushToUserCenter;
    cell.voiceM = self.dataArr[indexPath.row];
    cell.noPush = YES;
    __weak typeof(self) weakSelf = self;
    cell.replyClickBlock = ^(BOOL isReply) {
        [weakSelf hsRecoderView];
    };
    cell.addToZjBlock = ^(BOOL add) {
        [weakSelf addZjClick];
    };
    return cell;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)moreBtnClick{
    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){//如果是别人的
        [self.pinbTools pinbiWithModel:_voiceM];
       
    }else{
        [self.clickMore voiceClickMoreWith:self.voiceM];
    }
}

- (NoticeVoicePinbi *)pinbTools{
    if (!_pinbTools) {
        _pinbTools = [[NoticeVoicePinbi alloc] init];
  
    }
    return _pinbTools;
}

- (void)moreClickDeleteSucess{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelvoiceNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
