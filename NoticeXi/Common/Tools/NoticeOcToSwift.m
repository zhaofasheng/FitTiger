//
//  NoticeOcToSwift.m
//  NoticeXi
//
//  Created by li lei on 2019/8/28.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeOcToSwift.h"
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
@implementation NoticeOcToSwift

+ (UIViewController *)topViewController{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    return nav.topViewController;
}

+ (UIColor *)getDarkTextColor{
    return [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#999999":@"#3E3E4A"];
}
+ (UIColor *)getBackColor{
    return [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#181828"];
}
+ (UIColor *)getMainTextColor{
    return [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#333333":@"#72727F"];
}
+ (UIColor *)getMainThumbColor{
    return [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#46CDCF":@"#318F90"];
}
+ (CGFloat)devoiceWidth{
    return DR_SCREEN_WIDTH;
}
+ (CGFloat)devoiceHeight{
    return DR_SCREEN_HEIGHT;
}

+ (UIColor *)getMainThumbWhiteColor{
    return GetColorWithName(VMainThumeWhiteColor);
}

+ (UIColor *)getColorWith:(NSString *)colorHex{
    return [UIColor colorWithHexString:colorHex];
}

+ (UIColor *)getlineColor{
    return [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#EDEDED":@"#12121F"];
}

+ (UIColor *)getBigLineColor{
    return [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#F7F7F7":@"#12121F"];
}
@end
