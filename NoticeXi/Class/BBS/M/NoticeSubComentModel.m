//
//  NoticeSubComentModel.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSubComentModel.h"
#import "DDHAttributedMode.h"
@implementation NoticeSubComentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commentId":@"id"};
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.userInfo = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}

- (void)setTo_user_info:(NSDictionary *)to_user_info{
    _to_user_info = to_user_info;
    self.toUserInfo = [NoticeAbout mj_objectWithKeyValues:to_user_info];
}

- (void)setLike_id:(NSString *)like_id{
    _like_id = like_id;
    self.isGood = like_id.intValue;
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

- (void)reSetText{
    if (self.userInfo || self.comment_content) {
        self.showComContent = [self setLabelSpacewithValue:[NSString stringWithFormat:@"%@:%@",self.userInfo.nick_name,self.comment_content] withFont:THRETEENTEXTFONTSIZE noColor:NO];
        self.comHeight = [self getSpaceLabelHeight:[NSString stringWithFormat:@"%@:%@",self.userInfo.nick_name,self.comment_content] withFont:THRETEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-95];
    }
}

- (void)setComment_content:(NSString *)comment_content{
    _comment_content = comment_content;
    self.textContent = comment_content;
}

- (void)setTextContent:(NSString *)textContent{
    _textContent = textContent;
    self.textHeight = [self getSpaceLabelHeight:_textContent withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-75];
    self.allTextAttStr = [self setLabelSpacewithValue:_textContent withFont:FOURTHTEENTEXTFONTSIZE noColor:YES];
}

//如果是指定艾特谁，重新设置文本
- (void)sethHasToUserContent{
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
    NSDictionary *dic = @{NSFontAttributeName:THRETEENTEXTFONTSIZE, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    NSString *str = [NSString stringWithFormat:@"回复 %@ :%@",self.toUserInfo.nick_name,self.comment_content];
    self.textHeight = [self getSpaceLabelHeight:str withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-75];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[NoticeTools getWhiteColor:@"#9D6A54" NightColor:@"#6B493A"] range:NSMakeRange(3,[self.toUserInfo.nick_name length])];
    self.hasToUseerIdAllTextAttStr = attributeStr;
}

- (void)hasDelete{
    if (self.userInfo && self.to_user_id.intValue) {
        NSString *str = [NSString stringWithFormat:@"回复 %@ :%@",self.toUserInfo.nick_name,self.comment_content];
        [self.hasToUseerIdAllTextAttStr addAttribute:NSForegroundColorAttributeName value:[NoticeTools getWhiteColor:@"#FF7B7B" NightColor:@"#B35656"] range:NSMakeRange(str.length-self.comment_content.length,[self.comment_content length])];
    }else{
        [self.allTextAttStr addAttribute:NSForegroundColorAttributeName value:[NoticeTools getWhiteColor:@"#FF7B7B" NightColor:@"#B35656"] range:NSMakeRange(0,[self.comment_content length])];
    }
}

//返回文案
-(NSMutableAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font noColor:(BOOL)noColor{
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
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
    if (!noColor) {
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[NoticeTools getWhiteColor:@"#9D6A54" NightColor:@"#6B493A"] range:NSMakeRange(0,[self.userInfo.nick_name length])];
    }
    
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
