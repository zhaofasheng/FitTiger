//
//  NoticeNoticenterModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNoticenterModel : NSObject
@property (nonatomic, strong) NSString *subscribe;//订阅广场是否显示书评
@property (nonatomic, strong) NSString *chat_remind;//悄悄话提醒开关，0=关闭提醒，1=开启提醒，默认开启
@property (nonatomic, strong) NSString *chat_pri_remind;//私聊提醒开关，0=关闭提醒，1=开启提醒，默认开启
@property (nonatomic, strong) NSString *newfriend_remind;//新好友请求通知提醒开关,0=关闭提醒，1=开启提醒，默认开启
@property (nonatomic, strong) NSString *sys_remind;//系统消息通知提醒开关，0=关闭提醒，1=开启提醒，默认开启
@property (nonatomic, strong) NSString *chat_with;//谁可以向我悄悄话，0=所有人，1=仅限好友,默认所有人
@property (nonatomic, strong) NSString *chat_pri_with;//谁可以和我私聊，0=所有人，1=仅限好友，默认所有人
@property (nonatomic, strong) NSString *strange_view;//陌生人浏览我的声昔和相册，0=禁止，1=默认7天
@property (nonatomic, strong) NSString *gps_switch;//距离功能，0=关闭，1=开启，默认关闭
@property (nonatomic, strong) NSString *assoc_chat_remind;//社团聊天消息提醒开关，0=关闭提醒，1=开启提醒，默认开启
@property (nonatomic, strong) NSString *assoc_remind;//社团通知提醒开关，0=关闭提醒，1=开启提醒，默认开启
@property (nonatomic, strong) NSString *other_remind;//新好友/共鸣/表白通知，0=关闭，1=开启
@property (nonatomic, strong) NSString *auto_reply;//是否开启自动回复
@property (nonatomic, strong) NSString *close_border;//是否处于闭关模式
@property (nonatomic, strong) NSString *shop_comment_remind;//解忧订单评价通知
@property (nonatomic, strong) NSString *music_push;
@property (nonatomic, strong) NSString *admirers_renew;
@property (nonatomic, strong) NSString *display_same_topic;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *chantWithName;
@property (nonatomic, strong) NSString *chantPriWithName;
@property (nonatomic, strong) NSString *lookWithName;
@property (nonatomic, strong) NSString *ditanceName;
@property (nonatomic, strong) NSString *bbs_remind;

@property (nonatomic, strong) NSString *address_book_switch;

@property (nonatomic, strong) NSString *bindIos;
@property (nonatomic, strong) NSString *bindWechat;
@property (nonatomic, strong) NSString *bindWeibo;
@property (nonatomic, strong) NSString *bindQQ;
@property (nonatomic, strong) NSString *chat_hobby;
@property (nonatomic, strong) NSString *list;
@property (nonatomic, strong) NSString *homepage;//在我和好友的首页是否显示,1：显示，0：隐藏
@property (nonatomic, strong) NSString *review;//谁可以浏览我影评列表，0：所有人，1：仅限好友
@property (nonatomic, strong) NSString *machine;//在心情簿-时光机是否显示，1：显示，0：隐藏
@property (nonatomic, strong) NSString *memory;//在心情簿-记忆是否显示，1：显示，0：隐藏
@property (nonatomic, strong) NSString *square;//在评电影广场是否显示，1：显示，0：隐藏
@property (nonatomic, strong) NSString *favorite_topic;//0 所有人可看，1仅限好友
@property (nonatomic, strong) NSString *hobby;//是否允许被找同好找到
@property (nonatomic, strong) NSString *entry;//是否云允许显示在词条页
@property (nonatomic, strong) NSString *is_friend;
@property (nonatomic, strong) NSArray *chat_tips;
@property (nonatomic, strong) NSString *join_sing_ranking;//是否加入唱歌排行榜
@property (nonatomic, strong) NSString *bucket_id;

@property (nonatomic, strong) NSString *looking_for;

@property (nonatomic, strong) NSString *be_from_share;
@property (nonatomic, strong) NSString *be_from_movie;
@property (nonatomic, strong) NSString *be_from_book;
@property (nonatomic, strong) NSString *be_from_song;

@property (nonatomic, strong) NSString *minimachine_visibility;
@property (nonatomic, strong) NSString *movie_voice_visibility;
@property (nonatomic, strong) NSString *book_voice_visibility;
@property (nonatomic, strong) NSString *song_voice_visibility;
@property (nonatomic, strong) NSString *share_voice_visibility;
@property (nonatomic, strong) NSString *achievement_visibility;
@property (nonatomic, strong) NSString *voice_collection_visibility;
@property (nonatomic, strong) NSString *dubbing_visibility;
@property (nonatomic, strong) NSString *artwork_visibility;//1:所有人可见，2:仅限好友，默认所有人可见,3:仅自己可见，默认：1
@end

NS_ASSUME_NONNULL_END
