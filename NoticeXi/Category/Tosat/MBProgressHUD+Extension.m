//
//  MBProgressHUD+Extension.m
//  HousePKManager
//
//  Created by 赵发生 on 16/7/16.
//
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

/**
 扩展MBProgressHUD方法

 @param text 文本信息
 @param view 视图
 @return 弹出视图
 */
+ (instancetype)showWithText:(NSString *)text view:(UIView *)view
{
    UIView *v = nil;
    if (view == nil) {
        v = [UIApplication sharedApplication].keyWindow;
    } else {
        v = view;
    }
    if ([text isEqual:[NSNull null]]) {
        text = @"服务器请求异常";
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:v];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    
    [v addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:HUDHideDuration];
    return hud;
}

+ (instancetype)showInView:(UIView *)view
{
    return [self showInView:view labelText:nil];
}

/**
 扩展弹出信息视图

 @param view 视图
 @param text 文本信息
 @return 弹出视图
 */
+ (instancetype)showInView:(UIView *)view labelText:(NSString *)text
{
    UIView *v = nil;
    if (view == nil) {
        v = [UIApplication sharedApplication].keyWindow;
    } else {
        v = view;
    }
    if ([text isEqual:[NSNull null]]) {
        text = @"服务器请求异常";
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:v];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    [v addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    return hud;
}

/**
 关闭弹出视图
 */
- (void)hideInDefaultDuration
{
    [self hide:YES afterDelay:HUDHideDuration];
}

/**
 默认弹出文字

 @param text 文本
 */
- (void)showWithText:(NSString *)text
{
    if ([text isEqual:[NSNull null]]) {
        text = @"服务器请求异常";
    }
    self.mode = MBProgressHUDModeText;
    self.labelText = text;
    [self hideInDefaultDuration];
}
@end
