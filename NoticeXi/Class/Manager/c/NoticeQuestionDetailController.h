//
//  NoticeQuestionDetailController.h
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeUserQuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeQuestionDetailController : BaseTableViewController
@property (nonatomic, strong) NoticeUserQuestionModel *questionM;
@property (nonatomic, strong) NSString *managerCode;
@end

NS_ASSUME_NONNULL_END
