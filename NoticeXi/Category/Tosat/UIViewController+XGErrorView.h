//
//  UIViewController+XGErrorView.h
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/5/3.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XGErrorView)

/** 显示指定错误页面（如空白页）在VC上 */
- (void)showErrorViewWithFrame:(CGRect)frame errorText:(NSString *)errorText;


/** 显示指定错误页面在自定view上 */
- (void)showErrorViewWithFrame:(CGRect)frame errorText:(NSString *)errorText toView:(UIView *)toView;

- (void)hideErrorView;

@end
