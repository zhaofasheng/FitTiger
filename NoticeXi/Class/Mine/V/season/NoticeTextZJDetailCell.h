//
//  NoticeTextZJDetailCell.h
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextZJDetailCell : BaseCell
@property (nonatomic, strong) NoticeVoiceListModel *vocieM;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *lockImageV;
@end

NS_ASSUME_NONNULL_END
