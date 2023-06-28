//
//  NoticeClockPyController.h
//  NoticeXi
//
//  Created by li lei on 2019/10/16.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockPyController : BaseTableViewController

@property (nonatomic, assign) NSInteger tcTagType;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic,copy) void (^setNowBlock)(BOOL goNow);
@property (nonatomic, assign) BOOL isMain;
@property (nonatomic, assign) BOOL isMyDown;
@property (nonatomic, assign) BOOL needBackGround;
@end

NS_ASSUME_NONNULL_END
