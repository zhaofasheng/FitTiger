//
//  NoticeBannerModel.m
//  NoticeXi
//
//  Created by li lei on 2021/1/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBannerModel.h"

@implementation NoticeBannerModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"bannerId":@"id"};
}

- (void)setStarted_at:(NSString *)started_at{
    _started_at = [NoticeTools timeDataAppointFormatterWithTime:started_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
}

- (void)setTaketed_at:(NSString *)taketed_at{
    _taketed_at =  [NoticeTools timeDataAppointFormatterWithTime:taketed_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
    self.showTime = [NoticeTools timeDataAppointFormatterWithTime:taketed_at.integerValue appointStr:@"yyyy.MM.dd"];
    self.showTimeMD = [NoticeTools timeDataAppointFormatterWithTime:taketed_at.integerValue appointStr:@"MM.dd"];
}
@end
