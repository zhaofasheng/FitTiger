//
//  NoticeMusicLikeModel.h
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMusicLikeModel : NSObject
@property (nonatomic, strong) NSString *musicNum;
@property (nonatomic, strong) NSString *likeNum;
@property (nonatomic, strong) NSString *likeId;//在喜好历史和喜好列表里面是用户id
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) NSString *song_author;
@property (nonatomic, strong) NSString *song_id;
@property (nonatomic, strong) NSString *song_tile;
@property (nonatomic, strong) NSString *song_url;
@property (nonatomic, strong) NSString *readNum;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *levelImgIconName;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *level;

@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
