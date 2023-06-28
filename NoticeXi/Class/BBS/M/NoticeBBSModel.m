//
//  NoticeBBSModel.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSModel.h"
#import <CoreText/CoreText.h>
#import "NoticeBBSComent.h"
@implementation NoticeBBSModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cagaoId":@"id"};
}

- (void)setPost_title:(NSString *)post_title{
    _post_title = post_title;
    self.draft_title = post_title;
}

- (void)setPost_content:(NSString *)post_content{
    _post_content = post_content;
    self.draft_content = post_content;
    
    NSArray * array = [post_content componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {
        if ([array[i] length]) {
            [newArr addObject:array[i]];
        }
    }
    
    NSString *showContent = [newArr componentsJoinedByString:@"\n"];
    NSString *showText = nil;
    if (showContent && showContent.length) {
        
        CGFloat height = [self getSpaceLabelHeight:showContent withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-40];
        
        if ([[self getSeparatedLinesFromLabel:showContent width:DR_SCREEN_WIDTH-40 font:FIFTHTEENTEXTFONTSIZE textHeight:height] count]> 5) {
            self.isMoreFiveLines = YES;
            NSArray *array = [self getSeparatedLinesFromLabel:showContent width:DR_SCREEN_WIDTH-40 font:FIFTHTEENTEXTFONTSIZE textHeight:height];
            NSString *line4String = array[4];
            if (line4String.length < 5) {
                line4String = [NSString stringWithFormat:@"%@...完整",line4String];
                showText = [NSString stringWithFormat:@"%@%@%@%@%@", array[0], array[1], array[2],array[3],line4String];
            }else if (line4String.length > 19){
               showText = [NSString stringWithFormat:@"%@%@%@%@%@...完整", array[0], array[1], array[2],array[3], [line4String substringToIndex:line4String.length-9]];
            }
            else{
                showText = [NSString stringWithFormat:@"%@%@%@%@%@...完整", array[0], array[1], array[2],array[3], [line4String substringToIndex:line4String.length-5]];
            }
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paraStyle.alignment = NSTextAlignmentLeft;
            paraStyle.lineSpacing = 5;//设置行间距
            paraStyle.hyphenationFactor = 1.0;
            paraStyle.firstLineHeadIndent = 0.0;
            paraStyle.paragraphSpacingBefore = 0.0;
            paraStyle.headIndent = 0;
            paraStyle.tailIndent = 0;
            //设置label的attributedText
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:showText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSParagraphStyleAttributeName:paraStyle}];
            [attStr addAttributes:@{NSForegroundColorAttributeName:GetColorWithName(VMainThumeColor)} range:NSMakeRange(showText.length-2, 2)];
            self.fiveAttTextStr = attStr;
            self.fiveTextHeight = [self getSpaceLabelHeight:showText withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-40];
        }else{
            self.isMoreFiveLines = NO;
            showText = showContent;
            self.fiveAttTextStr = [self setLabelSpacewithValue:showText withFont:FIFTHTEENTEXTFONTSIZE];
            self.fiveTextHeight = [self getSpaceLabelHeight:showText withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-40];
        }
    }
}

- (void)setDraft_title:(NSString *)draft_title{
    _draft_title = draft_title;
    self.title = draft_title;
    
    self.titleAttStr = [self setLabelSpacewithValue:draft_title withFont:SIXTEENTEXTFONTSIZE];
    self.titleHeight = [self getSpaceLabelHeight:draft_title withFont:SIXTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30-60]+30;
    if (self.titleHeight < 70) {
        self.titleHeight = 70;
    }
}

- (void)setDraft_content:(NSString *)draft_content{
    _draft_content = draft_content;
    self.textContent = draft_content;
}

- (void)setTextContent:(NSString *)textContent{
    _textContent = textContent;
    
    self.textHeight = [self getSpaceLabelHeight:_textContent withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30];
    
    self.allTextAttStr = [self setLabelSpacewithValue:_textContent withFont:FIFTHTEENTEXTFONTSIZE];
    
    self.twoLineHeight = [self getSpaceLabelHeight:_textContent withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-110];
    self.twoTextAttStr = self.allTextAttStr;
}

- (void)setAnnexs:(NSArray *)annexs{
    _annexs = annexs;
    
    if (annexs.count) {

        if (annexs.count == 1) {
            self.imgHeight = DR_SCREEN_WIDTH*0.448+15;
        }else if (annexs.count == 2){
            self.imgHeight = DR_SCREEN_WIDTH*0.373+15;
        }else{
            self.imgHeight = (DR_SCREEN_WIDTH-46)/3+15;
        }
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    for (NSDictionary *dic in annexs) {
        NoticeAnnexsModel *annexsM = [NoticeAnnexsModel mj_objectWithKeyValues:dic];
        [arr addObject:annexsM];
    }
    self.annexsArr = arr;
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.userInfo = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];

    self.day = [NoticeTools getDayFromNow:created_at];
    self.hour = [NoticeTools getHourFormNow:created_at];
    NSString *year = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy"];
    
    self.year = [NSString stringWithFormat:@"%@年",year];
    
}

- (void)setAnnexsArr:(NSMutableArray *)annexsArr{
    _annexsArr = annexsArr;
    
    NSMutableArray *imgListArr = [NSMutableArray new];
    for (NoticeAnnexsModel *imgM in annexsArr) {
        [imgListArr addObject:imgM.annex_url];
    }
    self.imgListArr = imgListArr;
}

- (void)setComments:(NSArray *)comments{
    _comments = comments;
    self.commentArr = [NSMutableArray new];
    for (NSDictionary *dic in comments) {
        [self.commentArr addObject:[NoticeBBSComent mj_objectWithKeyValues:dic]];
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

//获取label上每一行的文字
- (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font textHeight:(CGFloat)txtHeight
{
    return [NoticeTools getSeparatedLinesFromLabel:text width:width font:font textHeight:self.textHeight];
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
