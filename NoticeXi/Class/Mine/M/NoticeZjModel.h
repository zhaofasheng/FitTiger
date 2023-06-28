//
//  NoticeZjModel.h
//  NoticeXi
//
//  Created by li lei on 2019/8/13.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeZjModel : NSObject

@property (nonatomic, strong) NSString *defaultName;
@property (nonatomic, strong) NSString *defaultImage;
@property (nonatomic, strong) NSString *dialog_num;
@property (nonatomic, strong) NSString *album_cover_url;
@property (nonatomic, strong) NSString *album_name;
@property (nonatomic, strong) NSString *album_sort;
@property (nonatomic, strong) NSString *album_type;
@property (nonatomic, strong) NSString *addType;//这个是添加专辑时候的类型
@property (nonatomic, strong) NSString *addName;//这个是添加专辑时候的类型
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *played_num;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *voice_total_len;
@property (nonatomic, strong) NSString *voice_total_len_o;//好友可见心情总时长
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *voice_num;
@property (nonatomic, strong) NSString *voice_total_lens;
@property (nonatomic, strong) NSString *voice_total_mins;
@property (nonatomic, strong) NSString *textNum;
@property (nonatomic, strong) NSString *ended_at;
@property (nonatomic, strong) NSString *created_atTime;
@property (nonatomic, strong) NSString *started_at;
@property (nonatomic, strong) NSString *latest_at;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *last_join_time;
@property (nonatomic, strong) NSString *last_join_timeName;
@end

NS_ASSUME_NONNULL_END
