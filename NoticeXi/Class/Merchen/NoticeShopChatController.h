//
//  NoticeShopChatController.h
//  NoticeXi
//
//  Created by li lei on 2022/7/13.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeByOfOrderModel.h"
#import "NoticeJuBaoShopChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopChatController : BaseTableViewController
@property (nonatomic, strong) NSString *mangagerCode;
@property (nonatomic, strong) NoticeByOfOrderModel *orderM;
@property (nonatomic, strong) NoticeJuBaoShopChatModel *jubaoM;
@end

NS_ASSUME_NONNULL_END
