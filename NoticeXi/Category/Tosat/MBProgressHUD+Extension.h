
#import <MBProgressHUD/MBProgressHUD.h>

#define HUDHideDuration 2

@interface MBProgressHUD (Extension)

+ (_Nonnull instancetype)showWithText:(NSString * _Nonnull)text view:(UIView * _Nullable)view;
+ (_Nonnull instancetype)showInView:(UIView * _Nullable)view;
+ (_Nonnull instancetype)showInView:(UIView * _Nullable)view labelText:(NSString * _Nullable)text;
- (void)showWithText:(NSString * _Nonnull)text;
- (void)hideInDefaultDuration;
@end
