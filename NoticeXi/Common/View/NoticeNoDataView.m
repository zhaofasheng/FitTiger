//
//  NoticeNoDataView.m
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNoDataView.h"

@implementation NoticeNoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        UIImageView *imageViewV = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-180)/2, (frame.size.height-180-60)/2, 180, 180)];
        _titleImageV = imageViewV;
        _titleImageV.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imageViewV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageViewV.frame)+20, DR_SCREEN_WIDTH, 20)];
        label.textColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0.7];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FOURTHTEENTEXTFONTSIZE;
        _titleL = label;
        label.numberOfLines = 0;
        [self addSubview:label];
        
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-160)/2, CGRectGetMaxY(label.frame)+45, 160, 45)];
        [self addSubview:_actionButton];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleL.text = titleStr;
    self.titleImageV.frame = CGRectMake((self.frame.size.width-180)/2, (self.frame.size.height-180-60)/2-40-20, 180, 180);
    self.titleL.frame = CGRectMake(0, CGRectGetMaxY(self.titleImageV.frame)+20, DR_SCREEN_WIDTH, 20);
}
@end
