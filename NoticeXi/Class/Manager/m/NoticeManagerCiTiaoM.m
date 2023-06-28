//
//  NoticeManagerCiTiaoM.m
//  NoticeXi
//
//  Created by li lei on 2019/9/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerCiTiaoM.h"

@implementation NoticeManagerCiTiaoM
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ciId":@"id"};
}

- (void)setResource_detail:(NSDictionary *)resource_detail{
    _resource_detail = resource_detail;
    self.movie = [NoticeMovie mj_objectWithKeyValues:resource_detail];
    self.book = [NoticeBook mj_objectWithKeyValues:resource_detail];
    self.song = [NoticeSong mj_objectWithKeyValues:resource_detail];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
}

- (void)setPointValue:(NSString *)pointValue{
    _pointValue = pointValue;
    self.hasRead = pointValue.integerValue? YES : NO;
}
@end
