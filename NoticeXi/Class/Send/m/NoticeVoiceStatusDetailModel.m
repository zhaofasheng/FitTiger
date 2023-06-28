//
//  NoticeVoiceStatusDetailModel.m
//  NoticeXi
//
//  Created by li lei on 2021/5/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceStatusDetailModel.h"

@implementation NoticeVoiceStatusDetailModel

- (void)setAudios:(NSDictionary *)audios{
    _audios = audios;
    self.audioM = [NoticeVoiceStatusAudioModel mj_objectWithKeyValues:audios];
}

@end
