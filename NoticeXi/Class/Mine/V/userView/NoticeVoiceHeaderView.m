//
//  NoticeVoiceHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceHeaderView.h"
#import "NoticeChangeIconViewController.h"
#import "AppDelegate.h"
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
#import "NoticeChangeIntroduceViewController.h"
@implementation NoticeVoiceHeaderView
{
    UIImageView *_iconImageView;
    UILabel *_nickNameL;
    UILabel *_infoL;
    UIButton *_button;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:view];
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-70)/2,NAVIGATION_BAR_HEIGHT+35, 70, 70)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.cornerRadius = 35;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        NoticeUserInfoModel *user = [NoticeSaveModel getUserInfo];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar_url] placeholderImage:[UIImage imageNamed:@"Image_jynohe"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon)];
        [_iconImageView addGestureRecognizer:tap];
        [view addSubview:_iconImageView];
        
       
        
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_iconImageView.frame)+25, DR_SCREEN_WIDTH, 16)];
        _nickNameL.textColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
        _nickNameL.font = SIXTEENTEXTFONTSIZE;
        _nickNameL.text = user.nick_name;
        _nickNameL.textAlignment = NSTextAlignmentCenter;
        [view addSubview:_nickNameL];
        
        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nickNameL.frame), DR_SCREEN_WIDTH, 43)];
        _infoL.textColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
        _infoL.font = THRETEENTEXTFONTSIZE;
        _infoL.text = (user.self_intro && user.self_intro.length)? user.self_intro:GETTEXTWITE(@"voicelist.selfinfo");//還沒有填寫簡介哦
        _infoL.textAlignment = NSTextAlignmentCenter;
        [view addSubview:_infoL];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-GET_STRWIDTH(_infoL.text, 13, 43))/2+GET_STRWIDTH(_infoL.text, 13, 43), CGRectGetMaxY(_nickNameL.frame), 43, 43)];
        [button addTarget:self action:@selector(intoEdit) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:UIImageNamed(@"user_index_edit") forState:UIControlStateNormal];
        _button = button;
        [view addSubview:button];
    }
    return self;
}

- (void)setUserM:(NoticeUserInfoModel *)userM{
    _userM = userM;
    if (self.isOther) {
        _button.hidden = YES;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_userM.avatar_url] placeholderImage:[UIImage imageNamed:@"Image_jynohe"]];
        _nickNameL.text = _userM.nick_name;
        _infoL.text = (userM.self_intro && userM.self_intro.length)? userM.self_intro:GETTEXTWITE(@"voicelist.selfinfo");//還沒有填寫簡介哦
    }else{
        _button.hidden = NO;
    }
}

- (void)refresh{
    NoticeUserInfoModel *user = [NoticeSaveModel getUserInfo];
    if (self.isOther) {
        user = _userM;
    }
    _infoL.text = (user.self_intro && user.self_intro.length)? user.self_intro:GETTEXTWITE(@"voicelist.selfinfo");//還沒有填寫簡介哦
}

- (void)intoEdit{
    NoticeChangeIntroduceViewController *ctl = [[NoticeChangeIntroduceViewController alloc] init];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        
    }
}

- (void)changeIcon{
    
//    if (<#condition#>) {
//        <#statements#>
//    }
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    NoticeChangeIconViewController *ctl = [storyBoard instantiateViewControllerWithIdentifier:@"NoticeChangeIconViewController"];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        
    }
}
@end
