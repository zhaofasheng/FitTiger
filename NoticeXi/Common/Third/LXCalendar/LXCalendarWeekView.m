//
//  LXCalendarWeekView.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXCalendarWeekView.h"
#import "UIView+LX_Frame.h"
#import "UILabel+LXLabel.h"
@implementation LXCalendarWeekView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    }
    return self;
}
-(void)setWeekTitles:(NSArray *)weekTitles{
    _weekTitles = weekTitles;
    
    CGFloat width = self.lx_width /weekTitles.count;
    for (int i = 0; i< weekTitles.count; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width, 0, width, self.lx_height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = TWOTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        label.text = weekTitles[i];
        [self addSubview:label];

    }
}
@end
