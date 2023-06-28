//
//  NoticeVoiceComDetailCell.m
//  NoticeXi
//
//  Created by li lei on 2022/2/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceComDetailCell.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeXi-Swift.h"
@implementation NoticeVoiceComDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.topfgView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, DR_SCREEN_WIDTH-80, 15)];
        self.topfgView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.topfgView];
        
        self.bottomfgView = [[UIView alloc] initWithFrame:CGRectMake(60, self.replyView.frame.size.height-15, DR_SCREEN_WIDTH-80, 15)];
        self.bottomfgView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.bottomfgView];
        
        self.replyView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, DR_SCREEN_WIDTH-60-20, 0)];
        self.replyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.replyView.layer.cornerRadius = 10;
        self.replyView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.replyView];
        
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
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
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
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [self.replyZanImgView addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [self.replyLikeNumL addGestureRecognizer:tap2];

        //时间
        _replyTimeL = [[UILabel alloc] initWithFrame:CGRectMake(36,self.replyView.frame.size.height-36, 200, 36)];
        _replyTimeL.font = TWOTEXTFONTSIZE;
        _replyTimeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.replyView addSubview:_replyTimeL];
        
        UILongPressGestureRecognizer *longDleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDeleteVoice:)];
        longDleTap.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longDleTap];
    }
    return self;
}

- (void)setComModel:(NoticeVoiceComModel *)comModel{
    _comModel = comModel;
    [_replyIconView sd_setImageWithURL:[NSURL URLWithString:comModel.fromUser.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageRefreshCached];
    self.replyNameL.text = comModel.fromUser.nick_name;
    self.replyTimeL.text = comModel.created_at;
    self.replyLikeNumL.text = [NSString stringWithFormat:@"%ld",comModel.like_num.integerValue];
    self.replyZanImgView.image = UIImageNamed(comModel.is_like.boolValue?@"Image_voicecomzy":@"Image_voicecomz");
    
    self.replyIconMarkView.image = UIImageNamed(comModel.fromUser.levelImgIconName);
    
    self.replyL.attributedText = comModel.subTextAttStr;
    
    self.replyL.textColor = comModel.comment_status.integerValue == 3?[UIColor colorWithHexString:@"#DB6E6E"] : [UIColor colorWithHexString:@"#25262E"];
    if ([self.jubaoContent isEqualToString:comModel.content]) {
        self.replyL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
    }
    
    self.replyL.frame = CGRectMake(36, 33, DR_SCREEN_WIDTH-122, comModel.subTextHeight);

    self.replyView.frame = CGRectMake(60, 0, DR_SCREEN_WIDTH-60-20, self.replyL.frame.size.height+33+36);
    self.replyTimeL.frame = CGRectMake(36,self.replyView.frame.size.height-36, 200, 36);
    self.replyZanImgView.frame = CGRectMake(self.replyView.frame.size.width-50,self.replyView.frame.size.height-20-8, 20, 20);
    self.replyLikeNumL.frame = CGRectMake(CGRectGetMaxX(self.replyZanImgView.frame), self.replyZanImgView.frame.origin.y, 40, 20);
 
    self.bottomfgView.frame = CGRectMake(60, self.replyView.frame.size.height-15, DR_SCREEN_WIDTH-80, 15);
    
}

- (void)longDeleteVoice:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;

    //py.dele  删除  chat.jubao 举报
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            if ([NoticeTools isManager]) {
                LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                } otherButtonTitleArray:@[@"管理员删除"]];
                sheet.delegate = self;
                [sheet show];
                return;
            }
            if ([self.comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {//自己的回复 删除
                LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.dele"]]];
                sheet.delegate = self;
                [sheet show];
            }else if (self.voiceM.isSelf || [self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]) {//自己心情下面的评论的回复 删除 举报
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
        if ([NoticeTools isManager]) {
            self.magager.type = @"删除评论回复";
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
    [self sureDelete];
}

- (void)sureDelete{
    [[DRNetWorking shareInstance] requestWithDeletePath:self.bokeModel? [NSString stringWithFormat:@"podcast/comment/%@",self.comModel.subId]: [NSString stringWithFormat:@"voice/comment/%@",self.comModel.subId] Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.deleteComBlock) {
                self.deleteComBlock(self.comModel.subId);
            }
        }
    } fail:^(NSError * _Nullable error) {

    }];
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
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.bokeModel? [NSString stringWithFormat:@"podcast/commentLike/%@/%@",_comModel.subId,_comModel.is_like.boolValue?@"2":@"1"]: [NSString stringWithFormat:@"voice/commentLike/%@/%@",_comModel.subId,_comModel.is_like.boolValue?@"2":@"1"] Accept:self.bokeModel?@"application/vnd.shengxi.v5.4.6+json": @"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (_comModel.is_like.boolValue) {
                _comModel.is_like = @"0";
                _comModel.like_num = [NSString stringWithFormat:@"%ld",_comModel.like_num.integerValue-1];
            }else{
                _comModel.is_like = @"1";
                _comModel.like_num = [NSString stringWithFormat:@"%ld",_comModel.like_num.integerValue+1];
            }
            self.replyLikeNumL.text = [NSString stringWithFormat:@"%ld",_comModel.like_num.integerValue];
            self.replyZanImgView.image = UIImageNamed(_comModel.is_like.boolValue?@"Image_voicecomzy":@"Image_voicecomz");
            if (self.likeBlock) {
                self.likeBlock(self.comModel);
            }
        }
        self.hadClickLike = NO;
    } fail:^(NSError * _Nullable error) {
        self.hadClickLike = NO;
    }];
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
