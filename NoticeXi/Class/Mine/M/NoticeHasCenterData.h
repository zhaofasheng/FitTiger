//
//  NoticeHasCenterData.h
//  NoticeXi
//
//  Created by li lei on 2020/4/24.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeHasCenterData : NSObject
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *typeId;

@property (nonatomic, assign) BOOL hasVoice;
@property (nonatomic, assign) BOOL hasPhoto;
@property (nonatomic, assign) BOOL hasTime;
@property (nonatomic, assign) BOOL hasMovie;
@property (nonatomic, assign) BOOL hasBook;
@property (nonatomic, assign) BOOL hasSong;
@property (nonatomic, assign) BOOL hasPy;
@property (nonatomic, assign) BOOL hasDraw;

@property (nonatomic, strong) NSString *artwork_num;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *comeHereTime;
@property (nonatomic, strong) NSString *dubbing_num;
@property (nonatomic, strong) NSString *frequency_no;
@property (nonatomic, strong) NSString *friend_num;
@property (nonatomic, strong) NSString *last_login_device;
@property (nonatomic, strong) NSString *line_num;
@property (nonatomic, strong) NSString *personality_no;
@property (nonatomic, strong) NSString *voice_book_num;
@property (nonatomic, strong) NSString *voice_movie_num;
@property (nonatomic, strong) NSString *voice_num;
@property (nonatomic, strong) NSString *voice_song_num;
@property (nonatomic, strong) NSString *voice_three_days_share;
@property (nonatomic, strong) NSString *voice_total_len;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *app_version;
@end

NS_ASSUME_NONNULL_END
