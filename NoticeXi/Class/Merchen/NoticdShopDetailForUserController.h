//
//  NoticdShopDetailForUserController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/11.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeMyShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticdShopDetailForUserController : NoticeBaseListController

@property (nonatomic, strong) NoticeMyShopModel *shopModel;

@end

NS_ASSUME_NONNULL_END
