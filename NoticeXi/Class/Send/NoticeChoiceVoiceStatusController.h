//
//  NoticeChoiceVoiceStatusController.h
//  NoticeXi
//
//  Created by li lei on 2022/1/12.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoiceVoiceStatusController : BaseTableViewController
@property (nonatomic, copy) void (^typeBlock)(NSInteger type);
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
