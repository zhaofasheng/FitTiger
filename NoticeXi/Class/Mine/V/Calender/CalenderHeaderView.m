//
//  CalenderHeaderView.m
//  YZCCalender
//
//  Created by Jason on 2018/1/18.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderHeaderView.h"
#import "UIColor+Extension.h"

@implementation CalenderHeaderView

- (UILabel *)yearAndMonthLabel {
    if (_yearAndMonthLabel == nil) {
        _yearAndMonthLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(30+50, 15, self.frame.size.width, 50)];
        _yearAndMonthLabel.font            = FIFTHTEENTEXTFONTSIZE;
        _yearAndMonthLabel.textColor       = GetColorWithName(VMainTextColor);
        [self addSubview:_yearAndMonthLabel];
    }
    return _yearAndMonthLabel;
}

- (UIImageView *)thumeImageView{
    if (!_thumeImageView) {
        _thumeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        _thumeImageView.layer.cornerRadius = 5;
        _thumeImageView.layer.masksToBounds = YES;
        _thumeImageView.backgroundColor = GetColorWithName(VlistColor);
        [self addSubview:_thumeImageView];
        if (![NoticeTools isWhiteTheme]) {
            UIView *mbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            mbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            [_thumeImageView addSubview:mbView];
        }
        _thumeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeThumeTap)];
        [_thumeImageView addGestureRecognizer:tap];
    }
    return _thumeImageView;
}

- (void)changeThumeTap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeThumeImageView:)]) {
        [self.delegate changeThumeImageView:self.section];
    }
}
@end
