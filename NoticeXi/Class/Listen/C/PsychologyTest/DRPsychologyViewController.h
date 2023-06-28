//
//  DRPsychologyViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/1/21.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPsychologyViewController : BaseTableViewController
@property (nonatomic, assign) BOOL isFromOpen;
@property (nonatomic, assign) BOOL isFromStart;
@property (nonatomic, assign) BOOL isFromShake;//判断是否是从摇一摇进来的
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) BOOL isFromMain;
@property (nonatomic, assign) BOOL isReg;
@end

NS_ASSUME_NONNULL_END
