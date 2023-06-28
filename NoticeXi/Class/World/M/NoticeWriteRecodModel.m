//
//  NoticeWriteRecodModel.m
//  NoticeXi
//
//  Created by li lei on 2021/12/8.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeWriteRecodModel.h"

@implementation NoticeWriteRecodModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"bannerId":@"id"};
}

- (void)setComments:(NSArray *)comments{
    _comments = comments;
    self.lyArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in comments) {
        NoticeLy *lyM = [NoticeLy mj_objectWithKeyValues:dic];
        [self.lyArr addObject:lyM];
    }
}

- (void)setTaketed_at:(NSString *)taketed_at{
    _taketed_at = taketed_at;
    self.year = [NoticeTools timeDataAppointFormatterWithTime:taketed_at.integerValue appointStr:@"YYYY"];
    self.day = [NoticeTools timeDataAppointFormatterWithTime:taketed_at.integerValue appointStr:@"MM/dd"];
}
@end
