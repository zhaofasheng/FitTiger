//
//  NoticeHasSupportHelpModel.m
//  NoticeXi
//
//  Created by li lei on 2023/5/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeHasSupportHelpModel.h"
#import "NoticeHelpCommentModel.h"
@implementation NoticeHasSupportHelpModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tieId":@"id"};
}

- (void)setReply_list:(NSArray *)reply_list{
    _reply_list = reply_list;
    if(reply_list.count){
        self.replyModelArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in reply_list) {
            NoticeHelpCommentModel *comM = [NoticeHelpCommentModel mj_objectWithKeyValues:dic];
            [self.replyModelArr addObject:comM];
        }
    }
}
@end
