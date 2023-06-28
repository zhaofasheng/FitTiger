//
//  NoticeHelpCommentModel.m
//  NoticeXi
//
//  Created by li lei on 2022/8/6.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpCommentModel.h"

@implementation NoticeHelpCommentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commentId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.intValue appointStr:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUserM = [NoticeAbout mj_objectWithKeyValues:from_user];
}

- (void)setReplys:(NSArray *)replys{
    _replys = replys;
    
    if (replys.count) {
        self.replyArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in replys) {
            NoticeHelpCommentModel *subModel = [NoticeHelpCommentModel mj_objectWithKeyValues:dic];
            [self.replyArr addObject:subModel];
            self.subContentType = subModel.content_type;
        }
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.textHeight = [NoticeTools getHeightWithLineHight:4 font:14 width:DR_SCREEN_WIDTH-104 string:content];
    self.textAttStr = [NoticeTools getStringWithLineHight:4 string:content];
     
    self.subTextHeight = [NoticeTools getHeightWithLineHight:4 font:14 width:DR_SCREEN_WIDTH-88-47 string:content];
 
}
@end
