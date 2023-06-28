//
//  NoticeMoveMemberModel.m
//  NoticeXi
//
//  Created by li lei on 2020/9/9.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeMoveMemberModel.h"

@implementation NoticeMoveMemberModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"moveId":@"id"};
}
- (void)setType:(NSString *)type{
    _type = type;
    // 1:人身攻击/色情/共享自拍/违法信息(正副部长删除) 2:违反舍规(正副部长删除) 3:发言动机不符合社团宗旨(正副部长删除) 4:管理员删除
    if (type.intValue == 1) {
        self.typeName = @"垃圾信息";
    }else if (type.intValue == 2){
        self.typeName = @"违反舍规";
    }else if (type.intValue == 3){
        self.typeName = @"无关人士";
    }else if (type.intValue == 4){
        self.typeName = @"管理员删除";
    }
}
- (void)setFromUserInfo:(NSDictionary *)fromUserInfo{
    self.fromUserM = [NoticeUserInfoModel mj_objectWithKeyValues:fromUserInfo];
}

- (void)setToUserInfo:(NSDictionary *)toUserInfo{
    self.toUserM = [NoticeUserInfoModel mj_objectWithKeyValues:toUserInfo];
}

- (void)setAssocInfo:(NSDictionary *)assocInfo{
    self.assocM = [NoticeSubGroupModel mj_objectWithKeyValues:assocInfo];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
}
@end
