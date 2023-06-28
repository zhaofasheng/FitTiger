//
//  NoticeNewTestResultController.h
//  NoticeXi
//
//  Created by li lei on 2021/5/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewTestResultController : BaseTableViewController
@property (nonatomic, assign) NSInteger testType;//1自己没做，2对方没做
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@end

NS_ASSUME_NONNULL_END
