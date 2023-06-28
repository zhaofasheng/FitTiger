//
//  NoticeTcTopBdController.h
//  NoticeXi
//
//  Created by li lei on 2020/4/22.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTcTopBdController : BaseTableViewController
@property (nonatomic, strong) NSString *voteType;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NoticeClockPyModel *currentModel;
@property (nonatomic, assign) BOOL isBest;
@property (nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
