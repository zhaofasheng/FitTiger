//
//  NoticeHeJiListController.h
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeVoiceReadModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHeJiListController : BaseTableViewController
@property (nonatomic, strong) NoticeVoiceReadModel *readModel;
@property (nonatomic, copy) void(^readingBlock)(NoticeVoiceReadModel *readM,BOOL isHejiBack);
@end

NS_ASSUME_NONNULL_END
