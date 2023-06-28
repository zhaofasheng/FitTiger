//
//  NoticeStatus.m
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeStatus.h"

@implementation NoticeStatus
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"friendS":@"friend",@"AdmiredId":@"id"};
}

- (void)setFriendS:(NSDictionary *)friendS{
    _friendS = friendS;
    self.friendStatus = [NoticeFriendStatus mj_objectWithKeyValues:friendS];
}

- (void)setChatPri:(NSDictionary *)chatPri{
    _chatPri = chatPri;
    self.chatStatus = [NoticeChatStatus mj_objectWithKeyValues:chatPri];
}
@end
