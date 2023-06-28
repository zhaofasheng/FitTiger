//
//  CalenderFootView.m
//  NoticeXi
//
//  Created by li lei on 2019/12/30.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "CalenderFootView.h"

@implementation CalenderFootView

- (UIView *)bootomLine{
    if (!_bootomLine) {
        _bootomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        _bootomLine.backgroundColor = GetColorWithName(VBackColor);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bootomLine.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _bootomLine.bounds;
        maskLayer.path = maskPath.CGPath;
        _bootomLine.layer.mask = maskLayer;
        [self addSubview:_bootomLine];
    }
    return _bootomLine;
}

@end
