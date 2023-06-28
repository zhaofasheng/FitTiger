//
//  NoticeRliCell.m
//  NoticeXi
//
//  Created by li lei on 2022/10/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeRliCell.h"

@implementation NoticeRliCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
      
        self.calenderView =[[NoticeCalendarView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.calenderView.currentMonthTitleColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.calenderView.lastMonthTitleColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.calenderView.nextMonthTitleColor = [UIColor colorWithHexString:@"#A1A7B3"];

        self.calenderView.isCanScroll = NO;
        self.calenderView.isShowLastAndNextBtn = YES;
        self.calenderView.isShowLastAndNextDate = NO;
        
        [self.contentView addSubview:self.calenderView];
    }
    return self;
}

@end
