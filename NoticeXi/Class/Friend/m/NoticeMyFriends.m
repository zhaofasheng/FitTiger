//
//  NoticeMyFriends.m
//  NoticeXi
//
//  Created by li lei on 2018/11/2.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyFriends.h"

@implementation NoticeMyFriends
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"lastId":@"id"};
}
- (void)setRelease_at:(NSString *)release_at{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    _release_at = [NSString stringWithFormat:@"%.f",(release_at.integerValue - currentTime)/86400];
}
@end
