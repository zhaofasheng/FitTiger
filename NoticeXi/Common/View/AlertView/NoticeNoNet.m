//
//  NoticeNoNet.m
//  NoticeXi
//
//  Created by li lei on 2018/12/13.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNoNet.h"
#define ANGLE_TO_RADIAN(angle) ((angle)/180.0 * M_PI)
@implementation NoticeNoNet

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 325, 280)];
        self.imageView.image = UIImageNamed(@"ImageNonet");
        self.imageView.center = self.center;
        [self addSubview:self.imageView];
        
        self.imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTao)];
        [self.imageView addGestureRecognizer:tap1];
        
    }
    return self;
}

- (void)setTao{
    [self dismiss];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:url options:@{} completionHandler:nil];
            }
        } else {
            [application openURL:url options:@{} completionHandler:nil];
        }
    }
}

- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [rootWindow bringSubviewToFront:self];
    //实例化
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    //拿到动画 key
    anim.keyPath =@"transform.rotation";
    // 动画时间
    anim.duration =.15;
    // 重复的次数
    //anim.repeatCount = 16;
    //无限次重复
    anim.repeatCount =MAXFLOAT;
    //设置抖动数值
    anim.values =@[@(ANGLE_TO_RADIAN(-5)),@(ANGLE_TO_RADIAN(5)),@(ANGLE_TO_RADIAN(-5))];
    // 保持最后的状态
    anim.removedOnCompletion =NO;
    //动画的填充模式
    anim.fillMode =kCAFillModeForwards;
    //layer层实现动画
    [self.imageView.layer addAnimation:anim forKey:@"shake"];
    
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];

}
- (void)delayMethod{
    [self.imageView.layer removeAnimationForKey:@"shake"];
}

- (void)dismiss{
    [self removeFromSuperview];
}

@end
