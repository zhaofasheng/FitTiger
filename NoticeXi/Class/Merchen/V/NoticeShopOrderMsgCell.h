//
//  NoticeShopOrderMsgCell.h
//  NoticeXi
//
//  Created by li lei on 2023/4/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeShopCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopOrderMsgCell : BaseCell

@property (nonatomic, strong) NoticeShopCommentModel *model;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *marksL;
@end

NS_ASSUME_NONNULL_END
