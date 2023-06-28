//
//  NoticeMessage.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMessage.h"
#import "ZFSDateFormatUtil.h"
@implementation NoticeMessage
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"msgId":@"id"};
}

- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUser = [NoticeVoiceListSubModel mj_objectWithKeyValues:from_user];
}

- (void)setComment:(NSDictionary *)comment{
    _comment = comment;
    self.currentComM = [NoticeVoiceComModel mj_objectWithKeyValues:comment];
}

- (void)setParent_comment:(NSDictionary *)parent_comment{
    _parent_comment = parent_comment;
    self.parrentComM = [NoticeVoiceComModel mj_objectWithKeyValues:parent_comment];
}

- (void)setInvitation_comment:(NSDictionary *)invitation_comment{
    _invitation_comment = invitation_comment;
    self.comModel = [NoticeHelpCommentModel mj_objectWithKeyValues:invitation_comment];
}

- (void)setVoice:(NSDictionary *)voice{
    _voice = voice;
    self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:voice];
}

- (void)setMessage_type:(NSString *)message_type{
    _message_type = message_type;
    if (_message_type) {
        self.type = _message_type;
    }
}

- (void)setPodcast_comment:(NSDictionary *)podcast_comment{
    _podcast_comment = podcast_comment;
    self.comBokeModel = [NoticeVoiceComModel mj_objectWithKeyValues:podcast_comment];
}

- (void)setRelease_at:(NSString *)release_at{
    _release_at = release_at;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    self.friendOutTime = [NSString stringWithFormat:@"%.f",(release_at.integerValue - currentTime)/3600];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curTime = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM-dd"];
    NSInteger cur = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",curTime]];
    
    NSString *str = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"];
    
    NSInteger day = ([ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",str]] +86400*30 - cur)/86400;
    
    if (day > 0 && day < 31) {
        self.days = [NSString stringWithFormat:@"%ld",(long)day];
    }
}

- (void)setTake_time:(NSString *)take_time{
    _take_time = [NoticeTools timeDataAppointFormatterWithTime:take_time.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
}


- (void)setPush_at:(NSString *)push_at{
    _push_at = [NoticeTools updateTimeForRow:push_at];
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentHeight = [self getSpaceLabelHeight:content withFont:TWOTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30-40];
    self.allTextAttStr = [self setLabelSpacewithValue:content withFont:TWOTEXTFONTSIZE];
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


- (void)setOpen_at:(NSString *)open_at{

    if ([open_at isEqualToString:@"0"]) {
        _open_at = open_at;
    }else{
        // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];//1553097600 1552543296
    
        NSString *strs = [NSString stringWithFormat:@"%.1f",(open_at.integerValue - currentTime)/86400];
        CGFloat days = (ceil)(strs.floatValue/1);
        _open_at =  [NSString stringWithFormat:@"%.f",days];
        if (_open_at.integerValue <= 0) {
            _open_at = @"9";
        }
    }

}
@end
