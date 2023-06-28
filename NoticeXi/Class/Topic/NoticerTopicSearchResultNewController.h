//
//  NoticerTopicSearchResultNewController.h
//  NoticeXi
//
//  Created by li lei on 2020/3/31.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticerTopicSearchResultNewController : NoticeBaseListController
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, assign) BOOL fromSearch;
@property (nonatomic, assign) BOOL isTextVoice;
@end

NS_ASSUME_NONNULL_END
