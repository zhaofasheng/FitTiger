//
//  NoticeOtherHeaderViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeOtherHeaderViewController : BaseTableViewController
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NoticeUserInfoModel *userInfo;
@property (nonatomic,copy) void (^refreshBlock)(BOOL refresh);

@end

NS_ASSUME_NONNULL_END
