//
//  NoticeTeamChatModel.h
//  NoticeXi
//
//  Created by li lei on 2023/6/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamChatModel : NSObject

@property (nonatomic, assign) CGFloat cellHeight;//cell高度
@property (nonatomic, strong) NSString *unread_num;
@property (nonatomic, strong) NSString *call_id;//是否艾特了自己的消息id
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL hasManage;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, assign) BOOL isSelf;//是否是自己发的消息
@property (nonatomic, assign) NSInteger contentType;//消息类型 1文本，2图片 3语音
@property (nonatomic, strong) NSString *content_type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSAttributedString *contentAtt;
@property (nonatomic, assign) CGFloat textHeight;//文本高度
@property (nonatomic, assign) CGFloat textWidth;//文本宽度

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *showTime;

@property (nonatomic, assign) BOOL isShowTime;//是否需要显示时间

@property (nonatomic, strong) NSString *logId;//消息id
@property (nonatomic, strong) NSString *mass_id;//社团id
@property (nonatomic, strong) NSString *from_user_id;//聊天用户id
@property (nonatomic, strong) NSDictionary *from_user;//聊天用户信息
@property (nonatomic, strong) NoticeAbout *fromUserM;

@property (nonatomic, strong) NSString *about_id;//被回复的聊天id

@property (nonatomic, strong) NSString *voice_len;//音频长度
@property (nonatomic, strong) NSString *resource_url;//图片或者音频资源url（content_type=2或3时用）

@property (nonatomic, strong) NSString *status;//状态, 1:正常  4:自己撤回

@property (nonatomic, strong) NSDictionary *call_chat;//引用的消息
@property (nonatomic, strong) NoticeTeamChatModel *userMsg;

@property (nonatomic, assign) BOOL hasDowned;//是否已经下载了图片
@property (nonatomic, assign) BOOL widthOverHeight;//图片的宽是否大于高

@property (nonatomic, assign) CGFloat callChatTextHeight;//引用的文本高度
@property (nonatomic, assign) CGFloat callChatTextWidth;//引用的文本宽度
@property (nonatomic, strong) NSAttributedString *callChatAttStr;//引用的文本

@property (nonatomic, strong) NSString *chat_log_id;

- (void)refreshCallChatHeight;
@property (nonatomic, strong) NSString *revokeOrDeleteStr;

@property (nonatomic, strong) NSDictionary *del_user;
@property (nonatomic, strong) NoticeAbout *delUserM;

@property (nonatomic, strong) NSString *to_user_id;

@property (nonatomic, strong) NSString *pathName;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *voiceFilePath;
@property (nonatomic, strong) NSString *imgUpPath;
@property (nonatomic, strong) NSString *isSaveCace;
@property (nonatomic, strong) NSString *saveId;//缓存保存id

@end

NS_ASSUME_NONNULL_END
