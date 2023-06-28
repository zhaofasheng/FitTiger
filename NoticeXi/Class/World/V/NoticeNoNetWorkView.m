//
//  NoticeNoNetWorkView.m
//  NoticeXi
//
//  Created by li lei on 2021/12/14.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNoNetWorkView.h"

@implementation NoticeNoNetWorkView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E69191"];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = EIGHTEENTEXTFONTSIZE;
        label.text = [NoticeTools getLocalStrWith:@"net.nowork"];
        [self addSubview:label];
        
        
    }
    return self;
}

- (void)show{
    [self dissMiss];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
    self.time = 0;
    self.waitTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(activeOut) userInfo:nil repeats:YES];
}

- (void)creatShowAnimation
{
    self.layer.position = self.center;
    self.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)activeOut{
    self.time++;
    if (self.time == 3) {
        [self dissMiss];
        self.time = 0;
    }
}

- (void)dissMiss{
    [self.waitTimer invalidate];
    [self removeFromSuperview];
}
@end
