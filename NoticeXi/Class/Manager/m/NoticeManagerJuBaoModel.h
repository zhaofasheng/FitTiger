//
//  NoticeManagerJuBaoModel.h
//  NoticeXi
//
//  Created by li lei on 2019/8/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeManagerUserInfo.h"
#import "NoticeManagerModel.h"
#import "NoticeVoiceListModel.h"
#import "NoticeDrawList.h"
#import "NoticeDrawTuM.h"
#import "NoticeGroupChatModel.h"
#import "NoticeBBSComent.h"
#import "NoticeDanMuListModel.h"
#import "NoticeVoiceComModel.h"
#import "NoticeHelpCommentModel.h"
#import "NoticeTeamChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerJuBaoModel : NSObject

@property (nonatomic, strong) NoticeVoiceComModel *comModel;
@property (nonatomic, strong) NSString *jubaoId;
@property (nonatomic, strong) NSString *type_id;//举报类型，1=人身攻击，2=色情暴力，3=共享自拍，4=违反舍规：禁約、禁二維碼、禁發廣告
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *resource_type;//数据类型，1=举报声兮，2=举报悄悄话，3=举报对话，4=举报用户
@property (nonatomic, strong) NSString *resourceTypeName;
@property (nonatomic, strong) NSString *resource_id;//举报的数据对象ID
@property (nonatomic, strong) NSString *from_user_id;//举报人用户ID
@property (nonatomic, strong) NSString *to_user_id;//被举报人用户ID
@property (nonatomic, strong) NSString *report_status;//状态，0:待调查，1:待处理，2：忽略，3：警告，4：封号
@property (nonatomic, strong) NSString *created_at;//举报时间
@property (nonatomic, strong) NSString *updated_at;//更新时间
@property (nonatomic, strong) NSDictionary *from_user_info;//举报人信息
@property (nonatomic, strong) NSDictionary *to_user_info;//被举报人信息
@property (nonatomic, strong) NoticeManagerUserInfo *fromUser;
@property (nonatomic, strong) NoticeManagerUserInfo *toUser;
@property (nonatomic, strong) NSDictionary *dialog;//私聊，悄悄话
@property (nonatomic, strong) NoticeManagerModel *managerM;
@property (nonatomic, strong) NSDictionary *voice;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NSDictionary *artwork;
@property (nonatomic, strong) NoticeDrawList *drawM;
@property (nonatomic, strong) NSDictionary *graffiti;
@property (nonatomic, strong) NoticeDrawTuM *tuyaModel;
@property (nonatomic, strong) NSString *entry_type;
@property (nonatomic, strong) NSDictionary *dubbing;
@property (nonatomic, strong) NSString *chat_type;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NoticeManagerUserInfo *centerUser;
@property (nonatomic, strong) NSString *voice_id;
@property (nonatomic, strong) NSString *data_type;
@property (nonatomic, strong) NSString *data_from;
@property (nonatomic, strong) NSString *data_fromName;
@property (nonatomic, strong) NSString *data_id;
@property (nonatomic, strong) NSString *operation_type;
@property (nonatomic, strong) NSString *operation_note;
@property (nonatomic, strong) NSString *chat_id;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSDictionary *line;
@property (nonatomic, strong) NSString *movie_id;
@property (nonatomic, strong) NSString *song_id;
@property (nonatomic, strong) NSString *book_id;
@property (nonatomic, strong) NSString *invitation_id;
@property (nonatomic, strong) NSString *invitation_comment_id;
@property (nonatomic, strong) NSDictionary *voice_comment;

@property (nonatomic, strong) NSDictionary *assoc;
@property (nonatomic, strong) NoticeGroupChatModel *groupChatModel;

@property (nonatomic, strong) NSDictionary *phone_card;
@property (nonatomic, strong) NoticeManagerModel *cardInfo;

@property (nonatomic, strong) NSDictionary *comment;
@property (nonatomic, strong) NoticeBBSComent *commentM;

@property (nonatomic, strong) NSDictionary *dubbing_comment;
@property (nonatomic, strong) NoticeBBSComent *pyComM;

@property (nonatomic, strong) NSDictionary *podcast_barrage;
@property (nonatomic, strong) NoticeDanMuListModel *danmM;

@property (nonatomic, strong) NSDictionary *podcast;
@property (nonatomic, strong) NoticeDanMuListModel *podModel;
@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSString *podcast_id;//播客id
@property (nonatomic, strong) NSDictionary *podcast_comment;
@property (nonatomic, strong) NoticeVoiceComModel *comBokeModel;
@property (nonatomic, strong) NSString *be_report_content;

@property (nonatomic, strong) NSArray *invitation_comment_list;
@property (nonatomic, strong) NSString *invitation_comment_parent_id;
@property (nonatomic, strong) NSMutableArray *helpCommentArr;

@property (nonatomic, strong) NSString *mass_id;
@property (nonatomic, strong) NSDictionary *mass_member;
@property (nonatomic, strong) NoticeAbout *massMember;
@property (nonatomic, strong) NSDictionary *mass_chat_log;
@property (nonatomic, strong) NoticeTeamChatModel *chatTeamM;
@end

NS_ASSUME_NONNULL_END
