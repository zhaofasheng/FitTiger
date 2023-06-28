//
//  NoticeCallVoiceModel.m
//  NoticeXi
//
//  Created by li lei on 2021/10/21.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCallVoiceModel.h"

@implementation NoticeCallVoiceModel

- (void)setUserInfo:(NSDictionary *)userInfo{
    _userInfo = userInfo;
    self.userM = [NoticeUserInfoModel mj_objectWithKeyValues:userInfo];
}

@end
