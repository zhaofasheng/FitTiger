//
//  NoticeMyCareModel.m
//  NoticeXi
//
//  Created by li lei on 2020/1/11.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyCareModel.h"
#import "ZFSDateFormatUtil.h"
@implementation NoticeMyCareModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"subId":@"id"};
}

- (void)setEstablished_at:(NSString *)established_at{
    
    NSTimeInterval thirtyTime = established_at.integerValue+30*86400;//到期时间
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curentTimeZreoY = [ZFSDateFormatUtil dateFullStringWithInterval:currentTime formatStyle:@"yyyy-MM-dd"];
    NSTimeInterval curentZeroTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",curentTimeZreoY]];//当前时间的零点时间
    _established_at = [NSString stringWithFormat:@"%.f",(thirtyTime - curentZeroTime)/86400];
}

- (void)setSubscribeUser:(NSDictionary *)subscribeUser{
    _subscribeUser = subscribeUser;
    self.userInfo = [NoticeVoiceListSubModel mj_objectWithKeyValues:subscribeUser];
}
@end
