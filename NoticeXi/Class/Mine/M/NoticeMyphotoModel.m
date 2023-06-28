//
//  NoticeMyphotoModel.m
//  NoticeXi
//
//  Created by li lei on 2018/10/27.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyphotoModel.h"
#import "NoticeSmallArrModel.h"
@implementation NoticeMyphotoModel

- (void)setData:(NSArray *)data{
    _data = data;
    if (_data.count) {
        self.smallArr = [NSMutableArray new];
        for (NSDictionary *dic in _data) {
            [self.smallArr addObject:[NoticeSmallArrModel mj_objectWithKeyValues:dic]];
        }
    }
}


@end
