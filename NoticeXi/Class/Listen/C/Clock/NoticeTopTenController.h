//
//  NoticeTopTenController.h
//  NoticeXi
//
//  Created by li lei on 2019/11/11.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTopTenController : BaseTableViewController
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *voteType;
@property (nonatomic, assign) BOOL isPicker;
@property (nonatomic, strong) NSString *pyId;//配音id，存在配音id的时候，就不是排名
@property (nonatomic, strong) NSDictionary *pyDic;
@property (nonatomic, strong) NSString *mangagerCode;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, assign) NSInteger topType;//类型
@property (nonatomic, strong) NoticeClockPyModel *currentModel;

@end

NS_ASSUME_NONNULL_END
