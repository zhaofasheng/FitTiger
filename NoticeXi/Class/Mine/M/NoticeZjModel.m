//
//  NoticeZjModel.m
//  NoticeXi
//
//  Created by li lei on 2019/8/13.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeZjModel.h"

@implementation NoticeZjModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"albumId":@"id"};
}
- (void)setVoice_total_len:(NSString *)voice_total_len{
    _voice_total_len = voice_total_len;
    if (voice_total_len.integerValue < 300) {
        self.voice_total_lens = [NSString stringWithFormat:@"%@秒",voice_total_len];
    }else if (voice_total_len.integerValue >= 300){
        self.voice_total_lens = [NSString stringWithFormat:@"%ld%@",voice_total_len.integerValue/60,[NoticeTools getLocalStrWith:@"movie.fenzhong"]];
    }
    self.voice_total_mins = [NSString stringWithFormat:@"%ld min",voice_total_len.integerValue % 60==0 ? (voice_total_len.integerValue / 60):((voice_total_len.integerValue / 60)+1)];
    self.textNum = [NSString stringWithFormat:@"%ld 字",voice_total_len.integerValue];
}
- (void)setAlbum_type:(NSString *)album_type{
    _album_type = album_type;
    if ([album_type isEqualToString:@"1"]) {
        self.addType = @"2";
        self.addName = [NoticeTools isSimpleLau]? [NoticeTools getLocalStrWith:@"mineme.alllkan"]:@"所有人可見";
    }else if ([album_type isEqualToString:@"2"]){
        self.addType = @"1";
        self.addName = [NoticeTools isSimpleLau]? [NoticeTools getLocalStrWith:@"mineme.xueyoukejian"]:@"学友可見";
    }else{
        self.addType = @"0";
        self.addName = [NoticeTools isSimpleLau]? [NoticeTools getLocalStrWith:@"zj.simizj"]:@"私密專輯";
    }
}

- (void)setStarted_at:(NSString *)started_at{
    _started_at = [NoticeTools timeDataAppointFormatterWithTime:started_at.integerValue appointStr:@"yyyy.MM.dd"];
}

- (void)setLast_join_time:(NSString *)last_join_time{
    _last_join_time = last_join_time;
    self.last_join_timeName = [NSString stringWithFormat:@"%@：%@",[NoticeTools chinese:@"最近新增" english:@"New" japan:@"新規"],[NoticeTools updateTimeForRowVoice:last_join_time]];
}

- (void)setEnded_at:(NSString *)ended_at{
    _ended_at = [NoticeTools timeDataAppointFormatterWithTime:ended_at.integerValue appointStr:@"yyyy.MM.dd"];
}

- (void)setLatest_at:(NSString *)latest_at{
    _latest_at = [NoticeTools timeDataAppointFormatterWithTime:latest_at.integerValue appointStr:@"yyyy.MM.dd"];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.created_atTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy.MM.dd"];
}

- (void)setAlbum_cover_url:(NSString *)album_cover_url{
    NSArray *array = [album_cover_url componentsSeparatedByString:@"?"];
    _album_cover_url = array[0];
}
@end
