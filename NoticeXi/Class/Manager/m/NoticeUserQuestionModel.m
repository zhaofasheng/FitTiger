//
//  NoticeUserQuestionModel.m
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserQuestionModel.h"

@implementation NoticeUserQuestionModel
- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"questionId":@"id"};
}
- (void)setUserInfo:(NSDictionary *)userInfo{
    _userInfo = userInfo;
    self.userM = [NoticeUserInfoModel mj_objectWithKeyValues:userInfo];
}

- (void)setSysmsgInfo:(NSDictionary *)sysmsgInfo{
    _sysmsgInfo = sysmsgInfo;
    self.msgM = [NoticeMessage mj_objectWithKeyValues:sysmsgInfo];
}
@end
