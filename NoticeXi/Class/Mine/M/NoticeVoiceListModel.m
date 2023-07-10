//
//  NoticeVoiceListModel.m
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceListModel.h"
#import "ZFSDateFormatUtil.h"
#import <CoreText/CoreText.h>
@implementation NoticeVoiceListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"lastShareId":@"id",@"voiceNum":@"count"};
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if (_title && _title.length) {
        self.titleHeight = 40-15;
    }
}

- (void)setChat:(NSDictionary *)chat{
    _chat = chat;
    NoticeVoiceListSubModel *diaLogNumM = [NoticeVoiceListSubModel mj_objectWithKeyValues:chat];
    self.dialog_num = diaLogNumM.dialog_num;
}

- (void)setVoice_content:(NSString *)voice_content{
    _voice_content = voice_content;
    self.textContent = voice_content;
}

- (void)setCollection:(NSDictionary *)collection{
    _collection = collection;
    NoticeVoiceListSubModel *collId = [NoticeVoiceListSubModel mj_objectWithKeyValues:collection];
    if (collId.userId) {
        self.is_collected = @"1";
    }
}

- (void)setTextContent:(NSString *)textContent{
    //_textContent = textContent;
    NSArray * array = [textContent componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {
//        if ([array[i] length]) {
//            [newArr addObject:array[i]];
//        }
        [newArr addObject:array[i]];
    }
    
    _textContent = [newArr componentsJoinedByString:@"\n"];
    
    self.textHeight = [self getSpaceLabelHeight:_textContent withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30-40];
    self.zjContentHeight = [self getSpaceLabelHeight:_textContent withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-60-60];
    
    if (self.zjContentHeight < 30) {
        self.zjContentHeight = 30;
    }
    
    if (self.textHeight < 30) {
        self.textHeight = 30;
    }
  
    if (self.textHeight > (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-36-125-50-BOTTOM_HEIGHT - 125-48)) {//文字心情详情高度
        self.isMoreHeight = YES;
        self.moreHeight = self.textHeight - (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-36-125-50-BOTTOM_HEIGHT - 125-48);
    }else{
        self.moreHeight = 0;
        self.isMoreHeight = NO;
    }
    
    if (self.textHeight > (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-36-125-50-BOTTOM_HEIGHT - 125-48-66)) {//文字心情详情高度
        self.isMoreSYYHeight = YES;
    }else{
        self.isMoreSYYHeight = NO;
    }
    
    if (textContent.length) {
        self.allTextAttStr = [self setLabelSpacewithValue:_textContent withFont:FIFTHTEENTEXTFONTSIZE];
        
        if ([[self getSeparatedLinesFromLabel:_textContent width:DR_SCREEN_WIDTH-70 font:FIFTHTEENTEXTFONTSIZE] count]> 5) {
            self.isMoreFiveLines = YES;
            NSArray *array = [self getSeparatedLinesFromLabel:_textContent width:DR_SCREEN_WIDTH-70 font:FIFTHTEENTEXTFONTSIZE];
            NSString *line4String = array[4];
            
            if ([NoticeTools getLocalType ]== 1) {
                if (line4String.length < 7) {
                    line4String = [NSString stringWithFormat:@"%@...More",line4String];
                }
                self.showText = [NSString stringWithFormat:@"%@%@%@%@%@...More", array[0], array[1], array[2], array[3],[line4String substringToIndex:line4String.length-7]];
            }else{
                if (line4String.length < 5) {
                    line4String = [NSString stringWithFormat:@"%@...全部",line4String];
                }
                self.showText = [NSString stringWithFormat:@"%@%@%@%@%@...全部", array[0], array[1], array[2], array[3],[line4String substringToIndex:line4String.length-5]];
            }
            self.fiveTextHeight = [self getSpaceLabelHeight:self.showText withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-70];
            
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paraStyle.alignment = NSTextAlignmentLeft;
            paraStyle.lineSpacing = 14;//设置行间距
            paraStyle.hyphenationFactor = 1.0;
            paraStyle.firstLineHeadIndent = 0.0;
            paraStyle.paragraphSpacingBefore = 0.0;
            paraStyle.headIndent = 0;
            paraStyle.tailIndent = 0;
            //设置label的attributedText
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.showText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paraStyle}];
            if ([NoticeTools getLocalType] == 1) {
                [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0099E6"]} range:NSMakeRange(self.showText.length-4, 4)];
            }else{
                [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0099E6"]} range:NSMakeRange(self.showText.length-2, 2)];
            }
            
            self.fiveAttTextStr = attStr;
        }else{
            self.isMoreFiveLines = NO;
        }
    }
}

- (void)setState_info:(NSDictionary *)state_info{
    _state_info = state_info;
    self.statusM = [NoticeVoiceStatusDetailModel mj_objectWithKeyValues:state_info];
    if (self.statusM.picture_url.length > 9 && !(self.topicHeight > 0)) {
        self.topicHeight = 40;
    }
}

- (void)setVoice_url:(NSString *)voice_url{
    _voice_url = voice_url;
    if (voice_url) {
        self.voiceName = [voice_url pathExtension];
    }
}

//返回文案
-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;//设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}

//获取label上每一行的文字
- (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{

    return [NoticeTools getSeparatedLinesFromLabel:text width:width font:font textHeight:self.textHeight];
}

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (void)setAlbum:(NSArray *)album{
    _album = album;
    for (NSDictionary *dic in album) {
        NoticeZjModel *zjm = [NoticeZjModel mj_objectWithKeyValues:dic];
        [self.albumArr addObject:zjm];
    }
}

- (NSMutableArray *)albumArr{
    if (!_albumArr) {
        _albumArr = [[NSMutableArray alloc] init];
    }
    return _albumArr;
}

- (void)setTitle_name:(NSString *)title_name{
    _title_name = title_name;
    self.title = title_name;
}


- (void)setSubscription_id:(NSString *)subscription_id{
    _subscription_id = subscription_id;
    self.be_subscribed = subscription_id;
}

- (void)setResource_content:(NSString *)resource_content{
    _resource_content = resource_content;
    if (_resource_content.length) {
        self.contentHeight = 30+GET_STRHEIGHT(resource_content, 14, DR_SCREEN_WIDTH-50);
    }
}

- (void)setUser:(NSDictionary *)user{
    _user = user;
    self.subUserModel = [NoticeVoiceListSubModel mj_objectWithKeyValues:user];
}

- (void)setUser_id:(NSString *)user_id{
    _user_id = user_id;
    if ([user_id isEqualToString:[NoticeTools getuserId]]) {
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        NoticeVoiceListSubModel *subM = [NoticeVoiceListSubModel new];
        subM.userId = user_id;
        subM.nick_name = userM.nick_name;
        subM.avatar_url = userM.avatar_url;
        subM.identity_type = userM.identity_type;
        self.subUserModel = subM;
    }
}

- (void)setSubUserModel:(NoticeVoiceListSubModel *)subUserModel{
    _subUserModel = subUserModel;
    if ([subUserModel.userId isEqualToString:[NoticeTools getuserId]]) {
        self.isSelf = YES;
    }else{
        self.isSelf = NO;
    }
}

- (void)setShared_at:(NSString *)shared_at{
    _shared_at = shared_at;
    self.sharedTime = [NoticeTools updateTimeForRow:shared_at];
    if (shared_at.intValue) {
        self.is_shared = @"1";
    }else{
        self.is_shared = @"0";
    }
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
    
    self.defaultImg = [NSString stringWithFormat:@"beijing%d.jpg",arc4random() % 40+1];
    self.creatTime1 = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy.MM.dd HH:mm:ss"];
    self.creatTime = [NoticeTools updateTimeForRowVoice:created_at];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curentTimeZreoY = [ZFSDateFormatUtil dateFullStringWithInterval:currentTime formatStyle:@"yyyy-MM-dd"];
    if ([curentTimeZreoY isEqualToString:[NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"]]) {
        self.isToday = YES;
    }else{
        self.isToday = NO;
    }
    
    self.day = [NoticeTools getDayFromNow:created_at];
    self.hour = [NoticeTools getHourFormNow:created_at];
    self.timeSgj = [NSString stringWithFormat:@"%@ %@",[NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd"],self.hour];
    self.photoTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy-MM-dd HH:mm"];
    
    self.textListTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"MM.dd"];
    self.longTextListTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy.MM.dd"];
    
    NSString *mon = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"MM"];
    NSString *year = [NoticeTools timeDataAppointFormatterWithTime:created_at.integerValue appointStr:@"yyyy"];
    
    self.year = [NSString stringWithFormat:@"%@年",year];
    
    if ([mon isEqualToString:@"01"]) {
        mon = @"Jan";
    }else if ([mon isEqualToString:@"02"]){
        mon = @"Feb";
    }else if ([mon isEqualToString:@"03"]){
        mon = @"Mar";
    }else if ([mon isEqualToString:@"04"]){
        mon = @"Apr";
    }else if ([mon isEqualToString:@"05"]){
        mon = @"May";
    }else if ([mon isEqualToString:@"06"]){
        mon = @"Jun";
    }else if ([mon isEqualToString:@"07"]){
        mon = @"Jul";
    }else if ([mon isEqualToString:@"08"]){
        mon = @"Aug"; 
    }else if ([mon isEqualToString:@"09"]){
        mon = @"Sept";
    }else if ([mon isEqualToString:@"10"]){
        mon = @"Oct";
    }else if ([mon isEqualToString:@"11"]){
        mon = @"Nov";
    }else if ([mon isEqualToString:@"12"]){
        mon = @"Dec";
    }
    self.monTime = [NSString stringWithFormat:@"%@ %@",mon,year];
}

- (void)setTopic_name:(NSString *)topic_name{
    _topic_name = [topic_name stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (_topic_name && _topic_name.length) {
        self.topicName = [NSString stringWithFormat:@"#%@#",_topic_name];
        if (!(self.topicHeight > 0)) {
            self.topicHeight = 40;
        }
    }
}

- (void)setBgm_name:(NSString *)bgm_name{
    _bgm_name = bgm_name;
    if (bgm_name) {
        self.bgmHeight = 30;
    }else{
        self.bgmHeight = 0;
    }
}

- (void)setFirst_comment:(NSArray *)first_comment{
    _first_comment = first_comment;
    if (first_comment.count) {
        self.comModel = [NoticeVoiceComModel mj_objectWithKeyValues:first_comment[0]];
    }
    
}

- (void)setResource:(NSDictionary *)resource{
    _resource = resource;
    if (resource) {
        self.movieM = [NoticeMovie mj_objectWithKeyValues:resource];
        self.scroMovieM = [NoticeMovie mj_objectWithKeyValues:resource];
        self.bookM = [NoticeBook mj_objectWithKeyValues:resource];
        self.songM = [NoticeSong mj_objectWithKeyValues:resource];
    }
}

- (void)setResource_type:(NSString *)resource_type{
    _resource_type = resource_type;
    if (!resource_type) {
        self.resource = nil;
        return;
    }
    if (!self.resource) {
        return;
    }
    if ([resource_type isEqualToString:@"1"]) {
        self.movieM = [NoticeMovie mj_objectWithKeyValues:self.resource];
        self.scroMovieM = [NoticeMovie mj_objectWithKeyValues:self.resource];
    
    }else if ([resource_type isEqualToString:@"2"]){
        self.bookM = [NoticeBook mj_objectWithKeyValues:self.resource];
        
    }else if ([resource_type isEqualToString:@"3"]){
        self.songM = [NoticeSong mj_objectWithKeyValues:self.resource];
    }else{
        self.resource = nil;
    }
}

- (void)setIntersect_tags:(NSArray *)intersect_tags{
    _intersect_tags = intersect_tags;
    if (_intersect_tags.count) {
        if (_intersect_tags.count == 1) {
            self.insterString = _intersect_tags[0];
        }else if (_intersect_tags.count == 2){
            self.insterString = [NSString stringWithFormat:@"%@、%@",intersect_tags[0],intersect_tags[1]];
        }else if (_intersect_tags.count == 3){
            self.insterString = [NSString stringWithFormat:@"%@、%@、%@",intersect_tags[0],intersect_tags[1],intersect_tags[2]];
        }
    }
}

- (void)setMovie:(NSDictionary *)movie{
    _movie = movie;
    if (movie) {
        self.movieM = [NoticeMovie mj_objectWithKeyValues:movie];
        self.scroMovieM = [NoticeMovie mj_objectWithKeyValues:movie];
    }
  
}

- (void)setVoice_len:(NSString *)voice_len{
    _voice_len = voice_len;
    self.vlaueSpeed = 1/_voice_len.intValue;
}

- (void)setPlayed_num:(NSString *)played_num{
    if (played_num.integerValue) {
        _played_num = played_num;
    }else{
        _played_num = @"";
    }
}

- (void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    self.contentWidth = GET_STRWIDTH(contentStr, 12, 40);
}

- (void)setRecognition_content:(NSString *)recognition_content{
    _recognition_content = recognition_content;
    if (recognition_content.length) {
        self.resource_content = recognition_content;
    }
    self.contentStr = recognition_content;
}
@end
