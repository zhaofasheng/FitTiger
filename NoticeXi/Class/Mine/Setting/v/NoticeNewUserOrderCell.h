//
//  NoticeNewUserOrderCell.h
//  NoticeXi
//
//  Created by li lei on 2021/8/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeNewUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewUserOrderCell : BaseCell
@property (nonatomic, strong) NoticeNewUserModel *orderM;

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *redView;

@end

NS_ASSUME_NONNULL_END
