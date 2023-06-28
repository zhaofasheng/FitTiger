//
//  NoticeJieYouGoodsController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeJieYouGoodsController : UIViewController<NoticeAssestDelegate,JXPagerViewListViewDelegate>
@property (nonatomic, strong) NoticeMyShopModel *goodsModel;
@property (nonatomic, strong) NoticeMyShopModel *shopDetailModel;
@property (nonatomic, strong) NSMutableArray *goodssellArr;
@property (nonatomic, copy) void(^refreshGoodsBlock)(NSMutableArray *goodsArr);
@property (nonatomic, copy) void(^buyGoodsBlock)(NoticeGoodsModel *buyGood);
@property (nonatomic, assign) BOOL isUserLookShop;//是否是用户视角看店铺
@end

NS_ASSUME_NONNULL_END
