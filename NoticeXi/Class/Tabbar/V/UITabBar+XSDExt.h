//
//  UITabBar+XSDExt.h
//  NoticeXi
//
//  Created by li lei on 2018/11/13.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (XSDExt)

- (void)showBadgeOnItemIndex:(NSInteger)index;   ///<显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index;  ///<隐藏小红点

@end
