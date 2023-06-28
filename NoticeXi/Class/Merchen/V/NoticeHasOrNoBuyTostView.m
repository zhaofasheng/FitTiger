//
//  NoticeHasOrNoBuyTostView.m
//  NoticeXi
//
//  Created by li lei on 2021/8/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeHasOrNoBuyTostView.h"
#import "NoticeLelveImageView.h"
@implementation NoticeHasOrNoBuyTostView

- (instancetype)initWithShowBuy:(BOOL)buy{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 296)];
        self.backImageView = imageView;
        self.backImageView.image = UIImageNamed(buy?@"Image_hasBuy" : @"Image_hasNoBuy");
        self.backImageView.center = self.center;
        [self addSubview:self.backImageView];

        self.backImageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [self addGestureRecognizer:cancelTap];
    }
    return self;
}

- (instancetype)initWithShowUser:(NoticeUserInfoModel *)userM points:(NSString *)points{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 285)];
        self.backImageView = imageView;
        self.backImageView.image = UIImageNamed(@"Image_hasBuydj");
        self.backImageView.center = self.center;
        [self addSubview:self.backImageView];

        self.backImageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 168, 280, 22)];
        label.text = [NoticeTools getLocalStrWith:@"zb.gxshuo"];
        label.font = SIXTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.backImageView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+8, 280, 33)];
        label1.text = [NSString stringWithFormat:@"%@%@",points,[NoticeTools getLocalStrWith:@"zb.dfadianzhi"]];
        label1.font = XGTwentyTwoBoldFontSize;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.backImageView addSubview:label1];
        
        CGFloat width = GET_STRWIDTH([NoticeTools getLocalStrWith:@"zb.yishegnjizhi"], 14, 20);
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((280-width-47)/2,CGRectGetMaxY(label1.frame)+8, width, 20)];
        label2.text = [NoticeTools getLocalStrWith:@"zb.yishegnjizhi"];
        label2.font = FOURTHTEENTEXTFONTSIZE;
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.backImageView addSubview:label2];
        
        NoticeLelveImageView *leImgView = [[NoticeLelveImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), label2.frame.origin.y+2.5, 52, 16)];
        leImgView.image = UIImageNamed(userM.levelImgName);
        [self.backImageView addSubview:leImgView];
        
        UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [self addGestureRecognizer:cancelTap];
    }
    return self;
}

- (void)cancelClick{
    [self removeFromSuperview];
}

- (void)showChoiceView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

    [self creatShowAnimation];
}
- (void)creatShowAnimation
{
    self.backImageView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
}

@end
