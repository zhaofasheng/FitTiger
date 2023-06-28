//
//  NoticeCheckModel.m
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeCheckModel.h"

@implementation NoticeCheckModel

- (void)setUser_info:(NSDictionary *)user_info{
    _user_info = user_info;
    self.userM = [NoticeUserInfoModel mj_objectWithKeyValues:user_info];
}

@end
