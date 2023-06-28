//
//  NoticeSayToSelf.m
//  NoticeXi
//
//  Created by li lei on 2019/7/9.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSayToSelf.h"

@implementation NoticeSayToSelf

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.day = [NoticeTools getDayFromNow:created_at];
    self.hour = [NoticeTools getHourFormNow:created_at];

}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"noteId":@"id"};
}

@end
