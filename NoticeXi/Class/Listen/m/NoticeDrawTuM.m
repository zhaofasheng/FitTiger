//
//  NoticeDrawTuM.m
//  NoticeXi
//
//  Created by li lei on 2019/10/25.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeDrawTuM.h"

@implementation NoticeDrawTuM

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"graffitiId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

- (void)setTopic_name:(NSString *)topic_name{
    _topic_name = topic_name;
    if (topic_name && topic_name.length) {
        self.topName = [NSString stringWithFormat:@"#%@#",topic_name];
    }
}
@end
