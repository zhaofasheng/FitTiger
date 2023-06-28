//
//  NoticeOneToOne.m
//  NoticeXi
//
//  Created by li lei on 2018/12/28.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeOneToOne.h"

@implementation NoticeOneToOne

- (void)setData:(NSDictionary *)data{
    _data = data;
    if (data && [data isKindOfClass:[NSDictionary class]]) {
       self.chatM = [NoticeOTOModel mj_objectWithKeyValues:data];
    }
}

@end
