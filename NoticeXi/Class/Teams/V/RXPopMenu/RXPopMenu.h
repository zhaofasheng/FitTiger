
 
#import <UIKit/UIKit.h>
@class RXPopMenuItem;

typedef enum : NSUInteger {
    RXPopMenuList = 0,
    RXPopMenuBox,
} RXPopMenuType;

@interface RXPopMenu : UIView

#pragma mark - ShowMenu

/** 创建弹出框 */
+ (id)menuWithType:(RXPopMenuType)type;

/** 隐藏弹出框 */
+ (void)hideBy:(id)target;

/** 展示弹出框 修改任意属性要在该方法调用前
 * target: 弹出框指向控件 可以是view或者UIBarButtonItem
 * items: 弹出框包含的选项
 */
- (void)showBy:(id)target withItems:(NSArray <RXPopMenuItem *>*)items;

/**
 *  如果这时候键盘处于弹起状态 可以将键盘高度传入 避免菜单被键盘遮挡
 *  键盘高度可以用项目中的一个全局单例监听KeyboardNotification来记录
 */
- (void)showBy:(id)target withItems:(NSArray <RXPopMenuItem *>*)items keyboardHeight:(CGFloat)keyboardHeight;

/** 点击事件
 * 可以用 item.index 或者 item.title 区分响应操作
 */
@property (nonatomic, copy) void (^itemActions)(RXPopMenuItem * item);

@property (nonatomic, copy) void (^menuHideDone)(void);

#pragma mark - Options

/** 弹出框是否隐藏箭头 默认 NO */
@property (nonatomic, assign) BOOL hideArrow;

/** 弹出元素是否隐藏图片 默认 NO */
@property (nonatomic, assign) BOOL hideImage;

/** 弹出框大小 默认 CGSizeMake(图片宽度+文字最大宽度, 50 * items.count) */
@property (nonatomic, assign) CGSize menuSize;

/** 单个元素高度 默认 50.f */
@property (nonatomic, assign) CGFloat itemHeight;


@end

#pragma mark -


@interface RXPopMenuItem : NSObject

+ (id)itemTitle:(NSString *)title;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * image;

@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIFont * titleFont;

@end
