
#import <UIKit/UIKit.h>

@interface LHEditTextView : UIView
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic,weak)UIButton *grayBgView;
@property (nonatomic,copy)void (^requestDataBlock)(NSString *text);
@property (nonatomic,copy)void (^requestTwoDataBlock)(NSString *text,NSString *textImage);
+(instancetype)showWithController:(UIViewController *)controller;
+(void)showWithController:(UIViewController *)controller andRequestDataBlock:(void(^)(NSString *))requestDataBlock;
+(void)showWithController:(UIViewController *)controller isAddandRequestDataBlock:(void(^)(NSString *,NSString*))requestDataBlock;
@end
