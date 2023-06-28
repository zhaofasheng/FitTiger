//
//  NoticeMessage.h
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeBBSComent.h"
#import "NoticeHelpCommentModel.h"
#import "NoticeVoiceComModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMessage : NSObject
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *days;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *friend_from;
@property (nonatomic, strong) NSString *article_id;
@property (nonatomic, strong) NSString *message_type;
@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *is_anonymous;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat  contentHeight;
@property (nonatomic, strong) NSAttributedString *allTextAttStr;
@property (nonatomic, strong) NSString *push_at;
@property (nonatomic, strong) NSString *log_status;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *release_at;
@property (nonatomic, strong) NSString *friendOutTime;
@property (nonatomic, strong) NSString *release_hour;
@property (nonatomic, strong) NSString *voice_id;
@property (nonatomic, strong) NSString *open_at;
@property (nonatomic, strong) NSString *html_id;
@property (nonatomic, strong) NSString *dubbing_id;//配音id
@property (nonatomic, strong) NSString *line_id;//台词id
@property (nonatomic, strong) NSString *vote_option;
@property (nonatomic, strong) NSString *graffiti_id;
@property (nonatomic, strong) NSString *artwork_id;
@property (nonatomic, strong) NSString *like_type;
@property (nonatomic, strong) NSString *message_id;
@property (nonatomic, strong) NSString *take_time;
@property (nonatomic, strong) NSString *read_at;
@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *supply;
@property (nonatomic, strong) NSString *link_url;

@property (nonatomic, strong) NSString *song_title;

@property (nonatomic, strong) NSString *isNew;

@property (nonatomic, strong) NSDictionary *comment;
@property (nonatomic, strong) NoticeVoiceComModel *currentComM;

@property (nonatomic, strong) NSDictionary *parent_comment;
@property (nonatomic, strong) NoticeVoiceComModel *parrentComM;

@property (nonatomic, strong) NoticeVoiceListSubModel *fromUser;
@property (nonatomic, strong) NSDictionary *from_user;

@property (nonatomic, strong) NSDictionary *voice;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;

@property (nonatomic, strong) NSString *invitation_id;//求助帖id
@property (nonatomic, strong) NSDictionary *invitation_comment;
@property (nonatomic, strong) NoticeHelpCommentModel *comModel;

@property (nonatomic, strong) NSString *smalllevelImgName;

@property (nonatomic, strong) NSString *podcast_id;//播客id
@property (nonatomic, strong) NSDictionary *podcast_comment;
@property (nonatomic, strong) NoticeVoiceComModel *comBokeModel;
@end

NS_ASSUME_NONNULL_END
