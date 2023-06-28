//
//  XCDateFormatUtil.m
//  XCUtil
//
//  Created by 刘德华 on 16/7/23.
//  Copyright (c) 2016年 刘德华. All rights reserved.
//

#import "ZFSDateFormatUtil.h"

@implementation ZFSDateFormatUtil
static NSDateFormatter *formatter = nil;




+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        NSTimeZone * zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:zone];
    });
}

+(NSString*)getChineseCalendarWithDate:(NSString*)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    //    [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *dateTemp = nil;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    dateTemp = [dateFormater dateFromString:date];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:dateTemp];
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    return chineseCal_str;
}

+ (NSInteger)getDayCountYear:(NSInteger)year Month:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1970 = [NSDate dateWithTimeIntervalSince1970:8*3600];
    
    NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitYear value:year - 1970 toDate:date1970 options:NSCalendarMatchFirst];
    date = [calendar dateByAddingUnit:NSCalendarUnitMonth value:month-1 toDate:date options:NSCalendarMatchFirst];
    
    NSInteger day = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
    return day;
}

+(NSArray*)getsystemtime{
    
    NSDate *date = [NSDate date];
    NSTimeInterval  sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:sec];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *na = [df stringFromDate:currentDate];
    return [na componentsSeparatedByString:@"-"];
    
}

+ (NSDateComponents *)nowDateCmp
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
    NSDateComponents *cmp = [calendar components:unitFlags fromDate:[NSDate date]];
    
    return cmp;
}

+ (NSDate *)getDateWithTime:(NSString *)time Formatter:(NSString *)formatStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatStr];
    NSDate *date = [formatter dateFromString:time];
    return date;
}

+ (NSString *)dateFormatToStringWithFormatStyle:(NSString *)style date:(NSDate *)date
{
    [formatter setDateFormat:style];
    return [formatter stringFromDate:date];
}

+ (NSDate *)stringFormatToDateWithFormatStyle:(NSString *)style string:(NSString *)dateString
{
    [formatter setDateFormat:style];
    return [formatter dateFromString:dateString];
}

+ (NSString *)dateFullStringWithInterval:(double)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [self dateFormatToStringWithFormatStyle:@"yyyy-MM-dd HH:mm:ss" date:date];
}

+ (NSString *)dateFullStringWithInterval:(double)interval formatStyle:(NSString *)style
{
    if (interval > 1400000000000) {
        interval /= 1000;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [self dateFormatToStringWithFormatStyle:style date:date];
}

+ (NSTimeInterval)timeIntervalWithDateString:(NSString *)dateString
{
    return [[self stringFormatToDateWithFormatStyle:@"yyyy-MM-dd HH:mm:ss" string:dateString] timeIntervalSince1970];
}

+ (NSString *)earliestDateStringWithDate:(NSDate *)date
{
    return [self dateFormatToStringWithFormatStyle:@"yyyy-MM-dd 00:00:00" date:date];
}

+ (NSString *)latestDateStringWithDate:(NSDate *)date
{
    return [self dateFormatToStringWithFormatStyle:@"yyyy-MM-dd 23:59:59" date:date];
}

+ (NSString *)shortDateString:(NSDate *)date
{
    return [self dateFormatToStringWithFormatStyle:@"yyyy-MM-dd" date:date];
}

+ (NSTimeInterval)timeIntervalWithDateString:(NSString *)dateString style:(NSString *)style{
    return [[self stringFormatToDateWithFormatStyle:style string:dateString] timeIntervalSince1970];
}
@end
