//
//  NoticeBoKeManagerController.h
//  NoticeXi
//
//  Created by li lei on 2022/9/29.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBoKeManagerController : BaseTableViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *managerCode;
@end

NS_ASSUME_NONNULL_END
