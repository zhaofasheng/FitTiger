//
//  NoticeChoiceJieyouChatCell.h
//  NoticeXi
//
//  Created by li lei on 2023/4/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoiceJieyouChatCell : BaseCell
@property (nonatomic, strong) NoticeGoodsModel *goodModel;
@property (nonatomic, assign) BOOL isUserLookShop;//是否是用户视角看店铺
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIImageView *changePriceBtn;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) void(^buyGoodsBlock)(NoticeGoodsModel *buyGood);
@end

NS_ASSUME_NONNULL_END
