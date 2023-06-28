//
//  NoticeTimeTools.m
//  NoticeXi
//
//  Created by li lei on 2019/7/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTimeTools.h"
#import "ZFSDateFormatUtil.h"
@implementation NoticeTimeTools
/**
 *  获取当天的字符串
 *
 *  @return 格式为年-月-日 时分秒
 */
+ (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatDay setTimeZone:timeZone];
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

+ (NSString *)needShowTimeMark{
    [NoticeTools getNowTimeTimestamp];
    NSDate * nowDate = [NSDate new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSArray * weekTitleArray = [NoticeTools getLocalType]?@[@"Sun",@"Mon",@"Tues",@"Wed",@"Thur",@"Fri",@"Sat"] : @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    
    BOOL isWeekEnd = false;
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curTime = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM-dd"];
    NSInteger cur = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 19:00:00",curTime]];
    
    NSInteger nightOclockTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 09:00:00",curTime]];//当天九点之前
    
    //国庆期间
    NSInteger curgqstart = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 19:00:00",@"2020-09-25"]];//国庆调休
    NSInteger curgqend = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 23:59:59",@"2020-09-26"]];
    
    NSInteger curgqstart1 = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",@"2020-09-27"]];//国庆调班
    NSInteger curgqend1 = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 09:00:00",@"2020-09-27"]];
    
    NSInteger curgqstart2 = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 09:00:00",@"2020-09-27"]];//国庆调班
    NSInteger curgqend2 = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 19:00:00",@"2020-09-27"]];
    if (currentTime > curgqstart && currentTime < curgqend) {
        return @"预计周日上午会收到回复";
    }
    
    if (currentTime > curgqstart1 && currentTime < curgqend1) {
        return @"预计今天上午会收到回复";
    }
    
    if (currentTime > curgqstart2 && currentTime < curgqend2) {
        return nil;
    }
    
    NSInteger curgqstart3 = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 19:00:00",@"2020-09-30"]];//国庆调班
    NSInteger curgqend3 = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 09:00:00",@"2020-10-08"]];
    
    if (currentTime > curgqstart3 && currentTime < curgqend3) {
        return @"预计北京时间2020-10-08 09:00 后会收到回复";
    }
    
    NSString *weekDay = [NSString stringWithFormat:@"%@",weekTitleArray[[dateComponent weekday] - 1]];
    if ([weekDay isEqualToString:@"星期六"] || [weekDay isEqualToString:@"星期日"]) {//非法定节假日的周末
        isWeekEnd = YES;
    }else if ([weekDay isEqualToString:@"星期五"] && currentTime > cur){//星期五并且超过当天晚上七点
        isWeekEnd = YES;
    }else{//工作日发消息
        if (currentTime < nightOclockTime) {//九点之前
            return @"预计今天上午会收到回复";
        }else if (currentTime > cur){//晚上七点以后
            return [NSString stringWithFormat:@"预计%@上午会收到回复",weekTitleArray[[dateComponent weekday]]];
        }else if ((currentTime >= nightOclockTime) && (currentTime <= cur)){
            return @"开发者等下就来";
        }
    }
    
    if (isWeekEnd) {
        return @"预计周一上午会收到回复";
    }
    return nil;
}
@end
