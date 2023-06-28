//
//  NoticeOcToSwift.h
//  NoticeXi
//
//  Created by li lei on 2019/8/28.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeOcToSwift : UIView

+ (UIColor *)getDarkTextColor;
+ (UIColor *)getBackColor;
+ (UIColor *)getMainTextColor;
+ (UIColor *)getlineColor;
+ (UIColor *)getBigLineColor;
+ (UIColor *)getMainThumbColor;
+ (UIColor *)getMainThumbWhiteColor;
+ (CGFloat)devoiceWidth;
+ (CGFloat)devoiceHeight;
+ (UIColor *)getColorWith:(NSString *)colorHex;

+ (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
