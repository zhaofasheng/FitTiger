//
//  DDHAttributedMode.h
//  PaySystem
//
//  Created by HandsomeC on 17/9/11.
//  Copyright © 2017年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDHAttributedMode : UIView


/**
 *  md5加密
 *
 
 *
 *  @return 32位md5字符串
 */
+ (NSString *)md5:(NSString *)input;

//解析H5字段
+ (NSMutableAttributedString *)setHtmlStr:(NSString *)html;

//数组转json字符串
+ (NSString *)arrayToJSONString:(NSMutableArray *)array;

+ (NSArray *)arraryWithJsonString:(NSString *)jsonString;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSMutableAttributedString *)setString:(NSString *)setStr setSize:(CGFloat)setSize setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize;
+ (NSMutableAttributedString *)setJiaCuString:(NSString *)setStr setSize:(CGFloat)setSize setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize;
+ (NSMutableAttributedString *)setColorString:(NSString *)setStr setColor:(UIColor *)color setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize;
+ (NSMutableAttributedString *)setTwoColorString:(NSString *)setStr setColor:(UIColor *)color setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize setLengthString1:(NSString *)lengthStr1 beginSize1:(NSInteger)beginSize1;

+ (NSMutableAttributedString *)setSizeAndColorString:(NSString *)setStr setColor:(UIColor *)color setSize:(CGFloat)setSize setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize;

+ (NSMutableAttributedString *)setTwoColorString:(NSString *)setStr setColor:(UIColor *)color setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize setLengthString1:(NSString *)lengthStr1 beginSize1:(NSInteger)beginSize1 setColor1:(UIColor *)color1;
@end
