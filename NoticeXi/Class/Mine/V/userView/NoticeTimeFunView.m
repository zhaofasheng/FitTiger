//
//  NoticeTimeFunView.m
//  NoticeXi
//
//  Created by li lei on 2019/5/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTimeFunView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeChatWithOtherViewController.h"
#import "NoticeBackVoiceViewController.h"
#import "NoticeNoticenterModel.h"
#import "NoticeSayToSelfController.h"
#import "NoticrChatLike.h"
#import "NoticeZjListView.h"
@implementation NoticeTimeFunView
{
    BOOL isLiuY;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:[NoticeTools isWhiteTheme]?0.6:0.7];
        UITapGestureRecognizer *fucTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funTap)];
        [self addGestureRecognizer:fucTap];
        
        MCFireworksButton *imageView1 = [[MCFireworksButton alloc] initWithFrame:CGRectMake(15,25/2,25, 25)];
        imageView1.contentMode = UIViewContentModeScaleAspectFit;
        imageView1.image = UIImageNamed(@"img_time_share");
        imageView1.particleImage = [UIImage imageNamed:@"Image_time_likec"];
        imageView1.particleScale = 0.05;
        imageView1.particleScaleRange = 0.02;
        _imageView1 = imageView1;
        [self addSubview:imageView1];
        
        NSString *str = self.isOther?[NoticeTools getTextWithSim:@"有启发" fantText:@"有啟發"]:[NoticeTools getLocalStrWith:@"em.gx"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+7, 0, GET_STRWIDTH(str, 12, 49), 49)];
        label.font = TWOTEXTFONTSIZE;
        label.textColor = [NoticeTools isWhiteTheme]?[UIColor whiteColor]:GetColorWithName(VMainTextColor);
        label.text = str;
        _label = label;
        [self addSubview:label];
        
        _listenL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-70, 29/2, 70, 20)];
        _listenL.font = ELEVENTEXTFONTSIZE;
        _listenL.textAlignment = NSTextAlignmentCenter;
        _listenL.textColor = [NoticeTools isWhiteTheme]?[UIColor whiteColor]:GetColorWithName(VMainTextColor);
        [self addSubview:_listenL];
        _listenL.layer.cornerRadius = 5;
        _listenL.layer.masksToBounds = YES;
        _listenL.layer.borderWidth = 1;
        _listenL.layer.borderColor = ([NoticeTools isWhiteTheme]?[UIColor whiteColor]:GetColorWithName(VMainTextColor)).CGColor;
        _listenL.hidden = YES;
        
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-22, 25/2, 22, 22)];
        _lockImageView.image = UIImageNamed(@"Imagelock");
        [self addSubview:_lockImageView];
        _lockImageView.hidden = YES;
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+20, 0, (DR_SCREEN_WIDTH-30)/3,49)];
        [button setTitle:GETTEXTWITE(@"voicelist.backVoice") forState:UIControlStateNormal];
        [button setTitleColor:[NoticeTools isWhiteTheme]?[UIColor whiteColor]:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        button.titleLabel.font = TWOTEXTFONTSIZE;
        [button setImage:GETUIImageNamed(@"replayButtonName") forState:UIControlStateNormal];
        _button = button;
        [self addSubview:button];
        
        self.tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetMaxX(label.frame), 49)];
        [self addSubview:self.tapView];
        
        [self.button addTarget:self action:@selector(replyHasClick) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeAndShareTap)];
        [self.tapView addGestureRecognizer:likeTap];
        
        _imageView1.image =  UIImageNamed(_isOther?@"Image_time_like":@"img_time_share");
        _label.frame = CGRectMake(CGRectGetMaxX(_imageView1.frame)+7, 0, GET_STRWIDTH(str, 12, 49), 49);
        _button.frame = CGRectMake(CGRectGetMaxX(_label.frame)+10, 0,80,49);
        self.tapView.frame = CGRectMake(0, 0,CGRectGetMaxX(_label.frame), 49);
        //[self.buttonView.firstImageView popInsideWithDuration:0.4];
        
        
        _selfButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+10, 0,88,49)];
        [_selfButton setTitle:[NoticeTools isSimpleLau]?@"  给自己留言":@"  給自己留言" forState:UIControlStateNormal];
        [_selfButton setTitleColor:[NoticeTools isWhiteTheme]?[UIColor whiteColor]:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        _selfButton.titleLabel.font = TWOTEXTFONTSIZE;
        [_selfButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"sayselfImg":@"sayselfImgy") forState:UIControlStateNormal];
        [self addSubview:_selfButton];
        _selfButton.hidden = YES;
        [_selfButton addTarget:self action:@selector(sayToSelfClick) forControlEvents:UIControlEventTouchUpInside];
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selfButton.frame)+25, 0,75, 49)];
        [_addButton setTitle:[NoticeTools isSimpleLau]?@" 加入专辑":@" 加入專輯" forState:UIControlStateNormal];
        [_addButton setTitleColor:[NoticeTools isWhiteTheme]?[UIColor whiteColor]:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        _addButton.titleLabel.font = TWOTEXTFONTSIZE;
        [_addButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"add_zjimg1":@"add_zjimg1y") forState:UIControlStateNormal];
        [self addSubview:_addButton];
        [_addButton addTarget:self action:@selector(addzjClick) forControlEvents:UIControlEventTouchUpInside];
        _addButton.hidden = YES;
    }
    return self;
}

- (void)setIsPhoto:(BOOL)isPhoto{
    _isPhoto = isPhoto;
    if (isPhoto) {
        self.selfButton.hidden = YES;
        _addButton.hidden = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
}

- (void)setCurrentModel:(NoticeVoiceListModel *)currentModel{
    _currentModel = currentModel;
  
    if (!_isOther) {
        if (_currentModel.content_type.intValue == 1 && _currentModel.length_type.intValue == 2) {
            _label.hidden = YES;
            _imageView1.hidden = YES;
            self.tapView.hidden = YES;
            _button.frame = CGRectMake(15, 0,80,49);
            
        }else{
            self.tapView.hidden = NO;
            _label.hidden = NO;
            _imageView1.hidden = NO;
            _button.frame = CGRectMake(CGRectGetMaxX(_label.frame)+10, 0,80,49);
        }
        _selfButton.frame = CGRectMake(CGRectGetMaxX(_button.frame)+10, 0,88,49);
        _addButton.frame = CGRectMake(CGRectGetMaxX(_selfButton.frame)+25, 0,75, 49);
    }
    
    if (_isPhoto) {//如果来自于相册，则直接从这里判断是否是别人的心情
        if ([currentModel.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
            self.isOther  = NO;
        }else{
            self.isOther = YES;
        }
    }

    
    if (!_isOther){//如果是自己，则是共享到世界，是别人则是共鸣
        
        if (currentModel.note_num.integerValue) {
            [_selfButton setTitle:[NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"more.saytoself"],currentModel.note_num] forState:UIControlStateNormal];
           _selfButton.frame = CGRectMake(CGRectGetMaxX(_button.frame)+15, 0,88+GET_STRWIDTH(currentModel.note_num, 12, 49),49);
        }else{
            [_selfButton setTitle:[NoticeTools getLocalStrWith:@"more.saytoself"] forState:UIControlStateNormal];
            _selfButton.frame = CGRectMake(CGRectGetMaxX(_button.frame)+15, 0,88,49);
        }
        
        if (_isPhoto) {//如果是相册查看相片，自己的相片心情存在收听数的时候
            if (currentModel.played_num.integerValue) {
                if (currentModel.is_private.integerValue) {
                    _listenL.hidden = YES;
                }else{
                   _listenL.hidden = NO;
                }
                
            }else{
                _listenL.hidden = YES;
            }
            _listenL.text = [NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"voicelist.listen"),currentModel.played_num];
            _lockImageView.hidden = !currentModel.is_private.integerValue;
            
            DRLog(@"%@",currentModel.is_private);
        }else{
            _listenL.hidden = YES;
        }
        
        if (currentModel.is_shared.boolValue) {
            self.label.text = [NoticeTools getLocalStrWith:@"group.back"];
            self.imageView1.image = UIImageNamed(@"Imagebackfrom");
        }else{
            self.label.text = [NoticeTools getLocalStrWith:@"em.gx"];
            self.imageView1.image = UIImageNamed([NoticeTools isWhiteTheme]?@"img_time_share":@"img_time_sharey");
        }
    }else{
        self.label.text = @"有启发";
        self.imageView1.image = currentModel.is_collected.boolValue?GETUIImageNamed(@"like_select"):GETUIImageNamed(@"like_default_yebtn");
    }
    //对话或者悄悄话数量
    if (!_isOther){
        if (currentModel.chat_num.integerValue) {
            [self.button setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"voicelist.backVoice"),currentModel.chat_num] forState:UIControlStateNormal];
        }else{
            [self.button setTitle:GETTEXTWITE(@"voicelist.backVoice") forState:UIControlStateNormal];
        }
    }else{
        if (currentModel.dialog_num.integerValue) {
            [self.button setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"chat.duihua"),currentModel.dialog_num] forState:UIControlStateNormal];
        }else{
            [self.button setTitle:GETTEXTWITE(@"voicelist.backVoice") forState:UIControlStateNormal];
        }
    }
}

- (void)setIsOther:(BOOL)isOther{
    _isOther = isOther;
    _selfButton.hidden = isOther?YES:NO;
    _addButton.hidden = _selfButton.hidden;
    _listenL.hidden = isOther;
    
    if (_isPhoto) {
        _addButton.hidden = YES;
        _selfButton.hidden = YES;
    }
    NSString *str = isOther?@"有启发":[NoticeTools getLocalStrWith:@"em.gx"];
    _imageView1.image = _isOther?GETUIImageNamed(@"like_select"): UIImageNamed(isOther?@"Image_time_like":@"img_time_share");
    _label.frame = CGRectMake(CGRectGetMaxX(_imageView1.frame)+7, 0, GET_STRWIDTH(str, 12, 49), 49);
    _button.frame = CGRectMake(CGRectGetMaxX(_label.frame)+10, 0,80,49);
    self.tapView.frame = CGRectMake(0, 0,CGRectGetMaxX(_label.frame), 49);
}

- (void)addzjClick{
   NoticeZjListView* _listView = [[NoticeZjListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    _listView.choiceM = _currentModel;
    [_listView show];
}

//共鸣或者共享到世界
- (void)likeAndShareTap{
    if (!_currentModel) {
        return;
    }
    //判断是否是自己,不是自己则为点击有启发
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (_isOther){
        if (_currentModel.is_collected.boolValue) {//取消有启发
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_currentModel.user_id,_currentModel.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_currentModel.is_collected = @"0";
                    [self.imageView1 popInsideWithDuration:0.4];
                    self.imageView1.image = GETUIImageNamed(@"like_default_yebtn");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelCollectionNotification" object:self userInfo:@{@"voiceId":self->_currentModel.voice_id}];
                }
            } fail:^(NSError *error) {
            }];
            
        }else{//点亮
            if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
                return;
            }
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"5" forKey:@"needDelay"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_currentModel.user_id,_currentModel.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                
                if (success) {
                    [self.imageView1 popInsideWithDuration:0.5];
                    self.imageView1.image = GETUIImageNamed(@"like_select");

                    self->_currentModel.is_collected = @"1";
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":self->_currentModel.voice_id}];
                }
            } fail:^(NSError *error) {
                [nav.topViewController hideHUD];
            }];
        }
        return;
    }
    if (_currentModel.is_private.integerValue) {
        [nav.topViewController showToastWithText:@"需要取消仅自己可见才能共享到操场哦"];
        return ;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickShareToWorld)]) {
        [self.delegate hasClickShareToWorld];
    }
    
    [nav.topViewController showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/sharenum",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if ([dict[@"data"][@"share_num"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NSString *num = [NSString stringWithFormat:@"%@",dict[@"data"][@"share_num"]];
            NSString *numStr = [NSString stringWithFormat:@"%@%@次%@",GETTEXTWITE(@"voicelist.todayt1"),num,GETTEXTWITE(@"voicelist.todayt2")];
            
            NoticeVoiceListModel *model = self->_currentModel;
            if (!num.integerValue && !model.is_shared.boolValue) {
                //[self showToastWithText:numStr];
                [nav.topViewController showToastWithText:GETTEXTWITE(@"tostas.noch")];
                return;
            }
            
            NSString *titleStr = nil;
            NSString *btnStr = nil;
            if (model.is_shared.boolValue) {
                titleStr = GETTEXTWITE(@"voicelist.offShare");
                btnStr = [NoticeTools getLocalStrWith:@"sure.comgir"];
                numStr = nil;
            }else{
                titleStr = GETTEXTWITE(@"voicelist.shareToworld");
                btnStr = GETTEXTWITE(@"voicelist.nowshanre");
            }
            
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:titleStr message:numStr sureBtn:btnStr cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    if (!model.is_shared.boolValue) {//共享到世界
                        [nav.topViewController showHUD];
                        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/share",[[NoticeSaveModel getUserInfo] user_id],model.voice_id] Accept:nil isPost:YES parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                            [nav.topViewController hideHUD];
                            if (success) {
                                model.shared_at = @"567890";
                                model.is_shared = @"1";
                                [nav.topViewController showToastWithText:@"已共享到操场"];
                                self.currentModel = model;
                            }
                        } fail:^(NSError *error) {
                            [nav.topViewController hideHUD];
                        }];
                    }
                    else{//取消共享到世界
                        [nav.topViewController showHUD];
                        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/share",[[NoticeSaveModel getUserInfo] user_id],model.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                            [nav.topViewController hideHUD];
                            if (success) {
                                model.shared_at = @"0";
                                model.is_shared = @"0";
                                [nav.topViewController showToastWithText:@"已从操场撤回"];
                                self.currentModel = model;
                            }
                        } fail:^(NSError *error) {
                            [nav.topViewController hideHUD];
                        }];
                    }
                }
            };
            [alerView showXLAlertView];
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
    
}

//给自己留言
- (void)sayToSelfClick{
    //判断是否是自己,不是自己则为点击「有启发」
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (_currentModel.note_num.integerValue) {
        NoticeSayToSelfController *ctl = [[NoticeSayToSelfController alloc] init];
        ctl.voiceId = _currentModel.voice_id;
        ctl.choiceM = _currentModel;
        __weak typeof(self) weakSelf = self;
        ctl.choiceBlock = ^(NoticeVoiceListModel * _Nonnull model) {
            [weakSelf.selfButton setTitle:[NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"more.saytoself"],model.note_num] forState:UIControlStateNormal];
            weakSelf.selfButton.frame = CGRectMake(CGRectGetMaxX(weakSelf.button.frame)+15, 0,88+GET_STRWIDTH(model.note_num, 12, 49),49);
        };
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        return;
    }
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(needStopBecauseLy)]) {
        [self.delegate needStopBecauseLy];
    }
    isLiuY = YES;
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@"留言仅自己可见"];
    recodeView.sayToSelf = YES;
    recodeView.hideCancel = NO;
    recodeView.isReply = YES;
    recodeView.delegate = self;

    [recodeView show];
}

//悄悄话
- (void)replyHasClick{
    if (!_currentModel) {
        return;
    }
    if (self.refreshBlock) {
        self.refreshBlock(YES);
    }
    
    if (!_isOther) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(needStopBecauseHS)]) {
            [self.delegate needStopBecauseHS];
        }
        NoticeBackVoiceViewController *ctl = [[NoticeBackVoiceViewController alloc] init];
        ctl.voiceM = _currentModel;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (_isPhoto) {
            ctl.navigationController.navigationBar.hidden = NO;
        }
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        _button.enabled = NO;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        if (!_currentModel.dialog_num.integerValue) {//没有对话过，则为执行对话，否则进入对话列表
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"chats/check/%@/1/%@",_currentModel.subUserModel.userId,_currentModel.voice_id] Accept:@"application/vnd.shengxi.v4.6.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                self.button.enabled = YES;
                if (success) {
                    NoticeNoticenterModel *autoM = [NoticeNoticenterModel mj_objectWithKeyValues:dict[@"data"]];
                    
                    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:GETTEXTWITE(@"chat.limit")];
                    recodeView.isHS = YES;
                    if (![dict[@"data"][@"chat_hobby"] isEqual:[NSNull null]]) {
                        NoticrChatLike *autoM1 = [NoticrChatLike mj_objectWithKeyValues:dict[@"data"][@"chat_hobby"]];
                        if ([autoM1.likeId isEqualToString:@"1"]) {
                            recodeView.isShort = YES;
                        }else if ([autoM1.likeId isEqualToString:@"2"]){
                            recodeView.isLong = YES;
                        }
                    }
                    if (autoM.chat_tips.count) {
                        NSString *str1 = @"";
                        for (NSDictionary *dic in autoM.chat_tips) {
                            NoticrChatLike *likeM = [NoticrChatLike mj_objectWithKeyValues:dic];
                            str1 = [NSString stringWithFormat:@"%@,%@",likeM.name,str1];
                        }
                        if (autoM.chat_tips.count == 2) {
                            str1 = @"NO联系方式·NO查户口";
                        }
                        if ([[str1 substringFromIndex:str1.length-1] isEqualToString:@","]) {
                            str1 = [str1 substringToIndex:str1.length-1];
                        }
                        recodeView.chatTips = str1;
                    }
                    recodeView.hideCancel = NO;
                    recodeView.isAuto = autoM.auto_reply.integerValue ? YES : NO;
                    recodeView.delegate = self;
                    recodeView.isReply = YES;
                    recodeView.iconUrl = self->_currentModel.subUserModel.avatar_url;
         
                    __weak typeof(self) weakSelf = self;
                    recodeView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId) {
                        //所有文件上传成功回调
                        NSMutableDictionary *sendDic = [NSMutableDictionary new];
                        [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self->_currentModel.subUserModel.userId] forKey:@"to"];
                        [sendDic setObject:@"singleChat" forKey:@"flag"];
                        
                        NSMutableDictionary *messageDic = [NSMutableDictionary new];
                        [messageDic setObject:self->_currentModel.voice_id forKey:@"voiceId"];
                        [messageDic setObject:@"1" forKey:@"dialogContentType"];
                        [messageDic setObject:url forKey:@"dialogContentUri"];
                        [messageDic setObject:@"0" forKey:@"dialogContentLen"];
                        [messageDic setObject:buckId?buckId:@"0" forKey:@"bucketId"];
                        [sendDic setObject:messageDic forKey:@"data"];
                        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [appdel.socketManager sendMessage:sendDic];
                        [nav.topViewController hideHUD];
                        weakSelf.currentModel.dialog_num = [NSString stringWithFormat:@"%ld",weakSelf.currentModel.dialog_num.integerValue + 1];
                        [weakSelf.button setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"chat.duihua"),self->_currentModel.dialog_num] forState:UIControlStateNormal];
                        [nav.topViewController showToastWithText:@"悄悄话已发布"];
                    };
                    [recodeView show];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(timeListHasClickReplyDelegate)]) {
                        [self.delegate timeListHasClickReplyDelegate];
                    }
                }else{
                    [nav.topViewController showToastWithText:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
                }
            } fail:^(NSError *error) {
                self.button.enabled = YES;
            }];
            
            
        }else{
            NoticeChatWithOtherViewController *ctl = [[NoticeChatWithOtherViewController alloc] init];
            ctl.voiceM = _currentModel;
            ctl.identType = _currentModel.subUserModel.identity_type;
            //ctl.noPush = YES;
            ctl.chatId = _currentModel.chat_id;
            ctl.userId = _currentModel.subUserModel.userId;
            ctl.toUserName = _currentModel.subUserModel.nick_name;
            self.button.enabled = YES;
            if (_isPhoto) {
                ctl.navigationController.navigationBar.hidden = NO;
            }
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (isLiuY) {
        isLiuY = NO;
        
        if (!locaPath) {
            [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
            return;
        }
        NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:@"13" forKey:@"resourceType"];
        [parm setObject:pathMd5 forKey:@"resourceContent"];
        
        
        [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
            
        } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
            
            if (sussess) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                if (bucketId) {
                    [parm setObject:bucketId forKey:@"bucketId"];
                }
                [parm setObject:Message forKey:@"noteUri"];
                [parm setObject:timeLength forKey:@"noteLen"];
                [nav.topViewController showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voice/%@/note",self->_currentModel.voice_id] Accept:@"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    self->_currentModel.note_num = [NSString stringWithFormat:@"%ld",self->_currentModel.note_num.integerValue+1];
                    [self->_selfButton setTitle:[NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"more.saytoself"],self->_currentModel.note_num] forState:UIControlStateNormal];
                    self->_selfButton.frame = CGRectMake(CGRectGetMaxX(self->_button.frame)+15, 0,88+GET_STRWIDTH(self->_currentModel.note_num, 12, 49),49);
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
                
            }else{
                [nav.topViewController showToastWithText:Message];
                [nav.topViewController hideHUD];
            }
        }];
        
        return;
    }
    
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeListHasClickReplySuccessDelegate)]) {
        [self.delegate timeListHasClickReplySuccessDelegate];
    }
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    

    
    __weak typeof(self) weakSelf = self;
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self->_currentModel.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self->_currentModel.voice_id forKey:@"voiceId"];
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
            [nav.topViewController hideHUD];
            weakSelf.currentModel.dialog_num = [NSString stringWithFormat:@"%ld",weakSelf.currentModel.dialog_num.integerValue + 1];
            [weakSelf.button setTitle:[NSString stringWithFormat:@"%@ %@",GETTEXTWITE(@"chat.duihua"),self->_currentModel.dialog_num] forState:UIControlStateNormal];
            [nav.topViewController showToastWithText:@"悄悄话已发布"];
          //  [self loadeSx];
        }else{
            [nav.topViewController showToastWithText:Message];
            [nav.topViewController hideHUD];
        }
    }];
}
- (void)loadeSx{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@/%@",_currentModel.subUserModel.userId,_currentModel.voice_id] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            self->_currentModel = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
            
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}


- (void)funTap{
    
}

@end
