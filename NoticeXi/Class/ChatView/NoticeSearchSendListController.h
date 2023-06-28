//
//  NoticeSearchSendListController.h
//  NoticeXi
//
//  Created by li lei on 2022/5/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSearchSendListController : BaseTableViewController
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, strong) NoticeClockPyModel *pyModel;
@property (nonatomic, strong) NoticeClockPyModel *tcModel;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@end

NS_ASSUME_NONNULL_END
