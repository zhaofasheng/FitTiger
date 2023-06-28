//
//  DDHAttributedMode.m
//  PaySystem
//
//  Created by HandsomeC on 17/9/11.
//  Copyright © 2017年 赵发生. All rights reserved.
//

#import "DDHAttributedMode.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@implementation DDHAttributedMode

+ (NSString *)md5:(NSString *)input
{
    const char *cStrValue = [input UTF8String];
    if (cStrValue == NULL) {
        cStrValue = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, (CC_LONG)strlen(cStrValue), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

+ (NSMutableAttributedString *)setString:(NSString *)setStr setSize:(CGFloat)setSize setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize{

    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:setStr];
    if (beginSize < setStr.length) {
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:setSize] range:NSMakeRange(beginSize,[[NSString stringWithFormat:@"%@",lengthStr] length])];
    }
    
    return attStr;
}

+ (NSMutableAttributedString *)setJiaCuString:(NSString *)setStr setSize:(CGFloat)setSize setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:setStr];
    if (beginSize < setStr.length) {
        [attStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:XGBoldFontName size:setSize] range:NSMakeRange(beginSize,[[NSString stringWithFormat:@"%@",lengthStr] length])];
    }
    
    return attStr;
}

+ (NSMutableAttributedString *)setColorString:(NSString *)setStr setColor:(UIColor *)color setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize{
    if ([setStr length]) {
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:setStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(beginSize,[lengthStr length])];
        
        return  attStr;
    }
    return nil;
}

+ (NSMutableAttributedString *)setTwoColorString:(NSString *)setStr setColor:(UIColor *)color setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize setLengthString1:(NSString *)lengthStr1 beginSize1:(NSInteger)beginSize1{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:setStr];
    if (lengthStr.length) {
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(beginSize,[lengthStr length])];
    }
    if (lengthStr1.length) {
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(beginSize1,[lengthStr1 length])];
    }
    return attStr;
}

+ (NSMutableAttributedString *)setTwoColorString:(NSString *)setStr setColor:(UIColor *)color setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize setLengthString1:(NSString *)lengthStr1 beginSize1:(NSInteger)beginSize1 setColor1:(UIColor *)color1{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:setStr];
    if (lengthStr.length) {
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(beginSize,[lengthStr length])];
    }
    if (lengthStr1.length) {
        [attStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(beginSize1,[lengthStr1 length])];
    }
    return attStr;
}

+ (NSMutableAttributedString *)setSizeAndColorString:(NSString *)setStr setColor:(UIColor *)color setSize:(CGFloat)setSize setLengthString:(NSString *)lengthStr beginSize:(NSInteger)beginSize{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:setStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(beginSize,[lengthStr length])];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:setSize] range:NSMakeRange(beginSize,[lengthStr length])];
    return  attStr;
}

+ (NSArray *)arraryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)arrayToJSONString:(NSMutableArray *)array

{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSMutableAttributedString *)setHtmlStr:(NSString *)html
{
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName: SIXTEENTEXTFONTSIZE} range:NSMakeRange(0, attr.string.length)];
    
    return attr;
}

@end
