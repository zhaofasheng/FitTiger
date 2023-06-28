//
//  NoticeDiaDetailController.h
//  NoticeXi
//
//  Created by li lei on 2021/4/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDiaDetailController : BaseTableViewController
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic,copy) void (^deleteSuccessBlock)(NSString *albumId);
@property (nonatomic,copy) void (^editSuccessBlock)(NoticeZjModel *zjmodel);
@end

NS_ASSUME_NONNULL_END
