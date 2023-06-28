//
//  NoticeGroupChatModel.h
//  NoticeXi
//
//  Created by li lei on 2020/8/13.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NoticeClockPyModel;

@interface NoticeGroupChatModel : NSObject
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat assosContentCellHeight;
@property (nonatomic, strong) NSAttributedString *groupAttStr;
@property (nonatomic, strong) NSAttributedString *attStr;
@property (nonatomic, strong) NSString *showTime;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *assoc_id;
@property (nonatomic, strong) NSString *chat_id;

@property (nonatomic, strong) NSString *levelImgName;
@property (nonatomic, strong) NSString *levelImgIconName;
@property (nonatomic, strong) NSString *levelName;
@property (nonatomic, strong) NSString *level;

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *resource_url;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *user_avatar_url;
@property (nonatomic, strong) NSString *garbage_type;
@property (nonatomic, assign) BOOL isShowTime;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) BOOL isSaveCace;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL hasDownload;
@property (nonatomic, assign) CGFloat imgHeight;
@property (nonatomic, strong) NSString *identity;

@property (nonatomic, strong) NSString *voice_url;
@property (nonatomic, strong) NSString *voice_len;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, strong) NSString *nowTime;

@property (nonatomic, strong) NSString *saveId;
@property (nonatomic, assign) BOOL isFailed;

@property (nonatomic, strong) NSString *real_type;
@property (nonatomic, strong) NSString *assoc_nick_name;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeDrawList *drawM;
@property (nonatomic, strong) NoticeClockPyModel *pyModel;
@property (nonatomic, strong) NSString *voice_content;
@property (nonatomic, strong) NSDictionary *artwork;
@property (nonatomic, strong) NSDictionary *voice;
@property (nonatomic, strong) NSDictionary *dubbing;

@property (nonatomic, strong) NSAttributedString *signAttStr;
@property (nonatomic, assign) CGFloat signNameHeight;//如果是打卡的，需要这个高度
@property (nonatomic, strong) NSString *event_type;//2打卡  4分享链接

@property (nonatomic, strong) NSString *share_url;

@property (nonatomic, strong) NSString *about_id;
@property (nonatomic, strong) NSString *picture_id;
@property (nonatomic, strong) NSString *hot_picture;
@property (nonatomic, strong) NSString *bucket_id;
@property (nonatomic, strong) NSString *resource_uri;

@property (nonatomic, strong) NSArray *call_user;
@property (nonatomic, strong) NSMutableArray *callArr;
//艾特人的语音消息视图高度
@property (nonatomic, strong) NSAttributedString *atPeopleAttStr;
@property (nonatomic, assign) CGFloat voiceAtHeight;
@property (nonatomic, assign) CGFloat voiceAtrealHeight;//艾特人的文本真实高度
@property (nonatomic, assign) CGFloat voiceAtWidth;
@property (nonatomic, assign) CGFloat voiceAtrealWidth;//艾特人的文本真实宽度

@property (nonatomic, assign) CGFloat playerVoiceViewWidth;

@property (nonatomic, strong) NSDictionary *call_chat;//引用的消息
@property (nonatomic, strong) NoticeGroupChatModel *callChat;
@property (nonatomic, assign) CGFloat callChatTextViewHeight;//引用的文本消视图息高度
@property (nonatomic, assign) CGFloat callChatTextViewWidth;//引用的文本消息视图宽度
@property (nonatomic, assign) CGFloat callChatTextHeight;//引用的文本高度
@property (nonatomic, assign) CGFloat callChatTextWidth;//引用的文本宽度
@property (nonatomic, strong) NSAttributedString *callChatAttStr;//引用的文本
@property (nonatomic, assign) CGFloat CallVoiceViewWidth;//引用的语音消息宽度

@property (nonatomic, strong) NSString *callChatTimeLen;

- (void)refreshCallChatHeight;//文本引用文本
- (void)refreshCallChatImageHeight;//文本引用图片
- (void)voiceUseTextHeight;//语音引用文本消息

- (void)voiceUseImgHeight;//语音引用图片消息

@property (nonatomic, strong) NSString *atPeopleStr;
@property (nonatomic, assign) CGFloat voiceUseTextViewHeght;//语音引用文本的视图高度
@property (nonatomic, assign) CGFloat voiceUseTextViewWidth;//语音引用文本的视图宽度

@property (nonatomic, assign) CGFloat voiceUseImgViewHeght;//语音引用图片的视图高度
@property (nonatomic, assign) CGFloat voiceUseImgViewWidth;//语音引用图片的视图宽度

- (void)voiceUseVoiceHeight;//语音引用语音
@property (nonatomic, assign) CGFloat voiceUseVoiceViewHeght;//语音引用语音的视图高度
@property (nonatomic, assign) CGFloat voiceUseVoiceViewWidth;//语音引用图片的视图宽度
@end

NS_ASSUME_NONNULL_END
