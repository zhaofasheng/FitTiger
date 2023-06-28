//
//  NoticeTeamManageMemberModel.m
//  NoticeXi
//
//  Created by li lei on 2023/6/27.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamManageMemberModel.h"

@implementation NoticeTeamManageMemberModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"manageId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{

    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.intValue appointStr:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUserM = [NoticeAbout mj_objectWithKeyValues:from_user];
}

- (void)setTo_user:(NSDictionary *)to_user{
    _to_user = to_user;
    self.toUserM = [NoticeAbout mj_objectWithKeyValues:to_user];
}

- (void)setReason_type:(NSString *)reason_type{
    if(reason_type.intValue == 1){
        _reason_type = @"原因：人身攻击";
    }else if (reason_type.intValue == 2){
        _reason_type = @"原因：色情暴力";
    }else if (reason_type.intValue == 3){
        _reason_type = @"原因：共享自拍";
    }else{
        _reason_type = @"原因：垃圾广告";
    }
}

- (void)setReason:(NSString *)reason{
    _reason = [NSString stringWithFormat:@"原因：%@",reason];
    self.reasonHeight = GET_STRHEIGHT(_reason, 12, DR_SCREEN_WIDTH-30);
}
@end
