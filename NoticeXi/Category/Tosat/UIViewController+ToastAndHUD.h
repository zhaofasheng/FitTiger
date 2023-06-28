//
//  UIViewController+ToastAndHUD.h
//  LepinSoftware
//
//  Created by ios on 15/8/26.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ToastAndHUD)

- (void)showToastWithText:(NSString *)toastString;
- (void)showToastWithText:(NSString *)toastString positon:(id)positon;
- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval;
- (void)showNoColorHUD;
- (void)showHUD;
- (void)showHUDWithText:(NSString *)text;
- (void)hideHUD;
- (void)hideHUDAfterDelay:(NSTimeInterval)timeInterval;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandler:(void(^)(UIAlertAction *confirmAction))handler;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmHandler:(void(^)(UIAlertAction *confirmAction))handler;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelHandler:(void (^)(UIAlertAction *cancelAction))cancelHandler confirmHandler:(void (^)(UIAlertAction *confirmAction))confirmHandler;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(UIAlertAction *)cancelAction confirmAction:(UIAlertAction *)confirmAction;
- (void)showCancelAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(UIAlertAction *cancelAction))cancelHandler;
@end
