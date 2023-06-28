//
//  NoticeShareView.h
//  NoticeXi
//
//  Created by li lei on 2018/11/12.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShareView : UIView
+ (void)shareWithurl:(NSString *)urlStr type:(SSDKPlatformType)type;
+ (void)shareWithurl:(NSString *)urlStr type:(SSDKPlatformType)type title:(NSString *)title name:(NSString *)name;
+ (void)inivteWithurl:(NSString *)urlStr type:(SSDKPlatformType)type;
@end

NS_ASSUME_NONNULL_END
