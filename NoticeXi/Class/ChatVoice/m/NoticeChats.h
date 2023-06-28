//
//  NoticeChats.h
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeChatTopicM.h"
#import "NoticeShareVoiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChats : NSObject
@property (nonatomic, strong) UIImage *downImage;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *resource_len;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *read_at;
@property (nonatomic, strong) NSString *resource_url;
@property (nonatomic, strong) NSString *dialog_id;
@property (nonatomic, strong) NSString *dialogId;//只限私聊界面删除操作使用
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *receive_status;
@property (nonatomic, strong) NSString *is_self;
@property (nonatomic, assign) CGFloat cellHeihgt;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isFinish;//是否加载完图片
@property (nonatomic, strong) NSString *tuyaDiaLogId;//只限涂鸦对话操作使用
@property (nonatomic, strong) NSString *chat_type;
@property (nonatomic, strong) NSString *dialog_content_uri;//校验数据
@property (nonatomic, strong) NSString *offline_prompt;
@property (nonatomic, strong) NSString *resource_content;
@property (nonatomic, strong) NSString *voice_id;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *showTime;
@property (nonatomic, strong) NSString *dialog_content_len;
@property (nonatomic, strong) NSString *dialog_content_type;
@property (nonatomic, strong) NSString *content_type;//1 音频  2信封 3图片
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSDictionary *first_card_info;
@property (nonatomic, strong) NoticeWhiteVoiceListModel *whiteModel;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat textWidth;
@property (nonatomic, strong) NSAttributedString *attStr;
@property (nonatomic, strong) NSString *globText;
@property (nonatomic, strong) NSString *user_avatar_url;
@property (nonatomic, strong) NSString *chat_id;
@property (nonatomic, strong) NSString *dialog_content_url;
@property (nonatomic, strong) NSString *dialog_content;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *yunxin_id;
@property (nonatomic, assign) BOOL isShowTime;
@property (nonatomic, assign) BOOL isKeFu;
@property (nonatomic, assign) BOOL needMarkAuto;

@property (nonatomic, assign) BOOL isSaveCace;
@property (nonatomic, strong) NSString *saveId;//缓存保存id
@property (nonatomic, strong) NSString *isGif;
@property (nonatomic, strong) NSString *isText;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, assign) CGFloat nowPro;
@property (nonatomic, strong) NSString *recognition_content;

@property (nonatomic, strong) NoticeChatTopicM *chatTopicM;
@property (nonatomic, strong) NSDictionary *talking_topic;
@property (nonatomic, assign) BOOL isFailed;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, strong) NSString *identity_type;
@property (nonatomic, strong) NSString *localId;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, assign) CGFloat imgCellHeight;
@property (nonatomic, assign) BOOL hasDowned;//是否已经下载了图片
@property (nonatomic, assign) BOOL widthOverHeight;//图片的宽是否大于高
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) NSMutableDictionary *sendDic;
@property (nonatomic, strong) NSString *resource_id;
@property (nonatomic, strong) NSString *garbage_type;
@property (nonatomic, strong) NSString *from_avatar_url;
@property (nonatomic, strong) NSString *dialog_status;//对话状态，1:正常，2:用户删除，3:系统删除

@property (nonatomic, strong) NSString *assoc_id;
@property (nonatomic, strong) NSString *chatlog_id;

@property (nonatomic, strong) NoticeShareVoiceModel *shareVoiceM;
@property (nonatomic, strong) NSDictionary *share_voice;

@property (nonatomic, strong) NSDictionary *share_dubbing;
@property (nonatomic, strong) NoticeShareVoiceModel *sharePyM;

@property (nonatomic, strong) NSDictionary *share_line;
@property (nonatomic, strong) NoticeShareVoiceModel *share_lineM;

@property (nonatomic, strong) NSDictionary *toUserInfo;
@property (nonatomic, strong) NoticeUserInfoModel *sendUserM;
@end

NS_ASSUME_NONNULL_END
