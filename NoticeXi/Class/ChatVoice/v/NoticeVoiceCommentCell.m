//
//  NoticeVoiceCommentCell.m
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceCommentCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeVoiceComDetailView.h"
#import "NoticeXi-Swift.h"
@implementation NoticeVoiceCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *moreT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreCom)];
        [self addGestureRecognizer:moreT];
        
        self.iconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 34, 34)];
        [self.contentView addSubview:self.iconMarkView];
        self.iconMarkView.layer.cornerRadius = self.iconMarkView.frame.size.height/2;
        self.iconMarkView.layer.masksToBounds = YES;
      
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 17, 30, 30)];
        _iconImageView.layer.cornerRadius = 15;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-9, CGRectGetMaxY(_iconImageView.frame)-14,14, 14)];
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(60, 43, DR_SCREEN_WIDTH-90, 0)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,15, DR_SCREEN_WIDTH-50, 20)];
        _nickNameL.font = XGFourthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];

        //阅读，浏览数
        self.numImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40,0, 20, 20)];
        [self.contentView addSubview:self.numImageView];
        self.numImageView.image = UIImageNamed(@"Image_voicecomz");
        self.numImageView.userInteractionEnabled = YES;

        self.redNumL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numImageView.frame), self.numImageView.frame.origin.y, 40, 20)];
        self.redNumL.font = FOURTHTEENTEXTFONTSIZE;
        self.redNumL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:self.redNumL];
        self.redNumL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [self.numImageView addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [self.redNumL addGestureRecognizer:tap2];

        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(60,0, 200, 40)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:_timeL];
        
        self.replyButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-100, self.timeL.frame.origin.y+10, 20, 20)];
        [self.replyButton setBackgroundImage:UIImageNamed(@"Image_voiceComReply") forState:UIControlStateNormal];
        [self.replyButton addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
        self.replyButton.hidden = YES;
        [self.contentView addSubview:self.replyButton];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.timeL.frame)-1, DR_SCREEN_WIDTH-80, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.line];
        
        UILongPressGestureRecognizer *longDleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDeleteVoice:)];
        longDleTap.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longDleTap];
    }
    return self;
}

- (void)setComModel:(NoticeVoiceComModel *)comModel{
    _comModel = comModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:comModel.fromUser.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
    self.markImage.hidden = comModel.fromUser.userId.intValue == 1?NO:YES;
    self.nickNameL.text = comModel.fromUser.nick_name;
    self.timeL.text = comModel.created_at;
    self.redNumL.text = [NSString stringWithFormat:@"%ld",comModel.like_num.integerValue];
    self.numImageView.image = UIImageNamed(comModel.is_like.boolValue?@"Image_voicecomzy":@"Image_voicecomz");
  
    self.iconMarkView.image = UIImageNamed(comModel.fromUser.levelImgIconName);
 
    
    self.contentL.attributedText = comModel.mainTextAttStr;
    self.contentL.frame = CGRectMake(60, 43, DR_SCREEN_WIDTH-90, comModel.mainTextHeight);
    
    if (comModel.replysArr.count && !self.isDetail) {
        self.replyView.hidden = NO;
        NoticeVoiceComModel *firstComM = comModel.replysArr[0];
        [_replyIconView sd_setImageWithURL:[NSURL URLWithString:firstComM.fromUser.avatar_url]
                              placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                       options:SDWebImageRefreshCached];
        self.replyNameL.text = firstComM.fromUser.nick_name;
        self.replyTimeL.text = firstComM.created_at;
        self.replyLikeNumL.text = [NSString stringWithFormat:@"%ld",firstComM.like_num.integerValue];
        self.replyZanImgView.image = UIImageNamed(firstComM.is_like.boolValue?@"Image_voicecomzy":@"Image_voicecomz");
        
    
        self.replyIconMarkView.image = UIImageNamed(firstComM.fromUser.levelImgIconName);
      
        
        self.replyL.attributedText = firstComM.subTextAttStr;
        self.replyL.textColor = firstComM.comment_status.integerValue == 3?[UIColor colorWithHexString:@"#DB6E6E"] : [UIColor colorWithHexString:@"#25262E"];
        self.replyL.frame = CGRectMake(36, 33, DR_SCREEN_WIDTH-122, firstComM.subTextHeight);

        self.replyView.frame = CGRectMake(60, CGRectGetMaxY(self.contentL.frame)+10, DR_SCREEN_WIDTH-60-20, self.replyL.frame.size.height+33+36 + (comModel.reply_num.integerValue > 1?40:0));
        
        self.replyTimeL.frame = CGRectMake(36,self.replyView.frame.size.height-36- (comModel.reply_num.integerValue > 1?40:0), 200, 36);
        self.replyZanImgView.frame = CGRectMake(self.replyView.frame.size.width-50,self.replyView.frame.size.height-20-8- (comModel.reply_num.integerValue > 1?40:0), 20, 20);
        self.replyLikeNumL.frame = CGRectMake(CGRectGetMaxX(self.replyZanImgView.frame), self.replyZanImgView.frame.origin.y, 40, 20);
        
        if (comModel.reply_num.integerValue > 1) {
            self.moreView.hidden = NO;
            _moreView.frame = CGRectMake(36,CGRectGetMaxY(self.replyTimeL.frame)+5, GET_STRWIDTH([NoticeTools getLocalStrWith:@"ly.morehf"], 14, 20)+20, 20);
        }else{
            
            _moreView.hidden = YES;
        }
    }else{
        _replyView.hidden = YES;
    }
    
    self.contentL.textColor = comModel.comment_status.integerValue == 3?[UIColor colorWithHexString:@"#DB6E6E"] : [UIColor colorWithHexString:@"#25262E"];
    
    if ([self.jubaoContent isEqualToString:comModel.content]) {
        self.contentL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
    }
    
    if (comModel.replysArr.count && !self.isDetail) {
        self.timeL.frame = CGRectMake(60, CGRectGetMaxY(self.replyView.frame), 200, 40);
    }else{
        self.timeL.frame = CGRectMake(60, CGRectGetMaxY(self.contentL.frame), 200, 40);
    }
    self.numImageView.frame = CGRectMake(DR_SCREEN_WIDTH-40-20,self.timeL.frame.origin.y+10, 20, 20);
    self.redNumL.frame = CGRectMake(CGRectGetMaxX(self.numImageView.frame), self.timeL.frame.origin.y, 40, 40);
    
    self.line.frame = CGRectMake(60, CGRectGetMaxY(self.timeL.frame)-1, DR_SCREEN_WIDTH-80, 1);
    
    
    if (!comModel.is_allow_reply.boolValue) {
        if (self.bokeModel) {
            if ([self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]) {//自己的播客
                if ([comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {//自己播客下自己的评论自己不能回复
                    comModel.is_allow_reply = @"0";
                }else{
                    comModel.is_allow_reply = @"1";//自己的播客，别人的评论了，自己可以回复
                }
            }else{//别人的心情
                if ([comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {//别人的播客下自己的评论
                    if (comModel.reply_num.intValue) {//播客主人回复过，则自己可以进行评论
                        comModel.is_allow_reply = @"1";
                    }else{
                        comModel.is_allow_reply = @"0";
                    }

                }else{//自己的播客，别人的评论，不可以回复
                    comModel.is_allow_reply = @"0";
                }
            }
        }else{
            if (self.voiceM.isSelf) {//自己的心情
                if ([comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {//自己心情下自己的评论自己不能回复
                    comModel.is_allow_reply = @"0";
                }else{
                    comModel.is_allow_reply = @"1";//自己的心情，别人的评论了，自己可以回复
                }
            }else{//别人的心情
                if ([comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {//别人的心情下自己的评论
                    if (comModel.reply_num.intValue) {//心情主人回复过，则自己可以进行评论
                        comModel.is_allow_reply = @"1";
                    }else{
                        comModel.is_allow_reply = @"0";
                    }

                }else{//自己的心情，别人的评论，不可以回复
                    comModel.is_allow_reply = @"0";
                }
            }
        }

    }

    if (comModel.is_allow_reply.boolValue && !self.isDetail) {
        self.replyButton.hidden = NO;
        self.replyButton.frame = CGRectMake(DR_SCREEN_WIDTH-100, self.timeL.frame.origin.y+10, 20, 20);
    }else{
        self.replyButton.hidden = YES;
    }
    
    self.line.hidden = self.isDetail?YES:NO;
}

- (void)longDeleteVoice:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;

    //py.dele  删除  chat.jubao 举报
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
    
            if ([NoticeTools isManager] && ![self.comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {
                LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                } otherButtonTitleArray:@[@"管理员删除"]];
                sheet.delegate = self;
                [sheet show];
                return;
            }
            if ([self.comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {//自己的评论 删除
                LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.dele"]]];
                sheet.delegate = self;
                [sheet show];
            }else if (self.voiceM.isSelf || [self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]) {//自己心情下面的评论 删除 举报
                LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"],[NoticeTools getLocalStrWith:@"py.dele"]]];
                sheet.delegate = self;
                [sheet show];
            }else{
                LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"chat.jubao"]]];
                sheet.delegate = self;
                [sheet show];
            }
            break;
        }
        default:
            break;
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
    
        if ([NoticeTools isManager] && ![self.comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {
            self.magager.type = @"删除心情评论";
            [self.magager show];
            return;
        }

        if ([self.comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {//自己的评论 删除
            [self deleteCom];
        }else if (self.voiceM.isSelf) {//自己心情下面的评论 删除 举报
            [self jubao];
        }else{
            [self jubao];
        }
    }else if(buttonIndex == 2){
        if (self.voiceM.isSelf || [self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]) {//自己心情下面的评论 删除 举报
            [self deleteCom];
            return;
        }
        [self jubao];
    }
}

- (void)sureManagerClick:(NSString *)code{
  
    [[DRNetWorking shareInstance] requestWithDeletePath:self.bokeModel? [NSString stringWithFormat:@"admin/podcast/comment/%@?confirmPasswd=%@",self.comModel.subId,code]: [NSString stringWithFormat:@"admin/voice/comment/%@?confirmPasswd=%@",self.comModel.subId,code] Accept:nil parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.manageDeleteComBlock) {
                self.manageDeleteComBlock(self.comModel.subId);
            }
            [self.magager removeFromSuperview];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError * _Nullable error) {

    }];
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (void)jubao{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.comModel.subId;
    juBaoView.reouceType = self.bokeModel?@"144": @"140";
    [juBaoView showView];
}

- (void)deleteCom{
    
    if (self.comModel.reply_num.integerValue) {//有回复的时候
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"nes.delesu"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self sureDelete];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.dele"]]];
        [sheet show];
    }else{
        [self sureDelete];
    }
}

- (void)sureDelete{
    [[DRNetWorking shareInstance] requestWithDeletePath:self.bokeModel? [NSString stringWithFormat:@"podcast/comment/%@",self.comModel.subId] : [NSString stringWithFormat:@"voice/comment/%@",self.comModel.subId] Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.deleteComBlock) {
                self.deleteComBlock(self.comModel.subId);
            }
        }
    } fail:^(NSError * _Nullable error) {

    }];
}

- (void)moreCom{
    if (!self.comModel.replysArr.count || self.isDetail) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NoticeVoiceComDetailView *comView = [[NoticeVoiceComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    comView.comModel = self.comModel;
    comView.voiceM = self.voiceM;
    comView.bokeModel = self.bokeModel;
    comView.comId = self.comModel.subId;
    comView.voiceId = self.comModel.voice_id;
    if (self.comModel.is_allow_reply.boolValue) {
        NSString *userId = self.bokeModel?self.bokeModel.user_id:self.voiceM.subUserModel.userId;
        NSString *nickName = self.bokeModel?self.bokeModel.nick_name:self.voiceM.subUserModel.nick_name;
        if ([userId isEqualToString:[NoticeTools getuserId]]) {
            if ([NoticeTools getLocalType] == 1) {
                comView.titleL.text = [NSString stringWithFormat:@"Comment with%@",self.comModel.fromUser.nick_name];
            }else if ([NoticeTools getLocalType] == 2){
                comView.titleL.text = [NSString stringWithFormat:@"%@とのメッセージ",self.comModel.fromUser.nick_name];
            }else{
                comView.titleL.text = [NSString stringWithFormat:@"和%@的留言",self.comModel.fromUser.nick_name];
            }
        }else{
            if ([NoticeTools getLocalType] == 1) {
                comView.titleL.text = [NSString stringWithFormat:@"Comment with%@",nickName];
            }else if ([NoticeTools getLocalType] == 2){
                comView.titleL.text = [NSString stringWithFormat:@"%@とのメッセージ",nickName];
            }else{
                comView.titleL.text = [NSString stringWithFormat:@"和%@的留言",nickName];
            }
        }

        
    }else{
        comView.titleL.text = [NoticeTools getLocalStrWith:@"ly.lydetail"];
    }
    comView.deleteComBlock = ^(NSString * _Nonnull comId) {
        if (weakSelf.deleteComBlock) {
            weakSelf.deleteComBlock(comId);
        }
    };
 
    comView.dissMissBlock = ^(BOOL diss) {
        if (weakSelf.dissMissBlock) {
            weakSelf.dissMissBlock(YES);
        }
    };
    [comView show];
}

- (void)replyClick{
    NoticeVoiceComDetailView *comView = [[NoticeVoiceComDetailView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    comView.bokeModel = self.bokeModel;
    comView.comModel = self.comModel;
    comView.voiceM = self.voiceM;
    comView.comId = self.comModel.subId;
    comView.voiceId = self.comModel.voice_id;
    if (self.comModel.is_allow_reply.boolValue) {
        if ([NoticeTools getLocalType] == 1) {
            comView.titleL.text = [NSString stringWithFormat:@"Comment with%@",self.comModel.fromUser.nick_name];
        }else if ([NoticeTools getLocalType] == 2){
            comView.titleL.text = [NSString stringWithFormat:@"%@とのメッセージ",self.comModel.fromUser.nick_name];
        }else{
            comView.titleL.text = [NSString stringWithFormat:@"和%@的留言",self.comModel.fromUser.nick_name];
        }
    }else{
        comView.titleL.text = [NoticeTools getLocalStrWith:@"ly.lydetail"];
    }
    __weak typeof(self) weakSelf = self;
    comView.dissMissBlock = ^(BOOL diss) {
        if (weakSelf.dissMissBlock) {
            weakSelf.dissMissBlock(YES);
        }
    };
    comView.deleteComBlock = ^(NSString * _Nonnull comId) {
        if (weakSelf.deleteComBlock) {
            weakSelf.deleteComBlock(comId);
        }
    };
    [comView.inputView.contentView becomeFirstResponder];
    [comView show];
}

- (void)userInfoTap1{
    if (!_comModel.replysArr.count) {
        return;
    }
    if (self.dissMissBlock) {
        self.dissMissBlock(YES);
    }
    NoticeVoiceComModel *firstComM = _comModel.replysArr[0];
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    if (![firstComM.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        ctl.isOther = YES;
        ctl.userId = firstComM.from_user_id;
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

- (void)userInfoTap{
    if (self.dissMissBlock) {
        self.dissMissBlock(YES);
    }
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    if (![_comModel.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        ctl.isOther = YES;
        ctl.userId = _comModel.from_user_id;
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

- (void)likeTap{
    if (self.hadClickLike) {
        return;
    }
    self.hadClickLike = YES;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.bokeModel?  [NSString stringWithFormat:@"podcast/commentLike/%@/%@",_comModel.subId,_comModel.is_like.boolValue?@"2":@"1"]: [NSString stringWithFormat:@"voice/commentLike/%@/%@",_comModel.subId,_comModel.is_like.boolValue?@"2":@"1"] Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (_comModel.is_like.boolValue) {
                _comModel.is_like = @"0";
                _comModel.like_num = [NSString stringWithFormat:@"%ld",_comModel.like_num.integerValue-1];
            }else{
                _comModel.is_like = @"1";
                _comModel.like_num = [NSString stringWithFormat:@"%ld",_comModel.like_num.integerValue+1];
            }
            self.redNumL.text = [NSString stringWithFormat:@"%ld",_comModel.like_num.integerValue];
            self.numImageView.image = UIImageNamed(_comModel.is_like.boolValue?@"Image_voicecomzy":@"Image_voicecomz");
            if (self.likeBlock) {
                self.likeBlock(self.comModel);
            }
        }
        self.hadClickLike = NO;
    } fail:^(NSError * _Nullable error) {
        self.hadClickLike = NO;
    }];
}

- (void)likeTap1{
    if (self.hadClickLike || !_comModel.replysArr.count) {
        return;
    }
    NoticeVoiceComModel *firstComM = _comModel.replysArr[0];
    self.hadClickLike = YES;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.bokeModel?[NSString stringWithFormat:@"podcast/commentLike/%@/%@",firstComM.subId,firstComM.is_like.boolValue?@"2":@"1"]: [NSString stringWithFormat:@"voice/commentLike/%@/%@",firstComM.subId,firstComM.is_like.boolValue?@"2":@"1"] Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (firstComM.is_like.boolValue) {
                firstComM.is_like = @"0";
                firstComM.like_num = [NSString stringWithFormat:@"%ld",firstComM.like_num.integerValue-1];
            }else{
                firstComM.is_like = @"1";
                firstComM.like_num = [NSString stringWithFormat:@"%ld",firstComM.like_num.integerValue+1];
            }
            self.replyLikeNumL.text = [NSString stringWithFormat:@"%ld",firstComM.like_num.integerValue];
            self.replyZanImgView.image = UIImageNamed(firstComM.is_like.boolValue?@"Image_voicecomzy":@"Image_voicecomz");
            if (self.likeBlock) {
                self.likeBlock(self.comModel);
            }
        }
        self.hadClickLike = NO;
    } fail:^(NSError * _Nullable error) {
        self.hadClickLike = NO;
    }];
}

- (UIView *)moreView{
    if (!_moreView) {
        _moreView = [[UIView alloc] initWithFrame:CGRectMake(36,CGRectGetMaxY(self.replyTimeL.frame)+5, GET_STRWIDTH([NoticeTools getLocalStrWith:@"ly.morehf"], 14, 20)+20, 20)];
        [self.replyView addSubview:_moreView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GET_STRWIDTH([NoticeTools getLocalStrWith:@"ly.morehf"], 14, 20), 20)];
        label.text = [NoticeTools getLocalStrWith:@"ly.morehf"];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#5B8ED1"];
        [_moreView addSubview:label];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, 20, 20)];
        imageV.image = UIImageNamed(@"Image_bluemorecom");
        [_moreView addSubview:imageV];
    }
    return _moreView;
}

- (UIView *)replyView{
    if (!_replyView) {
        _replyView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, DR_SCREEN_WIDTH-60-20, 0)];
        _replyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _replyView.layer.cornerRadius = 10;
        _replyView.layer.masksToBounds = YES;
        _replyView.hidden = YES;
        [self.contentView addSubview:_replyView];
        
        self.replyIconMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 26, 26)];
        [self.replyView addSubview:self.replyIconMarkView];
        self.replyIconMarkView.layer.cornerRadius = self.replyIconMarkView.frame.size.height/2;
        self.replyIconMarkView.layer.masksToBounds = YES;
      
        //头像
        _replyIconView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 22, 22)];
        _replyIconView.layer.cornerRadius = 11;
        _replyIconView.layer.masksToBounds = YES;
        [self.replyView addSubview:_replyIconView];
        _replyIconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap1)];
        [_replyIconView addGestureRecognizer:iconTap];

        
        self.replyL = [[UILabel alloc] initWithFrame:CGRectMake(36, 33, DR_SCREEN_WIDTH-122, 0)];
        self.replyL.font = FOURTHTEENTEXTFONTSIZE;
        self.replyL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.replyL.numberOfLines = 0;
        [self.replyView addSubview:self.replyL];
        
        //昵称
        _replyNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_replyIconView.frame)+5,0,200, 33)];
        _replyNameL.font = XGFourthBoldFontSize;
        _replyNameL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.8];
        [self.replyView addSubview:_replyNameL];

        //阅读，浏览数
        self.replyZanImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.replyView.frame.size.width-50,self.replyView.frame.size.height-20-8, 20, 20)];
        [self.replyView addSubview:self.replyZanImgView];
        self.replyZanImgView.image = UIImageNamed(@"Image_voicecomz");
        self.replyZanImgView.userInteractionEnabled = YES;

        self.replyLikeNumL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.replyZanImgView.frame), self.replyZanImgView.frame.origin.y, 40, 20)];
        self.replyLikeNumL.font = FOURTHTEENTEXTFONTSIZE;
        self.replyLikeNumL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.replyView addSubview:self.replyLikeNumL];
        self.replyLikeNumL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap1)];
        [self.replyZanImgView addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap1)];
        [self.replyLikeNumL addGestureRecognizer:tap2];

        //时间
        _replyTimeL = [[UILabel alloc] initWithFrame:CGRectMake(36,self.replyView.frame.size.height-36, 200, 36)];
        _replyTimeL.font = TWOTEXTFONTSIZE;
        _replyTimeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.replyView addSubview:_replyTimeL];
    }
    return _replyView;
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
