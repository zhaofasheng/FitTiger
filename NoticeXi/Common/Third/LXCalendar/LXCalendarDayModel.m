
//
//  LXCalendarDayModel.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/3.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXCalendarDayModel.h"

@implementation LXCalendarDayModel

- (void)setDay:(NSInteger)day{
    _day = day;
    self.dayName = [NSString stringWithFormat:@"%ld",day];
}

- (void)setMonth:(NSInteger)month{
    _month = month;
    self.monthName = [NSString stringWithFormat:@"%ld",month];
}

- (void)setYear:(NSInteger)year{
    _year = year;
    self.yearName = [NSString stringWithFormat:@"%ld",year];
}
@end
