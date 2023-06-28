//
//  DrawView.m
//  10-涂鸦画板
//
//  Created by 赵发生 on 15/8/4.
//  Copyright (c) 2019年 赵发生. All rights reserved.
//

#import "DrawView.h"

#import "DrawPath.h"

@interface DrawView ()

@property (nonatomic, strong) NSMutableArray *paths;

@property (nonatomic, strong) NSMutableArray *lastPaths;
@property (nonatomic, strong) UIBezierPath *path;


@end


@implementation DrawView
{
    double lastValue;
    CGFloat lastX;
    CGFloat lastY;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    [self.paths addObject:image];

    [self setNeedsDisplay];
}

// 撤销
- (void)undo
{
    if (self.paths.count) {
        [self.lastPaths addObject:self.paths.lastObject];//先保存删除的
        [self.paths removeLastObject];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshHasUndo:hasReback:)]) {
        [self.delegate refreshHasUndo:self.paths.count hasReback:self.lastPaths.count];
    }
    [self setNeedsDisplay];
}

- (void)reBack{
    if (self.lastPaths.count) {
        [self.paths addObject:self.lastPaths.lastObject];
        [self.lastPaths removeLastObject];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshHasUndo:hasReback:)]) {
        [self.delegate refreshHasUndo:self.paths.count hasReback:self.lastPaths.count];
    }
    [self setNeedsDisplay];
}

- (void)clear
{
    // 清除画板view所有的路径,并且重绘
    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lineWidth = 1;
    _lineColor = [UIColor blackColor];
}

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

-(BOOL)isMultipleTouchEnabled {
    return YES;
}

// 当手指点击view,就需要记录下起始点
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.drawViewType != 1) {
        return;
    }
    // 获取UITouch
    UITouch *touch = [touches anyObject];
    // 获取起始点
    CGPoint curP = [touch locationInView:self];

    // 只要一开始触摸控件,设置起始点
    DrawPath *path = [DrawPath path];

    path.lineColor = _lineColor;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:curP];

    path.lineWidth = _lineWidth;

    // 记录当前正在描述的路径
    _path = path;
    [self.lastPaths removeAllObjects];
    // 保存当前的路径
    [self.paths addObject:path];

    [_path addLineToPoint:curP];
    // 重绘
    [self setNeedsDisplay];

    if (self.delegate && [self.delegate respondsToSelector:@selector(hasDraw)]) {
        [self.delegate hasDraw];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshHasUndo:hasReback:)]) {
        [self.delegate refreshHasUndo:self.paths.count hasReback:self.lastPaths.count];
    }
}

// 每次手指移动的时候调用
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.drawViewType != 1) {
        return;
    }
    if (event.allTouches.count > 1) {
        return;
    }
    // 获取UITouch
    UITouch *touch = [touches anyObject];

    // 获取当前触摸点
    CGPoint curP = [touch locationInView:self];

    [_path addLineToPoint:curP];
    // 重绘
    [self setNeedsDisplay];

}

// 绘制东西
- (void)drawRect:(CGRect)rect
{
    for (DrawPath *path in self.paths) {
        
        if ([path isKindOfClass:[UIImage class]]) { // 图片
            UIImage *image = (UIImage *)path;
            
            [image drawAtPoint:CGPointZero];
        }else{
            
            [path.lineColor set];
            
            [path stroke];
        }
    }
}

- (NSMutableArray *)lastPaths{
    if (!_lastPaths) {
        _lastPaths = [NSMutableArray new];
    }
    return _lastPaths;
}

@end
