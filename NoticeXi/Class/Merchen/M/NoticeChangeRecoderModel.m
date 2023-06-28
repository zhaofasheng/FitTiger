//
//  NoticeChangeRecoderModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/18.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeRecoderModel.h"

@implementation NoticeChangeRecoderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"recodId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)setIncome_balance:(NSString *)income_balance{
    _income_balance = [NSString stringWithFormat:@"%.2f",income_balance.floatValue];
}

- (void)setRecharge_balance:(NSString *)recharge_balance{
    _recharge_balance = [NSString stringWithFormat:@"%.2f",recharge_balance.floatValue];
}

@end
