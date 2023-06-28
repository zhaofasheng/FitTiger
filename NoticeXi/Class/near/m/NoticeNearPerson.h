//
//  NoticeNearPerson.h
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNearPerson : NSObject
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *blackId;
@property (nonatomic, strong) NSString *distance;//单位是米
@property (nonatomic, strong) NSString *login_at;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *self_intro;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *wave_len;
@property (nonatomic, strong) NSString *wave_url;
@property (nonatomic, strong) NSString *identity_type;
@property (nonatomic, strong) NSString *released_at;
@property (nonatomic, strong) NSString *released_atTime;
@property (nonatomic, strong) NSString *voice_total_len;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isselect;
@property (nonatomic, assign) BOOL hasSend;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, assign) NSInteger whiteType;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NoticeUserInfoModel *userInfo;
@property (nonatomic, strong) NSArray *user_tag;
@end

NS_ASSUME_NONNULL_END
