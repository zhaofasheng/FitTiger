//
//  NoticeDrawDateViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/7/8.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDrawDateViewController : BaseTableViewController
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) BOOL isTuYa;
@property (nonatomic, assign) BOOL isFromMessage;
@property (nonatomic, strong) NSString *artId;
@property (nonatomic, strong) NSString *graffiti_id;
@property (nonatomic, assign) BOOL isBackReplay;
@end

NS_ASSUME_NONNULL_END
