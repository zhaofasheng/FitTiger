//
//  UITextField+LXPToolbar.m
//  Power4Iphone
//
//  Created by 赵发生 on 16/11/15.
//  Copyright © 2016年 赵发生. All rights reserved.
//

#import "UITextField+LXPToolbar.h"
#import <objc/runtime.h>

static const void *UITextFieldLeftButtonClickBlockKey = "UITextFieldLeftButtonClickBlockKey";
static const void *UITextFieldRightButtonClickBlockKey = "UITextFieldRightButtonClickBlockKey";

@implementation UITextField (LXPToolbar)

/**
 设置左边按钮回调

 @param leftButtonClickBlock 回调
 */
- (void)setLeftButtonClickBlock:(dispatch_block_t)leftButtonClickBlock
{
    objc_setAssociatedObject(self, UITextFieldLeftButtonClickBlockKey, leftButtonClickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_block_t)leftButtonClickBlock
{
    return objc_getAssociatedObject(self, UITextFieldLeftButtonClickBlockKey);
}

/**
 设置右边按钮回调

 @param rightButtonClickBlock 回调
 */
- (void)setRightButtonClickBlock:(dispatch_block_t)rightButtonClickBlock
{
    objc_setAssociatedObject(self, UITextFieldRightButtonClickBlockKey, rightButtonClickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_block_t)rightButtonClickBlock
{
    return objc_getAssociatedObject(self, UITextFieldRightButtonClickBlockKey);
}

/**
 设置工具栏视图

 @param leftTitle 左边标题
 @param leftClickBlock 回调
 @param rightTitle 右边标题
 @param rightClickBlock 回调
 */
- (void)setupToolbarWithLeftButtonTitle:(NSString *)leftTitle leftClickBlock:(dispatch_block_t)leftClickBlock rightButtonTitle:(NSString *)rightTitle rightClickBlock:(dispatch_block_t)rightClickBlock
{
    if (!leftTitle.length && !rightTitle.length) {
        return;
    }
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:2];
    UIBarButtonItem *leftItem = nil;
    if (leftTitle.length) {
        leftItem = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(toolbarLeftItemClickAction)];
        self.leftButtonClickBlock = leftClickBlock;
    }
    UIBarButtonItem *rightItem = nil;
    if (rightTitle.length) {
        rightItem = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(toolbarRightItemClickAction)];
        self.rightButtonClickBlock = rightClickBlock;
    }
    UIBarButtonItem *fispBarButtomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    if (leftItem && rightItem) {
        [items addObject:leftItem];
        [items addObject:fispBarButtomItem];
        [items addObject:rightItem];
    } else if (leftItem) {
        [items addObject:leftItem];
    } else if (rightItem) {
        [items addObject:fispBarButtomItem];
        [items addObject:rightItem];
    }
    toolbar.items = items;
    self.inputAccessoryView = toolbar;
}

/**
 加载工具栏左边按钮和点击回调

 @param title 按钮标题
 @param block 回调
 */
- (void)setupToolbarWithLeftButtonTitle:(NSString *)title clickBlock:(dispatch_block_t)block
{
    [self setupToolbarWithLeftButtonTitle:title leftClickBlock:block rightButtonTitle:nil rightClickBlock:nil];
}
/**
 加载工具栏右边按钮和点击回调
 
 @param title 按钮标题
 @param block 回调
 */
- (void)setupToolbarWithRightButtonTitle:(NSString *)title clickBlock:(dispatch_block_t)block
{
    [self setupToolbarWithLeftButtonTitle:nil leftClickBlock:nil rightButtonTitle:title rightClickBlock:block];
}

/**
 清楚工具栏右边按钮
 */
- (void)setupToolbarToDismissRightButton
{
    __weak typeof(self) weakSelf = self;
    [self setupToolbarWithRightButtonTitle:[NoticeTools getLocalStrWith:@"groupfm.finish"] clickBlock:^{
        [weakSelf resignFirstResponder];
    }];
}

- (void)toolbarLeftItemClickAction
{
    if (self.leftButtonClickBlock) {
        self.leftButtonClickBlock();
    }
}

- (void)toolbarRightItemClickAction
{
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }
}

@end
