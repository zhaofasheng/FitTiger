//
//  NoticeUserInfoModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserInfoModel : NSObject
@property (nonatomic, strong) NSString *is_myadmire;
@property (nonatomic, strong) NSString *admire_time;//互相欣赏时间
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *nick_name_true;
@property (nonatomic, strong) NSString *access_expire;//通信Token用于数据操作的过期时间
@property (nonatomic, strong) NSString *refresh_expire;//通信Token用于刷新自己的过期时间
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *piPeiId;
@property (nonatomic, strong) NSString *identity_type;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *voice_cover_photo_url;
@property (nonatomic, strong) NSString *in_whitelist;//是否在白名单里面
@property (nonatomic, strong) NSString *cover_photo_url;
@property (nonatomic, strong) NSString *main_cover_photo_url;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isMoreFiveMin;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, strong) NSString *personality_test;

@property (nonatomic, strong) NSString *socket_id;
@property (nonatomic, strong) NSString *socket_token;
@property (nonatomic, strong) NSString *level;//等级
@property (nonatomic, strong) NSString *levelName;//等级
@property (nonatomic, strong) NSString *levelImgName;//等级图片
@property (nonatomic, strong) NSString *levelImgIconName;//等级头像
@property (nonatomic, strong) NSString *points;//发电值
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *sgjTime;//时光机记录
@property (nonatomic, strong) NSString *createYear;//注册时间的年月
@property (nonatomic, strong) NSString *createMonth;//注册时间的年月
@property (nonatomic, strong) NSString *country_code;//国家/地区简称
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *avatar_url;//头像地址
@property (nonatomic, strong) NSString *frequency_no;//声频
@property (nonatomic, strong) NSString *self_intro;//用户简介
@property (nonatomic, strong) NSString *wave_len;//声波长度
@property (nonatomic, strong) NSString *voice_num;//有效声昔数量
@property (nonatomic, strong) NSString *friend_num;//朋友数量
@property (nonatomic, strong) NSString *enjoy_num;//enjoy_num(欣赏人数)、  be_enjoy_num(粉丝人数[被欣赏人数])
@property (nonatomic, strong) NSString *be_enjoy_num;//enjoy_num(欣赏人数)、  be_enjoy_num(粉丝人数[被欣赏人数])
@property (nonatomic, strong) NSString *wave_url;//声波地址
@property (nonatomic, strong) NSString *bg_photo_url;//背景图片地址
@property (nonatomic, strong) NSString *relation_status;//用户关系状态，0=不是室友且没拉黑，1=是室友，2=已拉黑，仅当获取不是自己的信息的时候才返回
@property (nonatomic, strong) NSString *personality_no;
@property (nonatomic, assign) BOOL isNounE;
@property (nonatomic, strong) NSString *interfaceType;
@property (nonatomic, strong) NSString *interface_type;
@property (nonatomic, strong) NSString *interface_type_setted;
@property (nonatomic, strong) NSString *voice_total_len;
@property (nonatomic, strong) NSString *allVoiceTime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *flag;//是否是仙人掌用户
@property (nonatomic, strong) NSString *released_at;//解封时间
@property (nonatomic, assign) BOOL isClose;//是否封禁状态
@property (nonatomic, strong) NSString *userStatus;
@property (nonatomic, strong) NSString *need_login_check;//是否需要二次验证

@property (nonatomic, strong) NSString *exists;
@property (nonatomic, strong) NSString *forbidden;//是否被禁用，1：是，0:否
@property (nonatomic, strong) NSString *comeHereDays;//来的时间
@property (nonatomic, strong) NSString *authType;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *thirdnickname;
@property (nonatomic, strong) NSString *regTime;//注册时间

@property (nonatomic, strong) NSString *regTimeForMid;//注册时间的十五号
@property (nonatomic, strong) NSString *assoc_id;
@property (nonatomic, strong) NSString *change_type;

@property (nonatomic, strong) NSString *renew_remind;//欣赏的人的内容更新通知开关
@property (nonatomic, strong) NSString *spec_bg_skin_url;
@property (nonatomic, strong) NSString *spec_bg_type;//默认的背景类型
@property (nonatomic, strong) NSString *spec_bg_default_photo;//默认背景图
@property (nonatomic, strong) NSString *spec_bg_photo_url;
@property (nonatomic, strong) NSString *spec_bg_svg_url;
@property (nonatomic, strong) NSString *music_like;//是否点赞过歌曲

@property (nonatomic, strong) NSString *voiceNum;//心情数量
@property (nonatomic, strong) NSString *podcastNum;//播客数量
@property (nonatomic, strong) NSString *invitationNum;//求助帖数量
@property (nonatomic, strong) NSString *albumNum;//专辑数量
@end

NS_ASSUME_NONNULL_END
