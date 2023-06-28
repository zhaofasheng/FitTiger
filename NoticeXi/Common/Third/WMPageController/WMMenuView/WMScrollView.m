//
//  WMScrollView.m
//  WMPageController
//
//  Created by lh on 15/11/21.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMScrollView.h"

@implementation WMScrollView

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag == 527) {
        // 如果视图为UITableViewCellContentView（即点击tableViewCell），则不截获Touch事件
        if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
            return NO;
        }
    }else{
        if (touch.view.tag >= 70000) {
            return YES;
        }
        
        if (touch.view.tag >= 2000) {
            // 如果视图为UITableViewCellContentView（即点击tableViewCell），则不截获Touch事件
            if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
                return NO;
            }
        }
        return  YES;
    }
    return YES;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (self.needCellScrool) {
        if ([view.superview isKindOfClass:[UITableViewCell class]]){
            self.scrollEnabled = NO;
        }else{
            self.scrollEnabled = YES;
        }
    }

    return view;
}


@end
