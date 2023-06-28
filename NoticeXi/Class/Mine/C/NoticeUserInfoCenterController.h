//
//  NoticeUserInfoCenterController.h
//  NoticeXi
//
//  Created by li lei on 2021/4/25.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserInfoCenterController : BaseTableViewController
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic,copy) void (^careClickBlock)(NSString *careId,NSString *userId);
@property (nonatomic, assign) BOOL isLead;//新手指南
@end

NS_ASSUME_NONNULL_END
