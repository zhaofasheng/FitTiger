//
//  NoticeSupplyNicknameController.h
//  NoticeXi
//
//  Created by li lei on 2022/7/4.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSupplyNicknameController : BaseTableViewController
@property (nonatomic, strong) NSString *idendFineNo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *payId;
@end

NS_ASSUME_NONNULL_END
