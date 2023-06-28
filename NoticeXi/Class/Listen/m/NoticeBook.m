
//
//  NoticeBook.m
//  NoticeXi
//
//  Created by li lei on 2019/4/18.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBook.h"

@implementation NoticeBook
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"bookId":@"id"};
}

- (void)setBook_score:(NSString *)book_score{
    _book_score = [NSString stringWithFormat:@"%.1f",book_score.floatValue/10];
}

- (void)setBook_author:(NSString *)book_author{
    if (book_author.length > 26) {
        _book_author = [book_author substringToIndex:26];
    }else{
        _book_author = book_author;
    }
}
- (void)setFirst_voice:(NSDictionary *)first_voice{
    _first_voice = first_voice;
    self.voiceM = [NoticeVoiceModel mj_objectWithKeyValues:first_voice];
}

- (void)setBook_intro:(NSString *)book_intro{

    NSArray * array = [book_intro componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {
        if ([array[i] length]) {
            [newArr addObject:array[i]];
        }
    }
    
    _book_intro = [newArr componentsJoinedByString:@"\n"];
    
    self.textHeight = [self getSpaceLabelHeight:_book_intro withFont:THRETEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30-40];

    if (self.textHeight < 30) {
        self.textHeight = 30;
    }
  

    if (_book_intro.length) {
        self.allTextAttStr = [self setLabelSpacewithValue:_book_intro withFont:THRETEENTEXTFONTSIZE];
        if ([[self getSeparatedLinesFromLabel:_book_intro width:DR_SCREEN_WIDTH-70 font:THRETEENTEXTFONTSIZE] count]> 3) {
            self.isMoreLines = YES;
            NSArray *array = [self getSeparatedLinesFromLabel:_book_intro width:DR_SCREEN_WIDTH-70 font:THRETEENTEXTFONTSIZE];

            NSString *showText = [NSString stringWithFormat:@"%@%@%@", array[0], array[1],array[2]];
            self.fiveTextHeight = [self getSpaceLabelHeight:showText withFont:THRETEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-70];
            
            self.fiveAttTextStr = [self setLabelSpacewithValue:showText withFont:THRETEENTEXTFONTSIZE];
        }else{
            self.isMoreLines = NO;
        }
    }
}

//返回文案
-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;//设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}

//获取label上每一行的文字
- (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{

    return [NoticeTools getSeparatedLinesFromLabel:text width:width font:font textHeight:self.textHeight];
}

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          
    };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
