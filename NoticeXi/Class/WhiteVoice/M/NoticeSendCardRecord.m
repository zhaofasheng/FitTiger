//
//  NoticeSendCardRecord.m
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendCardRecord.h"

@implementation NoticeSendCardRecord
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"recordId":@"id"};
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.fromUserInfo = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}
@end
