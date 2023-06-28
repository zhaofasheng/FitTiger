//
//  NoticeDataLikeModel.m
//  NoticeXi
//
//  Created by li lei on 2023/3/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeDataLikeModel.h"

@implementation NoticeDataLikeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"msgId":@"id"};
}

- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUser = [NoticeVoiceListSubModel mj_objectWithKeyValues:from_user];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

- (void)setInvitation_comment:(NSDictionary *)invitation_comment{
    _invitation_comment = invitation_comment;
    self.comModel = [NoticeHelpCommentModel mj_objectWithKeyValues:invitation_comment];
    
    if (self.comModel.content_type.intValue > 1) {
        self.comHeight = 88;
    }else{
        self.comHeight = [NoticeTools getHeightWithLineHight:5 font:15 width:DR_SCREEN_WIDTH-79 string:self.comModel.content];
        self.comAtt = [NoticeTools getStringWithLineHight:5 string:self.comModel.content];
        if (self.comHeight < 20) {
            self.comHeight = 20;
        }
    }
}

- (void)setInvitation_reply:(NSDictionary *)invitation_reply{
    _invitation_reply = invitation_reply;
    self.subComModel = [NoticeHelpCommentModel mj_objectWithKeyValues:invitation_reply];
    if (self.subComModel.content_type.intValue > 1) {
        self.subComHeight = 88;
    }else{
        self.subComHeight = [NoticeTools getHeightWithLineHight:5 font:15 width:DR_SCREEN_WIDTH-79 string:self.subComModel.content];
        self.subComAtt = [NoticeTools getStringWithLineHight:5 string:self.subComModel.content];
        if (self.subComHeight < 20) {
            self.subComHeight = 20;
        }
    }
}

- (void)setPodcast_comment_content:(NSString *)podcast_comment_content{
    _podcast_comment_content = podcast_comment_content;
    
   self.podcastHeight = [NoticeTools getHeightWithLineHight:5 font:15 width:DR_SCREEN_WIDTH-79 string:podcast_comment_content];
   self.podcastAtt = [NoticeTools getStringWithLineHight:5 string:podcast_comment_content];
    if (self.podcastHeight < 20) {
        self.podcastHeight = 20;
    }
}

- (void)setDubbing_comment_content:(NSString *)dubbing_comment_content{
    _dubbing_comment_content = dubbing_comment_content;
    self.dubbingAtt = [NoticeTools getStringWithLineHight:5 string:dubbing_comment_content];
    self.dubbingHeight = [NoticeTools getHeightWithLineHight:5 font:15 width:DR_SCREEN_WIDTH-79 string:dubbing_comment_content];
    if (self.dubbingHeight < 20) {
        self.dubbingHeight = 20;
    }
}

- (void)setHtml_comment_content:(NSString *)html_comment_content{
    _html_comment_content = html_comment_content;
    self.htmlAtt = [NoticeTools getStringWithLineHight:5 string:html_comment_content];
    self.htmlHeight = [NoticeTools getHeightWithLineHight:5 font:15 width:DR_SCREEN_WIDTH-79 string:html_comment_content];
    if (self.htmlHeight < 20) {
        self.htmlHeight = 20;
    }
}

- (void)setArticle_comment_content:(NSString *)article_comment_content{
    _article_comment_content = article_comment_content;
    self.articleAtt = [NoticeTools getStringWithLineHight:5 string:article_comment_content];
    self.articleHeight = [NoticeTools getHeightWithLineHight:5 font:15 width:DR_SCREEN_WIDTH-79 string:article_comment_content];
    if (self.articleHeight < 20) {
        self.articleHeight = 20;
    }
}

- (void)setVoice_comment:(NSDictionary *)voice_comment{
    _voice_comment = voice_comment;
    self.currentComM = [NoticeVoiceComModel mj_objectWithKeyValues:voice_comment];
    self.voice_comment_content = self.currentComM.content;
}

- (void)setVoice_parent_comment:(NSDictionary *)voice_parent_comment{
    _voice_parent_comment = voice_parent_comment;
    self.parrentComM = [NoticeVoiceComModel mj_objectWithKeyValues:voice_parent_comment];
    self.voice_parent_comment_content = self.parrentComM.content;
}

- (void)setLine_from_user:(NSDictionary *)line_from_user{
    _line_from_user = line_from_user;
    self.lineUser = [NoticeVoiceListSubModel mj_objectWithKeyValues:line_from_user];
}

- (void)setVoice_comment_content:(NSString *)voice_comment_content{
    _voice_comment_content = voice_comment_content;
    self.voiceComAtt = [NoticeTools getStringWithLineHight:5 string:voice_comment_content];
    self.voiceComHeight = [NoticeTools getHeightWithLineHight:5 font:15 width:DR_SCREEN_WIDTH-55-78 string:voice_comment_content];
}

- (void)setPodcast_comment:(NSDictionary *)podcast_comment{
    _podcast_comment = podcast_comment;
    self.comBokeModel = [NoticeVoiceComModel mj_objectWithKeyValues:podcast_comment];
}

- (void)setMessage_type:(NSString *)message_type{
    _message_type = message_type;
    self.needLabel = NO;
    if (message_type.intValue == 3) {
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.sendYou"];
    }else if (message_type.intValue == 17102){
        self.message_typeName = [NoticeTools chinese:@"赞了你的心情留言" english:@"likes your comment" japan:@"がコメントを気に入りました"];
    }else if (message_type.intValue == 17103){
        self.message_typeName = [NoticeTools chinese:@"赞了你的心情回复" english:@"likes your reply" japan:@"があなたの返信を気に入りました"];
    }else if (message_type.intValue == 22){
        self.needLabel = YES;
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.bgToYourPy"];
    }else if (message_type.intValue == 17){
        self.needLabel = YES;
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.likeYourPy"];
    }else if (message_type.intValue == 48102){
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.zanPyCom"];
        self.needLabel = YES;
    }else if (message_type.intValue == 16){
        self.needLabel = YES;
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.pyForTc"];
    }else if (message_type.intValue == 501){
        self.needLabel = YES;
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.scTc"];
    }else if (message_type.intValue == 19002){
        self.needLabel = YES;
        self.message_typeName = [NoticeTools getLocalStrWith:@"help.agreez"];
    }else if (message_type.intValue == 19012){
        self.message_typeName = [NoticeTools chinese:@"赞了你的播客留言" english:@"likes your comment" japan:@"がコメントを気に入りました"];
    }else if (message_type.intValue == 19013){
        self.message_typeName = [NoticeTools chinese:@"赞了你的播客回复" english:@"likes your reply" japan:@"があなたの返信を気に入りました"];
    }else if (message_type.intValue == 25){
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.collectYourDraw"];
    }else if (message_type.intValue == 27){
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.sendYouDraw"];
    }else if (message_type.intValue == 18){
        self.message_typeName = [NoticeTools getLocalStrWith:@"each.sendBgDraw"];
    }else if (message_type.intValue == 23){
        self.needLabel = YES;
    }
}
@end
