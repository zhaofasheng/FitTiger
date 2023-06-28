//
//  NoticeVoiceReadModel.m
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceReadModel.h"

@implementation NoticeVoiceReadModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"readId":@"id"};
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    self.textHeight = [NoticeTools getHeightWithLineHight:14 font:18 width:DR_SCREEN_WIDTH-40 string:content];
    self.allTextAttStr = [NoticeTools getStringWithLineHight:14 string:content];
    
    self.fourAttTextStr = [NoticeTools getStringWithLineHight:6 string:content];
}


@end
