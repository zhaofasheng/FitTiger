//
//  NoticeSysNewsManagerController.h
//  NoticeXi
//
//  Created by li lei on 2021/5/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSysNewsManagerController : BaseTableViewController

@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, assign) BOOL isDs;//定时任务
@end

NS_ASSUME_NONNULL_END
