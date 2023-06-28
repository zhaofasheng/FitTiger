//
//  NoticeCacheManagerController.h
//  NoticeXi
//
//  Created by li lei on 2019/5/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCacheManagerController : BaseTableViewController
@property (nonatomic, assign) NSInteger popType;//返回类型，1根视图 2动动圈
@property (nonatomic, copy)  void (^upSuccess)(BOOL success);
@end

NS_ASSUME_NONNULL_END
