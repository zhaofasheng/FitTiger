//
//  NoticeOrderListModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeOrderListModel.h"

@implementation NoticeOrderListModel

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"orderId":@"id"};
}

- (void)setOrder_type:(NSString *)order_type{
    _order_type = order_type;
    if(_order_type.integerValue == 9){
        _order_type = @"6";
    }
}

@end
