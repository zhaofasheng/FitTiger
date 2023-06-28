//
//  NoticeShareVoiceModel.m
//  NoticeXi
//
//  Created by li lei on 2022/5/27.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShareVoiceModel.h"

@implementation NoticeShareVoiceModel

- (void)setUser:(NSDictionary *)user{
    _user = user;
    self.userM = [NoticeFriendAcdModel mj_objectWithKeyValues:user];
}

- (void)setVoice:(NSDictionary *)voice{
    _voice = voice;
    self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:voice];
}

- (void)setDubbing:(NSDictionary *)dubbing{
    _dubbing = dubbing;
    self.pyM = [NoticeClockPyModel mj_objectWithKeyValues:dubbing];
}

- (void)setLine:(NSDictionary *)line{
    _line = line;
    self.lineM = [NoticeClockPyModel mj_objectWithKeyValues:line];
}

@end
