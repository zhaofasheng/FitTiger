//
//  NoticeActShowView.m
//  NoticeXi
//
//  Created by li lei on 2022/3/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeActShowView.h"

@implementation NoticeActShowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        testActivityIndicator.center = self.center;//只能设置中心，不能设置大小
        [self addSubview:testActivityIndicator];
        self.actView = testActivityIndicator;
        testActivityIndicator.color = [UIColor colorWithHexString:@"#0099E6"];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.actView.frame)+20, DR_SCREEN_WIDTH, 50)];
        self.titleL.textColor = [UIColor whiteColor];
        self.titleL.font = XGSIXBoldFontSize;
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleL];
    }
    return self;
}

- (void)show{
    [self.actView startAnimating];
    [CoreAnimationEffect animationEaseIn:self];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
}

- (void)disMiss{
    [self.actView stopAnimating];
    [self removeFromSuperview];
}
@end
