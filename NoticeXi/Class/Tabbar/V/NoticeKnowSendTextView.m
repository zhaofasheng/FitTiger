//
//  NoticeKnowSendTextView.m
//  NoticeXi
//
//  Created by li lei on 2020/7/16.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeKnowSendTextView.h"

@implementation NoticeKnowSendTextView
{
    NSInteger time;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sendtx_b":@"Image_sendtx_y");
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTap)];
        [self addGestureRecognizer:tap];
        time = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor) name:@"CHANGETHEMCOLORNOTICATION" object:nil];
    }
    return self;
}

- (void)changeColor{
    self.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sendtx_b":@"Image_sendtx_y");
}

- (void)hideTap{
    [self.anTimer invalidate];
    [self removeFromSuperview];
    [NoticeComTools saveHasKnowSendText];
}
@end
