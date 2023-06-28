//
//  NoticeAbout.h
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeAbout : NSObject
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *frequency_no;
@property (nonatomic, strong) NSString *friend_num;
@property (nonatomic, strong) NSString *html_id;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *voice_total_len;
@property (nonatomic, strong) NSString *voice_total_lens;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *oring;
@property (nonatomic, strong) NSString *released_at;
@property (nonatomic, strong) NSDictionary *whitelist;
@property (nonatomic, strong) NSString *actionString;
@property (nonatomic, assign) BOOL needColor;
@property (nonatomic, strong) NSString *actionType;
@property (nonatomic, strong) NSString *achievement_visibility;
@property (nonatomic, strong) NSString *friend_status;//获取用户关系，0：陌生人，1：待验证，2：已是好友，3：被对方拉黑，4：自己拉黑对方，5：自己
@property (nonatomic, strong) NSString *strange_view;//friend_status=0时返回，陌生人浏览我的声兮和相册，-1:全部,0=禁止，7=默认7天
@property (nonatomic, assign) BOOL mLimit;
@property (nonatomic, assign) BOOL bLimit;
@property (nonatomic, assign) BOOL sLimit;
@property (nonatomic, strong) NSString *cover_brightness;//封面图亮度，1:稍微调低，2:原图亮度
@property (nonatomic, strong) NSString *cover_efficacy;//封面气氛,0:无，1:雨，2:雪，3:叶，4:花，5:枫
@property (nonatomic, strong) NSString *minimachine_visibility;//迷你时光机可见性可见性，1：仅自己和好友可见，2:他人可见
@property (nonatomic, strong) NSString *setting_name;
@property (nonatomic, strong) NSString *setting_value;
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *about_artwork;//灵魂画手相关通知，涂鸦和点赞，1:开，2:关，默认开
@property (nonatomic, strong) NSString *resource_subscription;//书影音订阅通知，1:开，2：关，默认开
@property (nonatomic, strong) NSString *about_clock_vote;//闹钟相关投票，台词和配音点赞，1:开，2:关，默认开

@property (nonatomic, strong) NSString *check_code;//二次登录校验码
@property (nonatomic, strong) NSString *code_status;//二次登录校验码状态

@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *comeDays;

@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *num;

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *img;

@property (nonatomic, strong) NSString *voiceText;

@property (nonatomic, strong) NSString *mass_nick_name;
@property (nonatomic, strong) NSString *level;
@end

NS_ASSUME_NONNULL_END
