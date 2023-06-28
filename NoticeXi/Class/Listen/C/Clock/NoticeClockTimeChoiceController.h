//
//  NoticeClockTimeChoiceController.h
//  NoticeXi
//
//  Created by li lei on 2019/10/24.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockTimeChoiceController : BaseTableViewController
@property (nonatomic,copy) void (^setTimeBlock)(NoticeColockSetModel *timeModel);
@property (nonatomic, strong) NoticeColockSetModel *setModel;
@end

NS_ASSUME_NONNULL_END
