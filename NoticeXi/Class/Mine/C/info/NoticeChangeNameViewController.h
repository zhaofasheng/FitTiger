//
//  NoticeChangeNameViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeNameViewController : NoticeBaseListController
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, assign) BOOL isBeizhu;
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, assign) BOOL changeGroup;
@property (nonatomic, strong) NSString *trueName;
@property (nonatomic,copy) void (^nameBlock)(NSString *markName);
@end

NS_ASSUME_NONNULL_END
