//
//  UIView+Shadow.m
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/4/16.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

-(void)addShdowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(BNShadowSide)shadowSide{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = shadowOpacity;
    
    // 默认值 0 -3
    // 使用默认值即可，这个各个边都要设置阴影的，自己调反而效果不是很好。
    //    self.layer.shadowOffset = CGSizeMake(0, -3);
    
    CGRect bounds = self.layer.bounds;
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat maxY = CGRectGetMaxY(bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (shadowSide & BNShadowSideTop) {
        // 上边
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(0, -shadowRadius)];
        [path addLineToPoint:CGPointMake(maxX, -shadowRadius)];
        [path addLineToPoint:CGPointMake(maxX, 0)];
    }
    
    if (shadowSide & BNShadowSideRight) {
        // 右边
        [path moveToPoint:CGPointMake(maxX, 0)];
        [path addLineToPoint:CGPointMake(maxX,maxY)];
        [path addLineToPoint:CGPointMake(maxX + shadowRadius, maxY)];
        [path addLineToPoint:CGPointMake(maxX + shadowRadius, 0)];
    }
    
    if (shadowSide & BNShadowSideBottom) {
        // 下边
        [path moveToPoint:CGPointMake(0, maxY)];
        [path addLineToPoint:CGPointMake(maxX,maxY)];
        [path addLineToPoint:CGPointMake(maxX, maxY + shadowRadius)];
        [path addLineToPoint:CGPointMake(0, maxY + shadowRadius)];
    }
    
    if (shadowSide & BNShadowSideLeft) {
        // 左边
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(-shadowRadius,0)];
        [path addLineToPoint:CGPointMake(-shadowRadius, maxY)];
        [path addLineToPoint:CGPointMake(0, maxY)];
    }
    
    self.layer.shadowPath = path.CGPath;
}

- (void)setButtonShadowWithbuttonRadius:(CGFloat)radius {
	if (radius > 0) {
		self.layer.cornerRadius = radius;
//		self.layer.masksToBounds = YES;
	}

	[self setShadowWithColor:[UIColor blackColor] offset:CGSizeMake(0, 3) shadowOpacity:0.4 radius:5];
}

- (void)setBackgroundViewShadowWithColor:(UIColor *)color {
	[self setShadowWithColor:color offset:CGSizeMake(0, 0) shadowOpacity:0.7 radius:0];
}

- (void)setBackgroundViewShadowWithViewRadius:(CGFloat)radius {
	if (radius > 0) {
		self.layer.cornerRadius = radius;
//		self.layer.masksToBounds = YES;
	}
	
	[self setShadowWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] offset:CGSizeMake(0, 0) shadowOpacity:0.2 radius:3];
}

- (void)setShadowWithColor:(UIColor *)shadowColor offset:(CGSize)offset shadowOpacity:(float)shadowOpacity radius:(CGFloat)radius{
	self.layer.shadowColor = shadowColor.CGColor;
	self.layer.shadowOffset = offset;
	self.layer.shadowOpacity = shadowOpacity;
	self.layer.shadowRadius = radius;
}

- (void)setBackgroundViewShadowWithViewRadius:(CGFloat)radius addOffset:(CGFloat)addOffset {
	
	[self setButtonShadowWithbuttonRadius:radius];
	[self addShadowPathWithShadowLayer:self.layer addOffset:5];
}

- (void)addShadowPathWithShadowLayer:(CALayer *)shadowLayer addOffset:(CGFloat)addOffset {
	//路径阴影
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	float width = self.frame.size.width;
	float height = self.frame.size.height;
	float x = self.frame.origin.x;
	float y = self.frame.origin.y;
	float addWH = 10;
	
	CGPoint topLeft      = self.frame.origin;
	CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
	CGPoint topRight     = CGPointMake(x+width,y);
	
	CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
	
	CGPoint bottomRight  = CGPointMake(x+width,y+height);
	CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
	CGPoint bottomLeft   = CGPointMake(x,y+height);
	
	
	CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
	
	[path moveToPoint:topLeft];
	//添加四个二元曲线
	[path addQuadCurveToPoint:topRight
				 controlPoint:topMiddle];
	[path addQuadCurveToPoint:bottomRight
				 controlPoint:rightMiddle];
	[path addQuadCurveToPoint:bottomLeft
				 controlPoint:bottomMiddle];
	[path addQuadCurveToPoint:topLeft
				 controlPoint:leftMiddle];
	
	shadowLayer.shadowPath = path.CGPath;
}

@end
