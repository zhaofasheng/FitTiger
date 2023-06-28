//
//  NoticeTestResultViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/1/25.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTestResultViewController : BaseTableViewController
@property (nonatomic, strong) NSString *personalityId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isAll;
@property (nonatomic, assign) BOOL isTongzu;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isFromStart;
@property (nonatomic, assign) BOOL isFromShake;//判断是否是从摇一摇进来的
@property (nonatomic, strong) NSString *personalityNo;
@end

NS_ASSUME_NONNULL_END
