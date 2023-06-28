//
//  AppDelegate+Notification.m
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/5/5.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "AppDelegate+Notification.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "NoticeJpush.h"
#import "NoticeSysViewController.h"
#import "NoticeFriendRquestViewController.h"
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
#import "UNNotificationsManager.h"
#import "ClockViewModel.h"
#import "ZFSDateFormatUtil.h"
#import "ZFSIsMute.h"
#import "NoticePushModel.h"
#import "NoticeSCViewController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticeTextVoiceDetailController.h"
#import "NoticeSysViewController.h"
#import "NoticeVoiceCommentNewsController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticePyComController.h"
#import "NoticeTcPageController.h"
#import "NoticeTuYaChatWithOtherController.h"
#import "NoticeDrawShowListController.h"
#import "NoticeVoiceChatAndDepartController.h"
#import "NoticeHelpDetailController.h"
#import "NoticeReadBookController.h"
#import "NoticeMusicLikeHistoryController.h"
#import "NoticeNewLeadController.h"
#import "NoticeDepartureController.h"
#import "NoticeHasServeredController.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate (Notification)

- (void)configurationJPushWithLaunchOptions:(NSDictionary *)launchOptions {
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"73a728a890f7850c1c9a33b6"
                          channel:@"AppStore"
                 apsForProduction:YES
            advertisingIdentifier:nil];
     
   // [UNNotificationsManager registerLocalNotification];
    [self registNotification];
    
}

- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
                [UIUserNotificationSettings settingsForTypes:
                (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}




- (void)jpushSetAlias{
    if (![[NoticeSaveModel getUserInfo] socket_id] || [[NoticeSaveModel getUserInfo] socket_id].length < 5) {
        return;
    }
    
    if ([[NoticeSaveModel getUserInfo] socket_id]) {
        [JPUSHService setAlias:[[NoticeSaveModel getUserInfo] socket_id]?[[NoticeSaveModel getUserInfo] socket_id]:@"0" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (![[NoticeSaveModel getUserInfo] socket_id] || [[NoticeSaveModel getUserInfo] socket_id].length < 5) {
                return;
            }
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:[[NoticeSaveModel getUserInfo] socket_id]?[[NoticeSaveModel getUserInfo] socket_id]:@"0" forKey:@"jpushId"];
            [parm setObject:@"2" forKey:@"platformId"];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    DRLog(@"极光id更新成功");
                }
            } fail:^(NSError *error) {
            }];
            DRLog(@"rescode: %ld, \nalias: %@\n", (long)iResCode, iAlias);
        } seq:0];
    }
}

- (void)deleteAlias {
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        DRLog(@"deleteJpush : rescode: %ld, \nalias: %@\n", (long)iResCode, iAlias);
    } seq:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [JPUSHService setBadge:0];
    //清除角标
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = @(0);
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"clearBadge" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [JPUSHService setBadge:0];
    //清除角标
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = @(0);
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"clearBadge" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 收到推送通知
    [JPUSHService handleRemoteNotification:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    self.deviceToken = deviceToken;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ONREPORTDEVICETOKEN" object:nil];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    DRLog(@"推送2\n%@",userInfo);
    NoticeJpush *pushM = [NoticeJpush mj_objectWithKeyValues:userInfo];
    if ([pushM.type isEqualToString:@"12"]) {
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    }
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)//程序q在前台时不收极光推送
    {
        return;
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
	NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    NoticePushModel *model = [NoticePushModel mj_objectWithKeyValues:userInfo];
    
    BaseNavigationController *nav = nil;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionDefault
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    
    if (model.push_type.intValue == 10) {//私聊
        NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
        vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,model.push_user_id];
        vc.toUserId = model.push_user_id;
        vc.navigationItem.title = model.push_user_nick_name;
        [nav.topViewController.navigationController pushViewController:vc animated:NO];

    }else if (model.push_type.intValue == 1){//系统消息
        NoticeSysViewController *ctl = [[NoticeSysViewController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 7 || model.push_type.intValue == 3){//贴贴悄悄话通知
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"voices/%@",model.push_voice_id] Accept:@"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeVoiceListModel *voicemodel = [NoticeVoiceListModel mj_objectWithKeyValues:dict[@"data"]];
                if (voicemodel.video_url.count) {
                    return;
                }
                if (voicemodel.content_type.intValue == 2 && voicemodel.title) {
                    voicemodel.voice_content = [NSString stringWithFormat:@"%@\n%@",voicemodel.title,voicemodel.voice_content];
                }
                if (voicemodel.content_type.intValue == 2) {
                    NoticeTextVoiceDetailController *ctl = [[NoticeTextVoiceDetailController alloc] init];
                    ctl.voiceM = voicemodel;
                    if (model.push_type.intValue == 7) {
                        ctl.isHs = YES;
                    }
                    ctl.toUserName = model.push_user_nick_name;
                    ctl.toUserId = model.push_user_id;
                    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
                }else{
                    NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
                    ctl.voiceM = voicemodel;
                    if (model.push_type.intValue == 7) {
                        ctl.isHs = YES;
                    }
                    ctl.toUserName = model.push_user_nick_name;
                    ctl.toUserId = model.push_user_id;
                    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
                }
            }
        } fail:^(NSError *error) {
        }];
    }else if (model.push_type.intValue == 48666 || model.push_type.intValue == 48601){//欣赏的人有更新
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        if (![[NoticeTools getuserId] isEqualToString:model.push_user_id]) {
            ctl.isOther = YES;
            ctl.userId = model.push_user_id;
        }
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 4){//互动消息
        NoticeVoiceCommentNewsController *ctl = [[NoticeVoiceCommentNewsController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 22 || model.push_type.intValue == 48100 || model.push_type.intValue == 48101 || model.push_type.intValue == 48102 || model.push_type.intValue == 17 || model.push_type.intValue == 23){//配音相关消息
        NoticePyComController *ctl = [[NoticePyComController alloc] init];
        ctl.pyId = model.push_dubbing_id;
        if (model.push_type.intValue == 23) {
            ctl.isPicker = YES;
        }
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 16 || model.push_type.intValue == 501){//台词相关消息
        NoticeTcPageController *ctl = [[NoticeTcPageController alloc] init];
        ctl.tcId = model.push_line_id;
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 24){//涂鸦
        NoticeTuYaChatWithOtherController *ctl = [[NoticeTuYaChatWithOtherController alloc] init];
        ctl.drawId = model.push_artwork_id;
        ctl.toUserId = model.push_user_id;
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 18 || model.push_type.intValue == 25 || model.push_type.intValue == 27 || model.push_type.intValue == 26){//绘画贴贴 收藏 送画 画被pick
        NoticeDrawShowListController *ctl = [[NoticeDrawShowListController alloc] init];
        ctl.artId = model.push_artwork_id;
        ctl.listType = 7;
        ctl.isPicker = model.push_type.intValue == 26 ? YES:NO;
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue >= 17100 && model.push_type.intValue <= 17103){
        if (model.push_type.intValue <= 17101) {
            
            NoticeVoiceChatAndDepartController *ctl = [[NoticeVoiceChatAndDepartController alloc] init];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        }else{
            NoticeVoiceCommentNewsController *ctl = [[NoticeVoiceCommentNewsController alloc] init];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        }

    }else if (model.push_type.intValue == 19000 || model.push_type.intValue == 19001 || model.push_type.intValue == 19002){//求助帖相关
        if(model.push_type.integerValue != 19002){
            NoticeDepartureController *ctl = [[NoticeDepartureController alloc] init];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            return;
        }
        [self requestDetail:model.push_about_id type:model.push_type];

    }else if (model.push_type.intValue == 19013 || model.push_type.intValue == 19012 || model.push_type.intValue == 19010 || model.push_type.intValue == 19011){//播客相关
        if (model.push_type.intValue == 19010 || model.push_type.intValue == 19011) {
            NoticeDepartureController *ctl = [[NoticeDepartureController alloc] init];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        }else{
            NoticeVoiceCommentNewsController *ctl = [[NoticeVoiceCommentNewsController alloc] init];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        }

    }else if (model.push_type.intValue == 8 || model.push_type.intValue == 35){//文章回复
        NoticeDepartureController *ctl = [[NoticeDepartureController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue == 16300 || model.push_type.intValue == 16301){//喜欢历史
        
        NoticeMusicLikeHistoryController *ctl = [[NoticeMusicLikeHistoryController alloc] init];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue ==17000){
        NoticeReadBookController *ctl = [[NoticeReadBookController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }else if (model.push_type.intValue ==77674){
        NoticeHasServeredController *ctl = [[NoticeHasServeredController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
    }
    
    if (@available(iOS 10.0, *)) {
		if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
			[JPUSHService handleRemoteNotification:userInfo];
		}
	}
	completionHandler();// 系统要求执行这个方法
}

- (void)requestDetail:(NSString *)aboutId type:(NSString *)pushType{
    NoticeVoiceCommentNewsController *ctl = [[NoticeVoiceCommentNewsController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
}

@end
