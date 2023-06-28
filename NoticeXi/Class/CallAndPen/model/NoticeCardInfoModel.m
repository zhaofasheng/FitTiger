//
//  NoticeCardInfoModel.m
//  NoticeXi
//
//  Created by li lei on 2020/10/29.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeCardInfoModel.h"


@implementation NoticeCardInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cardId":@"id"};
}
- (void)setUser:(NSDictionary *)user{
    _user = user;
    self.userInfo = [NoticeAbout mj_objectWithKeyValues:user];
}



@end
