//
//  NoticeCheckCenterTypeController.h
//  NoticeXi
//
//  Created by li lei on 2020/6/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticeManagerJuBaoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCheckCenterTypeController : BaseTableViewController
@property (nonatomic, strong) NSString *mangagerCode;
@property (nonatomic, strong) NoticeManagerJuBaoModel *juModel;
@end

NS_ASSUME_NONNULL_END
