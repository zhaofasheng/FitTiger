//
//  NoticeBokeTosatView.m
//  NoticeXi
//
//  Created by li lei on 2022/9/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBokeTosatView.h"

@implementation NoticeBokeTosatView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.userInteractionEnabled = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 314)];
        self.backImageView = imageView;
        self.backImageView.image = UIImageNamed([NoticeTools getLocalImageNameCN:@"bok_success"]);
        self.backImageView.userInteractionEnabled = YES;
        

        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 314)];
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        self.contentView = contentView;
        [self addSubview:contentView];
        self.contentView.center = self.center;
        
        [self.contentView addSubview:self.backImageView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 254, 200, 40)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"group.knowjoin"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        cancelBtn.layer.cornerRadius = 20;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
    }
    return self;
}

- (void)cancelClick{
    if (self.refreshDataBlock) {
        self.refreshDataBlock(YES);
    }
    [self removeFromSuperview];
}

- (void)showChoiceView{
    
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];

    [self creatShowAnimation];
}
- (void)creatShowAnimation
{
    self.contentView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
}

@end
