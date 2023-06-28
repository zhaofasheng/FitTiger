

#import <UIKit/UIKit.h>


#define SCREEN_W                 [UIScreen mainScreen].bounds.size.width
#define SCREEN_H                 [UIScreen mainScreen].bounds.size.height
#define kMainWindow              [UIApplication sharedApplication].keyWindow


typedef void (^ClickBlock) (UIButton * _Nullable button);

NS_ASSUME_NONNULL_BEGIN

@interface PGBubble : UIView

@property (nonatomic, copy) void (^clickBlock)(NSInteger type);
/// 是否取消 消失的动画效果 默认NO
@property (nonatomic, assign) BOOL isAnimation;

/// 显示
-(void)showWithView:(UIView *)view;
/// 移除
- (void)dismiss;

@property (nonatomic, assign) BOOL isHalf;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *url;
@end

NS_ASSUME_NONNULL_END
