//
//  NoticeGroupChatModel.m
//  NoticeXi
//
//  Created by li lei on 2020/8/13.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeGroupChatModel.h"

@implementation NoticeGroupChatModel

- (void)setFrom_user_id:(NSString *)from_user_id{
    _from_user_id = from_user_id;
    self.isSelf = [_from_user_id isEqualToString:[NoticeTools getuserId]]?YES:NO;
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.showTime = [NoticeTools updateTimeForRow:created_at];
    self.sendTime = [NoticeTools timeDataAppointFormatterWithTime:created_at.intValue appointStr:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)setArtwork:(NSDictionary *)artwork{
    _artwork = artwork;
    self.drawM = [NoticeDrawList mj_objectWithKeyValues:artwork];
}

- (void)setVoice:(NSDictionary *)voice{
    _voice = voice;
    self.voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:voice];
    self.voice_url = self.voiceM.voice_url;
    self.voice_len = self.voiceM.voice_len;
}

- (void)setDubbing:(NSDictionary *)dubbing{
    _dubbing = dubbing;
    self.pyModel = [NoticeClockPyModel mj_objectWithKeyValues:dubbing];
    
    self.voice_url = self.pyModel.dubbing_url;
    self.voice_len = self.pyModel.dubbing_len;
}

- (void)setAssoc_nick_name:(NSString *)assoc_nick_name{
    _assoc_nick_name = assoc_nick_name;
    NSString *str = [NSString stringWithFormat:@"%@%@",assoc_nick_name,[NoticeTools getLocalType]==1?@"Finished attendance":@"完成今日打卡"];
    self.signNameHeight = [self getSpaceLabelHeight:str withFont:FIFTHTEENTEXTFONTSIZE withWidth:170]+20;
    self.signAttStr = [self setLabelSpacewithValue:str withFont:FIFTHTEENTEXTFONTSIZE];
    
}

- (void)setContent:(NSString *)content{
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _content = content;
    if (!_content || !_content.length) {
        return;
    }
    self.attStr = [self setLabelSpacewithValue:content withFont:FIFTHTEENTEXTFONTSIZE];
    if ((GET_STRWIDTH(content, 15,30)) >= (DR_SCREEN_WIDTH-140)) {
        self.contentWidth = DR_SCREEN_WIDTH-140;
    }else{
        self.contentWidth = GET_STRWIDTH(content, 15,30)+3;
    }
    self.contentHeight = [self getSpaceLabelHeight:content withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.contentWidth]+20;
    if (self.contentHeight < 35) {
        self.contentHeight = 35;
    }
    self.cellHeight = self.contentHeight+30;
    
    self.groupAttStr = [self setLabelSpacewithValue:content withFont:THRETEENTEXTFONTSIZE];

    CGFloat groupLHeight = [self getSpaceLabelHeight:content withFont:THRETEENTEXTFONTSIZE withWidth:(DR_SCREEN_WIDTH-40)/2-60];
    if (groupLHeight < 30) {
        self.assosContentCellHeight = 30;
    }else if (groupLHeight > (DR_SCREEN_WIDTH-40)/2/167*202-90){
        self.assosContentCellHeight = (DR_SCREEN_WIDTH-40)/2/167*202-90;
    }else{
        self.assosContentCellHeight = groupLHeight;
    }
}

- (void)setCall_chat:(NSDictionary *)call_chat{
    _call_chat = call_chat;
    self.callChat = [NoticeGroupChatModel mj_objectWithKeyValues:call_chat];
    
    if (self.callChat.type.intValue == 1 && self.callChat.content) {//被引用的是文本消息
        self.callChatAttStr = [self setLabelSpacewithValue:self.callChat.content withFont:TWOTEXTFONTSIZE];
        
        if ((GET_STRWIDTH(self.callChat.content, 12,30)) >= (DR_SCREEN_WIDTH-160)) {
            self.callChatTextWidth = DR_SCREEN_WIDTH-160;
        }else{
            self.self.callChatTextWidth = GET_STRWIDTH(self.callChat.content, 12,30)+3;
        }
    }
    
    if (self.callChat.type.intValue == 3) {
        if (self.callChat.voice_len.integerValue < 5) {
            self.CallVoiceViewWidth = 100;
        }else if (self.callChat.voice_len.integerValue >= 5 && self.callChat.voice_len.integerValue <= 105){
            self.CallVoiceViewWidth = 100+self.callChat.voice_len.integerValue;
        }else{
            self.CallVoiceViewWidth = 100+self.callChat.voice_len.integerValue;
        }
        self.callChatTimeLen = [NSString stringWithFormat:@"%@s",self.callChat.voice_len];
    }
    
}


//语音引用文本消息刷新UI
- (void)voiceUseTextHeight{
    
    if (self.callChatTextWidth < GET_STRWIDTH(self.callChat.assoc_nick_name, 13, 30)) {//如果被引用的消息长度小于昵称宽度
        self.callChatTextWidth = GET_STRWIDTH(self.callChat.assoc_nick_name, 13, 30)+22+25+10;
    }
    
    if (self.callArr.count) {//如果存在艾特人
        if ((self.callChatTextWidth + 40) < self.voiceAtrealWidth) {//如果小于艾特的人的文本宽度
            self.callChatTextWidth = self.voiceAtrealWidth - 40+25;
        }else{
           self.voiceAtrealWidth = self.callChatTextWidth+20;
        }
    }
    
    if (self.callChatTextWidth < self.CallVoiceViewWidth) {//艾特人的视图小于当前语音消息宽度
       self.callChatTextWidth = self.CallVoiceViewWidth+40+25;
    }
        
    if (self.callChatTextWidth < self.playerVoiceViewWidth) {//如果还小于语音长度
        self.callChatTextWidth = self.playerVoiceViewWidth-20;
    }
    
    self.callChatTextViewWidth = self.callChatTextWidth+20;
    self.callChatTextHeight = [self getSpaceLabelHeight:self.callChat.content withFont:TWOTEXTFONTSIZE withWidth:self.callChatTextWidth]+15;
    self.callChatTextViewHeight = self.callChatTextHeight+30;
    
    if (self.callChatTextViewHeight < 65) {
        self.callChatTextViewHeight = 65;
    }
    
    self.voiceAtrealHeight = [self getSpaceLabelHeight:self.atPeopleStr withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.voiceAtrealWidth];

    self.voiceAtWidth = self.voiceAtrealWidth;
    self.voiceAtHeight = self.voiceAtrealHeight+10;
    if (self.voiceAtHeight < 40) {
        self.voiceAtHeight = 40;
    }
    
    self.voiceUseTextViewWidth = self.callChatTextViewWidth+20;
    self.voiceUseTextViewHeght = self.callChatTextViewHeight+10+10+(self.callArr.count? self.voiceAtHeight:5)+35;
}

- (void)refreshCallChatHeight{
    
    if ((GET_STRWIDTH(self.content, 15,30)) >= (DR_SCREEN_WIDTH-140)) {
        self.contentWidth = DR_SCREEN_WIDTH-140;
    }else{
        self.contentWidth = GET_STRWIDTH(self.content, 15,30)+3;
    }
        
    if ((GET_STRWIDTH(self.callChat.content, 12,30)) >= (DR_SCREEN_WIDTH-160)) {
        self.callChatTextWidth = DR_SCREEN_WIDTH-160;
    }else{
        self.self.callChatTextWidth = GET_STRWIDTH(self.callChat.content, 12,30)+3;
    }
    
    if (self.event_type.intValue == 3 && self.callChat.type.intValue == 1 && self.type.intValue == 1) {
        
        if (self.callChatTextWidth < GET_STRWIDTH(self.assoc_nick_name, 13, 30)) {//如果被引用的消息长度小于昵称宽度
            self.callChatTextWidth = GET_STRWIDTH(self.assoc_nick_name, 13, 30)+22;
        }
        
        if (GET_STRWIDTH(self.callChat.content, 12,30) < 60 && GET_STRWIDTH(self.assoc_nick_name, 13, 30) < 60) {
            self.callChatTextWidth = 60+22;
        }
        
        if ((self.callChatTextWidth +20) > self.contentWidth) {//如果被引用的消息宽度大于本身的消息宽度，则取被引用的消息宽度
            self.contentWidth = self.callChatTextWidth+20;
            self.contentHeight = [self getSpaceLabelHeight:self.content withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.contentWidth]+20;
            if (self.contentHeight < 35) {
                self.contentHeight = 35;
            }
            
            self.callChatTextHeight = [self getSpaceLabelHeight:self.callChat.content withFont:TWOTEXTFONTSIZE withWidth:self.callChatTextWidth]+20;
            self.callChatTextViewWidth = self.callChatTextWidth+20;
            self.callChatTextViewHeight = self.callChatTextHeight+30;
        }else{//取消息本身的高度
            self.callChatTextWidth = self.contentWidth - 20;
            self.callChatTextHeight = [self getSpaceLabelHeight:self.callChat.content withFont:TWOTEXTFONTSIZE withWidth:self.callChatTextWidth]+20;
            self.callChatTextViewWidth = self.callChatTextWidth+20;
            self.callChatTextViewHeight = self.callChatTextHeight+30;
            
            self.contentHeight = [self getSpaceLabelHeight:self.content withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.contentWidth]+20;
            if (self.contentHeight < 35) {
                self.contentHeight = 35;
            }
        }
    }
}

- (void)refreshCallChatImageHeight{
    if ((GET_STRWIDTH(self.content, 15,30)) >= (DR_SCREEN_WIDTH-140)) {
        self.contentWidth = DR_SCREEN_WIDTH-140;
    }else{
        self.contentWidth = GET_STRWIDTH(self.content, 15,30)+3;
    }
    
    if (self.contentWidth < (GET_STRWIDTH(self.callChat.assoc_nick_name, 13, 30)+20+25)) {//如果内容宽度小于被引用的人的昵称宽度
        self.contentWidth = GET_STRWIDTH(self.callChat.assoc_nick_name, 13, 30)+20+25;

        if (self.contentWidth < 80) {//如果还小于图片视图宽度
            self.contentWidth = 90;
        }
        self.contentHeight = [self getSpaceLabelHeight:self.content withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.contentWidth]+20;
        if (self.contentHeight < 35) {
            self.contentHeight = 35;
        }
    }
    
}

- (void)voiceUseImgHeight{
    CGFloat width = 0;
    if ((GET_STRWIDTH(self.callChat.assoc_nick_name, 13,30)) > self.playerVoiceViewWidth) {//如果被引用的昵称长度大于语音条长度
        width = (GET_STRWIDTH(self.callChat.assoc_nick_name, 13,30))+20+25;
    }else{
        width = self.playerVoiceViewWidth+25;
    }
    
    if (self.callArr.count) {//如果存在艾特人
        if (width > self.voiceAtrealWidth) {//如果图片视图大于艾特文本宽度
            self.voiceAtrealWidth = width;
        }else{
            width = self.voiceAtrealWidth;
        }
        
        self.voiceAtrealHeight = [self getSpaceLabelHeight:self.atPeopleStr withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.voiceAtrealWidth];
        self.voiceAtWidth = self.voiceAtrealWidth;
        self.voiceAtHeight = self.voiceAtrealHeight+10;
        if (self.voiceAtHeight < 40) {
            self.voiceAtHeight = 40;
        }
    }
    
    self.voiceUseImgViewWidth = width+20;
    self.voiceUseImgViewHeght = 10+100+ (self.callArr.count?(self.voiceAtHeight+5):10)+35+10;
}

- (void)voiceUseVoiceHeight{
    CGFloat width = 0;
    if ((GET_STRWIDTH(self.callChat.assoc_nick_name, 13,30)) > self.CallVoiceViewWidth) {//如果被引用的昵称长度大于被引用的语音条长度
        width = (GET_STRWIDTH(self.callChat.assoc_nick_name, 13,30))+20+25;
    }else{
        width = self.CallVoiceViewWidth+20+25;
    }
    
    if (width < self.playerVoiceViewWidth) {//如果引用视图宽度小于当前语音条宽度
        width = self.playerVoiceViewWidth;
    }
    if (self.callArr.count) {//如果存在艾特人
        if (width > self.voiceAtrealWidth) {//如果图片视图大于艾特文本宽度
            self.voiceAtrealWidth = width;
        }else{
            width = self.voiceAtrealWidth;
        }
        
        self.voiceAtrealHeight = [self getSpaceLabelHeight:self.atPeopleStr withFont:FIFTHTEENTEXTFONTSIZE withWidth:self.voiceAtrealWidth];
        self.voiceAtWidth = self.voiceAtrealWidth;
        self.voiceAtHeight = self.voiceAtrealHeight+10;
        if (self.voiceAtHeight < 40) {
            self.voiceAtHeight = 40;
        }
    }
    self.voiceUseVoiceViewWidth = width+20;
    self.voiceUseVoiceViewHeght = 10+75+(self.callArr.count?(self.voiceAtHeight+5):10)+35+10;
}

- (void)setVoice_len:(NSString *)voice_len{
    _voice_len = voice_len;
    if (voice_len.integerValue < 5) {
        self.playerVoiceViewWidth = 120;
    }else if (voice_len.integerValue >= 5 && voice_len.integerValue <= 105){
        self.playerVoiceViewWidth = 120+voice_len.integerValue;
    }else{
        self.playerVoiceViewWidth = 120+voice_len.integerValue;
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

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",(long)seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",(long)seconds%60];
    //format of time
    if (str_second.integerValue < 10) {
        str_second = [NSString stringWithFormat:@"0%@",str_second];
    }
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
    
}

- (void)setLevel:(NSString *)level{
    _level = level;
    self.levelImgName = [NSString stringWithFormat:@"Image_leave%d",level.intValue>15?15:level.intValue];
    self.levelImgIconName = [NSString stringWithFormat:@"Image_icon%d",level.intValue>10?11:level.intValue];
    self.levelName = [NSString stringWithFormat:@"Lv%@",level];
}

@end
