//
//  NoticeHasCenterData.m
//  NoticeXi
//
//  Created by li lei on 2020/4/24.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeHasCenterData.h"
#import "ZFSDateFormatUtil.h"
@implementation NoticeHasCenterData
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"typeId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    //近日零点的时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curTime = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM-dd"];
    NSInteger cur = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",curTime]];
    
    //注册时候零点的时间戳
    NSString *str = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"];
    NSInteger regreTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",str]];
    
    NSInteger days = [NSString stringWithFormat:@"%ld",(long)(cur-regreTime)/86400].integerValue+1;
    self.comeHereTime = [NSString stringWithFormat:@"%ld",days];
}

- (void)setVoice_total_len:(NSString *)voice_total_len{
    if (voice_total_len.integerValue < 300) {
        _voice_total_len = [NSString stringWithFormat:@"%@秒",voice_total_len];
    }else if (voice_total_len.integerValue >= 300){
        _voice_total_len = [NSString stringWithFormat:@"%ld%@",voice_total_len.integerValue/60,[NoticeTools getLocalStrWith:@"movie.fenzhong"]];
    }
}

@end
