//
//  NoticeJieYouGoodsComController.h
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeJieYouGoodsComController : UIViewController<NoticeAssestDelegate,JXPagerViewListViewDelegate>
@property (nonatomic, assign) BOOL isUserLookShop;//是否是用户视角看店铺
@property (nonatomic, strong) NSString *shopId;
- (void)refresh;
@end

NS_ASSUME_NONNULL_END
