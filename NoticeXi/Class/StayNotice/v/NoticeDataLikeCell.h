//
//  NoticeDataLikeCell.h
//  NoticeXi
//
//  Created by li lei on 2023/3/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDataLikeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDataLikeCell : BaseCell
@property (nonatomic, strong) NoticeDataLikeModel *likeModel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *infoL;

@property (nonatomic, strong) UIImageView *voiceImageView;
@property (nonatomic, strong) UILabel *tcL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *lineContentLabel;

@property (nonatomic, strong) UIImageView *helpImageView;
@end

NS_ASSUME_NONNULL_END
