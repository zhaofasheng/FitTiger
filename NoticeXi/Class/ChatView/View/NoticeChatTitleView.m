//
//  NoticeChatTitleView.m
//  NoticeXi
//
//  Created by li lei on 2020/7/2.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeChatTitleView.h"

@implementation NoticeChatTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *titlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 18)];
        titlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        titlabel.font = SIXTEENTEXTFONTSIZE;
        [self addSubview:titlabel];
        titlabel.textAlignment = NSTextAlignmentCenter;
        self.mainL = titlabel;
        
        self.subL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainL.frame)+7, self.frame.size.width, 11)];
        self.subL.textAlignment = NSTextAlignmentCenter;
        self.subL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        [self addSubview:self.subL];
        self.subL.font = ELEVENTEXTFONTSIZE;
    }
    return self;
}


@end
