//
//  NoticeTeamChatModel.m
//  NoticeXi
//
//  Created by li lei on 2023/6/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamChatModel.h"

@implementation NoticeTeamChatModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"logId":@"id"};
}

- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUserM = [NoticeAbout mj_objectWithKeyValues:from_user];
    self.isSelf = [self.fromUserM.userId isEqualToString:[NoticeTools getuserId]]?YES:NO;
}

- (void)setContent_type:(NSString *)content_type{
    _content_type = content_type;
    self.contentType = content_type.integerValue;
}

- (void)setCall_chat:(NSDictionary *)call_chat{
    _call_chat = call_chat;
    self.userMsg = [NoticeTeamChatModel mj_objectWithKeyValues:call_chat];
    if (self.userMsg.status.intValue != 1) {
        self.userMsg.content_type = @"1";
        self.userMsg.content = @"内容已不存在";
    }
    if(self.userMsg.contentType == 2){
        self.userMsg.content = @"「图片」";
    }else if (self.userMsg.contentType == 3){
        self.userMsg.content = @"「语音」";
    }
    
    self.callChatAttStr = [NoticeTools getStringWithLineHight:4 string:self.userMsg.content];
    
    if ((GET_STRWIDTH(self.userMsg.content, 13,18)) >= (DR_SCREEN_WIDTH-160)) {
        self.callChatTextWidth = DR_SCREEN_WIDTH-160;
    }else{
        self.callChatTextWidth = GET_STRWIDTH(self.userMsg.content, 13,30)+3;
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    self.contentAtt = [NoticeTools getStringWithLineHight:4 string:content];
    
    CGFloat width = GET_STRWIDTH(content, 16, 22);
    CGFloat maxWidth = DR_SCREEN_WIDTH-20 - 63*2;
    //20为文本左右间距之和  63为文本视图左右间距之和
    
    
    if(width <= maxWidth){
        self.textWidth = width;
    }else{
        self.textWidth = maxWidth;
    }
    
    //22为只有一行文本时候的文本高度，上下间距为10，文本加上上下高度一行为22+20
    self.textHeight = [self getSpaceLabelHeight:content withFont:SIXTEENTEXTFONTSIZE withWidth:self.textWidth];
    if(self.textHeight <= 22){
        self.textHeight = 22;
    }
}

- (void)setDel_user:(NSDictionary *)del_user{
    _del_user = del_user;
    self.delUserM = [NoticeAbout mj_objectWithKeyValues:del_user];
}

- (void)refreshCallChatHeight{
    if(self.status.intValue == 4){//撤回的消息
        if([self.fromUserM.userId isEqualToString:[NoticeTools getuserId]]){//撤回的是自己的消息
            self.revokeOrDeleteStr = @"你 撤回了一条消息";
        }else{
            self.revokeOrDeleteStr = [NSString stringWithFormat:@"%@ 撤回了一条消息",self.fromUserM.mass_nick_name];
        }
        self.cellHeight = 50;
        return;
    }
    
    if(self.status.intValue == 3){//删除的消息
        if([self.fromUserM.userId isEqualToString:[NoticeTools getuserId]]){//删除的是自己的消息
            self.revokeOrDeleteStr = [NSString stringWithFormat:@"%@ 删除了 你的消息",self.delUserM.mass_nick_name];
        }else{
            self.revokeOrDeleteStr = [NSString stringWithFormat:@"%@ 删除了 %@的消息",self.delUserM.mass_nick_name,self.fromUserM.mass_nick_name];
        }
        self.cellHeight = 50;
        return;
    }
    
    if (self.call_chat) {
        if(self.userMsg.status.intValue != 1){
            self.userMsg.content = @"内容已不存在";
            self.callChatAttStr = [NoticeTools getStringWithLineHight:4 string:self.userMsg.content];
            
            if ((GET_STRWIDTH(self.userMsg.content, 13,18)) >= (DR_SCREEN_WIDTH-160)) {
                self.callChatTextWidth = DR_SCREEN_WIDTH-160;
            }else{
                self.callChatTextWidth = GET_STRWIDTH(self.userMsg.content, 13,30)+3;
            }
        }
        
        if (self.callChatTextWidth < (GET_STRWIDTH(self.userMsg.fromUserM.mass_nick_name, 13, 18)+30)) {//如果被引用的消息长度小于昵称宽度
            self.callChatTextWidth = GET_STRWIDTH(self.userMsg.fromUserM.mass_nick_name, 13, 18)+30;
        }
        
        if (self.callChatTextWidth < 60) {
            self.callChatTextWidth = 60;
        }
        
        if ((self.callChatTextWidth +16) > self.textWidth) {//如果被引用的消息宽度大于本身的消息宽度，则取被引用的消息宽度
            self.textWidth = self.callChatTextWidth+16;
        }else{//取消息本身的高度
            self.callChatTextWidth = self.textWidth - 16;
        }
        
        self.callChatTextHeight = [self getSpaceLabelHeight:self.userMsg.content withFont:THRETEENTEXTFONTSIZE withWidth:self.callChatTextWidth];
        
        
        self.textHeight = [self getSpaceLabelHeight:self.content withFont:SIXTEENTEXTFONTSIZE withWidth:self.textWidth];
        if(self.textHeight <= 22){
            self.textHeight = 22;
        }
    }
    
    //计算cell高度
    if(self.contentType == 1){//文字消息
        if(self.userMsg){//引用消息
            self.cellHeight = 20 + self.textHeight+40 +10 + (30+self.callChatTextHeight+8+10);
        }else{
            self.cellHeight = 20 + self.textHeight+40 +10;
        }
    }else if (self.contentType == 2){//图片消息
        self.cellHeight = 20 + 138-20+40 +10;

    }else if (self.contentType == 3){//语音消息
        self.cellHeight = 20 + 44-20+40 +10;
    }
 
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = created_at;
    self.showTime = [NoticeTools updateTimeForRow:created_at];
}

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4;
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
@end
