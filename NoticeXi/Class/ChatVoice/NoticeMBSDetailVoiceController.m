//
//  NoticeMBSDetailVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDeatilVoiceCell.h"
#import "AudioSpectrumPlayer.h"
#import "DownloadAudioService.h"
#import "NoticeClipImage.h"
#import "NoticeVoicePinbi.h"
#import "NoticeNewChatVoiceView.h"
#import "NewReplyVoiceView.h"
#import "NoticeBingGanListView.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeZJDetailController.h"
@interface NoticeMBSDetailVoiceController ()<AudioSpectrumPlayerDelegate,NoticeNewPlayerVoiceDelegates,NoticeRecordDelegate,NewSendTextDelegate,NoticePinbiClickSuccess>
@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, assign) BOOL isPlayWithNomer;
@property (nonatomic, assign) BOOL noread;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger oldIndex;
@property (nonatomic, strong) AudioSpectrumPlayer *playerTools;
@property (nonatomic, strong) NoticeVoiceListModel *oldModel;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) NoticeNewChatVoiceView *chatView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *addL;
@property (nonatomic, strong) UIButton *addZjBtn;
@end

@implementation NoticeMBSDetailVoiceController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backGroundImageView.svagPlayer.hidden = YES;
    [self.backGroundImageView.svagPlayer stopAnimation];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    self.tableView.rowHeight = DR_SCREEN_HEIGHT;
    [self.tableView registerClass:[NoticeMbsDeatilVoiceCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.pagingEnabled = YES;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    self.oldSelectIndex = 999999;
    self.isDown = YES;
    self.dataArr = [NSMutableArray new];
    [self request];
    
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
        _chatView.reSendBlock = ^(NoticeChats * _Nonnull reChat) {
            [weakSelf reSendWith:reChat];
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
            if (self.voiceM.chat_num.intValue) {
                [self selfChatNumView];
            }
        }
    }
    if (!self.voiceM.resource && [self.voiceM.subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {
        self.addZjBtn.hidden = NO;
        [self.view addSubview:self.backView];
        if (self.voiceM.albumArr.count) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            self.addZjBtn.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:appdel.backImg?0.2:1];
            NoticeZjModel *zjM = self.voiceM.albumArr[0];
            NSString *allStr = [NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"each.hasjoinGroup"],zjM.album_name];
            self.addL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:[self.voiceM.albumArr[0] album_name] beginSize:4];
        }else{
            self.addL.text = [NoticeTools getLocalStrWith:@"nojoin.zj"];
            self.addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [self.addZjBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        }
    }
    if (self.isSelfHsBG) {
        NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        listView.voiceM = self.voiceM;
        [listView showTost];
    }
    
    if (self.autoPlay) {
        [self clickPlayeButton:0];
    }
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

- (UIButton *)addZjBtn{
    if (!_addZjBtn) {
        _addZjBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-138-20,7, 138, 36)];
        [_addZjBtn setTitle:[NoticeTools getLocalType] == 1?@"+ Add":@"+ 加到专辑" forState:UIControlStateNormal];
        if ([NoticeTools getLocalType] == 2) {
            [_addZjBtn setTitle:@"+ 添加" forState:UIControlStateNormal];
        }
        [_addZjBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _addZjBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        _addZjBtn.layer.cornerRadius = 18;
        _addZjBtn.layer.masksToBounds = YES;
        _addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [_addZjBtn addTarget:self action:@selector(addZjClick) forControlEvents:UIControlEventTouchUpInside];
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50+BOTTOM_HEIGHT)];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:appdel.backImg?0.4:1];
        
        [self.backView addSubview:_addZjBtn];
        
        self.addL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40-138, 50)];
        self.addL.font = FOURTHTEENTEXTFONTSIZE;
        self.addL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        self.addL.text = [NoticeTools getLocalStrWith:@"nojoin.zj"];
        [self.backView addSubview:self.addL];
        self.addL.userInteractionEnabled = YES;
        UITapGestureRecognizer *gotoZJDetailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zjDetailtap)];
        [self.addL addGestureRecognizer:gotoZJDetailTap];
    }
    return _addZjBtn;
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
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (weakSelf.voiceM.albumArr.count) {
            weakSelf.addZjBtn.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:appdel.backImg?0.2:1];
            NoticeZjModel *zjM = weakSelf.voiceM.albumArr[0];
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

- (NoticeVoicePinbi *)pinbTools{
    if (!_pinbTools) {
        _pinbTools = [[NoticeVoicePinbi alloc] init];
        _pinbTools.delegate = self;
    }
    return _pinbTools;
}

- (void)pinbiSucess{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreBtnClick{

    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        [self.pinbTools pinbiWithModel:_voiceM];
    }else{
        [self.clickMore voiceClickMoreWith:self.voiceM];
    }
}

- (void)moreClickEditSusscee:(NoticeVoiceListModel *)editModel{
    self.voiceM = editModel;
    [self.tableView reloadData];
    if (self.reEditBlock) {
        self.reEditBlock(editModel);
    }
}

- (void)moreClickAddToZjSucess{
    if (self.voiceM.albumArr.count) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.addZjBtn.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:appdel.backImg?0.2:1];
        NoticeZjModel *zjM = self.voiceM.albumArr[0];
        zjM.voice_num = [NSString stringWithFormat:@"%d",zjM.voice_num.intValue+1];
        NSString *allStr = [NSString stringWithFormat:@"%@ %@",[NoticeTools getLocalStrWith:@"each.hasjoinGroup"],zjM.album_name];
        self.addL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#0099E6"] setLengthString:[self.voiceM.albumArr[0] album_name] beginSize:4];
    }else{
        self.addL.text = [NoticeTools getLocalStrWith:@"nojoin.zj"];
        self.addZjBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.addZjBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }
}

//点击更多删除成功回调
- (void)moreClickDeleteSucess{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelvoiceNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selfChatNumView{
    self.toUserId = @"";
    NewReplyVoiceView *replyView = [[NewReplyVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    replyView.voiceM = self.voiceM;
    [replyView show];
}

- (void)hsRecoderView{
    self.toUserId = @"";
    [self.audioPlayer stopPlaying];
    [self.playerTools stop];
    [self playFinish];
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
    _chatView.textBlock = ^(BOOL hs) {
        [weakSelf longTapToSendText];
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


- (void)backClick{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)needStopBecauseLy{
    self.voiceM.isPlaying = NO;
    [self.audioPlayer stopPlaying];
    [self.playerTools stop];
    [self playFinish];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isAppear = YES;
    [self.tableView reloadData];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isAppear = NO;
    self.voiceM.isPlaying = NO;
    [self.audioPlayer stopPlaying];
    [self.playerTools stop];
    [self playFinish];
    [self.tableView reloadData];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;//关闭右滑返回

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//开启右滑返回
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMbsDeatilVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.noPush = YES;
    cell.isDisappear = !self.isAppear;
    cell.noPushToUserCenter = self.noPushToUserCenter;
    cell.voiceM = self.dataArr[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    __weak typeof(self) weakSelf = self;
    cell.replyClickBlock = ^(BOOL isReply) {
        [weakSelf hsRecoderView];
    };
    return cell;
}

- (void)request{
    if (self.voiceM) {
        [self.dataArr addObject:self.voiceM];
        [self.tableView reloadData];
    }
}

- (void)playerDidGenerateSpectrum:(NSArray *)spectrums{
    dispatch_async(dispatch_get_main_queue(), ^{
        //放在主线程中
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.oldSelectIndex inSection:0];
        NoticeMbsDeatilVoiceCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.spectrumView updateSpectra:spectrums withStype:ADSpectraStyleRect];
        [cell.spectrumView1 updateSpectra:spectrums withStype:ADSpectraStyleRect];
    });
}

//频谱模式播放失败的时候利用常规播放
- (void)playFailWithPath:(NSString *)path{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isPlayWithNomer = NO;
        NoticeVoiceListModel *model = self.dataArr[self.oldSelectIndex];
        model.isPasue = NO;
        model.isPlaying = YES;
        self.isReplay = NO;
        self.isPasue = NO;
        [self.tableView reloadData];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        __weak typeof(self) weakSelf = self;
        DRLog(@"备用播放");
        self.audioPlayer.playComplete = ^{
            [weakSelf playFinish];
        };
    });
}

- (void)playFinish{
    dispatch_async(dispatch_get_main_queue(), ^{
        NoticeVoiceListModel *model = self.oldModel;
        model.isPlaying = NO;
        model.isPasue = NO;
        [self.tableView reloadData];
        self.isReplay = YES;
        DRLog(@"播放停止");
    });
}

//开始播放
- (void)playStart{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isPlayWithNomer = YES;
        DRLog(@"正常播放");
        //放在主线程中
        NoticeVoiceListModel *model = self.dataArr[self.oldSelectIndex];
        model.isPasue = NO;
        model.isPlaying = YES;
        self.isReplay = NO;
        self.isPasue = NO;
        [self.tableView reloadData];
    });
}



- (void)clickPlayeButton:(NSInteger)tag{
    if (tag > self.dataArr.count-1) {
        return;
    }
    if (tag != self.oldSelectIndex) {//判断点击的是否是当前视图
        if (self.dataArr.count && self.oldModel) {
            NoticeVoiceListModel *oldM = self.oldModel;
            oldM.isPlaying = NO;
            [self.tableView reloadData];
        }
        self.oldSelectIndex = tag;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
        self.isReplay = NO;
    }
    
    NoticeVoiceListModel *model = self.dataArr[self.oldSelectIndex];
    self.oldModel = model;
    if (self.isReplay || !self.oldModel.isPlaying) {
        if (!model.isPlaying && model.isDownloading) {//如果么有播放并且已经点击了下载，不再继续执行多次下载
            DRLog(@"重复点击无效");
            return;
        }
        if (model.voice_url && model.voice_url.length) {
            model.isDownloading = YES;
            
            [DownloadAudioService downloadAudioWithUrl:model.voice_url saveDirectoryPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] fileName:[NSString stringWithFormat:@"%@%@.%@",model.subUserModel.userId,model.voice_id,[model.voice_url pathExtension]] finish:^(NSString * _Nonnull filePath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    model.isDownloading = NO;
                
                    [self.audioPlayer stopPlaying];
                    [self.playerTools playWithFileName:filePath];
                });
            } failed:^{
                model.isDownloading = NO;
            }];
        }else{
            [self showToastWithText:@"音频无效"];
        }
    }else{
        self.isPasue = !self.isPasue;
        
        if (self.isPlayWithNomer) {
            [self.playerTools pause:self.isPasue];
        }else{
            [self.audioPlayer pause:self.isPasue];
        }
        
        model.isPasue = self.isPasue;

        [self.tableView reloadData];
    }
}

- (AudioSpectrumPlayer *)playerTools{
    if (!_playerTools) {
        _playerTools = [[AudioSpectrumPlayer alloc] init];
        _playerTools.delegate = self;
    }
    return _playerTools;
}



@end
