//
//  UIView+Shadow.h
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/4/16.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, BNShadowSide) {
    BNShadowSideNone   = 0,
    BNShadowSideTop    = 1 << 0,
    BNShadowSideLeft   = 1 << 1,
    BNShadowSideBottom = 1 << 2,
    BNShadowSideRight  = 1 << 3,
    BNShadowSideAll    = BNShadowSideTop | BNShadowSideLeft | BNShadowSideBottom | BNShadowSideRight
};

@interface UIView (Shadow)

- (void)setButtonShadowWithbuttonRadius:(CGFloat)radius; //设置button阴影

- (void)setBackgroundViewShadowWithColor:(UIColor *)color;
- (void)setBackgroundViewShadowWithViewRadius:(CGFloat)radius; //设置view阴影

- (void)setShadowWithColor:(UIColor *)shadowColor offset:(CGSize)offset shadowOpacity:(float)shadowOpacity radius:(CGFloat)radius;

//四周阴影路径
- (void)setBackgroundViewShadowWithViewRadius:(CGFloat)radius addOffset:(CGFloat)addOffset;

/// 使用位枚举指定圆角位置
/// 通过在各个边画矩形来实现shadowpath，真正实现指那儿打那儿
/// @param shadowColor 阴影颜色
/// @param shadowOpacity 阴影透明度
/// @param shadowRadius 阴影半径
/// @param shadowSide 阴影位置
-(void)addShdowColor:(UIColor *)shadowColor
       shadowOpacity:(CGFloat)shadowOpacity
        shadowRadius:(CGFloat)shadowRadius
          shadowSide:(BNShadowSide)shadowSide;
@end
