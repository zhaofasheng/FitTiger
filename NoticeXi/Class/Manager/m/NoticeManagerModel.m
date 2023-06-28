//
//  NoticeManagerModel.m
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerModel.h"

@implementation NoticeManagerModel

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"managerId":@"id"};
}

- (void)setRecognition_content:(NSString *)recognition_content{
    _recognition_content = recognition_content;
    self.resource_content = recognition_content;
}

- (void)setResource_content:(NSString *)resource_content{
    _resource_content = resource_content;
    if (_resource_content.length) {
        self.contentHeight = 30+GET_STRHEIGHT(resource_content, 14, DR_SCREEN_WIDTH-50);
    }
}
@end
