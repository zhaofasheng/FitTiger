//
//  NoticeQiaoqiaoController.h
//  NoticeXi
//
//  Created by li lei on 2023/3/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeQiaoqiaoController : BaseTableViewController
@property (nonatomic, copy) void(^clearUnreadBlock)(BOOL clear);
@end

NS_ASSUME_NONNULL_END
