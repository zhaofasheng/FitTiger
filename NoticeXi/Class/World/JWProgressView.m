//
//  JWProgressView.m
//  NoticeXi
//
//  Created by li lei on 2020/3/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//
#import "JWProgressView.h"
@interface JWProgressView ()

{
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
}

@end

@implementation JWProgressView

@synthesize progressValue = _progressValue;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
        
    }
    return self;
    
}

//初始化创建图层
- (void)setUp
{
    //创建背景图层
    self.backGroundLayer = [CAShapeLayer layer];
    self.backGroundLayer.fillColor = nil;

    //创建填充图层
    self.frontFillLayer = [CAShapeLayer layer];
    self.frontFillLayer.fillColor = nil;

    //创建中间label
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.textColor = GetColorWithName(VMainThumeColor);

    [self addSubview:_contentLabel];
    
    [self.layer addSublayer:self.backGroundLayer];
    [self.layer addSublayer:self.frontFillLayer];
      
}

#pragma mark -子控件约束
-(void)layoutSubviews {

    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    _contentLabel.frame = CGRectMake(0, 0, width - 4, 40);
    _contentLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.backGroundLayer.frame = self.bounds;

    backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:0 endAngle:M_PI*2
                                                       clockwise:YES];
    self.backGroundLayer.path = backGroundBezierPath.CGPath;
    
    self.frontFillLayer.frame = self.bounds;

    //设置线宽
    self.frontFillLayer.lineWidth = 4.0;
    self.backGroundLayer.lineWidth = 4.0;
}

#pragma mark - 设置label文字和进度的方法
-(void)setContentText:(NSString *)contentText {

    if (_progressValue == 1) {
        
        return;
    }
    if (contentText) {
        
        _contentLabel.text = contentText;
    }
}

- (void)setProgressValue:(CGFloat)progressValue
{
    
     progressValue = MAX( MIN(progressValue, 1.0), 0.0);
     _progressValue = progressValue;
    CGFloat width = self.bounds.size.width;
    
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:-0.25*2*M_PI endAngle:(2*M_PI)*progressValue - 0.25*2*M_PI clockwise:YES];
    self.frontFillLayer.path = frontFillBezierPath.CGPath;
}
- (CGFloat)progressValue
{
    return _progressValue;
}

@end
