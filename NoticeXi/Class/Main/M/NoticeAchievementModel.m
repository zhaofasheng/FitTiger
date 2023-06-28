//
//  NoticeAchievementModel.m
//  NoticeXi
//
//  Created by li lei on 2020/4/8.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeAchievementModel.h"

@implementation NoticeAchievementModel

- (void)setStarted_at:(NSString *)started_at{
    _started_at = started_at;
    self.started_at_timeValue = [ZFSDateFormatUtil timeIntervalWithDateString:started_at style:@"yyyyMMdd"];
    
}

- (void)setLatest_at:(NSString *)latest_at{
    _latest_at = latest_at;
    self.latest_at_timeValue = [ZFSDateFormatUtil timeIntervalWithDateString:latest_at style:@"yyyyMMdd"];
}

- (void)setAchievement_type:(NSString *)achievement_type{
    _achievement_type = achievement_type;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curentTimeZreoY = [ZFSDateFormatUtil dateFullStringWithInterval:currentTime formatStyle:@"yyyy-MM-dd"];
    NSTimeInterval curentZeroTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",curentTimeZreoY]];//当前时间的零点时间
    self.today_timeValue = curentZeroTime;
    self.yesterDay_timeValue = curentZeroTime-86400;
}
@end
