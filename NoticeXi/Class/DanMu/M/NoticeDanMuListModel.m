//
//  NoticeDanMuListModel.m
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuListModel.h"

@implementation NoticeDanMuListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"danmuId":@"id",@"allNum":@"count"};
}

- (void)setUserInfo:(NSDictionary *)userInfo{
    _userInfo = userInfo;
    self.userM = [NoticeAbout mj_objectWithKeyValues:userInfo];
}

- (void)setBarrage_at:(NSString *)barrage_at{
    _barrage_at = barrage_at;
    self.barrageTime = [self getMMSSFromSS:barrage_at.integerValue];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    if (seconds <0) {
        return format_time = @"00:00";
    }
    return format_time;
}


//- (void)setContentText:(NSString *)contentText{
//
//    contentText = [contentText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    _contentText = contentText;
//    if (!_contentText || !_contentText.length) {
//        return;
//    }
//    self.attStr = [self setLabelSpacewithValue:contentText withFont:FIFTHTEENTEXTFONTSIZE];
//    if ((GET_STRWIDTH(contentText, 15,30)) >= (DR_SCREEN_WIDTH-140)) {
//        self.textWidth = DR_SCREEN_WIDTH-140;
//    }else{
//        self.textWidth = GET_STRWIDTH(contentText, 15,30)+3;
//    }
//    self.textHeight = [self getSpaceLabelHeight:contentText withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.textWidth]+20;
//    if (self.textHeight < 35) {
//        self.textHeight = 35;
//    }
//}

- (void)setBarrage_content:(NSString *)barrage_content{
    barrage_content = [barrage_content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _barrage_content = barrage_content;
    if (!_barrage_content || !_barrage_content.length) {
        return;
    }
    
    self.attStr = [self setLabelSpacewithValue:barrage_content withFont:FIFTHTEENTEXTFONTSIZE];
    if ((GET_STRWIDTH(barrage_content, 15,30)) >= (DR_SCREEN_WIDTH-58-76)) {
        self.textWidth = DR_SCREEN_WIDTH-158-76;
    }else{
        self.textWidth = GET_STRWIDTH(barrage_content, 15,30);
    }
    self.textHeight = [self getSpaceLabelHeight:barrage_content withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.textWidth];
    if (self.textHeight < 21) {
        self.textHeight = 21;
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
