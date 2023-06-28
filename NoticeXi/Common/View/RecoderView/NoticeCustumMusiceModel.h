//
//  NoticeCustumMusiceModel.h
//  NoticeXi
//
//  Created by li lei on 2021/8/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCustumMusiceModel : NSObject
@property (nonatomic, strong) NSString *songUrl;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *song_author;
@property (nonatomic, strong) NSString *song_id;
@property (nonatomic, strong) NSString *song_poster;
@property (nonatomic, strong) NSString *song_url;
@property (nonatomic, strong) NSString *song_tile;
@property (nonatomic, strong) NSString *songId;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString *is_only;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, assign) NSInteger status;//1 播放中 2暂停 0停止
@property (nonatomic, strong) NSString *is_like;
@end

NS_ASSUME_NONNULL_END
