//
//  NoticeShareView.m
//  NoticeXi
//
//  Created by li lei on 2018/11/12.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeShareView

+ (void)shareWithurl:(NSString *)urlStr type:(SSDKPlatformType)type title:(NSString *)title name:(NSString *)name{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:name images:UIImageNamed(@"sharesdk") url:[NSURL URLWithString:urlStr] title:title type:SSDKContentTypeWebPage];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
          //  [nav.topViewController showToastWithText:@"分享成功"];
        }
    }];
}

+ (void)shareWithurl:(NSString *)urlStr type:(SSDKPlatformType)type{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:@"分享我的一段记忆" images:UIImageNamed(@"sharesdk") url:[NSURL URLWithString:urlStr] title:@"声昔APP-我发现了一段心情" type:SSDKContentTypeWebPage];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
          //  [nav.topViewController showToastWithText:@"分享成功"];
        }
    }];
}

+ (void)inivteWithurl:(NSString *)urlStr type:(SSDKPlatformType)type{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSString *titleStr;
    NSString *messAge;
    switch (type) {
        case SSDKPlatformTypeSinaWeibo:
            titleStr = @"SURPRISE";
            messAge = @"偷偷告诉你，我发现了一部时光机";
            break;
        case SSDKPlatformSubTypeWechatSession:
            titleStr = @"SURPRISE";
            messAge = @"送你一个礼物，猜猜是什么?";
            break;
        case SSDKPlatformSubTypeWechatTimeline:
            titleStr = @"我发现了一部时光机";
            messAge = @"只告诉我的朋友们";
            break;
        case SSDKPlatformSubTypeQQFriend:
            titleStr = @"SURPRISE";
            messAge = @"送你一个礼物，猜猜是什么?";
            break;
        case SSDKPlatformSubTypeQZone:
            titleStr = @"我发现了一部时光机";
            messAge = @"只告诉我的朋友们";
            break;
        default:
            break;
    }
    
    [shareParams SSDKSetupShareParamsByText:messAge images:UIImageNamed(@"share_img") url:[NSURL URLWithString:urlStr] title:titleStr type:SSDKContentTypeWebPage];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
        }
    }];
}
@end
