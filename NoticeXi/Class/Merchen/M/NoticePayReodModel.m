//
//  NoticePayReodModel.m
//  NoticeXi
//
//  Created by li lei on 2021/12/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePayReodModel.h"

@implementation NoticePayReodModel

- (void)setPay_time:(NSString *)pay_time{
    _pay_time = [NSString stringWithFormat:@"%@:%@",[NoticeTools getLocalStrWith:@"zb.buyTime"],[NoticeTools timeDataAppointFormatterWithTime:pay_time.integerValue appointStr:@"MM-dd HH:mm"]];
}

@end
