//
//  NoticeDataLikeModel.h
//  NoticeXi
//
//  Created by li lei on 2023/3/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeHelpCommentModel.h"
#import "NoticeDanMuModel.h"
#import "NoticeVoiceComModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDataLikeModel : NSObject

@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *message_type;//消息类型 3(心情贴贴) 17102(心情评论点赞) 17103(心情回复点赞)17(配音被收藏) 22(配音被贴贴) 23(配音被pick) 48102(配音评论点赞) 501(台词被收藏) 16(台词被配音) 19002(帖子评论点赞)  19012(播客评论点赞) 19013(播客回复点赞)   4(有人觉得你很棒) 26(画被推荐) 27(送你一幅画) 25(画被收藏) 18(画被点赞)  48100(配音被评论) 48101(配音被回复) 19000(帖子评论) 19001(帖子回复)  19010(播客评论) 19011(播客回复) 35(每日一阅被回复) 8(文章被回复)   17100(心情被评论) 17101(心情被回复)
@property (nonatomic, strong) NSString *message_typeName;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *is_anonymous;
@property (nonatomic, strong) NSString *message_id;

@property (nonatomic, strong) NoticeVoiceListSubModel *fromUser;
@property (nonatomic, strong) NSDictionary *from_user;

@property (nonatomic, strong) NSDictionary *voice_comment;
@property (nonatomic, strong) NoticeVoiceComModel *currentComM;

@property (nonatomic, strong) NSDictionary *voice_parent_comment;
@property (nonatomic, strong) NoticeVoiceComModel *parrentComM;
@property (nonatomic, strong) NSString *voice_parent_comment_content;
@property (nonatomic, strong) NSString *voice_comment_content;
@property (nonatomic, strong) NSMutableAttributedString *voiceComAtt;
@property (nonatomic, assign) CGFloat voiceComHeight;
@property (nonatomic, strong) NSString *voice_cover_img;//心情封面
@property (nonatomic, strong) NSString *voice_id;//心情id
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;

@property (nonatomic, strong) NSString *invitation_id;//求助帖id
@property (nonatomic, strong) NSDictionary *invitation_comment;
@property (nonatomic, strong) NoticeHelpCommentModel *comModel;
@property (nonatomic, strong) NSMutableAttributedString *comAtt;
@property (nonatomic, assign) CGFloat comHeight;
@property (nonatomic, strong) NSString *invitation_title;
@property (nonatomic, strong) NSDictionary *invitation_reply;
@property (nonatomic, strong) NoticeHelpCommentModel *subComModel;
@property (nonatomic, strong) NSMutableAttributedString *subComAtt;
@property (nonatomic, assign) CGFloat subComHeight;

@property (nonatomic, strong) NSString *podcast_id;
@property (nonatomic, strong) NSString *podcast_cover_url;
@property (nonatomic, strong) NSString *podcast_comment_content;//播客评论
@property (nonatomic, strong) NSString *podcast_parent_comment_content;//播客父类评论(显示俩级评论的时候)
@property (nonatomic, strong) NSMutableAttributedString *podcastAtt;
@property (nonatomic, assign) CGFloat podcastHeight;
@property (nonatomic, strong) NSString *podcast_title;
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic, strong) NSDictionary *podcast_comment;
@property (nonatomic, strong) NoticeVoiceComModel *comBokeModel;
@property (nonatomic, strong) NSString *podcast_parent_comment_id;

@property (nonatomic, strong) NSString *line_id;
@property (nonatomic, strong) NSString *dubbing_id;
@property (nonatomic, strong) NSString *dubbing_comment_content;
@property (nonatomic, strong) NSString *dubbing_parent_comment_content;
@property (nonatomic, strong) NSMutableAttributedString *dubbingAtt;
@property (nonatomic, assign) CGFloat dubbingHeight;
@property (nonatomic, strong) NSString *line_content;
@property (nonatomic, strong) NSDictionary *line_from_user;
@property (nonatomic, strong) NoticeVoiceListSubModel *lineUser;
@property (nonatomic, assign) BOOL needLabel;

@property (nonatomic, strong) NSString *html_id;//文章id
@property (nonatomic, strong) NSString *html_banner_url;
@property (nonatomic, strong) NSString *html_title;
@property (nonatomic, strong) NSString *html_parent_comment_content;//文章评论
@property (nonatomic, strong) NSString *html_comment_content;//文章回复
@property (nonatomic, strong) NSMutableAttributedString *htmlAtt;
@property (nonatomic, assign) CGFloat htmlHeight;


@property (nonatomic, strong) NSString *article_id;//每日一阅id
@property (nonatomic, strong) NSString *article_title;
@property (nonatomic, strong) NSString *article_comment_content;
@property (nonatomic, strong) NSString *article_parent_comment_content;//文章回复
@property (nonatomic, strong) NSMutableAttributedString *articleAtt;
@property (nonatomic, assign) CGFloat articleHeight;

@property (nonatomic, strong) NSString *artwork_id;
@end

NS_ASSUME_NONNULL_END
