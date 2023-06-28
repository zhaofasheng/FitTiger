//
//  NoticeChats.m
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChats.h"

@implementation NoticeChats

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tuyaDiaLogId":@"id"};
}

- (void)setContentText:(NSString *)contentText{
  
    contentText = [contentText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _contentText = contentText;
    if (!_contentText || !_contentText.length) {
        return;
    }
    self.attStr = [self setLabelSpacewithValue:contentText withFont:FIFTHTEENTEXTFONTSIZE];
    if ((GET_STRWIDTH(contentText, 15,30)) >= (DR_SCREEN_WIDTH-140)) {
        self.textWidth = DR_SCREEN_WIDTH-140;
    }else{
        self.textWidth = GET_STRWIDTH(contentText, 15,30)+3;
    }
    self.textHeight = [self getSpaceLabelHeight:contentText withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.textWidth]+20;
    if (self.textHeight < 35) {
        self.textHeight = 35;
    }
}

//返回文案
-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;//设置行间距
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

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5;
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

- (void)setFrom_avatar_url:(NSString *)from_avatar_url{
    _from_avatar_url = from_avatar_url;
    if (_from_avatar_url.length > 4) {
        self.avatar_url = _from_avatar_url;
    }
}

- (void)setRecognition_content:(NSString *)recognition_content{
    _recognition_content = recognition_content;
    if (recognition_content.length) {
        self.resource_content = recognition_content;
    }
    self.dialog_content = _recognition_content;
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.showTime = [NoticeTools updateTimeForRow:created_at];
}

- (void)setDialog_content_len:(NSString *)dialog_content_len{
    _dialog_content_len = dialog_content_len;
    self.resource_len = dialog_content_len;
}
- (void)setDialog_content_type:(NSString *)dialog_content_type{
    _dialog_content_type = dialog_content_type;
    self.resource_type = dialog_content_type;
    self.content_type = dialog_content_type;
}

- (void)setFirst_card_info:(NSDictionary *)first_card_info{
    _first_card_info = first_card_info;
    self.whiteModel = [NoticeWhiteVoiceListModel mj_objectWithKeyValues:first_card_info];
}


- (void)setShare_voice:(NSDictionary *)share_voice{
    _share_voice = share_voice;
    self.shareVoiceM = [NoticeShareVoiceModel mj_objectWithKeyValues:share_voice];
}

- (void)setShare_dubbing:(NSDictionary *)share_dubbing{
    _share_dubbing = share_dubbing;
    self.sharePyM = [NoticeShareVoiceModel mj_objectWithKeyValues:share_dubbing];
}

- (void)setShare_line:(NSDictionary *)share_line{
    _share_line = share_line;
    self.share_lineM = [NoticeShareVoiceModel mj_objectWithKeyValues:share_line];
}

- (void)setDialog_content_url:(NSString *)dialog_content_url{
    _dialog_content_url = dialog_content_url;
    self.resource_url = dialog_content_url;
}
- (void)setFrom_user_id:(NSString *)from_user_id{
    _from_user_id = from_user_id;
    if ([from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {
        self.is_self = @"1";
        self.isSelf = YES;
    }else{
        self.is_self = @"0";
        self.isSelf = NO;
    }
}
- (void)setUser_avatar_url:(NSString *)user_avatar_url{
    _user_avatar_url = user_avatar_url;
    self.avatar_url = user_avatar_url;
}

- (void)setTalking_topic:(NSDictionary *)talking_topic{
    _talking_topic = talking_topic;
    if (talking_topic) {
        self.chatTopicM = [NoticeChatTopicM mj_objectWithKeyValues:talking_topic];
    }
}

- (void)setDialog_content:(NSString *)dialog_content{
    _dialog_content = dialog_content;
    self.contentHeight = GET_STRHEIGHT(dialog_content, 14, 174)+10;
}

- (void)setResource_content:(NSString *)resource_content{
    _resource_content = resource_content;
    _dialog_content = resource_content;
}

- (void)setContent_type:(NSString *)content_type{
    _content_type = content_type;
    if (_content_type.intValue == 2) {
        self.imgCellHeight = 50;
    }else{
        self.imgCellHeight = 0;
    }
    
}

- (void)setToUserInfo:(NSDictionary *)toUserInfo{
    _toUserInfo = toUserInfo;
    self.sendUserM = [NoticeUserInfoModel mj_objectWithKeyValues:toUserInfo];
}
@end
