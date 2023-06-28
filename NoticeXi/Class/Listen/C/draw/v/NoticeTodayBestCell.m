//
//  NoticeTodayBestCell.m
//  NoticeXi
//
//  Created by li lei on 2020/6/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTodayBestCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMyFriendViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeDrawViewController.h"
#import "NoticeTuYaChatWithOtherController.h"
#import "NoticeTuYaChatController.h"
#import "NoticeClockPyModel.h"
@implementation NoticeTodayBestCell
{
    UIView *_likeTapView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled = YES;
        
        self.backDrawImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 12, DR_SCREEN_WIDTH-44, DR_SCREEN_WIDTH-44)];
        self.backDrawImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"img_drawback_b":@"img_drawback_y");
        [self.contentView addSubview:self.backDrawImageView];
        self.backDrawImageView.userInteractionEnabled = YES;
        
        self.drawImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,20, self.backDrawImageView.frame.size.height-40, self.backDrawImageView.frame.size.height-40)];
        self.drawImageView.image = UIImageNamed(@"img_empty_img");
        [self.contentView addSubview:self.drawImageView];
        self.drawImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biglook)];
        [self.drawImageView addGestureRecognizer:tapb];
        [self.backDrawImageView addSubview:self.drawImageView];
        
        if ([NoticeTools isManager]) {
            UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
            longPressGesture.minimumPressDuration = 0.7f;//设置长按 时间
            [self.backDrawImageView addGestureRecognizer:longPressGesture];
        }
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.backDrawImageView.frame)+6, DR_SCREEN_WIDTH-27-27, 37)];
        [self.contentView addSubview:backView];
        backView.backgroundColor = [NoticeTools getWhiteColor:@"#FFFDF7" NightColor:@"#1C1C2E"];
        
        self.likeImagView = [[UIImageView alloc] initWithFrame:CGRectMake(self.backDrawImageView.frame.origin.x+10,CGRectGetMaxY(self.backDrawImageView.frame)+6+(37-28)/2+1, 28, 28)];
        self.likeImagView.image = GETUIImageNamed(@"like_default_yebtn");
        [self.contentView addSubview:self.likeImagView];
        
        self.likeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeImagView.frame)+5,CGRectGetMaxY(self.backDrawImageView.frame)+6, 40, 37)];
        self.likeL.textColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#3E3E4A"];
        self.likeL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.likeL];
        
        UIView *tapLikeView = [[UIView alloc] initWithFrame:CGRectMake(self.likeImagView.frame.origin.x-10, CGRectGetMaxY(self.backDrawImageView.frame), 50, 46)];
        tapLikeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        tapLikeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [tapLikeView addGestureRecognizer:tap1];
        _likeTapView = tapLikeView;
        [self.contentView addSubview:tapLikeView];
        
        
        self.tuyaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeImagView.frame)+70,CGRectGetMaxY(self.backDrawImageView.frame)+(37-28)/2+7, 28, 28)];
        self.tuyaImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_tuya_b":@"Image_tuya_y");
        [self.contentView addSubview:self.tuyaImageView];
        
        self.tuyaL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tuyaImageView.frame)+5,CGRectGetMaxY(self.backDrawImageView.frame)+6, 40, 37)];
        self.tuyaL.textColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#3E3E4A"];
        self.tuyaL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.tuyaL];
        
        UIView *tatuyaView = [[UIView alloc] initWithFrame:CGRectMake(self.tuyaImageView.frame.origin.x-10,CGRectGetMaxY(self.backDrawImageView.frame), 50, 46)];
        tatuyaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        tatuyaView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuyaTap)];
        [tatuyaView addGestureRecognizer:tap2];
        [self.contentView addSubview:tatuyaView];
        
        self.colliceiontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tuyaImageView.frame)+70,CGRectGetMaxY(self.backDrawImageView.frame)+(37-28)/2+6, 28, 28)];
        self.colliceiontImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_draw_yesb":@"Image_draw_yesy");//[NoticeTools isWhiteTheme]?@"Image_draw_nob":@"Image_draw_noy"
        [self.contentView addSubview:self.colliceiontImageView];
        
        UIView *collView = [[UIView alloc] initWithFrame:CGRectMake(self.colliceiontImageView.frame.origin.x-10,CGRectGetMaxY(self.backDrawImageView.frame), 50, 46)];
        collView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        collView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionTap)];
        [collView addGestureRecognizer:tap3];
        [self.contentView addSubview:collView];
        
        self.byL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-17-73, CGRectGetMaxY(self.backDrawImageView.frame)+6-2,17, 37)];
        self.byL.textColor = [NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3E3E4A"];
        self.byL.font = FOURTHTEENTEXTFONTSIZE;
        self.byL.text = @"by";
        [self.contentView addSubview:self.byL];

        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.byL.frame)+5, CGRectGetMaxY(self.backDrawImageView.frame)+6+3.5, 30, 30)];
        _iconImageView.layer.cornerRadius = 30/2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
       
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
                
//        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(20+_iconImageView.frame.origin.x, 20+_iconImageView.frame.origin.y,15, 15)];
//        self.markImage.image = UIImageNamed(@"jlzb_img");
//        [self.contentView addSubview:self.markImage];
    }
    return self;
}

- (void)cellLongPress:(UILongPressGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {//执行一次
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[_drawM.top_id.intValue?@"取消今日推荐": @"设为今日推荐"]];
        sheet.delegate = self;
        self.isManagerSheet = sheet;
        [sheet show];
    }
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (!self.isManagerSheet) {
        return;
    }
    if (buttonIndex == 1){
         self.magager.type =_drawM.top_id.intValue?@"取消今日推荐": @"设为今日推荐";
         [self.magager show];
     }
}

- (void)sureManagerClick:(NSString *)code{
    if ([self.magager.type isEqualToString:@"设为今日推荐"]){
        [self setTodayHot:code];
    }else if ([self.magager.type isEqualToString:@"取消今日推荐"]){
        [self setTodayUp:code isUp:YES];
    }

}

- (void)setTodayHot:(NSString *)code{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"artworks/%@/pick",_drawM.drawId] Accept:@"application/vnd.shengxi.v4.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            NoticeClockPyModel *pickM = [NoticeClockPyModel mj_objectWithKeyValues:dict[@"data"]];
            if (pickM.pick_status.intValue == 0) {
                [self setTodayUp:code isUp:NO];
            }else if (pickM.pick_status.intValue == 1){
                [self setTodayUp:code isUp:YES];
            }else if (pickM.pick_status.intValue == 2 || pickM.pick_status.intValue == 3){
                [self.magager removeFromSuperview];
                LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"作品曾被推荐过，确定再次推荐？" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self setTodayUp:code isUp:NO];
                    }
                } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"main.sure"]]];
                [sheet show];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [nav.topViewController hideHUD];
    }];
}



- (void)setTodayUp:(NSString *)code isUp:(BOOL)isUp{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [nav.topViewController showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    [parm setObject:isUp?@"0": [NSString stringWithFormat:@"%.f",currentTime] forKey:@"topAt"];

    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/artwork/%@",_drawM.drawId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [nav.topViewController hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            self->_drawM.top_id = isUp?@"0": [NSString stringWithFormat:@"%.f",currentTime];
            [nav.topViewController showToastWithText:@"操作已执行"];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [nav.topViewController hideHUD];
    }];
}
- (void)setDrawM:(NoticeDrawList *)drawM{
    _drawM = drawM;
    if (_drawM.isSelf) {
        _iconImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_you_b":@"Image_you_y");
    }else{
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_drawM.avatar_url]
        placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                 options:SDWebImageRefreshCached];
        if ([_drawM.identity_type isEqualToString:@"0"] || [_drawM.is_private isEqualToString:@"1"]) {
            self.markImage.hidden = YES;
        }else if ([_drawM.identity_type isEqualToString:@"1"]){
            self.markImage.hidden = NO;
            self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzb_img");
        }else if ([_drawM.identity_type isEqualToString:@"2"]){
            self.markImage.hidden = NO;
            self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzb_img-1");
        }else{
            self.markImage.hidden = YES;
        }
        
        if ([_drawM.user_id isEqualToString:@"1"]) {
            self.markImage.hidden = NO;
            self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_guanfang_b":@"Image_guanfang_y");
        }
    }
    [self.drawImageView sd_setImageWithURL:[NSURL URLWithString:_drawM.artwork_url] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    _likeL.text = _drawM.publicly_like_num.intValue?_drawM.publicly_like_num:@"";
    _likeImagView.image = UIImageNamed([drawM.like_type isEqualToString:@"2"]?([NoticeTools isWhiteTheme]?@"Imagedrawlikes":@"Imagedrawlikesy"):([NoticeTools isWhiteTheme]?@"Imagedrawlike":@"Imagedrawlikey"));
    
    if (_drawM.isSelf) {
        self.tuyaL.text = _drawM.chat_num.intValue?_drawM.chat_num:@"";
    }else{
        self.tuyaL.text = _drawM.dialog_num.intValue?_drawM.dialog_num:@"";
    }
    if (_drawM.collection_id && _drawM.collection_id.length) {
        self.colliceiontImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_draw_yesb":@"Image_draw_yesy");
    }else{
        self.colliceiontImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_draw_nob":@"Image_draw_noy");
    }
    
    self.colliceiontImageView.hidden = _drawM.isSelf?YES:NO;
    if (self.isTuijian) {
        self.markImage.hidden = YES;
    }
}

- (void)biglook{
    if (_drawM.isBlack) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.nocaoz"]];
        return;
    }
    if (!_drawM.isSelf) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        if (!_drawM.graffiti_switch.intValue) {
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.henotuy"]];
            return;
        }else{
            if (_drawM.dialog_num.intValue) {//有对话
                NoticeTuYaChatWithOtherController *ctl = [[NoticeTuYaChatWithOtherController alloc] init];
                ctl.curentDraw = _drawM;
                ctl.toUserId = _drawM.user_id;
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                return;
            }
            NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
            ctl.tuyeImage = self.drawImageView.image;
            ctl.drawId = _drawM.drawId;
            ctl.isTuYa = YES;
            ctl.isFromDrawList = YES;
            ctl.userId = _drawM.user_id;
            if (_drawM.topic_name) {
                NoticeTopicModel *topM = [[NoticeTopicModel alloc] init];
                topM.topic_id = _drawM.topic_id;
                topM.topic_name = _drawM.topic_name;
                ctl.topicM = topM;
            }
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            return;
        }
    }
    YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
    item.thumbView = _drawImageView;
    item.largeImageURL = [NSURL URLWithString:@""];
    NSArray *arr = @[item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    
    if (_drawM.isSelf && _drawM.is_private.intValue) {
        photoView.isSendToFriend = NO;
    }else{
        photoView.isSendToFriend = _drawM.isSelf? YES:NO;
    }
    __weak typeof(self) weakSelf = self;
    photoView.sendToFriendBlock = ^(BOOL send, UIImage *sendImage) {
        [weakSelf senImagView:sendImage];
    };
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:_drawImageView toContainer:toView animated:YES completion:nil];
}

- (void)senImagView:(UIImage *)image{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticeMyFriendViewController *ctl = [[NoticeMyFriendViewController alloc] init];
    ctl.isSend = YES;
    ctl.resourceId = _drawM.drawId;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)userInfoTap{
    if (_drawM.isSelf) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];

        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }else{
        if (_drawM.isBlack) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.nocaoz"]];
            return;
        }
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _drawM.user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
    }
}

- (void)likeTap{
    if (_drawM.isBlack) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.nocaoz"]];
        return;
    }
    _likeTapView.userInteractionEnabled = NO;
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"2" forKey:@"likeType"];
    if (_drawM.like_type.intValue == 2) {
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/artworkLike/%@",_drawM.user_id,_drawM.drawId] Accept:@"application/vnd.shengxi.v3.6+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            self->_likeTapView.userInteractionEnabled = YES;
            if (success) {
                self->_drawM.like_type = @"0";
                self->_drawM.publicly_like_num =  [NSString stringWithFormat:@"%d",self->_drawM.publicly_like_num.intValue-1];
                self->_likeL.text = self->_drawM.publicly_like_num.intValue?self->_drawM.publicly_like_num:@"";
                self->_likeImagView.image = UIImageNamed([self->_drawM.like_type isEqualToString:@"2"]?([NoticeTools isWhiteTheme]?@"Imagedrawlikes":@"Imagedrawlikesy"):([NoticeTools isWhiteTheme]?@"Imagedrawlike":@"Imagedrawlikey"));
            }
        } fail:^(NSError * _Nullable error) {
            self->_likeTapView.userInteractionEnabled = YES;
        }];
    }else{
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/artworkLike/%@",_drawM.user_id,_drawM.drawId] Accept:@"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            self->_likeTapView.userInteractionEnabled = YES;
            if (success) {
                self->_drawM.like_type = @"2";
                self->_drawM.publicly_like_num =  [NSString stringWithFormat:@"%d",self->_drawM.publicly_like_num.intValue+1];
                self->_likeL.text = self->_drawM.publicly_like_num.intValue?self->_drawM.publicly_like_num:@"";
                 self->_likeImagView.image = UIImageNamed([self->_drawM.like_type isEqualToString:@"2"]?([NoticeTools isWhiteTheme]?@"Imagedrawlikes":@"Imagedrawlikesy"):([NoticeTools isWhiteTheme]?@"Imagedrawlike":@"Imagedrawlikey"));
            }
        } fail:^(NSError * _Nullable error) {
            self->_likeTapView.userInteractionEnabled = YES;
        }];
    }
}

- (void)tuyaTap{
    if (_drawM.isBlack) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.nocaoz"]];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (!_drawM.isSelf) {
        if (!_drawM.graffiti_switch.intValue) {
            [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.henotuy"]];
            return;
        }else{
            if (_drawM.dialog_num.intValue) {//有对话
                NoticeTuYaChatWithOtherController *ctl = [[NoticeTuYaChatWithOtherController alloc] init];
                ctl.curentDraw = _drawM;
                ctl.toUserId = _drawM.user_id;
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                return;
            }
            NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
            ctl.tuyeImage = self.drawImageView.image;
            ctl.drawId = _drawM.drawId;
            ctl.isTuYa = YES;
            ctl.isFromDrawList = YES;
            ctl.userId = _drawM.user_id;
            if (_drawM.topic_name) {
                NoticeTopicModel *topM = [[NoticeTopicModel alloc] init];
                topM.topic_id = _drawM.topic_id;
                topM.topic_name = _drawM.topic_name;
                ctl.topicM = topM;
            }
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
            return;
        }
    }
    if (!_drawM.chat_num.intValue) {
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.havenotuya"]];
        return; 
    }
    NoticeTuYaChatController *ctl = [[NoticeTuYaChatController alloc] init];
    ctl.drawId = _drawM.drawId;
    [nav.topViewController.navigationController pushViewController:ctl animated:YES];
}

- (void)collectionTap{
    if (_drawM.isBlack) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"hh.nocaoz"]];
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    if (!_drawM.isSelf) {
        [nav.topViewController showHUD];
        if (_drawM.collection_id && _drawM.collection_id.length) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"artworkCollection/%@",_drawM.collection_id] Accept:@"application/vnd.shengxi.v4.3+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    self->_drawM.collection_id = @"";
                    self.colliceiontImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_draw_nob":@"Image_draw_noy");
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }else{
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:_drawM.drawId forKey:@"artworkId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"artworkCollection" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [nav.topViewController hideHUD];
                if (success) {
                    self.colliceiontImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_draw_yesb":@"Image_draw_yesy");
                    self->_drawM.collection_id = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
                }
            } fail:^(NSError * _Nullable error) {
                [nav.topViewController hideHUD];
            }];
        }
    }
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
