//
//  NoticeShopForLabelcomCell.h
//  NoticeXi
//
//  Created by li lei on 2023/4/17.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeComLabelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopForLabelcomCell : BaseCell
@property (nonatomic, strong) NoticeComLabelModel *model;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIView *backV;
@end

NS_ASSUME_NONNULL_END
