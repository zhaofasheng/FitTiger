//
//  NoticeShopGetOrderTostView.h
//  NoticeXi
//
//  Created by li lei on 2022/7/12.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeByOfOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopGetOrderTostView : UIView

@property (nonatomic, strong) NoticeByOfOrderModel *orderModel;
@property (nonatomic, assign) BOOL noClick;
@property (nonatomic, assign) BOOL isAudioCalling;
@property (nonatomic, assign) BOOL hasShow;//已经弹出
@property (nonatomic, copy) void(^acceptBlock)(BOOL accept);
@property (nonatomic, copy) void(^endOpenBlock)(BOOL close);
- (void)showCallView;
- (void)dissMiseeShow;
@end

NS_ASSUME_NONNULL_END
