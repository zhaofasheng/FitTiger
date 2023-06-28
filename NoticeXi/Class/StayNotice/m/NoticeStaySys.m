//
//  NoticeStaySys.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeStaySys.h"

@implementation NoticeStaySys


- (void)setSys:(NSDictionary *)sys{
    _sys = sys;
    self.sysM = [NoticeStayMesssage mj_objectWithKeyValues:sys];
}

- (void)setVoice_comment:(NSDictionary *)voice_comment{
    _voice_comment = voice_comment;
    self.comModel = [NoticeStayMesssage mj_objectWithKeyValues:voice_comment];
}

- (void)setChar_pri:(NSDictionary *)char_pri{
    _char_pri = char_pri;
    self.char_priM = [NoticeStayMesssage mj_objectWithKeyValues:char_pri];
}

- (void)setVoice_whisper:(NSDictionary *)voice_whisper{
    _voice_whisper = voice_whisper;
    self.voice_whisperModel = [NoticeStayMesssage mj_objectWithKeyValues:voice_whisper];
}

- (void)setOther_comment:(NSDictionary *)other_comment{
    _other_comment = other_comment;
    self.other_commentModel = [NoticeStayMesssage mj_objectWithKeyValues:other_comment];
}

- (void)setLike:(NSDictionary *)like{
    _like = like;
    self.likeModel = [NoticeStayMesssage mj_objectWithKeyValues:like];
}

- (void)setChatpri:(NSDictionary *)chatpri{
    _chatpri = chatpri;
    self.chatpriM = [NoticeStayMesssage mj_objectWithKeyValues:chatpri];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}


- (void)setUpdated_at:(NSString *)updated_at{
    _updated_at = [NoticeTools updateTimeForRow:updated_at];
}

- (void)setWith_user_identity_type:(NSString *)with_user_identity_type{
    _with_user_identity_type = with_user_identity_type;
    self.identity_type = with_user_identity_type;
}

- (void)setLast_dialog:(NSDictionary *)last_dialog{
    _last_dialog = last_dialog;
    self.lastChatModel = [NoticeChats mj_objectWithKeyValues:last_dialog];
}

- (void)setUser_flag:(NSString *)user_flag{
    _user_flag = user_flag;
    if (user_flag.intValue == 5) {
        self.user_flagName = @"垃圾";
    }else if (user_flag.intValue == 10){
        self.user_flagName = @"普通";
    }else if (user_flag.intValue == 15){
        self.user_flagName = @"优质";
    }else if (user_flag.intValue == 20){
        self.user_flagName = @"vip";
    }
}

- (void)setWith_user_level:(NSString *)with_user_level{
    _with_user_level = with_user_level;
    NSString *level = with_user_level;
    self.levelImgName = [NSString stringWithFormat:@"Image_leave%d",level.intValue>21?21:level.intValue];
    self.smalllevelImgName = [NSString stringWithFormat:@"Image_smalleave%d",level.intValue>21?21:level.intValue];
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


@end
