//
//  NoticeSureSendUserTostView.m
//  NoticeXi
//
//  Created by li lei on 2022/6/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSureSendUserTostView.h"

@implementation NoticeSureSendUserTostView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 201)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        self.backView.center = self.center;
        [self addSubview:self.backView];
        
        UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(15, 65, 250, 74)];
        mbView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        mbView.layer.cornerRadius = 8;
        mbView.layer.masksToBounds = YES;
        [self.backView addSubview:mbView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 81, 41, 41)];
        self.iconImageView.layer.cornerRadius = 41/2;
        self.iconImageView.layer.masksToBounds = YES;
        [self.backView addSubview:self.iconImageView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(64+15, 80, 280-64-15, 21)];
        self.nameL.font = FIFTHTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.nameL];
        
       
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(64+15, 104, 280-64-15, 20)];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.numL];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,25, 280, 20)];
        titleL.font = XGEightBoldFontSize;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = [NoticeTools getLocalStrWith:@"send.checkeuser"];
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:titleL];
        self.titleLabel = titleL;
        
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 201-40, 280/2, 40)];
        [cancel setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        cancel.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [cancel setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:cancel];
        
        UIButton *surebtn = [[UIButton alloc] initWithFrame:CGRectMake(280/2, 201-40, 280/2, 40)];
        [surebtn setTitle:[NoticeTools getLocalStrWith:@"main.sure"] forState:UIControlStateNormal];
        surebtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [surebtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        [surebtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:surebtn];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 201-41, 280, 1)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.backView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(280/2-0.5, 201-41, 1,41)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.backView addSubview:line2];
    }
    return self;
}

- (void)sureClick{
    if (self.sureBlock) {
        self.sureBlock(YES);
    }
    [self cancelClick];
}

- (void)cancelClick{
    [self removeFromSuperview];
}

- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.backView.layer.position = self.center;
    self.backView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
