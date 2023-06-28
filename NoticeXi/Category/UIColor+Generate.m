//
//  UIColor+Generate.m
//  Power4Iphone
//
//  Created by 赵发生 on 16/8/10.
//  Copyright © 2016年 赵发生. All rights reserved.
//

#import "UIColor+Generate.h"

/**
 该文件主要是自定制一些颜色
 */
@implementation UIColor (Generate)

+ (UIColor *)rgbWithRed:(int)red green:(int)green blue:(int)blue
{
    return [self rgbAlphaWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)rgbAlphaWithRed:(int)red green:(int)green blue:(int)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:alpha];
}

+ (UIColor *)rgbWithWhite:(int)white
{
    return [self rgbWithWhite:white alpha:1.0];
}

+ (UIColor *)rgbWithWhite:(int)white alpha:(float)alpha
{
    return [UIColor colorWithWhite:(white / 255.0) alpha:alpha];
}

- (UIColor *)rgbWithAlpha:(float)alpha
{
    return [self colorWithAlphaComponent:alpha];
}

#pragma mark - Project Color


+ (UIColor *)navigationTintColor
{
    return [self rgbWithRed:37 green:149 blue:223];
}

+ (UIColor *)barButtonItemTintColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)viewBackgroundColor
{
    return [self rgbWithWhite:245];
}

+ (UIColor *)viewButtonGroundColor{
    return [self rgbWithRed:240 green:240 blue:240];
}

+ (UIColor *)viewBorderColor
{
    return [self rgbWithWhite:237];
}

+ (UIColor *)placeholderBackgroundColor
{
    return [self rgbWithWhite:102];
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
	NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters
	if ([cString length] < 6) {
		return [UIColor clearColor];
	}
	// 判断前缀
	if ([cString hasPrefix:@"0X"])
		cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"])
		cString = [cString substringFromIndex:1];
	if ([cString length] != 6)
		return [UIColor navigationTintColor];
	// 从六位数值中找到RGB对应的位数并转换
	NSRange range;
	range.location = 0;
	range.length = 2;
	//R、G、B
	NSString *rString = [cString substringWithRange:range];
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *)getColorWithString:(NSString *)color{
    
    NSString *cString = [[[NoticeTools getThemeColorWithKey:color] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor navigationTintColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
