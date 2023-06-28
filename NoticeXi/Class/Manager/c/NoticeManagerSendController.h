//
//  NoticeManagerSendController.h
//  NoticeXi
//
//  Created by li lei on 2021/5/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerSendController : BaseTableViewController
@property (nonatomic, assign) NSInteger type;//1 图书，2播客,3话题，4活动，5声昔君说，6反馈，7版本更新
@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NoticeMessage *messageM;
@end

NS_ASSUME_NONNULL_END
