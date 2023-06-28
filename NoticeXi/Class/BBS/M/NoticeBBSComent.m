//
//  NoticeBBSComent.m
//  NoticeXi
//
//  Created by li lei on 2020/11/5.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSComent.h"
#import <CoreText/CoreText.h>
@implementation NoticeBBSComent
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commentId":@"id"};
}

- (void)setReply:(NSDictionary *)reply{
    _reply = reply;
    self.replyM = [NoticeBBSComent mj_objectWithKeyValues:reply];
}

- (void)setLike_id:(NSString *)like_id{
    _like_id = like_id;
    self.isGood = like_id.intValue;
}

- (void)setTo_user_info:(NSDictionary *)to_user_info{
    _to_user_info = to_user_info;
    self.toUserInfo = [NoticeAbout mj_objectWithKeyValues:to_user_info];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.userInfo = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}

- (void)setComments:(NSArray *)comments{
    _comments = comments;
    NSMutableArray *arr = [NSMutableArray new];
    for (NSDictionary *dic in comments) {
        NoticeSubComentModel *comM = [NoticeSubComentModel mj_objectWithKeyValues:dic];
        [comM reSetText];
        [arr addObject:comM];
    }
    self.subCommentArr = arr;
}

- (void)setComment_content:(NSString *)comment_content{
    _comment_content = comment_content;
    self.textContent = comment_content;
}

- (void)setTextContent:(NSString *)textContent{
    _textContent = textContent;
    self.textHeight = [self getSpaceLabelHeight:_textContent withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-77];
    self.allTextAttStr = [self setLabelSpacewithValue:_textContent withFont:FOURTHTEENTEXTFONTSIZE];
    
    self.replyTextHeight = [self getSpaceLabelHeight:_textContent withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-15-10-15-35-10];
    
    NSArray * array = [textContent componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {
        if ([array[i] length]) {
            [newArr addObject:array[i]];
        }
    }
    
    NSString *showContent = [newArr componentsJoinedByString:@"\n"];
    NSString *showText = nil;
    if (showContent && showContent.length) {
        CGFloat height = [self getSpaceLabelHeight:showContent withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-75];
        if ([[self getSeparatedLinesFromLabel:showContent width:DR_SCREEN_WIDTH-75 font:FOURTHTEENTEXTFONTSIZE textHeight:height] count] > 2) {

            NSArray *array = [self getSeparatedLinesFromLabel:showContent width:DR_SCREEN_WIDTH-75 font:FOURTHTEENTEXTFONTSIZE textHeight:height];
            NSString *line4String = array[1];
            if (line4String.length < 5) {
                line4String = [NSString stringWithFormat:@"%@...完整",line4String];
                showText = [NSString stringWithFormat:@"%@%@", array[0],line4String];
            }else if (line4String.length > 19){
               showText = [NSString stringWithFormat:@"%@%@...完整", array[0],[line4String substringToIndex:line4String.length-9]];
            }
            else{
                showText = [NSString stringWithFormat:@"%@%@...完整", array[0],[line4String substringToIndex:line4String.length-5]];
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
            self.twoAttTextStr = attStr;
            self.twoTextHeight = [self getSpaceLabelHeight:showText withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-75]+10;
        }else{
            showText = showContent;
            self.twoAttTextStr = [self setLabelSpacewithValue:showText withFont:FIFTHTEENTEXTFONTSIZE];
            self.twoTextHeight = [self getSpaceLabelHeight:showText withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-75];
        }
    }
}

- (void)hasDelete{
    self.allTextAttStr = [self setHasDeleteLabelSpacewithValue:self.textContent withFont:FOURTHTEENTEXTFONTSIZE];
}

- (void)setSubCommentArr:(NSMutableArray *)subCommentArr{
    _subCommentArr = subCommentArr;
    
    if (subCommentArr.count == 1) {
        NoticeSubComentModel *subModel1 = subCommentArr[0];
        self.subCommentHeight = 20+subModel1.comHeight;
    }else if (subCommentArr.count >= 2){
        NoticeSubComentModel *subModel1 = subCommentArr[0];
        NoticeSubComentModel *subModel2 = subCommentArr[1];
        self.subCommentHeight = 10+subModel1.comHeight+subModel2.comHeight+40;
    }
}

//获取label上每一行的文字
- (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font textHeight:(CGFloat)txtHeight
{
    return [NoticeTools getSeparatedLinesFromLabel:text width:width font:font textHeight:self.textHeight];
}

//已删除的留言返回文案
-(NSAttributedString *)setHasDeleteLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
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
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.comment_content attributes:dic];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[NoticeTools getWhiteColor:@"#FF7B7B" NightColor:@"#B35656"] range:NSMakeRange(0,[str length])];
    return attributeStr;
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
