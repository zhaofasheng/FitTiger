//
//  NoticeOrderDetailController.h
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeOrderDetailController : BaseTableViewController
@property (nonatomic, strong) NoticeOrderListModel *orderM;
@end

NS_ASSUME_NONNULL_END
