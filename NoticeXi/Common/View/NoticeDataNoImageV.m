//
//  NoticeDataNoImageV.m
//  NoticeXi
//
//  Created by li lei on 2018/11/7.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDataNoImageV.h"

@implementation NoticeDataNoImageV

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = GetColorWithName(VlistColor);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,(frame.size.height-13-45-40)/2, DR_SCREEN_WIDTH, 15)];
        label.textColor = GetColorWithName(VDarkTextColor);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FIFTHTEENTEXTFONTSIZE;
        label.text = GETTEXTWITE(@"nearby.openadress");
        label.numberOfLines = 0;
        _titleL = label;
        [self addSubview:label];
        
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-160)/2, CGRectGetMaxY(label.frame)+40, 160, 45)];
        _actionButton.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        _actionButton.layer.cornerRadius = 45/2;
        _actionButton.layer.masksToBounds = YES;
        [_actionButton setTitleColor:[UIColor colorWithHexString:WHITEBACKCOLOR] forState:UIControlStateNormal];
        _actionButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [_actionButton setTitle:GETTEXTWITE(@"nearby.open") forState:UIControlStateNormal];
        [self addSubview:_actionButton];
    }
    return self;
}
@end
