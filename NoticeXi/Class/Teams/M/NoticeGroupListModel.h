//
//  NoticeGroupListModel.h
//  NoticeXi
//
//  Created by li lei on 2023/6/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeTeamChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeGroupListModel : NSObject

@property (nonatomic, strong) NSArray *joins;//已加入的社团
@property (nonatomic, strong) NSArray *not_joins;//没加入的社团
@property (nonatomic, strong) NSString *identity;

@property (nonatomic, strong) NSString *teamId;//社团id
@property (nonatomic, strong) NSString *title;//社团名称
@property (nonatomic, strong) NSString *img_url;//社团头像
@property (nonatomic, strong) NSString *rule;//社团规则
@property (nonatomic, strong) NSString *member_num;//社团成员数量
@property (nonatomic, strong) NSString *created_at;//创建时间
@property (nonatomic, strong) NSString *is_join;//是否已加入
@property (nonatomic, strong) NSString *unread_num;//社团未读消息数量
@property (nonatomic, strong) NSString *call_id;//被艾特的聊天记录
@property (nonatomic, strong) NSString *mass_nick_name;//在社团里的昵称
@property (nonatomic, strong) NSString *mass_remind;//消息提醒开关 0:关闭提醒 1:开启提醒
@property (nonatomic, strong) NSString *is_forbid;//是否被禁止加入
@property (nonatomic, strong) NSDictionary *last_chat_log;//最新一条消息
@property (nonatomic, strong) NoticeTeamChatModel *lastMsgModel;
@end

NS_ASSUME_NONNULL_END
