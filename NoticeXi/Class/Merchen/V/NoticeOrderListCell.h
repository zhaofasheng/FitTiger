//
//  NoticeOrderListCell.h
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeOrderListCell : BaseCell
@property (nonatomic, strong) NoticeOrderListModel *orderM;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *shopNameL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UIImageView *userIconImageView;
@property (nonatomic, strong) UILabel *userNameL;
@property (nonatomic, strong) UILabel *payL;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, strong) UIButton *comButton;
@property (nonatomic, assign) BOOL isUser;//是否是买家
@property (nonatomic, strong) UIImageView *intoImageView;
@property (nonatomic, strong) UIView *backV;
@end

NS_ASSUME_NONNULL_END
