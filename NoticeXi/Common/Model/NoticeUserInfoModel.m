//
//  NoticeUserInfoModel.m
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserInfoModel.h"
#import "ZFSDateFormatUtil.h"

@implementation NoticeUserInfoModel

- (void)setSelf_intro:(NSString *)self_intro{
    _self_intro = [self_intro stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (void)setReleased_at:(NSString *)released_at{
    _released_at = released_at;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *currentTimeString = [NSString stringWithFormat:@"%.f",currentTime];
    if (released_at.integerValue > currentTimeString.integerValue) {
        self.isClose = YES;
    }else{
        self.isClose = NO;
    }
}

- (void)setAvatar_url:(NSString *)avatar_url{
     NSArray *array = [avatar_url componentsSeparatedByString:@"?"];
    _avatar_url = array[0];
}

- (void)setBg_photo_url:(NSString *)bg_photo_url{
    NSArray *array = [bg_photo_url componentsSeparatedByString:@"?"];
    _bg_photo_url = array[0];
}

- (void)setMain_cover_photo_url:(NSString *)main_cover_photo_url{
    _main_cover_photo_url = main_cover_photo_url;
   // self.cover_photo_url = main_cover_photo_url;
}

- (void)setInterfaceType:(NSString *)interfaceType{
    _interfaceType = interfaceType;
    if ([interfaceType isEqualToString:@"E"]) {
        self.isNounE = YES;
    }else{
        self.isNounE = NO;
    }
}

- (void)setInterface_type:(NSString *)interface_type{
    _interface_type = interface_type;
    self.interfaceType = interface_type;
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    
    //近日零点的时间戳
    NSString *currentTime = [NoticeTools getNowTimeStamp];
    NSString *curTime = [NoticeTools timeDataAppointFormatterWithTime:currentTime.integerValue appointStr:@"yyyy-MM-dd"];
    NSInteger cur = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",curTime]];
    
    //注册时候零点的时间戳
    NSString *str = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"];
    NSInteger regreTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",str]];
    
    self.regTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"];
    self.regTimeForMid = [NSString stringWithFormat:@"%@-15",[NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM"]];
    
    NSInteger days = [NSString stringWithFormat:@"%ld",(long)(cur-regreTime)/86400].integerValue+1;
    self.comeHereDays = [NSString stringWithFormat:@"%ld",days];
    NSString *str1 = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"];

    self.createYear = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy"];
    self.createMonth = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"MM"];
    self.sgjTime = str1;
}

- (void)setLevel:(NSString *)level{
    _level = level;

    self.levelImgName = [NSString stringWithFormat:@"Image_leave%d",level.intValue>21?21:level.intValue];
    if (level.intValue == 0) {
        self.levelImgIconName = @"Image_icon0";
    }else if (level.intValue > 0  & level.intValue < 4){
        self.levelImgIconName = @"Image_icon123";
    }else if (level.intValue > 3  & level.intValue < 7){
        self.levelImgIconName = @"Image_icon456";
    }else if (level.intValue > 6  & level.intValue < 10){
        self.levelImgIconName = @"Image_icon789";
    }else if (level.intValue > 9  & level.intValue < 13){
        self.levelImgIconName = @"Image_icon101112";
    }else if (level.intValue > 12  & level.intValue < 16){
        self.levelImgIconName = @"Image_icon131415";
    }else if (level.intValue > 15  & level.intValue < 19){
        self.levelImgIconName = @"Image_icon161718";
    }else{
        self.levelImgIconName = @"Image_icon192021";
    }

    self.levelName = [NSString stringWithFormat:@"Lv%@",level];
}

- (void)setAdmire_time:(NSString *)admire_time{
    if (admire_time.intValue > 0) {
        //近日零点的时间戳
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        NSString *curTime = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM-dd"];
        NSInteger cur = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",curTime]];
        
        //欣赏时候零点的时间戳
        NSString *str = [NoticeTools timeDataAppointFormatterWithTime:admire_time.integerValue appointStr:@"yyyy-MM-dd"];
        NSInteger regreTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",str]];
        
        NSInteger days = [NSString stringWithFormat:@"%ld",(long)(cur-regreTime)/86400].integerValue+1;
        _admire_time = [NSString stringWithFormat:@"%ld",days];
    }else{
        _admire_time = @"0";
    }
}

- (void)setVoice_total_len:(NSString *)voice_total_len{
    _voice_total_len = voice_total_len;
    if (voice_total_len.integerValue < 300) {
        self.allVoiceTime = [NSString stringWithFormat:@"%@",voice_total_len];
        self.isMoreFiveMin = NO;
    }else if (voice_total_len.integerValue >= 300){
        self.isMoreFiveMin = YES;
        self.allVoiceTime = [NSString stringWithFormat:@"%ld",voice_total_len.integerValue/60];
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"piPeiId":@"id"};
}

@end
