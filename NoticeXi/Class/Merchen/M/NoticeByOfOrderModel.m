//
//  NoticeByOfOrderModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/12.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeByOfOrderModel.h"

@implementation NoticeByOfOrderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"orderId":@"id"};
}

- (void)setResult:(NSDictionary *)result{
    _result = result;
    self.resultModel = [NoticeByOfOrderModel mj_objectWithKeyValues:result];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.created_atTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.intValue appointStr:@"yyyy-MM-dd hh:mm:ss"];
}
@end
