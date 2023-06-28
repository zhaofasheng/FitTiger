//
//  NoticePointView.m
//  NoticeXi
//
//  Created by li lei on 2022/10/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticePointView.h"
#define kLineWidth 2.f
@implementation NoticePointView

- (void)setPointArray:(NSArray *)pointArray
{
    _pointArray = pointArray;
    
    //调用该方法会重新加载drawRect方法
    [self setNeedsDisplay];
}
 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}
 
- (void)drawRect:(CGRect)rect
{
    if (self.pointArray.count == 0) {
        return;
    }
    //获取上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(ref, kLineWidth);
    //路径
    CGContextBeginPath(ref);
    //设置颜色
    CGContextSetStrokeColorWithColor(ref, [UIColor colorWithHexString:self.colorStr].CGColor);
    
    for (int i = 0; i < self.pointArray.count; i++) {
        CGPoint point = [[_pointArray objectAtIndex:i] CGPointValue];
        //设置起点坐标
        CGContextMoveToPoint(ref, self.bounds.size.width - i * kLineWidth * 2, self.bounds.size.height);
        //设置下一个点坐标
        CGContextAddLineToPoint(ref, self.bounds.size.width - i * kLineWidth * 2, self.bounds.size.height - point.y);
    }
    
    //渲染，连接起点和下一个坐标点
    CGContextStrokePath(ref);
}


@end
