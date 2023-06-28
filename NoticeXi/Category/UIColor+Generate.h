//
//  UIColor+Generate.h
//  Power4Iphone
//
//  Created by 赵发生 on 16/8/10.
//  Copyright © 2016年 赵发生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Generate)

+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) getColorWithString:(NSString *)color;

+ (UIColor *)rgbWithRed:(int)red green:(int)green blue:(int)blue;
+ (UIColor *)rgbAlphaWithRed:(int)red green:(int)green blue:(int)blue alpha:(float)alpha;
+ (UIColor *)rgbWithWhite:(int)white;
+ (UIColor *)rgbWithWhite:(int)white alpha:(float)alpha;
- (UIColor *)rgbWithAlpha:(float)alpha;

#pragma mark - Project Color
+ (UIColor *)viewButtonGroundColor;
+ (UIColor *)navigationTintColor;
+ (UIColor *)barButtonItemTintColor;
+ (UIColor *)viewBackgroundColor;
+ (UIColor *)viewBorderColor;
+ (UIColor *)placeholderBackgroundColor;

@end
