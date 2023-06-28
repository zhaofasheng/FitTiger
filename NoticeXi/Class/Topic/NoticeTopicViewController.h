//
//  NoticeTopicViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/30.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTopicViewController : NoticeBaseListController
@property (nonatomic,copy) void (^topicBlock)(NoticeTopicModel *topic);
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, assign) BOOL isSet;
@property (nonatomic, assign) BOOL isDraw;
@property (nonatomic, assign) BOOL isJustTopic;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSMutableArray *hotArr;
@end

NS_ASSUME_NONNULL_END
