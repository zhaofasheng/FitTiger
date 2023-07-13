//
//  NoticeMorelikeTopicController.h
//  NoticeXi
//
//  Created by li lei on 2023/7/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMorelikeTopicController : NoticeBaseListController
@property (nonatomic,copy) void (^topicBlock)(NoticeTopicModel *topic);
@property (nonatomic, assign) BOOL isSearch;
@end

NS_ASSUME_NONNULL_END
