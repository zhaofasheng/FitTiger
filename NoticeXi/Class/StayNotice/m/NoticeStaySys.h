//
//  NoticeStaySys.h
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeStayMesssage.h"
#import "NoticeChats.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeStaySys : NSObject
@property (nonatomic, strong) NSDictionary *assooc;
@property (nonatomic, strong) NSDictionary *assoc;
@property (nonatomic, strong) NoticeStayMesssage *assoocM;

@property (nonatomic, strong) NSDictionary *sys;
@property (nonatomic, strong) NoticeStayMesssage *sysM;

@property (nonatomic, strong) NSDictionary *bbs;
@property (nonatomic, strong) NoticeStayMesssage *bbsM;

@property (nonatomic, strong) NSDictionary *book;
@property (nonatomic, strong) NoticeStayMesssage *bookM;

@property (nonatomic, strong) NSDictionary *friend_notice;
@property (nonatomic, strong) NoticeStayMesssage *frequestM;

@property (nonatomic, strong) NSDictionary *other;
@property (nonatomic, strong) NoticeStayMesssage *otherM;

@property (nonatomic, strong) NSString *resource_user_id;
@property (nonatomic, strong) NSString *total;

@property (nonatomic, strong) NSDictionary *chatpri;
@property (nonatomic, strong) NoticeStayMesssage *chatpriM;

@property (nonatomic, strong) NSDictionary *voice_comment;
@property (nonatomic, strong) NoticeStayMesssage *comModel;//心情评论消息

@property (nonatomic, strong) NSDictionary *famous_quotes_card;
@property (nonatomic, strong) NoticeStayMesssage *cardM;

@property (nonatomic, strong) NSDictionary *chat_common;
@property (nonatomic, strong) NoticeStayMesssage *qiaoqiaoModel;

@property (nonatomic, strong) NSDictionary *like;
@property (nonatomic, strong) NoticeStayMesssage *likeModel;//点赞贴贴类消息


@property (nonatomic, strong) NSDictionary *other_comment;
@property (nonatomic, strong) NoticeStayMesssage *other_commentModel;//留言消息(除心情评论外)


@property (nonatomic, strong) NSDictionary *voice_whisper;
@property (nonatomic, strong) NoticeStayMesssage *voice_whisperModel;//悄悄话消息

@property (nonatomic, strong) NSDictionary *char_pri;
@property (nonatomic, strong) NoticeStayMesssage *char_priM;//私聊消息

//悄悄话列表模块
@property (nonatomic, strong) NSString *smalllevelImgName;
@property (nonatomic, strong) NSString *levelImgName;
@property (nonatomic, strong) NSString *levelImgIconName;
@property (nonatomic, strong) NSString *levelName;

@property (nonatomic, strong) NSString *with_user_level;
@property (nonatomic, strong) NSString *topic_type;
@property (nonatomic, strong) NSString *chat_id;
@property (nonatomic, strong) NSString *with_user_id;
@property (nonatomic, strong) NSString *with_user_name;
@property (nonatomic, strong) NSString *with_user_avatar_url;
@property (nonatomic, strong) NSString *voice_id;
@property (nonatomic, strong) NSString *un_read_num;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *chat_type;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *last_resource_type;
@property (nonatomic, strong) NSString *with_user_socket_id;
@property (nonatomic, strong) NSString *notice_at;
@property (nonatomic, strong) NSString *identity_type;
@property (nonatomic, strong) NSString *with_user_identity_type;
@property (nonatomic, strong) NSString *dialog_num;
@property (nonatomic, strong) NSString *last_dialog_id;
@property (nonatomic, strong) NSString *resource_id;
@property (nonatomic, strong) NSString *user_flag;
@property (nonatomic, strong) NSString *user_flagName;

@property (nonatomic, strong) NoticeChats *lastChatModel;
@property (nonatomic, strong) NSDictionary *last_dialog;
@property (nonatomic, strong) NSString *voice_cover_img;
@property (nonatomic, strong) NSString *voice_user_id;//发心情的用户id
@end

NS_ASSUME_NONNULL_END
