//
//  NoticeJuBaoShopChatCell.h
//  NoticeXi
//
//  Created by li lei on 2022/7/20.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeJuBaoShopChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeJuBaoShopChatCell : BaseCell
@property (nonatomic, strong) NoticeJuBaoShopChatModel *jubaoModel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *staltusL;
@property (nonatomic, strong) UILabel *staltusL1;
@end

NS_ASSUME_NONNULL_END
