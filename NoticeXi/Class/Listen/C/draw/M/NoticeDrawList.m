//
//  NoticeDrawList.m
//  NoticeXi
//
//  Created by li lei on 2019/7/8.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawList.h"

@implementation NoticeDrawList

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
    self.createTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"drawId":@"id"};
}

- (void)setIs_private:(NSString *)is_private{
    _is_private = is_private;
    if (is_private.integerValue) {
        self.nick_name = [NoticeTools getLocalStrWith:@"hh.nmhuajia"];
    }
}

- (void)setTopic_name:(NSString *)topic_name{
    _topic_name = topic_name;
    if (topic_name && topic_name.length) {
        self.topName = [NSString stringWithFormat:@"#%@#",topic_name];
    }
}

- (void)setUser_id:(NSString *)user_id{
    _user_id = user_id;
    if ([user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        self.isSelf = YES;
    }else{
        self.isSelf = NO;
    }
}

@end
