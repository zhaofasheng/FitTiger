//
//  NoticeMyOwnMusicListController.h
//  NoticeXi
//
//  Created by li lei on 2021/8/31.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeMusicLikeModel.h"
#import "NoticeCustumMusiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyOwnMusicListController : NoticeBaseListController
@property (nonatomic, strong) NSString *userId;
@property (nonatomic,copy) void (^addMusicBlock)(BOOL add);
@property (nonatomic, strong) NoticeMusicLikeModel * __nullable playModel;
@property (nonatomic, assign) BOOL noStopPlay;
@property (nonatomic,copy) void (^playBlock)(NoticeCustumMusiceModel *playCurrentModel);
@end

NS_ASSUME_NONNULL_END
