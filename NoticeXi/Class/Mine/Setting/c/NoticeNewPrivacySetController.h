//
//  NoticeNewPrivacySetController.h
//  NoticeXi
//
//  Created by li lei on 2019/12/27.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewPrivacySetController : BaseTableViewController
@property (nonatomic, assign) NSInteger type;//0 迷你时光机 1信息流
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSArray *titArr;
@property (nonatomic, strong) NSString *setName;
@property (nonatomic,copy) void (^openBlock)(BOOL open);
@end

NS_ASSUME_NONNULL_END
