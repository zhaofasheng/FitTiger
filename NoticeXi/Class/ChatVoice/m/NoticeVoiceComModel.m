//
//  NoticeVoiceComModel.m
//  NoticeXi
//
//  Created by li lei on 2022/2/23.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceComModel.h"

@implementation NoticeVoiceComModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"subId":@"id"};
}

- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUser = [NoticeVoiceListSubModel mj_objectWithKeyValues:from_user];
}

- (void)setReplys:(NSArray *)replys{
    _replys = replys;
    if (replys.count) {
        self.replysArr = [[NSMutableArray alloc] init];
        for (NSDictionary *subDic in replys) {
            [self.replysArr addObject:[NoticeVoiceComModel mj_objectWithKeyValues:subDic]];
        }
    }
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    self.mainTextAttStr = [self setLabelSpacewithValue:content withFont:FOURTHTEENTEXTFONTSIZE];
    self.subTextAttStr = [self setLabelSpacewithValue:content withFont:FOURTHTEENTEXTFONTSIZE];
    
    self.mainTextHeight = [self getSpaceLabelHeight:content withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-90]+20;
    self.subTextHeight = [self getSpaceLabelHeight:content withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-120]+20;
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
