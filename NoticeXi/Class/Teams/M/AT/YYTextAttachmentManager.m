//
//  JMTextAttachmentManager.m
//  Jiemo
//
//  Created by Ace on 16/12/27.
//  Copyright © 2016年 Longbeach. All rights reserved.
//

#import "YYTextAttachmentManager.h"
#import "YYPersonItem.h"
#import "YYAtTextAttachment.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+YY.h"
#import "UIImage+Tools.h"
#import "NSString+Tools.h"

@implementation YYTextAttachmentManager

+ (YYTextAttachmentManager *)getInstance {
    static YYTextAttachmentManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)transformTextWithTextView:(UITextView *)textView
                tickedPersonItems:(NSArray *)tickedPersonItems
                     atAllPersons:(NSArray *)atAllPersons
                        canRepeat:(BOOL)canRepeat
                         needBack:(BOOL)needBack
                            color:(UIColor *)color
                        attributes:(NSDictionary *)attributes
                    completeBlock:(JMCompleteBlock)completeBlock
{
    if (needBack && textView.attributedText.length > 0 ) { //处理键盘输出的@，选择人后需要删掉
        NSRange currentSeletedRange = textView.selectedRange;
        if (textView.attributedText.length >= textView.selectedRange.location + textView.selectedRange.length) {
            NSAttributedString *subAttributedString = [textView.attributedText attributedSubstringFromRange:NSMakeRange(currentSeletedRange.location - 1, 1)];
            if ([subAttributedString.string isEqualToString:@"@"]) {
                [textView.textStorage deleteCharactersInRange:NSMakeRange(currentSeletedRange.location - 1, 1)];
            }
        }
    }
    
    NSArray *currentAtPersons = [textView.attributedText getCurrentAtPersonItems];
    NSMutableArray *tickedAtPersons = [NSMutableArray arrayWithArray:tickedPersonItems];
    NSMutableArray *deletedAtPersons = [NSMutableArray new];
    NSMutableArray *addedAtPersons = [NSMutableArray new];
    for (YYPersonItem *personItem in currentAtPersons) {
        if (![tickedAtPersons containsObject:personItem] && !canRepeat) {
            [deletedAtPersons addObject:personItem];
        }
    }
    
    for (YYPersonItem *personItem in tickedAtPersons) {
        if (![currentAtPersons containsObject:personItem] || canRepeat) {
            [addedAtPersons addObject:personItem];
        }
    }
    
    NSMutableAttributedString *addMutableAttributeStr = [[NSMutableAttributedString alloc] init];
    [addedAtPersons enumerateObjectsUsingBlock:^(YYPersonItem *personItem, NSUInteger idx, BOOL * _Nonnull stop) {
        YYAtTextAttachment *attach = [[YYAtTextAttachment alloc] init];
        attach.personItem = personItem;
        UIFont *font = textView.font;
        NSString *nameAndSpace = [NSString stringWithFormat:@"@%@ ", personItem.name];
        attach.image = [UIImage imageWithString:nameAndSpace font:font color:color];//将字转化为UIImage
        CGSize size = CGSizeMake([nameAndSpace getSizeWithFont:font constrainedWidth:0 numberOfLines:1].width, font.pointSize + 3);
        attach.imageSize = CGSizeMake(size.width, size.height);
        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        NSMutableAttributedString *mutablImageStr = [[NSMutableAttributedString alloc] initWithAttributedString:imageStr];
        
        [mutablImageStr addAttributes:attributes range:NSMakeRange(0, imageStr.length)];
        [addMutableAttributeStr appendAttributedString:mutablImageStr];
    }];
    __block NSRange selectedRange = textView.selectedRange;
    if (selectedRange.length > 0) {
        [textView.textStorage deleteCharactersInRange:selectedRange];
    }
    
    if (addMutableAttributeStr.length > 0) {
        [textView.textStorage insertAttributedString:addMutableAttributeStr atIndex:textView.selectedRange.location];
    }
    selectedRange = NSMakeRange(textView.selectedRange.location + addedAtPersons.count, 0);
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    __block NSUInteger changeLength = 0;
    if (deletedAtPersons.count > 0) {
        [textView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, textView.attributedText.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            if (value && [value isKindOfClass:[YYAtTextAttachment class]]) {
                YYAtTextAttachment *textAttachment = value;
                if ([deletedAtPersons containsObject:textAttachment.personItem]) {
                    if (textView.attributedText.length >= range.location + range.length) {
                        [mutableAttributedString deleteCharactersInRange:NSMakeRange(range.location - changeLength, range.length)];
                        changeLength += range.length;
                        if (range.location <= textView.selectedRange.location) {
                            selectedRange = NSMakeRange(selectedRange.location - range.length, 0);
                        }
                    }
                }
            }
        }];
    }
    
    if (completeBlock) {
        completeBlock(mutableAttributedString, selectedRange);
    }
}

//把带有图片的属性字符串转成普通的字符串
+ (NSString *)attributedStringToString:(NSAttributedString *)attributedText
{
    NSMutableAttributedString * resutlAtt = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];

    //枚举出所有的附件字符串
    [attributedText enumerateAttributesInRange:NSMakeRange(0, attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        //从字典中取得那一个图片
        YYAtTextAttachment * textAtt = attrs[@"NSAttachment"];
        if (textAtt)
        {
            [resutlAtt replaceCharactersInRange:range withString:[NSString stringWithFormat:@"@%@ ",textAtt.personItem.name]];
        }
    }];
    return resutlAtt.string;
}

@end
