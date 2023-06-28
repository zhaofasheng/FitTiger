//
//  NoticeVoiceChat.m
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceChat.h"

@implementation NoticeVoiceChat
- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

- (void)setUser:(NSDictionary *)user{
    _user = user;
    self.subUserModel = [NoticeVoiceListSubModel mj_objectWithKeyValues:user];
}

- (void)setResource_type:(NSString *)resource_type
{
    _resource_type = resource_type;
    self.content_type = resource_type;
}

@end
