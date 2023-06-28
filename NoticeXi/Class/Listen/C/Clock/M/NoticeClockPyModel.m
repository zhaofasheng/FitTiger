//
//  NoticeClockPyModel.m
//  NoticeXi
//
//  Created by li lei on 2019/10/17.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockPyModel.h"
#import <CoreText/CoreText.h>
@implementation NoticeClockPyModel

- (void)setLine_content:(NSString *)line_content{
    _line_content = line_content;
    self.contentHeight = [self getSpaceLabelHeight:line_content withFont:FOURTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-100]+10;
    self.attLine_content = [self setLabelSpacewithValue:line_content withFont:FOURTHTEENTEXTFONTSIZE];
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

- (void)setLine:(NSDictionary *)line{
    if (!line) {
        return;
    }
    _line = line;
    self.lineM = [NoticeClockPyModel mj_objectWithKeyValues:line];
    self.line_id = self.lineM.tcId;
    self.dubbing_num = self.lineM.dubbing_num;

    self.tag_id = self.lineM.tag_id;
    self.tag_name = self.lineM.tag_name;
}

- (void)setTo_user_info:(NSDictionary *)to_user_info{
    _to_user_info = to_user_info;
    self.toUserInfo = [NoticeUserInfoModel mj_objectWithKeyValues:to_user_info];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tcId":@"id"};
}

- (void)setTcId:(NSString *)tcId{
    _tcId = tcId;
    self.pyId = tcId;
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.created_atTime = [NoticeTools updateTimeForRow:created_at];
   self.pickTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"];
}

- (void)setUser:(NSDictionary *)user{
    _user = user;
    self.userInfo = [NoticeUserInfoModel mj_objectWithKeyValues:user];
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.pyUserInfo = [NoticeUserInfoModel mj_objectWithKeyValues:from_user_info];
}

- (void)setComments:(NSArray *)comments{
    _comments = comments;
    self.comArr = [NSMutableArray new];
    for (NSDictionary *dic in comments) {
        [self.comArr addObject:[NoticeBBSComent mj_objectWithKeyValues:dic]];
    }
}
@end
