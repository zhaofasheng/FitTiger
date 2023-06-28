
#import <UIKit/UIKit.h>

@interface LHTopTextView : UIView

@property (nonatomic,weak)UITextField *textView;
@property (nonatomic,weak)UIButton *submitBtn;
@property (nonatomic,weak)UIButton *cancelBtn;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,copy) void(^submitImageBlock)(NSString * text);
@property (nonatomic,copy) void(^submitBlock)(NSString * text);
@property (nonatomic,copy) void(^closeBlock)(void);

@end
