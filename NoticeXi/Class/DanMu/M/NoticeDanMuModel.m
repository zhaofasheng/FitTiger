//
//  NoticeDanMuModel.m
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuModel.h"

@implementation NoticeDanMuModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"bokeId":@"id",@"allNum":@"count"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.sendAt = [NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"em.sentat"],[NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm:ss"]];
}

- (void)setPodcast_intro:(NSString *)podcast_intro{
    _podcast_intro = podcast_intro;
    self.allTextAttStr = [self setLabelSpacewithValue:podcast_intro withFont:FIFTHTEENTEXTFONTSIZE];
    self.textHeight = [self getSpaceLabelHeight:podcast_intro withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30];
}

- (void)setPodcast_title:(NSString *)podcast_title{
    _podcast_title = podcast_title;
    self.allTitleAttStr = [self setLabelSpacewithValue:podcast_title withFont:XGFifthBoldFontSize];
    self.titleHeight = [self getSpaceLabelHeight:podcast_title withFont:XGFifthBoldFontSize withWidth:DR_SCREEN_WIDTH-70]+10;
    if (self.titleHeight < 45) {
        self.titleHeight = 45;
    }
}

//返回文案
-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;//设置行间距
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

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
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
