//
//  NoticeGoToComShopController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeGoToComShopController : NoticeBaseListController
@property (nonatomic, strong) NoticeByOfOrderModel *resultModel;
@property (nonatomic, strong) NoticeOrderListModel *orderM;
@property (nonatomic, copy) void(^hasComBlock)(NSString *orderId);
@end

NS_ASSUME_NONNULL_END
