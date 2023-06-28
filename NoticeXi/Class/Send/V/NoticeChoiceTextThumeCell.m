//
//  NoticeChoiceTextThumeCell.m
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceTextThumeCell.h"

@implementation NoticeChoiceTextThumeCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GetColorWithName(VBackColor);
        self.contentView.backgroundColor = GetColorWithName(VBackColor);
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backView.backgroundColor = GetColorWithName(VBackColor);
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [NoticeTools getWhiteColor:@"#999999" NightColor:@"#3e3e4a"].CGColor;
        [self.contentView addSubview:backView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-61, 10, 61, 20)];
        self.nameL.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        self.nameL.textColor = [NoticeTools getWhiteColor:@"#ffffff" NightColor:@"#b2b2b2"];
        self.nameL.font = ELEVENTEXTFONTSIZE;
        self.nameL.textAlignment = NSTextAlignmentCenter;
        self.nameL.layer.cornerRadius = 10;
        self.nameL.layer.masksToBounds = YES;
        if (![NoticeTools isWhiteTheme]) {
            self.nameL.layer.borderWidth = 1;
            self.nameL.layer.borderColor = [UIColor colorWithHexString:@"#b2b2b2"].CGColor;
        }
        [backView addSubview:self.nameL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, backView.frame.size.width-20, backView.frame.size.height-30)];
        self.contentL.textColor = GetColorWithName(VMainTextColor);
        self.contentL.font = TWOTEXTFONTSIZE;
        [backView addSubview:self.contentL];
    }
    return self;
}

- (void)setModel:(NoticeBackQustionModel *)model{
    _model = model;
    self.nameL.text = model.name;
    if ([NoticeTools isWhiteTheme]) {
        self.nameL.backgroundColor = [[UIColor colorWithHexString:model.color] colorWithAlphaComponent:0.3];
    }
    self.contentL.attributedText = model.contentSmallAtt;
    self.contentL.textAlignment = NSTextAlignmentCenter;
    self.contentL.numberOfLines = 0;
}

@end
