//
//  NoticeJuBaoShopChatModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/20.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeJuBaoShopChatModel.h"

@implementation NoticeJuBaoShopChatModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"jubaiId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.fromeUserM = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}

- (void)setTo_user_info:(NSDictionary *)to_user_info{
    _to_user_info = to_user_info;
    self.toUserM = [NoticeAbout mj_objectWithKeyValues:to_user_info];
}

- (void)setType_id:(NSString *)type_id{
    if (type_id.intValue == 1) {
        _type_id = @"人身攻击";
    }else if (type_id.intValue == 2){
        _type_id = @"色情暴力";
    }else if (type_id.intValue == 3){
        _type_id = @"垃圾广告";
    }else if (type_id.intValue == 4){
        _type_id = @"无响应";
    }
}
@end
