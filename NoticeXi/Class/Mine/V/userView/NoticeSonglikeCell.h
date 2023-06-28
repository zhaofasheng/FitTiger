//
//  NoticeSonglikeCell.h
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMusicLikeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSonglikeCell : BaseCell

@property (nonatomic, strong) NoticeMusicLikeModel *likeModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, assign) BOOL isHistory;
@property (nonatomic, strong) UILabel *markL;
@end

NS_ASSUME_NONNULL_END
