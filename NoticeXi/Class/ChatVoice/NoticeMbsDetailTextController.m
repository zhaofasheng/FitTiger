//
//  NoticeMbsDetailTextController.m
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMbsDetailTextController.h"
#import "NoticeMbsTextDetailCell.h"
#import "NoticeClipImage.h"
#import "NewReplyVoiceView.h"
#import "NoticeNewChatVoiceView.h"
#import "NoticeBingGanListView.h"
#import "NoticeVoicePinbi.h"
#import "NoticeZJDetailController.h"
#import "NoticeSaveVoiceTools.h"
@interface NoticeMbsDetailTextController ()<NoticeRecordDelegate,NewSendTextDelegate>
@property (nonatomic, strong) NoticeNewChatVoiceView *chatView;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) UIButton *addZjBtn;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *addL;
@end

@implementation NoticeMbsDetailTextController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.backGroundImageView.svagPlayer.hidden = YES;
    [self.backGroundImageView.svagPlayer stopAnimation];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    self.tableView.rowHeight = DR_SCREEN_HEIGHT;
    [self.tableView registerClass:[NoticeMbsTextDetailCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_backbutton") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [moreBtn setImage:UIImageNamed(@"morebuttonimg") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    
    if (self.toUserId) {
        _chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _chatView.voiceM = self.voiceM;
        _chatView.userId = self.toUserId;
        _chatView.chatId = self.voiceM.chat_id;
        _chatView.stayChat = self.stayChat;
        
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

    if (!self.voiceM.resource && [self.voiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {
        self.addZjBtn.hidden = NO;
        [self.view addSubview:self.backView];
        if (self.voiceM.albumArr.count) {
            self.addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
            [self.addZjBtn setTitleColor:[UIColor colorWithHexString:@"#737780"] forState:UIControlStateNormal];
            NoticeZjModel *zjM = self.voiceM.albumArr[0];
            NSString *allStr = [NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"each.hasjoinGroup"],zjM.album_name];
            self.addL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:[self.voiceM.albumArr[0] album_name] beginSize:4];
        }else{
            self.addL.text = [NoticeTools getLocalStrWith:@"nojoin.zj"];
            self.addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.addZjBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }
    }
    if (self.isSelfBG) {
        NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        listView.voiceM = self.voiceM;
        [listView showTost];
    }
}

- (UIButton *)addZjBtn{
    if (!_addZjBtn) {
        _addZjBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-138-20,7, 138, 36)];
        [_addZjBtn setTitle:[NoticeTools getLocalType]?@"+ Add":@"+ 加到专辑" forState:UIControlStateNormal];
        if ([NoticeTools getLocalType] == 2) {
            [_addZjBtn setTitle:@"+ 添加" forState:UIControlStateNormal];
        }
        [_addZjBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _addZjBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        _addZjBtn.layer.cornerRadius = 18;
        _addZjBtn.layer.masksToBounds = YES;
        _addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [_addZjBtn addTarget:self action:@selector(addZjClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50+BOTTOM_HEIGHT)];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50+BOTTOM_HEIGHT)];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:appdel.backImg?0.4:1];
        
        [self.backView addSubview:_addZjBtn];
        
        self.addL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40-138, 50)];
        self.addL.font = FOURTHTEENTEXTFONTSIZE;
        self.addL.textColor = [UIColor colorWithHexString:@"#737780"];
        self.addL.text = [NoticeTools getLocalStrWith:@"nojoin.zj"];
        [self.backView addSubview:self.addL];
        
        self.addL.userInteractionEnabled = YES;
        UITapGestureRecognizer *gotoZJDetailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zjDetailtap)];
        [self.addL addGestureRecognizer:gotoZJDetailTap];
    }
    return _addZjBtn;
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
        __weak typeof(self) weakSelf = self;
        NSString *str = [NoticeTools getLocalType]?[NSString stringWithFormat:@"You've added it  to[%@]，sure to add it again?",[self.voiceM.albumArr[0] album_name]]:[NSString stringWithFormat:@"你已添加到[%@]，确定继续添加吗?",[self.voiceM.albumArr[0] album_name]];
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"main.sure"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf sureAdd];
            }
        };
        [alerView showXLAlertView];
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
        if (weakSelf.voiceM.albumArr.count) {
            weakSelf.addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
            [weakSelf.addZjBtn setTitleColor:[UIColor colorWithHexString:@"#737780"] forState:UIControlStateNormal];
            NoticeZjModel *zjM = weakSelf.voiceM.albumArr[0];
            zjM.voice_num = [NSString stringWithFormat:@"%d",zjM.voice_num.intValue+1];
            NSString *allStr = [NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"each.hasjoinGroup"],zjM.album_name];
            weakSelf.addL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:[weakSelf.voiceM.albumArr[0] album_name] beginSize:4];
        }else{
            weakSelf.addL.text = [NoticeTools getLocalStrWith:@"nojoin.zj"];
            weakSelf.addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [weakSelf.addZjBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }
    };
    [_listView show];
}


- (void)moreClickAddToZjSucess{
    if (self.voiceM.albumArr.count) {
        self.addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [self.addZjBtn setTitleColor:[UIColor colorWithHexString:@"#737780"] forState:UIControlStateNormal];
        NoticeZjModel *zjM = self.voiceM.albumArr[0];
        NSString *allStr = [NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"each.hasjoinGroup"],zjM.album_name];
        self.addL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:[self.voiceM.albumArr[0] album_name] beginSize:4];
    }else{
        self.addL.text = [NoticeTools getLocalStrWith:@"nojoin.zj"];
        self.addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.addZjBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }
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
        [self recoderSureWithPath:chat.resource_url time:chat.resource_len];
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
//回声
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
                [weakSelf saveVoice:timeLength];
            }
            [weakSelf showToastWithText:Message];
            [weakSelf hideHUD];
        }
    }];
}

//缓存音频
- (void)saveVoice:(NSString *)time{
    NSMutableArray *alreadyArr = [NoticeTools gethsChatArrarychatId:[NSString stringWithFormat:@"%@%@",self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId,self.voiceM.voice_id]];
    if ([NoticeSaveVoiceTools copyItemAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:@"temporaryRadio.aac"] toPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",[NoticeSaveVoiceTools getNowTmp]]]]) {
        NoticeChatSaveModel *saveM = [[NoticeChatSaveModel alloc] init];
        saveM.pathName = [NSString stringWithFormat:@"%@.aac",[NoticeSaveVoiceTools getNowTmp]];
        saveM.voiceTimeLen = time;
        saveM.chatId = self.toUserId.length?self.toUserId:self->_voiceM.subUserModel.userId;
        saveM.saveId = [NoticeSaveVoiceTools getNowTmp];
        saveM.type = @"1";
        saveM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",[NoticeSaveVoiceTools getNowTmp]]];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMbsTextDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.noPushToUserCenter = self.noPushToUserCenter;
    cell.voiceM = self.voiceM;
    cell.noPush = YES;
    __weak typeof(self) weakSelf = self;
    cell.replyClickBlock = ^(BOOL isReply) {
        [weakSelf hsRecoderView];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT;
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
