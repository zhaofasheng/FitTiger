//
//  NoticeTeamChatCell.m
//  NoticeXi
//
//  Created by li lei on 2023/6/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeTeamChatCell.h"
#import "UIView+CLSetRect.h"
#import "RXPopMenu.h"
#import "NoticeXi-Swift.h"
#import "NoticeSuperMangerClickPersongController.h"
@implementation NoticeTeamChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.contentView.userInteractionEnabled = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,20, 40, 40)];
        [_iconImageView setAllCorner:20];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-12, CGRectGetMaxY(_iconImageView.frame)-12,12, 12)];
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(63, self.iconImageView.frame.origin.y, DR_SCREEN_WIDTH-63*2, 17)];
        self.nickNameL.font = TWOTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.nickNameL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nickNameL];
        
        self.contentV = [[UIView alloc] initWithFrame:CGRectMake(63, _iconImageView.frame.origin.y-20, 0, 0)];
        self.contentV.layer.cornerRadius = 10;
        self.contentV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.contentV];
        self.contentV.userInteractionEnabled = YES;
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10,10,0, 17)];
        self.contentL.font = SIXTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.contentL.textAlignment = NSTextAlignmentLeft;
        [self.contentV addSubview:self.contentL];
        self.contentL.numberOfLines = 0;
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
        self.timeL.font = TWOTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeL];
        
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.3;
        [self.contentV addGestureRecognizer:longPressDeleT];
        
        _sendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 14, 100, 150)];
        _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        _sendImageView.layer.cornerRadius = 5;
        _sendImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag)];
        [_sendImageView addGestureRecognizer:tapImg];
        [self.contentView addSubview:_sendImageView];
        _sendImageView.hidden = YES;
        UILongPressGestureRecognizer *longPressDeleT1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT1.minimumPressDuration = 0.3;
        [self.sendImageView addGestureRecognizer:longPressDeleT1];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 45,125, 44)];
        _playerView.delegate = self;
        _playerView.isThird = YES;
        _playerView.noNeedLizi = YES;
        [_playerView.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [self.contentView addSubview:_playerView];
        _playerView.hidden = YES;
        UILongPressGestureRecognizer *longPressDeleT2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT2.minimumPressDuration = 0.3;
        [self.playerView addGestureRecognizer:longPressDeleT2];
        
        self.failButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.failButton setImage:UIImageNamed(@"Image_failimg") forState:UIControlStateNormal];
        [self.contentView addSubview:self.failButton];
        [self.failButton addTarget:self action:@selector(failClick) forControlEvents:UIControlEventTouchUpInside];
        self.failButton.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editNameNotice:) name:@"CHANGETEAMMASSNICKNAMENotification" object:nil];
    }
    return self;
}


- (void)editNameNotice:(NSNotification*)notification{
    NSDictionary *Dictionary = [notification userInfo];
    NSString *userId = Dictionary[@"userId"];
    NSString *name = Dictionary[@"nickName"];
    if([self.chatModel.from_user_id isEqualToString:userId]){
        self.chatModel.fromUserM.mass_nick_name = name;
        self.nickNameL.text = name;
    }
}

- (void)failClick{
    if(self.reSendMsgBlock){
        self.reSendMsgBlock(self.chatModel);
    }
}

- (void)deleTapT:(UILongPressGestureRecognizer *)tap{

    if (tap.state == UIGestureRecognizerStateBegan) {
        NSArray * showItems = nil;
        if (!self.isjoin.boolValue) {
            return;
        }
        if(self.chatModel.isSaveCace){
            return;
        }
        if(self.chatModel.isSelf){//自己的消息
            if(self.chatModel.contentType == 1){
                showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"复制"],[RXPopMenuItem itemTitle:@"撤回"]];
            }else{
                showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"撤回"]];
            }
        }
        else{//长按别人的消息
     
            if(self.identity.intValue == 3){//自己是超级管理员
                if(self.chatModel.contentType == 1){
                    showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"复制"],[RXPopMenuItem itemTitle:@"删除"],[RXPopMenuItem itemTitle:@"举报"]];
                }else{
                    showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"删除"],[RXPopMenuItem itemTitle:@"举报"]];
                }
            }else if(self.identity.intValue > 1){//自己是vip
                if(self.chatModel.fromUserM.identity.intValue > 1){//对方也是vip
                    if(self.chatModel.contentType == 1){
                        showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"复制"],[RXPopMenuItem itemTitle:@"举报"]];
                    }else{
                        showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"举报"]];
                    }
                }else{//对方不是vip
                    if(self.chatModel.contentType == 1){
                        showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"复制"],[RXPopMenuItem itemTitle:@"删除"],[RXPopMenuItem itemTitle:@"举报"]];
                    }else{
                        showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"删除"],[RXPopMenuItem itemTitle:@"举报"]];
                    }
                }
            }else{//普通用户长按对方消息
                if(self.chatModel.contentType == 1){
                    showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"复制"],[RXPopMenuItem itemTitle:@"举报"]];
                }else{
                    showItems = @[[RXPopMenuItem itemTitle:@"回复"],[RXPopMenuItem itemTitle:@"举报"]];
                }
            }
        }
        if(!showItems.count){
            return;
        }
        RXPopMenu * menu = [RXPopMenu menuWithType:RXPopMenuBox];
        [menu showBy:tap.view withItems:showItems];
  
        __weak typeof(self) weak = self;
        menu.itemActions = ^(RXPopMenuItem *item) {
            if([item.title isEqualToString:@"回复"]){
                [weak replyMsg];
            }else if([item.title isEqualToString:@"复制"]){
                [weak copyText];
            }else if([item.title isEqualToString:@"删除"]){
                [weak deleteMsg];
            }else if([item.title isEqualToString:@"撤回"]){
                [weak backMsg];
            }else if([item.title isEqualToString:@"举报"]){
                [weak jubaoMsg];
            }
        };
    }
}

//回复消息
- (void)replyMsg{
    if(self.replyMsgBlock){
        self.replyMsgBlock(self.chatModel);
    }
}

//复制消息
- (void)copyText{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.chatModel.content];
    [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
}

//举报
- (void)jubaoMsg{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.chatModel.logId;
    juBaoView.reouceType = @"146";
    [juBaoView showView];
}

//删除
- (void)deleteMsg{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *revokeDic = [[NSMutableDictionary alloc] init];
    [revokeDic setObject:@"massChat" forKey:@"flag"];
    [revokeDic setObject:@"delete" forKey:@"action"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:self.chatModel.logId forKey:@"chatLogId"];
    [revokeDic setObject:data forKey:@"data"];
    [appdel.socketManager sendMessage:revokeDic];
}

//撤回消息
- (void)backMsg{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *revokeDic = [[NSMutableDictionary alloc] init];
    [revokeDic setObject:@"massChat" forKey:@"flag"];
    [revokeDic setObject:@"revoke" forKey:@"action"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:self.chatModel.logId forKey:@"chatLogId"];
    [revokeDic setObject:data forKey:@"data"];
    [appdel.socketManager sendMessage:revokeDic];
}

- (void)setChatModel:(NoticeTeamChatModel *)chatModel{
    _chatModel = chatModel;
    self.failButton.hidden = YES;
    self.iconImageView.frame = CGRectMake(chatModel.isSelf?(DR_SCREEN_WIDTH-15-40):15, chatModel.isShowTime?30:20, 40, 40);
    self.markImage.hidden = chatModel.fromUserM.userId.intValue==1?NO:YES;
    if(!self.markImage.hidden){
        self.markImage.frame = CGRectMake(chatModel.isSelf?_iconImageView.frame.origin.x: (CGRectGetMaxX(_iconImageView.frame)-12), CGRectGetMaxY(_iconImageView.frame)-12,12, 12);
    }
    self.nickNameL.frame = CGRectMake(63, self.iconImageView.frame.origin.y, DR_SCREEN_WIDTH-63*2, 17);
    self.nickNameL.textAlignment = chatModel.isSelf?NSTextAlignmentRight:NSTextAlignmentLeft;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:chatModel.fromUserM.avatar_url] placeholderImage:[UIImage imageNamed:@"Image_jynohe"]];
    self.nickNameL.text = chatModel.fromUserM.mass_nick_name;
    
    self.contentV.backgroundColor = [UIColor colorWithHexString:chatModel.isSelf?@"#0099E6":@"#F7F8FC"];
    self.contentL.textColor = [UIColor colorWithHexString:chatModel.isSelf?@"#FFFFFF":@"#25262E"];
    
    [self showTextMsg];
    [self showImageView];
    [self showVoice];
    [self revokeOrDelete];
}

//撤回或者删除消息
- (void)revokeOrDelete{
    self.iconImageView.hidden = NO;
    self.nickNameL.hidden = NO;
    if(self.chatModel.status.intValue == 4 || self.chatModel.status.intValue == 3){
        self.timeL.hidden = NO;
        self.timeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.iconImageView.hidden = YES;
        self.nickNameL.hidden = YES;
        self.markImage.hidden = YES;
        self.timeL.text = self.chatModel.revokeOrDeleteStr;
    }else{
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.timeL.hidden = _chatModel.isShowTime?NO:YES;
        self.timeL.text = _chatModel.showTime;
    }
}

//文本消息
- (void)showTextMsg{
    if(self.chatModel.status.intValue == 4 || self.chatModel.status.intValue == 3){
        self.contentV.hidden = YES;
    }else{
        self.contentV.hidden = _chatModel.contentType==1?NO:YES;
    }
    if(self.contentV.hidden){//隐藏的话就不需要往下走了
        return;
    }
    
    if(self.chatModel.call_chat){

        self.contentV.frame = CGRectMake(_chatModel.isSelf?(DR_SCREEN_WIDTH-63-_chatModel.textWidth-20):63, CGRectGetMaxY(_iconImageView.frame)-20, _chatModel.textWidth+20, _chatModel.textHeight+20+ (30+self.chatModel.callChatTextHeight+8+10));
        self.replyMsgView.hidden = NO;
        self.replyMsgView.chatModel = self.chatModel;
        self.contentL.frame = CGRectMake(10,CGRectGetMaxY(self.replyMsgView.frame)+10, _chatModel.textWidth, _chatModel.textHeight);

    }else{
        self.contentV.frame = CGRectMake(_chatModel.isSelf?(DR_SCREEN_WIDTH-63-_chatModel.textWidth-20):63, CGRectGetMaxY(_iconImageView.frame)-20, _chatModel.textWidth+20, _chatModel.textHeight+20);
        self.contentL.frame = CGRectMake(10, 10, _chatModel.textWidth, _chatModel.textHeight);
        _replyMsgView.hidden = YES;
    }
    

    self.contentL.attributedText = _chatModel.contentAtt;
    
    if (self.chatModel.isSaveCace.boolValue) {
        self.failButton.hidden = NO;
        self.failButton.frame = CGRectMake(self.contentV.frame.origin.x-35-5, self.contentV.frame.origin.y+(self.contentV.frame.size.height-35)/2, 35, 35);
    }
}

//图片消息
- (void)showImageView{
    if(self.chatModel.status.intValue == 4 || self.chatModel.status.intValue == 3){
        self.sendImageView.hidden = YES;
    }else{
        self.sendImageView.hidden = _chatModel.contentType == 2?NO:YES;
    }
    if(_chatModel.contentType == 2){
        
        __weak typeof(self) weakSelf = self;
        if (self.chatModel.isSaveCace) {
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.chatModel.resource_url];
            NSData *data = [fileHandle readDataToEndOfFile];
            [fileHandle closeFile];
            UIImage *image  = [[UIImage alloc] initWithData:data];
            _sendImageView.image = image;
            [self setImageViewFrame:image];
        }else{
            if ([self.chatModel.resource_url containsString:@".gif"] || [self.chatModel.resource_url containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [_sendImageView setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:self.chatModel.resource_url]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                    [weakSelf setImageViewFrame:image];
                }];
            }else{
                [_sendImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:self.chatModel.resource_url]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [weakSelf setImageViewFrame:image];
                }];
            }
        }
    }
}

//根据图片尺寸设置图片比例
- (void)setImageViewFrame:(UIImage *)image{
    self.chatModel.hasDowned = YES;
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    if(!image){
        imageWidth = 100;
        imageHeight = 100;
    }
    CGFloat beishu = imageHeight/imageWidth;

    if (beishu < 0.86){
        if (self.chatModel.isSelf) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-63-172,CGRectGetMaxY(_iconImageView.frame)-20, 172, 172*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(self.nickNameL.frame.origin.x,CGRectGetMaxY(_iconImageView.frame)-20,172,172*beishu);
        }
    }else if (beishu <= 1.15 && beishu > 0.95) {
        if (self.chatModel.isSelf) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-63-120,CGRectGetMaxY(_iconImageView.frame)-20, 120, 120*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(_iconImageView.frame)-20,120,120*beishu);
        }
    }else if (beishu >= 2.76) {
        if (self.chatModel.isSelf) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-63-50,CGRectGetMaxY(_iconImageView.frame)-20, 50,138);
        }else{
            self.sendImageView.frame = CGRectMake(self.nickNameL.frame.origin.x,CGRectGetMaxY(_iconImageView.frame)-20,50,138);
        }
    }
    else  if (beishu <= 1.38) {
        if (self.chatModel.isSelf) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-63-100,CGRectGetMaxY(_iconImageView.frame)-20, 100, 100*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(_iconImageView.frame)-20,100,100*beishu);
        }
    }else{
        if (self.chatModel.isSelf) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-63-100,CGRectGetMaxY(_iconImageView.frame)-20, 100, 138);
        }else{
            self.sendImageView.frame = CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(_iconImageView.frame)-20,100,138);
        }
    }
    if (self.chatModel.isSaveCace.boolValue) {
        self.failButton.hidden = NO;
        self.failButton.frame = CGRectMake(self.sendImageView.frame.origin.x-35-5, self.sendImageView.frame.origin.y+(self.sendImageView.frame.size.height-35)/2, 35, 35);
    }
}

- (void)showVoice{
    if(self.chatModel.status.intValue == 4 || self.chatModel.status.intValue == 3){
        _playerView.hidden = YES;
    }else{
        _playerView.hidden = self.chatModel.contentType == 3?NO:YES;
    }

    if(self.chatModel.contentType == 3){
        _playerView.voiceUrl = self.chatModel.resource_url;
        _playerView.timeLen = self.chatModel.voice_len;
        
        self.playerView.frame = CGRectMake(self.chatModel.isSelf?(DR_SCREEN_WIDTH-63-144): 63, CGRectGetMaxY(_iconImageView.frame)-20,144, 44);
        [self.playerView refreWithFrame];
        self.playerView.slieView.progress = self.chatModel.nowPro >0 ?self.chatModel.nowPro:0;
        self.playerView.timeLen = self.chatModel.nowTime.integerValue?self.chatModel.nowTime: self.chatModel.voice_len;
        
        if (!self.chatModel.isSelf) {
            [self.playerView.playButton setImage:UIImageNamed(self.chatModel.isPlaying ? @"Image_nnoplaay" : @"Image_nplaay") forState:UIControlStateNormal];
        }else{
            [self.playerView.playButton setImage:UIImageNamed(!self.chatModel.isPlaying ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
        }
        self.playerView.isGroupChatSelf = self.chatModel.isSelf;
        self.playerView.layer.borderWidth = 0;
        
        if (self.chatModel.isSaveCace.boolValue) {

            self.failButton.hidden = NO;
            self.failButton.frame = CGRectMake(self.playerView.frame.origin.x-self.playerView.frame.size.height-5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
        }
    }
}

- (NoticeUseTextView *)replyMsgView{
    if(!_replyMsgView){
        _replyMsgView = [[NoticeUseTextView alloc] initWithFrame:CGRectMake(10, 10, self.contentV.frame.size.width-20, 0)];
        __weak typeof(self) weakSelf = self;
        _replyMsgView.locationUseBlock = ^(BOOL upLocation) {
            if(weakSelf.locationUseBlock){
                weakSelf.locationUseBlock(weakSelf.chatModel);
            }
        };
        [self.contentV addSubview:_replyMsgView];
    }
    return _replyMsgView;
}


//点击了播放按钮
- (void)startPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop: section:)]) {
        [self.delegate startPlayAndStop:self.index section:self.section];
    }
}

//点击头像
- (void)userInfoTap{
    
    if (!self.isjoin.boolValue) {
        return;
    }
    
    if(self.chatModel.fromUserM.member_status.intValue != 1){
        [[NoticeTools getTopViewController] showToastWithText:@"对方已不在社团"];
        return;
    }
    
    if(self.clickHeaderBlock){
        self.clickHeaderBlock(YES);
    }
    __weak typeof(self) weakSelf = self;
    if(self.identity.intValue == 3){
        NoticeSuperMangerClickPersongController *ctl = [[NoticeSuperMangerClickPersongController alloc] init];
        ctl.identity = self.identity;
        ctl.chatModel = self.chatModel;
        ctl.clickButtonTagBlock = ^(NSString * _Nonnull clickStr) {
            if ([clickStr isEqualToString:@"移出本社团"]){
                [weakSelf outPeopleWithNojoin:NO];
            }else if ([clickStr isEqualToString:@"移出并禁止加入本社团"]){
                [weakSelf outPeopleWithNojoin:YES];
            }
        };
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        return;
    }
    
    self.iconClickView.identity = self.identity;
    self.iconClickView.chatModel = self.chatModel;
    
    self.iconClickView.clickButtonTagBlock = ^(NSString * _Nonnull clickStr) {
        if([clickStr isEqualToString:@"举报"]){
            [weakSelf jubaoyOnhu];
        }else if ([clickStr isEqualToString:@"交流"]){
            [NoticeComTools connectXiaoer];
        }else if ([clickStr isEqualToString:@"移出本社团"]){
            [weakSelf outPeopleWithNojoin:NO];
        }else if ([clickStr isEqualToString:@"移出并禁止加入本社团"]){
            [weakSelf outPeopleWithNojoin:YES];
        }
    };
    [self.iconClickView showIconView];
}

- (void)outPeopleWithNojoin:(BOOL)noJoin{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.isOutPerson = YES;
    juBaoView.titleL.text = @"移出理由";
    [juBaoView.pinbBtn setTitle:@"移出" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    juBaoView.outBlock = ^(NSInteger type) {
        [weakSelf outPersonNojoin:noJoin type:[NSString stringWithFormat:@"%ld",type]];
    };
    [juBaoView showView];
}

- (void)outPersonNojoin:(BOOL)noJoin type:(NSString *)type{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.chatModel.mass_id forKey:@"massId"];
    [parm setObject:self.chatModel.fromUserM.userId forKey:@"userId"];
    [parm setObject:type forKey:@"reasonType"];
    [parm setObject:noJoin?@"1":@"0" forKey:@"isForbid"];

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"mass/member/remove" Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
      
        if (success) {
            [[NoticeTools getTopViewController] showToastWithText:@"已移出"];
        }
    } fail:^(NSError * _Nullable error) {
     
    }];
}

- (void)jubaoyOnhu{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.chatModel.fromUserM.userId;
    juBaoView.reouceType = @"4";
    [juBaoView showView];
}

- (NoticeClickHeaderTeamView *)iconClickView{
    if(!_iconClickView){
        _iconClickView = [[NoticeClickHeaderTeamView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _iconClickView;
}

//查看大图
- (void)bigTag{
    if(self.chatModel.contentType != 2){
        return;
    }
    
    NSArray *array = [self.chatModel.resource_url componentsSeparatedByString:@"?"];
    if (!array.count) {
        return;
    }
    
    if(self.clickHeaderBlock){
        self.clickHeaderBlock(YES);
    }
    if (!self.photoArr.count) {
        return;
    }
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.photoArr];
    NSInteger index = 0;
    for (YYPhotoGroupItem *item in self.photoArr) {//找到当前点击图片在图片数组里面的位置,然后替换位置
        if ([item.smallUrlString isEqualToString:self.chatModel.resource_url]) {
            break;
        }
        index++;
    }
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.sendImageView;
    item.largeImageURL     = [NSURL URLWithString:self.chatModel.resource_url];
    [newArr replaceObjectAtIndex:index withObject:item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:newArr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:_sendImageView toContainer:toView animated:YES completion:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
