//
//  NoticeNearPerson.m
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeNearPerson.h"

@implementation NoticeNearPerson
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"blackId":@"id"};
}
- (void)setDistance:(NSString *)distance{
    if (distance.floatValue < 1000) {
        if (distance.floatValue < 1) {
            _distance = @"0m";
        }else{
            _distance = [NSString stringWithFormat:@"%.fm",distance.floatValue];
        }
    }else{
        _distance = [NSString stringWithFormat:@"%.1fkm",distance.floatValue/1000.0];
    }
}

- (void)setLogin_at:(NSString *)login_at{
    _login_at = [NoticeTools updateTimeForRowNear:login_at];
}

- (void)setVoice_total_len:(NSString *)voice_total_len{
    if (voice_total_len.integerValue > 300) {
        _voice_total_len = [NSString stringWithFormat:@"%ld%@",(long)voice_total_len.integerValue/60,[NoticeTools getLocalStrWith:@"movie.fenzhong"]];
    }else{
        _voice_total_len = [NSString stringWithFormat:@"%@秒",voice_total_len];
    }
}

- (void)setReleased_at:(NSString *)released_at{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    _released_at = [NSString stringWithFormat:@"%.f",(released_at.integerValue - currentTime)/86400+1];
    self.released_atTime = [NSString stringWithFormat:@"%.f天",(released_at.integerValue - currentTime)/86400+1];
}

- (void)setTo_user_id:(NSString *)to_user_id{
    _to_user_id = to_user_id;
    self.user_id = _to_user_id;
}

- (void)setUser:(NSDictionary *)user{
    _user = user;
    self.userInfo = [NoticeUserInfoModel mj_objectWithKeyValues:user];
}
@end
