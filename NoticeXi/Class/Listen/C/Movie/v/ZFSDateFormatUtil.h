//
//  ZFSDateFormatUtil.h
//  XCUtil
//
//  Created by 刘德华 on 16/7/23.
//  Copyright (c) 2016年 刘德华. All rights reserved.
//


/**************************************************************
 *
 * 对常用的时间格式进行简化 宜租车专属(赵发生)
 *
 **************************************************************/

#import <Foundation/Foundation.h>

@interface ZFSDateFormatUtil : NSObject

/**
 根据阳历获取中国农历时间

 @param date 阳历时间
 @return 中国农历时间
 */
+(NSString*)getChineseCalendarWithDate:(NSString*)date;

/**
 * 传入距1970年1月1日 多少年 多少天 返回当月的总天数
 */
+ (NSInteger)getDayCountYear:(NSInteger)year Month:(NSInteger)month;

/**
 获取系统时间

 @return 返回值
 */
+(NSArray*)getsystemtime;

/**
 当前书剑管理

 @return 返回值
 */
+ (NSDateComponents *)nowDateCmp;

/**
 根据字符串获取date数据
 
 @param time 时间字符串
 @param formatStr 格式
 @return 返回值
 */
+ (NSDate *)getDateWithTime:(NSString *)time Formatter:(NSString *)formatStr;

/**
 *  时间转换到字符串
 *
 *  @param style 格式化样式
 *  @param date  格式化的时间
 *
 *  @return 格式化后的时间字符串
 */
+ (NSString *)dateFormatToStringWithFormatStyle:(NSString *)style date:(NSDate *)date;
/**
 *  字符串转换到时间
 *
 *  @param style      格式化样式
 *  @param dateString 字符串时间
 *
 *  @return 时间对象
 */
+ (NSDate *)stringFormatToDateWithFormatStyle:(NSString *)style string:(NSString *)dateString;
/**
 *  时间戳转时间字符串（yyyy-MM-dd HH:mm:ss）
 *
 *  @param interval 时间戳
 *
 *  @return 时间字符串
 */
+ (NSString *)dateFullStringWithInterval:(double)interval;
/**
 *  时间戳转时间字符串
 *
 *  @param interval 时间戳
 *  @param style    格式化的格式
 *
 *  @return 时间字符串
 */
+ (NSString *)dateFullStringWithInterval:(double)interval formatStyle:(NSString *)style;
/**
 *  时间字符串(yyyy-MM-dd HH:mm:ss)转时间戳
 *
 *  @param dateString 时间字符串
 *
 *  @return 时间戳
 */
+ (NSTimeInterval)timeIntervalWithDateString:(NSString *)dateString;
/**
 *  时间对象转成成最早的时间字符串（yyyy-MM-dd 00:00:00）
 *
 *  @param date 时间对象
 *
 *  @return 时间字符串
 */
+ (NSString *)earliestDateStringWithDate:(NSDate *)date;
/**
 *  时间对象转成成最晚的时间字符串（yyyy-MM-dd 23:59:59）
 *
 *  @param date 时间对象
 *
 *  @return 时间字符串
 */
+ (NSString *)latestDateStringWithDate:(NSDate *)date;
/**
 *  时间对象转换成日期字符串(yyyy-MM-dd)
 *
 *  @param date 时间对象
 *
 *  @return 日期字符串
 */
+ (NSString *)shortDateString:(NSDate *)date;

+ (NSTimeInterval)timeIntervalWithDateString:(NSString *)dateString style:(NSString *)style;
@end
