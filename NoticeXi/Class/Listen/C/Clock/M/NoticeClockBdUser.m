
//
//  NoticeClockBdUser.m
//  NoticeXi
//
//  Created by li lei on 2019/11/11.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeClockBdUser.h"

@implementation NoticeClockBdUser

- (void)setDidding_user_info:(NSDictionary *)didding_user_info{
    _didding_user_info = didding_user_info;
    self.didding_userM = [NoticeUserInfoModel mj_objectWithKeyValues:didding_user_info];
}

- (void)setLine_user_info:(NSDictionary *)line_user_info{
    _line_user_info = line_user_info;
    self.line_userM = [NoticeUserInfoModel mj_objectWithKeyValues:line_user_info];
}
@end
