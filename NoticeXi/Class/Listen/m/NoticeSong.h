//
//  NoticeSong.h
//  NoticeXi
//
//  Created by li lei on 2019/4/18.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSong : NSObject
@property (nonatomic, strong) NSString *album_cover;//专辑封面地址
@property (nonatomic, strong) NSString *album_genre;//歌曲流派
@property (nonatomic, strong) NSString *album_name;//专辑名称
@property (nonatomic, strong) NSString *album_singer;//专辑演唱者
@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *published_date;
@property (nonatomic, strong) NSString *song_name;//歌曲名称
@property (nonatomic, strong) NSString *song_id;
@property (nonatomic, strong) NSString *song_singer;//歌曲名称
@property (nonatomic, strong) NSString *song_cover;//歌曲名称
@property (nonatomic, strong) NSString *song_genre;//歌曲名称
@property (nonatomic, strong) NSString *rate_id;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSDictionary *subscription;
@property (nonatomic, strong) NSString * __nullable subscription_type;
@property (nonatomic, strong) NSString * __nullable subscription_id;//订阅ID
@property (nonatomic, strong) NSString * _Nullable voice_num;
@property (nonatomic, strong) NSDictionary *__nullable resource;
@property (nonatomic, strong) NSDictionary *first_voice;
@property (nonatomic, strong) NoticeVoiceModel *voiceM;
@property (nonatomic, strong) NSString *resouce_num;
@end

NS_ASSUME_NONNULL_END
