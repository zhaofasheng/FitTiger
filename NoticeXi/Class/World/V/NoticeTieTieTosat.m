//
//  NoticeTieTieTosat.m
//  NoticeXi
//
//  Created by li lei on 2022/4/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeTieTieTosat.h"

@implementation NoticeTieTieTosat

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-80, DR_SCREEN_WIDTH-120+60+20)];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.layer.cornerRadius = 20;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        self.contentView.center = self.center;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-80, 60)];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.font = XGSIXBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.titleL];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, DR_SCREEN_WIDTH-120, DR_SCREEN_WIDTH-120)];
        self.imageView.layer.cornerRadius = 2;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        self.imageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dissTap{
    [self removeFromSuperview];
}

- (void)show{
    [self creatShowAnimation];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}

- (void)creatShowAnimation
{
    self.contentView.layer.position = self.center;
    self.contentView.transform = CGAffineTransformMakeScale(0.70, 0.70);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

@end
