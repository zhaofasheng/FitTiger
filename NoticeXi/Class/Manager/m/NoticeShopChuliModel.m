//
//  NoticeShopChuliModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopChuliModel.h"

@implementation NoticeShopChuliModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"shopId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.userM = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}
@end
