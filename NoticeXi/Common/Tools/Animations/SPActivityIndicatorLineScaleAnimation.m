//
//  SPActivityIndicatorLineScaleAnimation.m
//  SPActivityIndicatorExample
//
//  Created by Nguyen Vinh on 7/20/15.
//  Copyright (c) 2015 iDress. All rights reserved.
//

#import "SPActivityIndicatorLineScaleAnimation.h"

@implementation SPActivityIndicatorLineScaleAnimation

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor from:(BOOL)left{
    CGFloat duration = 1.0f;
    NSArray *beginTimes = @[@0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f, @0.2f, @0.3f, @0.4f, @0.5f];
    NSArray *beginTimes1 = @[@0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f, @0.4f, @0.3f, @0.2f, @0.1f, @0.2f, @0.3f, @0.4f, @0.5f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2f :0.68f :0.18f :1.08f];
    CGFloat lineSize = size.width / 25+1;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    
    // Animation
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform.scale.y"];
    
    animation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    animation.values = @[@1.0f, @0.4f, @1.0f];
    animation.timingFunctions = @[timingFunction, timingFunction];
    animation.repeatCount = HUGE_VALF;
    animation.duration = duration;
    
    for (int i = 0; i < 3; i++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,size.height/4, lineSize, size.height/2) cornerRadius:lineSize / 2];
        
        animation.beginTime = left? [beginTimes[i] floatValue]:[beginTimes1[i] floatValue];
        line.fillColor = tintColor.CGColor;
        line.path = linePath.CGPath;
        [line addAnimation:animation forKey:@"animation"];
        line.frame = CGRectMake(x + lineSize * 2 * i+1, y, lineSize, size.height);
        [layer addSublayer:line];
    }
}

@end
