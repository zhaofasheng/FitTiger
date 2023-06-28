//
//  NoticeZJDetailController.h
//  NoticeXi
//
//  Created by li lei on 2019/8/14.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeZJDetailController : BaseTableViewController
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic,copy) void (^deleteSuccessBlock)(NSString *albumId);
@property (nonatomic,copy) void (^editSuccessBlock)(NoticeZjModel *zjmodel);

@end

NS_ASSUME_NONNULL_END
