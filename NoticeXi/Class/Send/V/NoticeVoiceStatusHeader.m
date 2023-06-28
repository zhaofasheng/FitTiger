//
//  NoticeVoiceStatusHeader.m
//  NoticeXi
//
//  Created by li lei on 2021/4/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceStatusHeader.h"

@implementation NoticeVoiceStatusHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, DR_SCREEN_WIDTH, 22)];
        self.titleL.font = XGEightBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleL];
    }
    return self;
}

@end
