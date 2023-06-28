//
//  NoticeMerchantModel.m
//  NoticeXi
//
//  Created by li lei on 2021/11/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeMerchantModel.h"

@implementation NoticeMerchantModel

- (void)setProducts:(NSArray *)products{
    _products = products;
    self.subModelArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in products) {
        [self.subModelArr addObject:[NoticeOpenTbModel mj_objectWithKeyValues:dic]];
    }
}

@end
