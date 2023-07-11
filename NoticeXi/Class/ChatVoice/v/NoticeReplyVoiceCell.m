//
//  NoticeReplyVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeReplyVoiceCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeChatWithOtherViewController.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeNoticenterModel.h"
#import "NoticrChatLike.h"
#import "NoticeClipImage.h"
#import "NoticeNewChatVoiceView.h"
@implementation NoticeReplyVoiceCell
{
    UIButton *_button;
    UILabel *_numL;
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:0];
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
        _iconImageView.layer.cornerRadius = 30/2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
                
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+7, 15,(DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-10)/2+50, 20)];
        _nickNameL.font = FOURTHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:_nickNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,CGRectGetMaxY(_nickNameL.frame)+6,(DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-12)/2-25, 11)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:_timeL];
     
        _sendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+7,CGRectGetMaxY(_nickNameL.frame)+6, 88, 88)];
        _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        _sendImageView.layer.cornerRadius = 5;
        _sendImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag)];
        [_sendImageView addGestureRecognizer:tapImg];
        [self.contentView addSubview:_sendImageView];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+7, CGRectGetMaxY(_nickNameL.frame)+5,125, 35)];
        _playerView.delegate = self;
        _playerView.isThird = YES;
        [self.contentView addSubview:_playerView];
        self.playerView.playButton.frame = CGRectMake(4,9/2+1,24, 24);
        [_playerView refreWithFrame];
        
        _button = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24,19, 24, 24)];
        [_button setBackgroundImage:UIImageNamed(@"Image_newhsnew") forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(listTaps) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
        
        _numL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-170, _playerView.frame.origin.y, 170, 35)];
        _numL.font = TWOTEXTFONTSIZE;
        _numL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        _numL.textAlignment = NSTextAlignmentRight;
        _numL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listTap)];
        [_numL addGestureRecognizer:tap];
        [self.contentView addSubview:_numL];
        
        self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-21, _numL.frame.origin.y-2, 21, 21)];
        self.nextImageView.image = UIImageNamed(@"sys_nextimg");
        [self.contentView addSubview:self.nextImageView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 122.5+10, DR_SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        [self.contentView addSubview:line];
        _line = line;
        
        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        longPressGesture.minimumPressDuration = 0.5f;//设置长按 时间
        [self addGestureRecognizer:longPressGesture];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.12;
        [self.playerView addGestureRecognizer:longPress];
        
    }
    return self;
}

//查看大图
- (void)bigTag{
    
    
    NSArray *array = [_chat.resource_url componentsSeparatedByString:@"?"];
    if (!array.count) {
        return;
    }
    YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];

    item.largeImageURL = [NSURL URLWithString:array[0]];
    NSArray *arr = @[item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow;
    [photoView presentFromImageView:_sendImageView toContainer:toView animated:YES completion:nil];

}

- (void)longPressGestureRecognized:(id)sender{
    if (!_chat.isPlaying) {//只有在播放或者暂停的时候才可以拖拽
        return;
    }
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag:)]) {
                [self.delegate beginDrag:self.index];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index:)]) {
                [self.delegate dragingFloat:(_chat.resource_len.floatValue/self.playerView.frame.size.width)*p.x index:self.index];
            }
            break;
        }
        default: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag:)]) {
                [self.delegate endDrag:self.index];
            }
            break;
        }
    }
}


- (void)startPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop: section:)]) {
        [self.delegate startPlayAndStop:self.index section:self.section];
    }
}

- (void)cellLongPress:(UILongPressGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {//执行一次
        if (self.delegate && [self.delegate respondsToSelector:@selector(longTapWithIndex:)]) {
            [self.delegate longTapWithIndex:self.index];
        }
    }
}

//点击头像
- (void)userInfoTap{
    if ([_chat.subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _chat.subUserModel.userId;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dissMissTap)]) {
        [self.delegate dissMissTap];
    }
}

- (void)listTap{
    NoticeNewChatVoiceView* chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    chatView.voiceM = self.voiceM;
    chatView.isBack = YES;
    chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,[self.chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.userId : self.chat.subUserModel.userId];
    chatView.userId = [_chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.userId : _chat.subUserModel.userId;
    chatView.chatId = self.voiceM.chat_id;
    __weak typeof(self) weakSelf = self;
    chatView.hsBlock = ^(BOOL hs) {
        [weakSelf replyClick];
    };
    chatView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        [weakSelf sendEmotion:url buckId:buckId];
    };
    chatView.textBlock = ^(BOOL hs) {
        [weakSelf longTapToSendText];
    };
    chatView.hideBlock = ^(BOOL ish) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(dissMissTap)]) {
            [weakSelf.delegate dissMissTap];
        }
        if (weakSelf.dissMissTapBlock) {
            weakSelf.dissMissTapBlock(YES);
        }
    };
    [chatView show];

}

- (void)listTaps{
    NoticeNewChatVoiceView* chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    chatView.voiceM = self.voiceM;
    chatView.isBack = YES;
    chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,[self.chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.userId : self.chat.subUserModel.userId];
    chatView.userId = [_chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.userId : _chat.subUserModel.userId;
    chatView.chatId = self.voiceM.chat_id;
    __weak typeof(self) weakSelf = self;
    chatView.hsBlock = ^(BOOL hs) {
        [weakSelf replyClick];
    };
    chatView.textBlock = ^(BOOL hs) {
        [weakSelf longTapToSendText];
    };
    chatView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
        [weakSelf sendEmotion:url buckId:buckId];
    };
    chatView.hideBlock = ^(BOOL ish) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(dissMissTap)]) {
            [weakSelf.delegate dissMissTap];
        }
        if (weakSelf.dissMissTapBlock) {
            weakSelf.dissMissTapBlock(YES);
        }
    };
    [chatView show];
    [chatView hsClick];

}

- (void)replyClick{

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
    [self replyClick];
}

- (void)sendEmotion:(NSString *)url buckId:(NSString *)buckId{
    //所有文件上传成功回调
    NSMutableDictionary *sendDic = [NSMutableDictionary new];
    [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,[self.chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.userId : self.chat.subUserModel.userId] forKey:@"to"];
    [sendDic setObject:@"singleChat" forKey:@"flag"];
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
    if (buckId) {
        [messageDic setObject:buckId forKey:@"bucketId"];
    }
    [messageDic setObject:@"2" forKey:@"dialogContentType"];
    [messageDic setObject:url forKey:@"dialogContentUri"];
    [messageDic setObject:@"0" forKey:@"dialogContentLen"];
    [messageDic setObject:@"" forKey:@"dialogContentText"];
    [sendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:sendDic];
    self->_chat.dialog_num =[NSString stringWithFormat:@"%ld", self->_chat.dialog_num.integerValue + 1];
    appdel.canRefresDialNum = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.voiceM.voice_id}];
    self->_numL.text =  [NSString stringWithFormat:@"查看%@条对话",self->_chat.dialog_num];
    if ([NoticeTools getLocalType] == 1) {
        self->_numL.text =  [NSString stringWithFormat:@"More %@",self->_chat.dialog_num];
    }else if ([NoticeTools getLocalType] ==2){
        self->_numL.text =  [NSString stringWithFormat:@"会話内容 %@",self->_chat.dialog_num];
    }
    
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
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,[self.chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.userId : self.chat.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [nav.topViewController hideHUD];
            self->_chat.dialog_num =[NSString stringWithFormat:@"%ld", self->_chat.dialog_num.integerValue + 1];
            self->_numL.text =  [NSString stringWithFormat:@"查看%@条对话",self->_chat.dialog_num];
            if ([NoticeTools getLocalType] == 1) {
                self->_numL.text =  [NSString stringWithFormat:@"More %@",self->_chat.dialog_num];
            }else if ([NoticeTools getLocalType] ==2){
                self->_numL.text =  [NSString stringWithFormat:@"会話内容 %@",self->_chat.dialog_num];
            }
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.voiceM.voice_id}];
        }else{
            [nav.topViewController showToastWithText:Message];
            [nav.topViewController hideHUD];
        }
    }];
}


- (void)longTapToSendText{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 3000;
    inputView.delegate = self;
    inputView.saveKey = [NSString stringWithFormat:@"qqchat%@%@%@",[NoticeTools getuserId],self.voiceM.voice_id,[NSString stringWithFormat:@"%@%@",socketADD,[self.chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.userId : self.chat.subUserModel.userId]];
    inputView.isReply = YES;
    inputView.titleL.text = [NSString stringWithFormat:@"致 %@",[self.chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.nick_name : self.chat.subUserModel.nick_name];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if ([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:self.voiceM.subUserModel.nick_name]) {
        NSString *pathMd5 = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
        [self upLoadHeader:UIImageJPEGRepresentation([NoticeClipImage clipImageWithText:str fromName:[[NoticeSaveModel getUserInfo] nick_name] toName:[self.chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.nick_name : self.chat.subUserModel.nick_name], 0.9) path:pathMd5 text:str];
    }
}
- (void)upLoadHeader:(NSData *)image path:(NSString *)path text:(NSString *)text{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"11" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
   // [_topController showHUD];
    [[XGUploadDateManager sharedManager] noShowuploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,[self.chat.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]] ? self.voiceM.subUserModel.userId : self.chat.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_voiceM.voice_id forKey:@"voiceId"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [messageDic setObject:text forKey:@"dialogContentText"];
            [messageDic setObject:@"2" forKey:@"dialogContentType"];
            [messageDic setObject:errorMessage forKey:@"dialogContentUri"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",text.length] forKey:@"dialogContentLen"];
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            self->_chat.dialog_num =[NSString stringWithFormat:@"%ld", self->_chat.dialog_num.integerValue + 1];
            appdel.canRefresDialNum = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ADDNotification" object:self userInfo:@{@"voiceId":self.voiceM.voice_id}];
            self->_numL.text =  [NSString stringWithFormat:@"查看%@条对话",self->_chat.dialog_num];
            if ([NoticeTools getLocalType] == 1) {
                self->_numL.text =  [NSString stringWithFormat:@"More %@",self->_chat.dialog_num];
            }else if ([NoticeTools getLocalType] ==2){
                self->_numL.text =  [NSString stringWithFormat:@"会話内容 %@",self->_chat.dialog_num];
            }
            
        }else{
           // [self->_topController hideHUD];
           // [self->_topController showToastWithText:errorMessage];
        }
    }];
}
- (void)setChat:(NoticeVoiceChat *)chat{
    _chat = chat;
    _nickNameL.text = chat.subUserModel.nick_name;
    _timeL.text = chat.created_at;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.subUserModel.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageRefreshCached];
    _playerView.voiceUrl = chat.resource_url;
    _playerView.timeLen = chat.resource_len;
    
    self.playerView.timeLen = chat.nowTime.integerValue?chat.nowTime: chat.resource_len;
    self.playerView.slieView.progress = chat.nowPro >0 ?chat.nowPro:0;
    
    _numL.text =  [NSString stringWithFormat:@"查看%@条对话",_chat.dialog_num];
    if ([NoticeTools getLocalType] == 1) {
        _numL.text =  [NSString stringWithFormat:@"More %@",_chat.dialog_num];
    }else if ([NoticeTools getLocalType] ==2){
        _numL.text =  [NSString stringWithFormat:@"会話内容 %@",_chat.dialog_num];
    }
  
    _playerView.hidden = chat.content_type.intValue == 1?NO:YES;
    _sendImageView.hidden = (chat.content_type.intValue == 2 || chat.content_type.intValue==3)?NO:YES;
    self.linkView.hidden = chat.content_type.intValue==5?NO:YES;
    self.linkView.shareUrl = chat.share_url;
    self.linkView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+7,CGRectGetMaxY(_nickNameL.frame)+6, 175, 53);
    if (_sendImageView.isHidden) {
        _numL.frame = CGRectMake(DR_SCREEN_WIDTH-15-170, _playerView.frame.origin.y, 170, 35);
    }else{
        _numL.frame = CGRectMake(DR_SCREEN_WIDTH-15-170,CGRectGetMaxY(_sendImageView.frame)-40, 170, 35);
        if (chat.content_type.intValue == 2) {
           self.sendImageView.frame =  CGRectMake(CGRectGetMaxX(_iconImageView.frame)+7,CGRectGetMaxY(_nickNameL.frame)+6, 40, 40);
            self.sendImageView.image = UIImageNamed(@"Image_otherxinfengweidu");
        }else{
            self.sendImageView.frame =  CGRectMake(CGRectGetMaxX(_iconImageView.frame)+7,CGRectGetMaxY(_nickNameL.frame)+6, 88, 88);
            [_sendImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            }];
        }
    }
    
    if (chat.content_type.intValue == 1) {//语音
        self.timeL.frame = CGRectMake(_nickNameL.frame.origin.x, CGRectGetMaxY(self.playerView.frame)+8, (DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-12)/2-25, 17);
        self.nextImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-21, _timeL.frame.origin.y-2, 21, 21);
        _numL.frame = CGRectMake(DR_SCREEN_WIDTH-20-21-170, _timeL.frame.origin.y, 170, 17);
        
    }else{
        self.timeL.frame = CGRectMake(_nickNameL.frame.origin.x, CGRectGetMaxY(self.sendImageView.frame)+8, (DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-15-12)/2-25, 17);
        self.nextImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-21, _timeL.frame.origin.y-2, 21, 21);
        _numL.frame = CGRectMake(DR_SCREEN_WIDTH-20-21-170, _timeL.frame.origin.y, 170, 17);
    }
    self.line.frame = CGRectMake(_nickNameL.frame.origin.x, CGRectGetMaxY(self.timeL.frame)+15, DR_SCREEN_WIDTH-58-20, 0.5);
    
}

- (NoticeShareLinkCell *)linkView{
    if (!_linkView) {
        _linkView = [[NoticeShareLinkCell alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+7,CGRectGetMaxY(_nickNameL.frame)+6, 175, 53)];
        [self.contentView addSubview:_linkView];
        _linkView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _linkView.dissMissTapBlock = ^(BOOL diss) {
            if (weakSelf.dissMissTapBlock) {
                weakSelf.dissMissTapBlock(YES);
            }
        };
    }
    return _linkView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
