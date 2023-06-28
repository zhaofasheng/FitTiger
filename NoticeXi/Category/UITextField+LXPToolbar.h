//
//  UITextField+LXPToolbar.h
//  Power4Iphone
//
//  Created by 赵发生 on 16/11/15.
//  Copyright © 2016年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LXPToolbar)
@property (nonatomic, strong) dispatch_block_t leftButtonClickBlock;
@property (nonatomic, strong) dispatch_block_t rightButtonClickBlock;

- (void)setupToolbarWithLeftButtonTitle:(NSString *)leftTitle leftClickBlock:(dispatch_block_t)leftClickBlock rightButtonTitle:(NSString *)rightTitle rightClickBlock:(dispatch_block_t)rightClickBlock;
- (void)setupToolbarWithLeftButtonTitle:(NSString *)title clickBlock:(dispatch_block_t)block;
- (void)setupToolbarWithRightButtonTitle:(NSString *)title clickBlock:(dispatch_block_t)block;
- (void)setupToolbarToDismissRightButton;
@end


@interface UITextView (LXPToolbar)
@property (nonatomic, strong) dispatch_block_t leftButtonClickBlock;
@property (nonatomic, strong) dispatch_block_t rightButtonClickBlock;

- (void)setupToolbarWithLeftButtonTitle:(NSString *)leftTitle leftClickBlock:(dispatch_block_t)leftClickBlock rightButtonTitle:(NSString *)rightTitle rightClickBlock:(dispatch_block_t)rightClickBlock;
- (void)setupToolbarWithLeftButtonTitle:(NSString *)title clickBlock:(dispatch_block_t)block;
- (void)setupToolbarWithRightButtonTitle:(NSString *)title clickBlock:(dispatch_block_t)block;
- (void)setupToolbarToDismissRightButton;
@end
