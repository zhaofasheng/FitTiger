//
//  NoticeAllTieTieController.h
//  NoticeXi
//
//  Created by li lei on 2022/10/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LXCalendarMonthModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAllTieTieController : BaseTableViewController
@property (nonatomic, copy) void(^choiceMongthBlock)(LXCalendarMonthModel *month,NSDate *date);
@end

NS_ASSUME_NONNULL_END
