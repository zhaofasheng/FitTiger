//
//  NoticeOrderListController.h
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeOrderListController : BaseTableViewController
@property (nonatomic, assign) BOOL isFinished;//已完成 店主
@property (nonatomic, strong) NSString *userType;//1=商家 2用户
@property (nonatomic, strong) NSString *type;//买家买过的类型 userType= 1 (1=完成，2=失效) userType= 2(1=已完成，2=待评价，3=已评价)
@end

NS_ASSUME_NONNULL_END
