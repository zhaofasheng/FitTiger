//
//  NoticeChangeSkinReusableView.m
//  NoticeXi
//
//  Created by li lei on 2021/9/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeSkinReusableView.h"

@implementation NoticeChangeSkinReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-20, 22)];
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.nameL.font = SIXTEENTEXTFONTSIZE;
        [self addSubview:self.nameL];
    }
    return self;
}

@end
