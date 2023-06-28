//
//  UIViewController+XGErrorView.m
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/5/3.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "UIViewController+XGErrorView.h"
#import "XGErrorView.h"

static void *ErrorViewKey = &ErrorViewKey;


@implementation UIViewController (XGErrorView)

- (XGErrorView *)errorView {
	return objc_getAssociatedObject(self, ErrorViewKey);
}

- (void)setErrorView:(XGErrorView *)errorView {
	objc_setAssociatedObject(self, ErrorViewKey, errorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)showErrorViewWithFrame:(CGRect)frame errorText:(NSString *)errorText {
	[self showErrorViewWithFrame:frame errorText:errorText toView:self.view];
}

- (void)showErrorViewWithFrame:(CGRect)frame errorText:(NSString *)errorText toView:(UIView *)toView {
	XGErrorView *errorView = [self errorView];
	if (errorView == nil) {
		errorView = [[XGErrorView alloc] initWithFrame:frame errorText:errorText];
		[toView addSubview:errorView];
		[self setErrorView:errorView];
	}
	errorView.hidden = NO;
	errorView.frame = frame;
    errorView.errorText = errorText;
}

- (void)hideErrorView {
	[self errorView].hidden = YES;
}

@end
