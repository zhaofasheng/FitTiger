//
//  NoticeGroupListModel.m
//  NoticeXi
//
//  Created by li lei on 2023/6/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeGroupListModel.h"

@implementation NoticeGroupListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"teamId":@"id"};
}

- (void)setLast_chat_log:(NSDictionary *)last_chat_log{
    _last_chat_log = last_chat_log;
    self.lastMsgModel = [NoticeTeamChatModel mj_objectWithKeyValues:last_chat_log];
}
@end
