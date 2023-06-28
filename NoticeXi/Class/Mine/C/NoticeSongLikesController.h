//
//  NoticeSongLikesController.h
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeMusicLikeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSongLikesController : NoticeBaseListController

@property (nonatomic, strong) NoticeMusicLikeModel *musicModel;

@end

NS_ASSUME_NONNULL_END
