//
//  NoticeChatTextCell.h
//  NoticeXi
//
//  Created by li lei on 2023/4/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChatTextCell : BaseCell
@property (nonatomic, strong) NoticeGoodsModel *goodModel;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *markL;
@end

NS_ASSUME_NONNULL_END
