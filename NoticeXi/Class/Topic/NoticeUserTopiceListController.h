//
//  NoticeUserTopiceListController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/23.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserTopiceListController : BaseTableViewController
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) BOOL isOther;
@end

NS_ASSUME_NONNULL_END
