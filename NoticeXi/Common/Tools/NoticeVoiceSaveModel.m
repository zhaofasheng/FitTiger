//
//  NoticeVoiceSaveModel.m
//  NoticeXi
//
//  Created by li lei on 2019/5/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceSaveModel.h"

@implementation NoticeVoiceSaveModel


- (void)getData{
    
       NSArray * array = [_textContent componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
       NSMutableArray *newArr = [NSMutableArray new];
       for (int i = 0;i < array.count; i++) {
       //        if ([array[i] length]) {
       //            [newArr addObject:array[i]];
       //        }
           [newArr addObject:array[i]];
       }

       _textContent = [newArr componentsJoinedByString:@"\n"];

       self.textHeight = [self getSpaceLabelHeight:_textContent withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30-40];

       if (self.textHeight < 30) {
           self.textHeight = 30;
       }

       if (_textContent.length) {
           self.allTextAttStr = [self setLabelSpacewithValue:_textContent withFont:FIFTHTEENTEXTFONTSIZE];
           if ([[self getSeparatedLinesFromLabel:_textContent width:DR_SCREEN_WIDTH-70 font:FIFTHTEENTEXTFONTSIZE] count]> 5) {
               self.isMoreFiveLines = YES;
               NSArray *array = [self getSeparatedLinesFromLabel:_textContent width:DR_SCREEN_WIDTH-70 font:FIFTHTEENTEXTFONTSIZE];
               NSString *line4String = array[4];
               
               if ([NoticeTools getLocalType ]== 1) {
                   if (line4String.length < 7) {
                       line4String = [NSString stringWithFormat:@"%@...More",line4String];
                   }
                   self.showText = [NSString stringWithFormat:@"%@%@%@%@%@...More", array[0], array[1], array[2], array[3],[line4String substringToIndex:line4String.length-7]];
               }else{
                   if (line4String.length < 5) {
                       line4String = [NSString stringWithFormat:@"%@...全部",line4String];
                   }
                   self.showText = [NSString stringWithFormat:@"%@%@%@%@%@...全部", array[0], array[1], array[2], array[3],[line4String substringToIndex:line4String.length-5]];
               }
               self.fiveTextHeight = [self getSpaceLabelHeight:self.showText withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-70];
               
               NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
               paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
               paraStyle.alignment = NSTextAlignmentLeft;
               paraStyle.lineSpacing = 14;//设置行间距
               paraStyle.hyphenationFactor = 1.0;
               paraStyle.firstLineHeadIndent = 0.0;
               paraStyle.paragraphSpacingBefore = 0.0;
               paraStyle.headIndent = 0;
               paraStyle.tailIndent = 0;
               //设置label的attributedText
               NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.showText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paraStyle}];
               if ([NoticeTools getLocalType] == 1) {
                   [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0099E6"]} range:NSMakeRange(self.showText.length-4, 4)];
               }else{
                   [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0099E6"]} range:NSMakeRange(self.showText.length-2, 2)];
               }
               
               self.fiveAttTextStr = attStr;
           }else{
               self.isMoreFiveLines = NO;
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
