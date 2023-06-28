//
//  NoticeManagerJuBaoModel.m
//  NoticeXi
//
//  Created by li lei on 2019/8/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerJuBaoModel.h"

@implementation NoticeManagerJuBaoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"jubaoId":@"id"};
}

- (void)setType_id:(NSString *)type_id{
    _type_id = type_id;
    if ([type_id isEqualToString:@"1"]) {
        self.typeName = @"人身攻击";
    }else if ([type_id isEqualToString:@"2"]){
        self.typeName = [NoticeTools getLocalStrWith:@"jubao.reason2"];
    }else if ([type_id isEqualToString:@"3"]){
        self.typeName = [NoticeTools getLocalStrWith:@"jubao.reason3"];
    }else if ([type_id isEqualToString:@"6"]){
        self.typeName = @"垃圾信息";
    }
    else{
        self.typeName = @"违反舍规";
    }
}

- (void)setPodcast:(NSDictionary *)podcast{
    _podcast = podcast;
    self.podModel = [NoticeDanMuListModel mj_objectWithKeyValues:podcast];
}

- (void)setAssoc:(NSDictionary *)assoc{
    _assoc = assoc;
    self.groupChatModel = [NoticeGroupChatModel mj_objectWithKeyValues:assoc];
}

- (void)setUser:(NSDictionary *)user{
    _user = user;
    self.centerUser = [NoticeManagerUserInfo mj_objectWithKeyValues:user];
}

- (void)setResource_type:(NSString *)resource_type{
    _resource_type = resource_type;
    if ([resource_type isEqualToString:@"1"]) {
        self.resourceTypeName = @"心情";
    }else if ([resource_type isEqualToString:@"2"]){
        self.resourceTypeName = @"会话";
    }else if ([resource_type isEqualToString:@"5"]){
        self.resourceTypeName = @"绘画";
    }else if ([resource_type isEqualToString:@"6"]){
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"em.tuya"];
    }else if ([resource_type isEqualToString:@"4"]){
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"search.user"];
    }else if ([resource_type isEqualToString:@"3"]){
        self.resourceTypeName = @"对话";
    }else if ([resource_type isEqualToString:@"7"]){
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"py.tc"];
    }else if ([resource_type isEqualToString:@"8"]){
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"py.py"];
    }else if ([resource_type isEqualToString:@"9"]){
        self.resourceTypeName = @"社团聊天";
    }else if ([resource_type isEqualToString:@"10"]){
        self.resourceTypeName = @"弹幕";
    }
    else if ([resource_type isEqualToString:@"128"]){
        self.resourceTypeName = @"电话卡";
    }else if ([resource_type isEqualToString:@"133"]){
        self.resourceTypeName = @"流星语";
    }else if ([resource_type isEqualToString:@"130"]){
        self.resourceTypeName = @"bbs";
    }else if ([resource_type isEqualToString:@"130"]){
        self.resourceTypeName = @"bbs";
    }else if ([resource_type isEqualToString:@"131"]){
        self.resourceTypeName = @"配音留言";
    }else if ([resource_type isEqualToString:@"132"]){
        self.resourceTypeName = @"配音回复";
    }else if ([resource_type isEqualToString:@"111"]){
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"read.title"];
    }else if ([resource_type isEqualToString:@"140"]){
        self.resourceTypeName = @"心情评论";
    }else if ([resource_type isEqualToString:@"141"]){
        self.resourceTypeName = @"求助帖";
    }else if ([resource_type isEqualToString:@"142"]){
        self.resourceTypeName = @"求助帖评论";
    }else if ([resource_type isEqualToString:@"144"]){
        self.resourceTypeName = @"播客评论";
    }else if ([resource_type isEqualToString:@"146"]){
        self.resourceTypeName = @"社团聊天";
    }else if ([resource_type isEqualToString:@"147"]){
        self.resourceTypeName = @"社团用户";
    }
    else{
        DRLog(@"举报类型%@",resource_type);
    }
}

- (void)setMass_member:(NSDictionary *)mass_member{
    _mass_member = mass_member;
    self.massMember = [NoticeAbout mj_objectWithKeyValues:mass_member];
}

- (void)setMass_chat_log:(NSDictionary *)mass_chat_log{
    _mass_chat_log = mass_chat_log;
    self.chatTeamM = [NoticeTeamChatModel mj_objectWithKeyValues:mass_chat_log];
}
- (void)setInvitation_comment_list:(NSArray *)invitation_comment_list{
    _invitation_comment_list = invitation_comment_list;
    if(invitation_comment_list.count){
        self.helpCommentArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in invitation_comment_list) {
            NoticeHelpCommentModel *model = [NoticeHelpCommentModel mj_objectWithKeyValues:dic];
            [self.helpCommentArr addObject:model];
        }
    }
}

- (void)setPodcast_comment:(NSDictionary *)podcast_comment{
    _podcast_comment = podcast_comment;
    self.comBokeModel = [NoticeVoiceComModel mj_objectWithKeyValues:podcast_comment];
}


- (void)setPodcast_barrage:(NSDictionary *)podcast_barrage{
    self.danmM = [NoticeDanMuListModel mj_objectWithKeyValues:podcast_barrage];
    
}

- (void)setDubbing_comment:(NSDictionary *)dubbing_comment{
    self.pyComM = [NoticeBBSComent mj_objectWithKeyValues:dubbing_comment];
}

- (void)setVoice_comment:(NSDictionary *)voice_comment{
    _voice_comment = voice_comment;
    if (voice_comment) {
        NoticeManagerModel *model = [NoticeManagerModel mj_objectWithKeyValues:voice_comment];
        self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:model.voice];
        if (model.comment.count) {
            self.comModel = [NoticeVoiceComModel mj_objectWithKeyValues:model.comment[0]];
        }
    }
}

- (void)setComment:(NSDictionary *)comment{
    _comment = comment;
    self.commentM = [NoticeBBSComent mj_objectWithKeyValues:comment];
}

- (void)setPhone_card:(NSDictionary *)phone_card{
    _phone_card = phone_card;
    self.cardInfo = [NoticeManagerModel mj_objectWithKeyValues:phone_card];
}

- (void)setData_type:(NSString *)data_type{
    _data_type = data_type;
    NSString *resource_type = data_type;
    if ([resource_type isEqualToString:@"1"]) {
        self.resourceTypeName = @"用户信息";
    }else if ([resource_type isEqualToString:@"2"]){
        self.resourceTypeName = @"心情";
    }else if ([resource_type isEqualToString:@"3"]){
        self.resourceTypeName = @"交流对话";
    }else if ([resource_type isEqualToString:@"4"]){
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"py.tc"];
    }else if ([resource_type isEqualToString:@"5"]){
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"py.py"];
    }else if ([resource_type isEqualToString:@"6"]){
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"hh.h"];
    }else if ([resource_type isEqualToString:@"7"]){
        self.resourceTypeName = @"词条";
    }else if ([resource_type isEqualToString:@"133"]){
        self.resourceTypeName = @"流星语";
    }
    else{
        DRLog(@"举报类型%@",resource_type);
    }
}

- (void)setData_from:(NSString *)data_from{
    _data_from = data_from;
    if (_data_from.intValue == 34) {
        self.data_fromName = @"上传心情簿封面";
    }else if (_data_from.intValue == 31){
        self.data_fromName = @"上传头像";
    }else if (_data_from.intValue == 39){
        self.data_fromName = @"上传时光机封面";
    }else if (_data_from.intValue == 38){
        self.data_fromName = @"上传词条封面";
    }else if (_data_from.intValue == 36){
        self.data_fromName = @"上传专辑封面";
    }else if (_data_from.intValue == 40){
        self.data_fromName = @"上传独立秘密封面";
    }else if (_data_from.intValue == 35){
        self.data_fromName = @"上传心情日历主题封面";
    }else if (_data_from.intValue == 101){
        self.data_fromName = @"用户昵称，简介";
    }else if (_data_from.intValue == 102){
        self.data_fromName = @"话题名称";
    }else if (_data_from.intValue == 103){
        self.data_fromName = @"台词名称";
    }else if (_data_from.intValue == 104){
        self.data_fromName = @"心情专辑名称";
    }
}

- (void)setArtwork:(NSDictionary *)artwork{
    _artwork = artwork;
    self.drawM = [NoticeDrawList mj_objectWithKeyValues:artwork];
}

- (void)setGraffiti:(NSDictionary *)graffiti{
    _graffiti = graffiti;
    self.tuyaModel = [NoticeDrawTuM mj_objectWithKeyValues:graffiti];
}

- (void)setDialog:(NSDictionary *)dialog{
    _dialog = dialog;
    self.managerM = [NoticeManagerModel mj_objectWithKeyValues:dialog];
    self.managerM.avatar_url = self.toUser.avatar_url;
    self.managerM.to_user_id = self.to_user_id;
    self.managerM.nick_name = self.toUser.nick_name;
    if ([self.managerM.chat_type isEqualToString:@"2"]) {
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"message.chat"];
    }else if ([self.managerM.chat_type isEqualToString:@"3"]) {
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"em.tuya"];
    }
    else{
        self.resourceTypeName = [NoticeTools getLocalStrWith:@"em.hs"];
    }
}

- (void)setVoice:(NSDictionary *)voice{
    _voice = voice;
    self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:voice];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.fromUser = [NoticeManagerUserInfo mj_objectWithKeyValues:from_user_info];
}

- (void)setTo_user_info:(NSDictionary *)to_user_info{
    _to_user_info = to_user_info;
    self.toUser = [NoticeManagerUserInfo mj_objectWithKeyValues:to_user_info];
}

@end
