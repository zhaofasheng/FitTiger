//
//  NoticeCannotCallView.m
//  NoticeXi
//
//  Created by li lei on 2021/10/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCannotCallView.h"

@implementation NoticeCannotCallView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 335, 475)];
        if ([NoticeTools getLocalType] == 1) {
            self.imageView.image = UIImageNamed(@"Image_timeCallen");
        }else if ([NoticeTools getLocalType] == 2){
            self.imageView.image = UIImageNamed(@"Image_timeCallja");
        }else{
            self.imageView.image = UIImageNamed(@"Image_timeCall");
        }
        
        [self addSubview:self.imageView];
        self.imageView.center = self.center;
        self.imageView.userInteractionEnabled = YES;
        
        UIButton *disbtn = [[UIButton alloc] initWithFrame:CGRectMake(335-60, 0, 60, 60)];
        [disbtn addTarget:self action:@selector(dissClick) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:disbtn];
        
        UIButton *disbtn1 = [[UIButton alloc] initWithFrame:CGRectMake(30, 475-50-20, 335-60-10, 60)];
        [disbtn1 addTarget:self action:@selector(dissClick) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:disbtn1];
    }
    return self;
}

- (void)dissClick{
    if (self.closkBlock) {
        self.closkBlock(YES);
    }
    [self removeFromSuperview];
}

- (void)show{

    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.imageView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
