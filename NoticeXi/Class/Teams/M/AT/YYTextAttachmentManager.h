//
//  JMTextAttachmentManager.h
//  Jiemo
//
//  Created by Ace on 16/12/27.
//  Copyright © 2016年 Longbeach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^JMCompleteBlock)(NSMutableAttributedString *mutableAttributedString, NSRange selectedRange);

@interface YYTextAttachmentManager : NSObject

+ (YYTextAttachmentManager *)getInstance;

- (void)transformTextWithTextView:(UITextView *)textView
                tickedPersonItems:(NSArray *)tickedPersonItems
                     atAllPersons:(NSArray *)atAllPersons
                        canRepeat:(BOOL)canRepeat
                         needBack:(BOOL)needBack
                            color:(UIColor *)color
                        attributes:(NSDictionary *)attributes
                    completeBlock:(JMCompleteBlock)completeBlock;

//把带有图片的属性字符串转成普通的字符串
+ (NSString *)attributedStringToString:(NSAttributedString *)attributedText;

@end
