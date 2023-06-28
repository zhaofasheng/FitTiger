//
//  NoticeChatVoiceShopCell.h
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChatVoiceShopCell : BaseCell
@property (nonatomic, strong) NoticeGoodsModel *goodModel;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) FSCustomButton *changePriceBtn;
@property (nonatomic, copy) void(^changePriceBlock)(NSString *price);
@end

NS_ASSUME_NONNULL_END
