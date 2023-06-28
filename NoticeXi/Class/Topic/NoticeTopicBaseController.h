//
//  NoticeTopicBaseController.h
//  NoticeXi
//
//  Created by li lei on 2021/6/16.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTopicBaseController : WMPageController
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *topicName;
@end

NS_ASSUME_NONNULL_END
