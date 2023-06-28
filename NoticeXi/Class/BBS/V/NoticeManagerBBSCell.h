//
//  NoticeManagerBBSCell.h
//  NoticeXi
//
//  Created by li lei on 2020/11/12.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeContributionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerBBSCell : BaseCell
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) NoticeContributionModel *contriM;
@end

NS_ASSUME_NONNULL_END
