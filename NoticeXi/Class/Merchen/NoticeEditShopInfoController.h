//
//  NoticeEditShopInfoController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEditShopInfoController : NoticeBaseListController
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);
@property (nonatomic, strong) NoticeMyShopModel *myShopModel;
@end

NS_ASSUME_NONNULL_END
