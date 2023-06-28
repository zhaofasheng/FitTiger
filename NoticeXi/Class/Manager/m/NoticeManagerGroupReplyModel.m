//
//  NoticeManagerGroupReplyModel.m
//  NoticeXi
//
//  Created by li lei on 2020/9/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerGroupReplyModel.h"

@implementation NoticeManagerGroupReplyModel

- (void)setUserInfo:(NSDictionary *)userInfo{
    _userInfo = userInfo;
    self.userM = [NoticeUserInfoModel mj_objectWithKeyValues:userInfo];
}

- (void)setCreated_at:(NSString *)created_at{
    
    _created_at =  [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
}



+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"replyId":@"id"};
}
@end
