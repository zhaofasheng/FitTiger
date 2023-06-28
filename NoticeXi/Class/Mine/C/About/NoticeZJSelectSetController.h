//
//  NoticeZJSelectSetController.h
//  NoticeXi
//
//  Created by li lei on 2019/8/12.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeZJSelectSetController : BaseTableViewController
@property (nonatomic,copy) void (^selectBlock)(NSString *select);
@property (nonatomic, strong) NSString *selectName;
@end

NS_ASSUME_NONNULL_END
