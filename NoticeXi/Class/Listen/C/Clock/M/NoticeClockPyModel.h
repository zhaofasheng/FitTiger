//
//  NoticeClockPyModel.h
//  NoticeXi
//
//  Created by li lei on 2019/10/17.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeBBSComent.h"
NS_ASSUME_NONNULL_BEGIN

@class NoticeUserInfoModel;

@interface NoticeClockPyModel : NSObject

@property (nonatomic, assign) NSInteger fromType;//判断最后一个数据来自哪个接口
@property (nonatomic, strong) NSString *dubbing_id;
//台词模块字段
@property (nonatomic, strong) NSString *user_id;//台词发布者
@property (nonatomic, strong) NSString *tcId;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NoticeUserInfoModel *userInfo;
@property (nonatomic, strong) NSString *dubbing_num;//台词配音数量
@property (nonatomic, strong) NSString *is_dubbed;//是否参与了该台词的配音
//共同拥有的属性
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *created_atTime;
@property (nonatomic, strong) NSString *vote_option;//投票结果
@property (nonatomic, strong) NSString *vote_id;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSString *line_content;
@property (nonatomic, strong) NSAttributedString *attLine_content;
@property (nonatomic, strong) NSString *line_status;//台词状态，1：正常，2:用户删除，3:系统删除
@property (nonatomic, strong) NSString *is_anonymous;//是否匿名发布，1:是，0:否
@property (nonatomic, strong) NSString *vote_option_one;//天使投票数量
@property (nonatomic, strong) NSString *vote_option_two;//恶魔投票数量
@property (nonatomic, strong) NSString *vote_option_three;//神投票数量
@property (nonatomic, strong) NSString *vote_option_four;//最新版本投票

@property (nonatomic, strong) NSString *log_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *comment_num;
//配音模块时候的字段
@property (nonatomic, strong) NSString *hide_at;
@property (nonatomic, assign) BOOL hasDownLoad;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isPicker;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, strong) NSDictionary *from_user_info;
@property (nonatomic, strong) NoticeUserInfoModel *pyUserInfo;
@property (nonatomic, strong) NSString *pyId;
@property (nonatomic, strong) NSString *from_user_id;//配音人id
@property (nonatomic, strong) NSString *to_user_id;//被配音者id
@property (nonatomic, strong) NSString *line_id;//配音对应的台词id
@property (nonatomic, strong) NSString *dubbing_len;//配音音频长度
@property (nonatomic, strong) NSString *dubbing_url;//配音音频绝对地址
@property (nonatomic, strong) NSString *dubbing_status;

@property (nonatomic, strong) NSAttributedString *attLineContent;

@property (nonatomic, strong) NSString *tag_id;
@property (nonatomic, strong) NSString *tag_name;

//分享在社团聊天里面时候用的
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *collection_id;//台词收藏id
@property (nonatomic, strong) NSString *collection_num;
@property (nonatomic, strong) NSString *downloaded_num;//配音收藏数量
@property (nonatomic, strong) NSDictionary *line;//配音列表的时候存在
@property (nonatomic, strong) NoticeClockPyModel *lineM;

@property (nonatomic, strong) NSDictionary *to_user_info;//配音列表里面的台词发布者用户信息
@property (nonatomic, strong) NoticeUserInfoModel *toUserInfo;
@property (nonatomic, strong) NSString *pickTime;
@property (nonatomic, strong) NSString *pick_status;
@property (nonatomic, strong) NSString *top_status;

@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *comArr;
@end

NS_ASSUME_NONNULL_END
