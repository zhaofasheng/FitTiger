//
//  CalenderCollectionCell.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderCollectionCell.h"
#import "CalenderModel.h"
#import "UIColor+Extension.h"

@interface CalenderCollectionCell()

@end

@implementation CalenderCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 30 * 0.5, self.frame.size.height * 0.5 - 30 * 0.5, 30, 30)];
        self.anImageView.layer.cornerRadius = 15;
        self.anImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.anImageView];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.leftLine];
        [self.contentView addSubview:self.rightLine];
    }
    return self;
}

#pragma mark - lazy


- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 30 * 0.5, self.frame.size.height * 0.5 - 30 * 0.5, 30, 30)];
        _numberLabel.textAlignment   = NSTextAlignmentCenter;
        _numberLabel.font            = FOURTHTEENTEXTFONTSIZE;
        _numberLabel.layer.cornerRadius = 30/2;
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.textColor = GetColorWithName(VMainTextColor);
        
    }
    return _numberLabel;
}

- (UIView *)bootomLine{
    if (!_bootomLine) {
        _bootomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        _bootomLine.backgroundColor = GetColorWithName(VlistColor);
    }
    return _bootomLine;
}

- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [[UIView alloc] initWithFrame:CGRectMake(-15, 0, 15, self.frame.size.height)];
        
        _leftLine.backgroundColor = GetColorWithName(VBackColor);
    }
    return _leftLine;
}

- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 15, self.frame.size.height)];
        _rightLine.backgroundColor = GetColorWithName(VBackColor);
    }
    return _rightLine;
}

-(void)setModel:(CalenderModel *)model {
    _model = model;
    self.numberLabel.text = model.day;
    [self.anImageView stopPulse];
    if (model.isHasData) {
        self.numberLabel.backgroundColor = [NoticeTools getWhiteColor:@"#46cdcf" NightColor:@"#318F90"];
        self.numberLabel.textColor = GetColorWithName(VMainThumeWhiteColor);
        if (model.isSelected) {
            [self.anImageView startPulseWithColor:GetColorWithName(VMainThumeColor) animation:YGPulseViewAnimationTypeRadarPulsing];
        }
    }else{
        [self.anImageView stopPulse];
        self.numberLabel.backgroundColor = GetColorWithName(VBackColor);
        if (model.isWeek) {
            self.numberLabel.textColor = [NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3e3e4a"];
        }else{
            
            self.numberLabel.textColor = GetColorWithName(VMainTextColor);
        }
    }
}


-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.values = @[@0.6,@1.2,@1.0];
    anim.keyPath = @"transform.scale";  // transform.scale 表示长和宽都缩放
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;
    [self.numberLabel.layer addAnimation:anim forKey:nil];
}
@end

