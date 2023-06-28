//
//  NoticeMyWallectModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyWallectModel.h"

@implementation NoticeMyWallectModel


- (void)setPayment_methods:(NSArray *)payment_methods{
    _payment_methods = payment_methods;
    self.payModelArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in payment_methods) {
        [self.payModelArr addObject:[NoticeMyWallectModel mj_objectWithKeyValues:dic]];
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tixianId":@"id"};
}



@end
