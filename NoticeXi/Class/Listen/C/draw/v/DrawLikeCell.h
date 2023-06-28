//
//  DrawLikeCell.h
//  NoticeXi
//
//  Created by li lei on 2019/7/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "DrawLikeModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface DrawLikeCell : BaseCell
@property (nonatomic, strong) DrawLikeModel *likeModel;

@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *markImage;
@end

NS_ASSUME_NONNULL_END
