//
//  NoticeTuYaChatCell.m
//  NoticeXi
//
//  Created by li lei on 2020/6/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTuYaChatCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeDrawViewController.h"
#import "NoticeXi-Swift.h"
@implementation NoticeTuYaChatCell
{
    UIButton *_tapBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,25, 35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
        
        _sendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,25,90,90)];
        _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        _sendImageView.layer.cornerRadius = 5;
        _sendImageView.layer.masksToBounds = YES;
        _sendImageView.layer.borderWidth = 0.5;
        _sendImageView.layer.borderColor = [UIColor colorWithHexString:@"#1D1E24"].CGColor;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag)];
        [_sendImageView addGestureRecognizer:tapImg];
        [self.contentView addSubview:_sendImageView];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 32)];
        self.timeL.backgroundColor = self.backgroundColor;
        self.timeL.textColor = GetColorWithName(VDarkTextColor);
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
        self.userInteractionEnabled = YES;
        
        
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.5;
        [_sendImageView addGestureRecognizer:longPressDeleT];
        
        _tapBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, 99, 66, 20)];
        [_tapBtn addTarget:self action:@selector(contiuneLook) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)deleTapT:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
         LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
         } otherButtonTitleArray:@[_chatModel.isSelf?[NoticeTools getLocalStrWith:@"group.back"]:[NoticeTools getLocalStrWith:@"chat.jubao"]]];
         sheet.delegate = self;
         [sheet show];
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        if (_chatModel.isSelf) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithIndex:section:)]) {
                [self.delegate deleteWithIndex:self.index section:self.section];
            }
        }else{
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = _chatModel.dialog_id;
            juBaoView.reouceType = @"3";
            [juBaoView showView];
        }
    }
}
- (void)contiuneLook{
    _chatModel.garbage_type = @"0";
    self.refreshHeightBlock(self.currentPath);
    [_tapBtn removeFromSuperview];
}
- (void)setChatModel:(NoticeChats *)chatModel{
    _chatModel = chatModel;
    _iconImageView.image = UIImageNamed(@"Image_jynohe");
    if (!chatModel.isSelf) {
        _iconImageView.frame = CGRectMake(15, 32, 35, 35);
        _sendImageView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 32,90,90);
    }else{
        _iconImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35, 32, 35, 35);
        _sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35-90-12, 32,90,90);
    }
    self.markImage.frame = CGRectMake(22+_iconImageView.frame.origin.x, 22+_iconImageView.frame.origin.y,15, 15);
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:chatModel.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageRefreshCached];
    if ([_chatModel.from_user_id isEqualToString:@"1"]) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
    }
    else if ([chatModel.identity_type isEqualToString:@"0"]) {
        self.markImage.hidden = YES;
    }else if ([chatModel.identity_type isEqualToString:@"1"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img":@"jlzy_img");
    }else if ([chatModel.identity_type isEqualToString:@"2"]){
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed([NoticeTools isWhiteTheme]?@"jlzb_img-1":@"jlzy_img-1");
    }
    else{
        self.markImage.hidden = YES;
    }
    if (!_chatModel.garbage_type.intValue) {
        [_sendImageView sd_setImageWithURL:[NSURL URLWithString:chatModel.resource_url] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        [_tapBtn removeFromSuperview];
    }else{
        [_sendImageView addSubview:_tapBtn];
        _sendImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_smallgarba_b":@"Image_smallgarba_y");
    }

}

- (void)bigTag{
    if (self.noSend) {
        YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
        item.thumbView = _sendImageView;
        item.largeImageURL = [NSURL URLWithString:@""];
        NSArray *arr = @[item];
        YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
        UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        [photoView presentFromImageView:_sendImageView toContainer:toView animated:YES completion:nil];
        return;
    }
    if (_chatModel.isSelf) {
        YYPhotoGroupItem *item = [[YYPhotoGroupItem alloc] init];
        item.thumbView = _sendImageView;
        item.largeImageURL = [NSURL URLWithString:@""];
        NSArray *arr = @[item];
        YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
        UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        [photoView presentFromImageView:_sendImageView toContainer:toView animated:YES completion:nil];
    }else{
        if (_chatModel.garbage_type.intValue) {
            return;
        }
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        
        NoticeDrawViewController *ctl = [[NoticeDrawViewController alloc] init];
        ctl.isTuYa = YES;
        ctl.tuyeImage = _sendImageView.image;
        ctl.userId = [_chatModel.to_user_id isEqualToString:[NoticeTools getuserId]]?_chatModel.from_user_id:_chatModel.to_user_id;
        ctl.drawId = self.drawId;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)userInfoTap{
    if (_chatModel.is_self.integerValue) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
            
        }
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _chatModel.from_user_id;
        ctl.isOther = YES;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
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
