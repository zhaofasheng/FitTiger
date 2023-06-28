//
//  NoticeAbout.m
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeAbout.h"
#import "ZFSDateFormatUtil.h"
@implementation NoticeAbout
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userId":@"id"};
}
- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.day = [NoticeTools getDayFromNow:created_at];
    self.hour = [NoticeTools getHourFormNow:created_at];
    
    //近日零点的时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curTime = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM-dd"];
    NSInteger cur = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",curTime]];
    
    //注册时候零点的时间戳
    NSString *str = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"];
    NSInteger regreTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",str]];
    NSInteger days = [NSString stringWithFormat:@"%ld",(long)(cur-regreTime)/86400].integerValue+1;
    self.comeDays = [NSString stringWithFormat:@"%@%ld%@",[NoticeTools getLocalStrWith:@"mineme.comeday"],days,[NoticeTools getLocalStrWith:@"group.day"]];
}

- (void)setVoice_total_len:(NSString *)voice_total_len{
    self.oring = voice_total_len;
    if (voice_total_len.integerValue < 300) {
        self.voice_total_lens = voice_total_len;
        _voice_total_len = [NSString stringWithFormat:@"%@%@",voice_total_len,[NoticeTools getLocalStrWith:@"mineme.miao"]];
        self.addTime = [NSString stringWithFormat:@"%@%@%@",[NoticeTools getLocalStrWith:@"mineme.jilu"],voice_total_len,[NoticeTools getLocalStrWith:@"mineme.miao"]];
    }else if (voice_total_len.integerValue >= 300){
        _voice_total_len = [NSString stringWithFormat:@"%ld%@",voice_total_len.integerValue/60,[NoticeTools getLocalStrWith:@"mineme.fenz"]];
        self.voice_total_lens = [NSString stringWithFormat:@"%ld",voice_total_len.integerValue/60];
        self.addTime = [NSString stringWithFormat:@"%@%ld%@",[NoticeTools getLocalStrWith:@"mineme.jilu"],voice_total_len.integerValue/60,[NoticeTools getLocalStrWith:@"mineme.fenz"]];
    }
}

- (void)setAvatar_url:(NSString *)avatar_url{
    NSArray * array = [avatar_url componentsSeparatedByString:@"?"];
    if (array.count) {
        _avatar_url = array[0];
    }
}

@end
