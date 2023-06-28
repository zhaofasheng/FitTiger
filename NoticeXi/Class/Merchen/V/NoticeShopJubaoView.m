//
//  NoticeShopJubaoView.m
//  NoticeXi
//
//  Created by li lei on 2022/7/15.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopJubaoView.h"

@implementation NoticeShopJubaoView
{
    UIButton *_oldBtn;
    UIButton *sureBtn;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 360)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.center = self.center;
        [self addSubview:self.contentView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 280, 25)];
        titleL.text = @"举报后，将自动结束订单";
        titleL.font = XGEightBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:titleL];
        titleL.textAlignment = NSTextAlignmentCenter;
        
        UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, 280, 17)];
        markL.text = @"如举报确认属实，鲸币会退回钱包";
        markL.font = TWOTEXTFONTSIZE;
        markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:markL];
        markL.textAlignment = NSTextAlignmentCenter;
        
        NSArray *btnArr = @[@"人身攻击",@"色情暴力",@"垃圾广告",@"无响应"];
        for (int i = 0; i < 4; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 86+55*i, 220, 40)];
            button.tag = i;
            button.layer.cornerRadius = 8;
            button.layer.masksToBounds = YES;
            button.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
            [button setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [button setTitle:btnArr[i] forState:UIControlStateNormal];
            [self.contentView addSubview:button];
            [button addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0, 316, 280, 1)];
        hline.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.contentView addSubview:hline];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hline.frame), 280/2-0.5, 43)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        
        UIView *sline = [[UIView alloc] initWithFrame:CGRectMake(280/2-0.5, 316, 1, 45)];
        sline.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.contentView addSubview:sline];
        
        sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(280/2-0.5, CGRectGetMaxY(hline.frame), 280/2-0.5, 43)];
        [sureBtn setTitle:[NoticeTools getLocalStrWith:@"chat.jubao"] forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:sureBtn];
    }
    return self;
}

- (void)sureClick{
    if (self.type > 0) {
        if (self.shopjubaoBlock) {
            self.shopjubaoBlock(self.type);
        }
        [self removeFromSuperview];
    }
}

- (void)typeClick:(UIButton *)button{
    self.type = button.tag+1;
    _oldBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [_oldBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
    
    _oldBtn = button;
}

- (void)cancelClick{
    [self removeFromSuperview];
}

- (void)showJuBao{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.contentView.layer.position = self.center;
    self.contentView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
