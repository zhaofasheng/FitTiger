//
//  UIViewController+LogWhenDealloc.m
//  LepinSoftware
//
//  Created by HeiHuaBaiHua on 15/8/4.
//  Copyright (c) 2015年 成都拼车帮科技有限公司. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+LogWhenDealloc.h"

@implementation UIViewController (LogWhenDealloc)

+ (void)load
{
    Method m1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method m2 = class_getInstanceMethod(self, @selector(swizzleDealloc));
    method_exchangeImplementations(m1, m2);
    
    Method m3 = class_getInstanceMethod(self, @selector(didReceiveMemoryWarning));
    Method m4 = class_getInstanceMethod(self, @selector(swizzleDidReceiveMemoryWarning));
    method_exchangeImplementations(m3, m4);
}

- (void)swizzleDealloc
{
    NSString *className = NSStringFromClass([self class]);
    if (![className hasPrefix:@"UI"] && ![className hasPrefix:@"_UI"]) {
        //NSLog(@"------------------------------Dealloc : %@------------------------------",className);
    }
    [self swizzleDealloc];
}

- (void)swizzleDidReceiveMemoryWarning
{
    NSString *className = NSStringFromClass([self class]);
    if (![className hasPrefix:@"UI"] && ![className hasPrefix:@"_UI"]) {
        //NSLog(@"------------------------------MemoryWarning : %@------------------------------",className);
    }
    [self swizzleDidReceiveMemoryWarning];
}

@end
