//
//  NoticeLy.m
//  NoticeXi
//
//  Created by li lei on 2018/11/27.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLy.h"

@implementation NoticeLy
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"liuyanId":@"id"};
}

- (void)setContent:(NSString *)content{

    if ([self.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        self.isSelf = YES;
    }else{
        self.isSelf = NO;
    }

    if (self.isSelf) {
        _content = [NSString stringWithFormat:@"你:%@",content];
    }else{
        _content = [NSString stringWithFormat:@"作者:%@",content];
    }
    
    self.allTextAttStr = [NoticeTools getStringWithLineHight:10 string:_content];
    self.allreadTextAttStr = [NoticeTools getStringWithLineHight:10 string:content];
    self.height = [NoticeTools getHeightWithLineHight:10 font:14 width:DR_SCREEN_WIDTH-40 string:_content];
    self.height1 = [NoticeTools getHeightWithLineHight:10 font:14 width:DR_SCREEN_WIDTH-30-44-66 string:content];
}

- (void)setReply_content:(NSString *)reply_content{
    _reply_content = reply_content;
    self.replyTextAttStr = [NoticeTools getStringWithLineHight:10 string:_reply_content];
    self.height2 = [NoticeTools getHeightWithLineHight:10 font:14 width:DR_SCREEN_WIDTH-30-74-64 string:_reply_content];
    if (self.height2 < 20) {
        self.height2 = 20;
    }
}
@end
