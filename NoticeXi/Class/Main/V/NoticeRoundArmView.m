//
//  NoticeRoundArmView.m
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeRoundArmView.h"

@implementation NoticeRoundArmView
{
    BOOL isHiden;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,315, 430)];
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        self.contentView.center = self.center;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshiTap)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshiTap1)];
        [self.contentView addGestureRecognizer:tap1];
        
        UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width-159)/2, 40, 159, 19)];
        iamgeView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_lptit_b":@"Image_lptit_y");
        [self.contentView addSubview:iamgeView];
        
        self.ruondImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width-270)/2,92, 270, 270)];
        self.ruondImageView.layer.cornerRadius = self.ruondImageView.frame.size.height/2;
        self.ruondImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.ruondImageView];
        self.ruondImageView.backgroundColor = GetColorWithName(VMainThumeColor);
        self.ruondImageView.userInteractionEnabled = YES;
        self.ruondImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imagelpb":@"Imagelpy");
  
        UIImageView *startImagView = [[UIImageView alloc] initWithFrame:self.ruondImageView.frame];
        [self.contentView addSubview:startImagView];
        startImagView.userInteractionEnabled = YES;
        startImagView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Imagelpzb":@"Imagelpzy");
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startClick)];
        [startImagView addGestureRecognizer:tap2];

    }
    return self;
}

- (void)xiaoshiTap{
    isHiden = YES;
    [self.ruondImageView.layer removeAllAnimations];
    if (self.hideBlock) {
        self.hideBlock(YES);
    }
    [self removeFromSuperview];
}
- (void)xiaoshiTap1{
}
- (void)startClick{
    if (self.isAnationm) {
        return;
    }
    self.isAnationm = YES;

     //设置转圈的圈数
     NSInteger circleNum = 16;
     
    _circleAngle = arc4random()%360;
 
     CGFloat perAngle = M_PI/180.0;
          
     CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
     rotationAnimation.toValue = [NSNumber numberWithFloat:_circleAngle * perAngle + 360 * perAngle * circleNum];
     rotationAnimation.duration = 4.0f;
     rotationAnimation.cumulative = YES;
     rotationAnimation.delegate = self;
     
//     kCAMediaTimingFunctionLinear//匀速的线性计时函数
//     kCAMediaTimingFunctionEaseIn//缓慢加速，然后突然停止
//     kCAMediaTimingFunctionEaseOut//全速开始，慢慢减速
//     kCAMediaTimingFunctionEaseInEaseOut//慢慢加速再慢慢减速
//     kCAMediaTimingFunctionDefault//也是慢慢加速再慢慢减速，但是它加速减速速度略慢
     //由快变慢
     rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     rotationAnimation.fillMode=kCAFillModeForwards;
     rotationAnimation.removedOnCompletion = NO;
     [self.ruondImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (isHiden) {
        return;
    }
    [NSThread sleepForTimeInterval:1];
    self.isAnationm = NO;
    NSString *title;
    //1:学习  2:躺尸 3：活动拉伸  4培养兴趣  5:刷最近追的剧 6阅读 7游戏
    if ((_circleAngle >=0 && _circleAngle <= 30) || _circleAngle > 330) {
        title = @"学习";
        self.type = 1;
        self.time = 5*60;
        self.whiteColor = @"#ff9d4d";
        self.nightColor = @"#b36e3e";
    }else if (_circleAngle > 30 && _circleAngle<= 80){
        title = @"游戏";
        self.type = 7;
        self.time = 30*60;
        self.whiteColor = @"#4bc481";
        self.nightColor = @"#2e784f";
    }else if (_circleAngle > 80 && _circleAngle<= 130){
        title = @"阅读";
        self.type = 6;
        self.time = 5*60;
        self.whiteColor = @"#ffc152";
        self.nightColor = @"#b38639";
    }else if (_circleAngle > 130 && _circleAngle<= 180){
        title = @"追剧";
        self.type = 5;
        self.time = 40*60;
        self.whiteColor = @"#48ccc6";
        self.nightColor = @"#2d807b";
    }else if (_circleAngle > 180 && _circleAngle<= 230){
        title = @"培养兴趣";
        self.type = 4;
        self.time = 25*60;
        self.whiteColor = @"#a5a0ea";
        self.nightColor = @"#716da1";
    }else if (_circleAngle > 230 && _circleAngle<= 280){
        title = @"活动拉伸";
        self.type = 3;
        self.time = 2*60;
        self.whiteColor = @"#ff8e55";
        self.nightColor = @"#b3633b";
    }else if (_circleAngle > 280 && _circleAngle<= 330){
        title = @"躺尸";
        self.type = 2;
        self.time = 60;
        self.whiteColor = @"#4cb4d3";
         self.nightColor = @"#317387";
    }
    
    if (self.timeBlock) {
        self.timeBlock(self.type, self.time, self.whiteColor, self.nightColor);
    }
    [self removeFromSuperview];
    DRLog(@"%@",title);
}

- (void)showTostView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.contentView.layer.position = self.center;
    self.contentView.transform = CGAffineTransformMakeScale(0.20, 0.20);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
