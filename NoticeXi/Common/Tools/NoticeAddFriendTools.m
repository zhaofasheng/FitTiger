//
//  NoticeAddFriendTools.m
//  NoticeXi
//
//  Created by li lei on 2019/7/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddFriendTools.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSendViewController.h"
@implementation NoticeAddFriendTools

+ (void)addFriendWithUserId:(NSString *)userId{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }

//    if (!([[NoticeSaveModel getUserInfo] voice_total_len].floatValue > 0)) {//如果没发过心情
//        NoticePinBiView *tostView = [[NoticePinBiView alloc] initWithTostWithImage:@"zero_img" titleName:@"请求已发送" content1:@"发条心情" content2:@"遇见更多的同伴" buttonName1:@"发心情" buttonName2:@"还没准备好" actionId:@"" type:2];
//        [tostView showTostView];
//    }
    
    if ((![NoticeComTools isOpenVoice]) && [[NoticeSaveModel getUserInfo] voice_total_len].integerValue) {//如果设置了陌生人不可见并且非0秒用户
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"学友请求已发送，当前隐私设置为禁止非学友浏览记忆和相册，要将对方加入白名单吗(允许对方三天内浏览你的心情和相册)?" message:nil sureBtn:@"加人白名单" cancleBtn:@"不加"];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [nav.topViewController showHUD];
                NSMutableDictionary *parms = [NSMutableDictionary new];
                [parms setObject:userId forKey:@"toUserId"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/whitelist",[[NoticeSaveModel getUserInfo]user_id ]] Accept:@"application/vnd.shengxi.v3.6+json" isPost:YES parmaer:parms page:0 success:^(NSDictionary *dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        NoticePinBiView *pinTostView = [[NoticePinBiView alloc] initWithTostViewString:@"已加入白名单，白名单可\n以在「隐私设置」中管理"];
                        [pinTostView showTostView];
                    }
                } fail:^(NSError *error) {
                    [nav.topViewController hideHUD];
                }];
            }else{
                [nav.topViewController showToastWithText:@"学友请求已发送"];
            }
        };
        [alerView showXLAlertView];
        return ;
    }
    
    if ([NoticeComTools isOpenVoice]) {
        return ;
    }
    
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"请求已发送" message:[NoticeTools isSimpleLau]?@"当前隐私设置为心情和相册仅学友可见是否更改设置，方便对方了解你?":@"當前隱私設置為心情和相冊僅学友可見是否更改設置，方便對方了解妳?" sureBtn:[NoticeTools isSimpleLau]?@"更改设置":@"更改設置" cancleBtn:@"不更改"];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            NoticePrivacySetViewController *ctl = [[NoticePrivacySetViewController alloc] init];
            ctl.titArr = @[Localized(@"privacy.seven"),Localized(@"privacy.no")];
            ctl.headerTitle = Localized(@"privacy.photo");
            ctl.isFromAddFriend = YES;
            ctl.keyString = @"strangeView";
            ctl.boolStr = [NoticeComTools isOpenVoiceString];
            ctl.tag = 2;
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        }else{
            [nav.topViewController showToastWithText:@"学友请求已发送"];
        }
    };
    
    [alerView showXLAlertView];
}

@end
