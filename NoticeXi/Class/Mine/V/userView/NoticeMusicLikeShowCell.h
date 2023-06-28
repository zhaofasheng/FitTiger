//
//  NoticeMusicLikeShowCell.h
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMusicLikeModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMusicLikeShowCell : BaseCell

@property (nonatomic, strong) NoticeMusicLikeModel *likeModel;
@property (nonatomic, strong) CBAutoScrollLabel *songNameL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeNumL;
@property (nonatomic, strong) UILabel *unreadNumL;
@property (nonatomic, copy) void(^gotoLikeTapBlock)(NoticeMusicLikeModel *model);
@property (nonatomic, strong) UIImageView *playMarkImageView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
