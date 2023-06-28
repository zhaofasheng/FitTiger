//
//  NoticeClockMyClockController.h
//  NoticeXi
//
//  Created by li lei on 2019/10/16.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockMyClockController : BaseTableViewController
@property (nonatomic,copy) void (^setHotBlock)(BOOL goHot);
@property (nonatomic,copy) void (^setTcBlock)(BOOL goTc);
@property (nonatomic, assign) NSInteger tcTagType;
@end

NS_ASSUME_NONNULL_END
