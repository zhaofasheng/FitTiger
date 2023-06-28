//
//  UIViewController+ToastAndHUD.m
//  LepinSoftware
//
//  Created by ios on 15/8/26.
//
#import <objc/runtime.h>

#import "UIViewController+ToastAndHUD.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

#define ToastDuration 1.5

@implementation UIViewController (ToastAndHUD)

#pragma mark - HUD

static void *HUDKEY = &HUDKEY;

- (MBProgressHUD *)HUD {
    return objc_getAssociatedObject(self, HUDKEY);
}

- (void)setHUD:(MBProgressHUD *)HUD {
    objc_setAssociatedObject(self, HUDKEY, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUD {
    [self showHUDWithText:@""];
}

- (void)showHUDWithText:(NSString *)text {
    MBProgressHUD *HUD = [self HUD];
    if (!HUD)
    {
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        HUD.dimBackground = NO;
        HUD.removeFromSuperViewOnHide = YES;
        HUD.color = [[UIColor redColor] colorWithAlphaComponent:0];
        [self setHUD:HUD];
    }
    UIActivityIndicatorView *ActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    ActivityIndicator.transform = transform;
    ActivityIndicator.color = GetColorWithName(VMainThumeColor);
    //在某个地方设置其 ，开始旋转动画
    [ActivityIndicator startAnimating];
    //菊花隐藏
    [ActivityIndicator setHidesWhenStopped:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = ActivityIndicator;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.labelText = text;
    [HUD show:YES];
}


- (void)showNoColorHUD{
    MBProgressHUD *HUD = [self HUD];
    if (!HUD)
    {
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        HUD.dimBackground = NO;
        HUD.removeFromSuperViewOnHide = YES;
        [self setHUD:HUD];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.color = [UIColor clearColor];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [UIView new];
    [HUD show:YES];
}

- (void)hideHUD {
    [[self HUD] hide:YES];
}

- (void)hideHUDAfterDelay:(NSTimeInterval)timeInterval {
    [[self HUD] hide:YES afterDelay:timeInterval];
}

#pragma mark - Toast

static void *ToastKEY = &ToastKEY;

- (UIView *)toastView {
    return objc_getAssociatedObject(self, ToastKEY);
}

- (void)setToastView:(UIView *)toastView {
    objc_setAssociatedObject(self, ToastKEY, toastView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showToastWithText:(NSString *)toastString {
    [TUITool makeToast:toastString duration:2 position:CGPointMake(DR_SCREEN_WIDTH / 2.0, DR_SCREEN_HEIGHT / 2.0)];
 //   [self showToastWithText:toastString positon:CSToastPositionCenter];
}

- (void)showToastWithText:(NSString *)toastString positon:(id)positon {
    
    if (toastString.length > 0) {
        
        if (![self toastView]) {
            [CSToastManager setQueueEnabled:NO];
            [CSToastManager sharedStyle].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            [CSToastManager sharedStyle].verticalPadding = 20;
            [CSToastManager sharedStyle].horizontalPadding = 18;
        }
        
        UIView *toastView = [self.view toastViewForMessage:toastString title:nil image:nil style:nil];
        [UIView animateWithDuration:0.3 animations:^{
            [self toastView].alpha = 0 ;
        } completion:^(BOOL finished) {
            [[self toastView] removeFromSuperview];
            [self setToastView:toastView];
        }];
        [self.view showToast:toastView duration:ToastDuration position:positon completion:nil];
    }
}

- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showToastWithText:toastString];
    });
}

#pragma mark - Alert

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmAction:(UIAlertAction *)confirmAction {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NoticeTools getLocalStrWith:@"main.cancel"] style:UIAlertActionStyleCancel handler:nil];
    [self showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:confirmAction];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandler:(void(^)(UIAlertAction *))handler {
    [self showAlertWithTitle:title message:message cancelHandler:nil confirmHandler:handler];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(void(^)(UIAlertAction *))handler {
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:handler];
    [self showAlertWithTitle:title message:message confirmAction:confirmAction];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelHandler:(void (^)(UIAlertAction *))cancelHandler confirmHandler:(void (^)(UIAlertAction *))confirmHandler {
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NoticeTools getLocalStrWith:@"main.cancel"] style:UIAlertActionStyleCancel handler:cancelHandler];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[NoticeTools getLocalStrWith:@"main.sure"] style:UIAlertActionStyleDefault handler:confirmHandler];
    [self showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:confirmAction];
}

- (void)showCancelAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(UIAlertAction *))cancelHandler {
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelHandler];
    [self showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(UIAlertAction *)cancelAction confirmAction:(UIAlertAction *)confirmAction {
    
    if (cancelAction == nil && confirmAction == nil) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    cancelAction != nil ? [alertController addAction:cancelAction] : nil;
    confirmAction != nil ? [alertController addAction:confirmAction] : nil;
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
