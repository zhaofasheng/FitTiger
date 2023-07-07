//
//  NoticeSCCell.m
//  NoticeXi
//
//  Created by li lei on 2019/1/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSCCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeSCCell
{
    UILabel *_markL;
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
    UIButton *_tapBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;

        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,14, 35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
        
        _threeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, _iconImageView.frame.origin.y+25/2, 5, 10)];
        _threeImageView.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_othermsgjt_b":@"Image_othermsgjt_y");
        [self.contentView addSubview:_threeImageView];
        _threeImageView.hidden = YES;
        
        self.contentVL = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_threeImageView.frame), _iconImageView.frame.origin.y, 0, 0)];
        self.contentVL.backgroundColor = [NoticeTools getWhiteColor:@"#F7F7F7" NightColor:@"#212137"];
        [self.contentView addSubview:self.contentVL];
        self.contentVL.layer.cornerRadius = 5;
        self.contentVL.layer.masksToBounds = YES;
        self.contentVL.userInteractionEnabled = YES;
        self.contentVL.hidden = YES;
  
        self.contentL = [[NoticeTextView alloc] initWithFrame:CGRectMake(10, 10, self.contentVL.frame.size.width-20, self.contentVL.frame.size.height-20)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.userInteractionEnabled = NO;
        UILongPressGestureRecognizer *textlongPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        textlongPressDeleT.minimumPressDuration = 0.5;
        [_contentL addGestureRecognizer:textlongPressDeleT];
        self.contentL.textColor = [UIColor whiteColor];
        self.contentL.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.contentL.scrollEnabled = NO;
        self.contentL.editable = NO;
        [self.contentVL addSubview:self.contentL];
        self.contentL.hidden = YES;
        self.contentL.isContent = YES;
        self.contentL.textContainerInset = UIEdgeInsetsMake(10, -5, 0, -5);
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,14,125, 35)];
        _playerView.delegate = self;
        _playerView.isThird = YES;
        [self.contentView addSubview:_playerView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
        
        _rePlayView.hidden = YES;
        [self.contentView addSubview:_rePlayView];
        
        _sendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 14, 100, 150)];
        _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        _sendImageView.layer.cornerRadius = 5;
        _sendImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag)];
        [_sendImageView addGestureRecognizer:tapImg];
        [self.contentView addSubview:_sendImageView];
        
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        self.redView.backgroundColor = [UIColor redColor];
        self.redView.layer.cornerRadius = 2;
        self.redView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.redView];
        self.redView.hidden = YES;
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
        self.timeL.backgroundColor = self.backgroundColor;
        self.timeL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
        self.timeL.hidden = YES;
        
        self.userInteractionEnabled = YES;
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 27+35+15, DR_SCREEN_WIDTH, 11)];
        _markL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        _markL.textAlignment = NSTextAlignmentCenter;
        _markL.font = ELEVENTEXTFONTSIZE;
        _markL.text = [NoticeTools isSimpleLau]? @"对方可能不方便立刻回复":@"對方可能不方便立刻回復";
        [self.contentView addSubview:_markL];
        _markL.numberOfLines = 0;
        _markL.hidden = YES;
      
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.5;
        [self.playerView addGestureRecognizer:longPress];
        
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.5;
        [_sendImageView addGestureRecognizer:longPressDeleT];
        
        
        _tapBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, 99, 66, 20)];
        [_tapBtn addTarget:self action:@selector(contiuneLook) forControlEvents:UIControlEventTouchUpInside];
        
        self.failButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.failButton setImage:UIImageNamed(@"Image_failimg") forState:UIControlStateNormal];
        [self.contentView addSubview:self.failButton];
        [self.failButton addTarget:self action:@selector(failClick) forControlEvents:UIControlEventTouchUpInside];
        self.failButton.hidden = YES;
        
        self.markImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.markImage];
    }
    return self;
}

- (NoticeShareLineChatView*)shareLineView{
    if (!_shareLineView) {
        _shareLineView = [[NoticeShareLineChatView alloc] initWithFrame:CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 117)];
        [self.contentView addSubview:_shareLineView];
    }
    return _shareLineView;
}

- (NoticeSharePyChatView *)sharepyView{
    if (!_sharepyView) {
        _sharepyView = [[NoticeSharePyChatView alloc] initWithFrame:CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 120)];
        [self.contentView addSubview:_sharepyView];
    }
    return _sharepyView;
}

- (NoticeWhiteCardChatView *)cardView{
    if (!_cardView) {
        _cardView = [[NoticeWhiteCardChatView alloc] initWithFrame:CGRectMake(62,_iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 260)];
        [self.contentView addSubview:_cardView];
    }
    return _cardView;
}

- (NoticeShareLinkCell *)linkView{
    if (!_linkView) {
        _linkView = [[NoticeShareLinkCell alloc] initWithFrame:CGRectMake(0, 0, 205, 53)];
        [self.contentView addSubview:_linkView];
        _linkView.hidden = YES;
        UILongPressGestureRecognizer *longPressDeleT3 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT3.minimumPressDuration = 0.5;
        [_linkView addGestureRecognizer:longPressDeleT3];
    }
    return _linkView;
}

- (UIView *)sendLevelView{
    if (!_sendLevelView) {
        _sendLevelView = [[UIView alloc] initWithFrame:CGRectMake(self.contentL.frame.origin.x,CGRectGetMaxY(self.contentL.frame), self.contentVL.frame.size.width-self.contentL.frame.origin.x*2, 48)];
        _sendLevelView.layer.cornerRadius = 4;
        _sendLevelView.layer.masksToBounds = YES;
        _sendLevelView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.sendIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
        self.sendIconImageView.layer.cornerRadius = 2;
        self.sendIconImageView.layer.masksToBounds = YES;
        _sendLevelView.userInteractionEnabled = YES;
        [_sendLevelView addSubview:self.sendIconImageView];
        
        self.sendNameL = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, _sendLevelView.frame.size.width-55, 48)];
        self.sendNameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.sendNameL.font = FOURTHTEENTEXTFONTSIZE;
        [_sendLevelView addSubview:self.sendNameL];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendPeopleTap)];
        [_sendLevelView addGestureRecognizer:tap];
        
        [self.contentVL addSubview:_sendLevelView];
        _sendLevelView.hidden = YES;
    }
    return _sendLevelView;
}

- (NoticeShareVoiceChatView *)shareVoiceView{
    if (!_shareVoiceView) {
        _shareVoiceView = [[NoticeShareVoiceChatView alloc] initWithFrame:CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 98)];
        [self.contentView addSubview:_shareVoiceView];
    }
    return _shareVoiceView;
}

- (void)deleTapT:(UILongPressGestureRecognizer *)tap{
    if (self.chat.isSaveCace) {
        return;
    }
    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longTapCancelWithSection:tag:)]) {
            [self.delegate longTapCancelWithSection:self.section tag:self.index];
        }
    }
}

- (void)longPressGestureRecognized:(id)sender{
    
    if (_chat.contentText && _chat.contentText.length && (_chat.from_user_id.intValue == 1125 || _chat.from_user_id.intValue == 684699)) {
        return;
    }
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (!_chat.isPlaying) {//只有在播放或者暂停的时候才可以拖拽
        if (self.chat.isSaveCace) {
            return;
        }
        if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
            if (self.delegate && [self.delegate respondsToSelector:@selector(longTapCancelWithSection:tag:)]) {
                [self.delegate longTapCancelWithSection:self.section tag:self.index];
            }
        }
        return;
    }
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag: section:)]) {
                [self.delegate beginDrag:self.tag section:self.section];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index: section:)]) {
                [self.delegate dragingFloat:(_chat.resource_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag section:self.section];
            }
            break;
        }
        default: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag: section:)]) {
                [self.delegate endDrag:self.tag section:self.section];
            }
            break;
        }
    }
}

//点击了播放按钮
- (void)startPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop: section:)]) {
        [self.delegate startPlayAndStop:self.index section:self.section];
    }
}

//点击重播
- (void)playReplay{
    if (_chat.is_self.intValue && _chat.isFailed) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(failReSend:row:chatM:)]) {
            [self.delegate failReSend:self.section row:self.index chatM:self.chat];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRePlayAndStop: section:)]) {
        [self.delegate startRePlayAndStop:self.index section:self.section];
    }
}

- (void)contiuneLook{
    _chat.garbage_type = @"0";
    self.refreshHeightBlock(self.currentPath);
    [_tapBtn removeFromSuperview];
}

- (void)setChat:(NoticeChats *)chat{
    _chat = chat;
    self.failButton.hidden = YES;
    self.timeL.text = chat.showTime;
    self.timeL.hidden = !chat.isShowTime;
 
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.avatar_url]]
    placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
             options:SDWebImageRefreshCached];

    [self refreVoiceUI:chat];
    
    [self refreshImgUI:chat];
    
    [self refreshCard];
    
    [self refreshShareVoice];
    
    [self refreshSharePy];
    
    [self refreshShareLine];
    //官方标识
    if ([_chat.from_user_id isEqualToString:@"1"] || _chat.from_user_id.intValue == 684699) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
    }
    else{
        self.markImage.hidden = YES;
    }
    
    if (chat.needMarkAuto || chat.offline_prompt) {
        _markL.hidden = NO;
        if (chat.needMarkAuto && !chat.offline_prompt) {
            if ([self.toUserId isEqualToString:@"1"]) {
                _markL.text = [NoticeTools isSimpleLau]?@"小二回窝睡觉了~":@"小二回窩睡覺了~";
                
                if ([NoticeTimeTools needShowTimeMark]) {
                    _markL.text = [NoticeTimeTools needShowTimeMark];
                }
            }else{
                _markL.text = [NoticeTools isSimpleLau]? @"对方可能不方便立刻回复":@"對方可能不方便立刻回復";
            }
          
        }else if (!chat.needMarkAuto && chat.offline_prompt){
            _markL.text = GETTEXTWITE(@"sx3.1.noonline");
        }else if (chat.needMarkAuto && chat.offline_prompt){
            _markL.text = [NSString stringWithFormat:@"%@\n\n%@\n",GETTEXTWITE(@"sx3.1.noonline"),[NoticeTools isSimpleLau]? @"对方可能不方便立刻回复":@"對方可能不方便立刻回復"];
        }
        
        if ([chat.resource_type isEqualToString:@"4"] || [chat.resource_type isEqualToString:@"1"]) {//是否是图片
      
            _markL.frame = CGRectMake(0, CGRectGetMaxY(_iconImageView.frame), DR_SCREEN_WIDTH, 30+(chat.offline_prompt ? 55:0));
        }else{
            _markL.frame = CGRectMake(0, CGRectGetMaxY(_sendImageView.frame), DR_SCREEN_WIDTH, 30+(chat.offline_prompt ? 55:0));
        }
    }else{
        _markL.hidden = YES;
    }
    
    if (!_sendImageView.hidden) {
        self.redView.hidden = YES;
    }
    
    //声昔卫士
    [self refreshWeiShi:chat];
    
    //分享链接
    [self refreLink];
    
    if (!self.markImage.hidden) {
        self.markImage.frame = CGRectMake(22+_iconImageView.frame.origin.x, 22+_iconImageView.frame.origin.y,15, 15);
    }
    
}

//分享的台词
- (void)refreshShareLine{
    if (self.chat.content_type.intValue == 8) {
        self.shareLineView.hidden = NO;
        self.shareLineView.chat = self.chat;
        self.shareLineView.frame = CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 117);
    }else{
        _shareLineView.hidden = YES;
    }
}

//分享的配音
- (void)refreshSharePy{
    if (self.chat.content_type.intValue == 7) {
        self.sharepyView.hidden = NO;
        self.sharepyView.chat = self.chat;
        self.sharepyView.frame = CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 120);
    }else{
        _sharepyView.hidden = YES;
    }
}

//分享的心情
- (void)refreshShareVoice{
    if (self.chat.content_type.intValue == 6) {
        
        self.shareVoiceView.chat = self.chat;
        if (self.chat.shareVoiceM.show_status.intValue > 1) {
            self.shareVoiceView.frame = CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 98);
        }else{
            if (self.chat.shareVoiceM.voiceM.img_list.count == 3) {
                self.shareVoiceView.frame = CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 166);
            }else if (self.chat.shareVoiceM.voiceM.img_list.count == 2){
                self.shareVoiceView.frame = CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 186);
            }else if (self.chat.shareVoiceM.voiceM.img_list.count == 1){
                self.shareVoiceView.frame = CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 226);
            }else{
                self.shareVoiceView.frame = CGRectMake(62, _iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 98);
            }
        }
        self.shareVoiceView.hidden = NO;
    }else{
        _shareVoiceView.hidden = YES;
    }
}

//赠送的白噪声
- (void)refreshCard{
    if (self.chat.content_type.intValue == 4) {
        self.cardView.hidden = NO;
        self.cardView.chat = self.chat;
        self.cardView.frame = CGRectMake(62,_iconImageView.frame.origin.y, DR_SCREEN_WIDTH-62*2, 260);
    }else{
        _cardView.hidden = YES;
    }
}

//分享的链接
- (void)refreLink{
    if (self.chat.content_type.intValue == 5) {
        self.linkView.shareUrl = self.chat.share_url;
        self.linkView.hidden = NO;
        _chat.imgCellHeight = 53;
        if (self.chat.is_self.integerValue) {
            self.linkView.frame = CGRectMake(_iconImageView.frame.origin.x-12-205, _iconImageView.frame.origin.y, 205, 53);
        }else{
            self.linkView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, _iconImageView.frame.origin.y, 205, 53);
        }
    }else{
        _linkView.hidden = YES;
    }
}


//声昔小卫士
- (void)refreshWeiShi:(NoticeChats *)chat{
    //声昔小卫士显示文案
    _sendLevelView.hidden = YES;
    if (_chat.contentText && _chat.contentText.length ) {
        self.threeImageView.hidden = NO;
        self.contentVL.hidden = NO;
        self.contentL.hidden = NO;
        self.sendImageView.hidden = YES;
        _contentL.textColor = [UIColor whiteColor];
        _contentL.attributedText = _chat.attStr;
        
        if (_chat.content_type.intValue == 9 && _chat.sendUserM) {
            
            if (_chat.is_self.boolValue) {//自己的消息
                self.contentVL.backgroundColor = GetColorWithName(VMainThumeColor);
                self.contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                _threeImageView.frame = CGRectMake(_iconImageView.frame.origin.x-10, _iconImageView.frame.origin.y+25/2, 5, 10);
                _threeImageView.image = UIImageNamed(@"Image_groupchatselft_b");
                self.contentVL.frame = CGRectMake(_threeImageView.frame.origin.x-_chat.textWidth-15, _iconImageView.frame.origin.y, _chat.textWidth+15, _chat.textHeight+58);
                self.contentL.frame = CGRectMake(_chat.contentText.length<4?7: 10,0, _chat.textWidth, _chat.textHeight);
            }else{//别人的消息
                self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
                self.contentVL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
                _iconImageView.frame = CGRectMake(15,30, 35, 35);
                _threeImageView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, _iconImageView.frame.origin.y+25/2, 5, 10);
                _threeImageView.image = UIImageNamed(@"Image_othermsgjt_b");
                self.contentVL.frame = CGRectMake(CGRectGetMaxX(_threeImageView.frame), _iconImageView.frame.origin.y, _chat.textWidth+15, _chat.textHeight+58);
                self.contentL.frame = CGRectMake(_chat.contentText.length<4?7: 10,0, _chat.textWidth, _chat.textHeight);
            }
            self.sendLevelView.frame = CGRectMake(self.contentL.frame.origin.x,CGRectGetMaxY(self.contentL.frame), self.contentVL.frame.size.width-self.contentL.frame.origin.x*2, 48);
            [self.sendIconImageView sd_setImageWithURL:[NSURL URLWithString:_chat.sendUserM.avatar_url]];
            self.sendNameL.text = _chat.sendUserM.nick_name;
            self.sendLevelView.hidden = NO;
        }else{
            if (_chat.is_self.boolValue) {//自己的消息
                self.contentVL.backgroundColor = GetColorWithName(VMainThumeColor);
                self.contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                _threeImageView.frame = CGRectMake(_iconImageView.frame.origin.x-10, _iconImageView.frame.origin.y+25/2, 5, 10);
                _threeImageView.image = UIImageNamed(@"Image_groupchatselft_b");
                self.contentVL.frame = CGRectMake(_threeImageView.frame.origin.x-_chat.textWidth-15, _iconImageView.frame.origin.y, _chat.textWidth+15, _chat.textHeight);
                self.contentL.frame = CGRectMake(_chat.contentText.length<4?7: 10,0, _chat.textWidth, self.contentVL.frame.size.height);
            }else{//别人的消息
                self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
                self.contentVL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
                _iconImageView.frame = CGRectMake(15,30, 35, 35);
                _threeImageView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, _iconImageView.frame.origin.y+25/2, 5, 10);
                _threeImageView.image = UIImageNamed(@"Image_othermsgjt_b");
                self.contentVL.frame = CGRectMake(CGRectGetMaxX(_threeImageView.frame), _iconImageView.frame.origin.y, _chat.textWidth+15, _chat.textHeight);
                self.contentL.frame = CGRectMake(_chat.contentText.length<4?7: 10,0, _chat.textWidth, self.contentVL.frame.size.height);
            }
        }
    }else{
        _sendImageView.hidden = (chat.content_type.intValue == 2 || chat.content_type.intValue==3)?NO:YES;
        self.threeImageView.hidden = YES;
        self.contentVL.hidden = YES;
        self.contentL.hidden = YES;
    }

}

//图片视图
- (void)refreshImgUI:(NoticeChats *)chat{
    _sendImageView.hidden = (chat.content_type.intValue == 2 || chat.content_type.intValue==3)?NO:YES;
    if(chat.content_type.intValue == 2 || chat.content_type.intValue == 3){
         
         //__weak typeof(self) weakSelf = self;
         if (chat.content_type.intValue == 2) {//信封
             chat.imgCellHeight = 50;
             if (self.chat.is_self.integerValue) {
                 self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-40,_iconImageView.frame.origin.y, 40, 40);
                 self.sendImageView.image = UIImageNamed(@"Image_selfXinfeng");
             }else{
                 self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12,_iconImageView.frame.origin.y,40,40);
                 if (chat.read_at.intValue) {
                     self.sendImageView.image = UIImageNamed(@"Image_otherxinfengyidu");
                 }else{
                     self.sendImageView.image = UIImageNamed(@"Image_otherxinfengweidu");
                 }
             }
             if (_chat.isSaveCace) {
                 self.failButton.hidden = NO;
                 self.failButton.frame = CGRectMake(self.sendImageView.frame.origin.x-35-5, self.sendImageView.frame.origin.y+(self.sendImageView.frame.size.height-35)/2, 35, 35);
             }
         }else if (chat.content_type.intValue == 3){//图片
             if (chat.garbage_type.intValue == 1) {
                 _sendImageView.image = UIImageNamed(@"Image_garbag_b");
                 chat.widthOverHeight = NO;
                 chat.imgCellHeight = 138;
                 self.refreshHeightBlock(self.currentPath);
                 [self.sendImageView addSubview:_tapBtn];
             }else{
                 [_tapBtn removeFromSuperview];
                 
                 __weak typeof(self) weakSelf = self;
                 if (chat.isSaveCace) {
                     NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:chat.resource_url];
                     NSData *data = [fileHandle readDataToEndOfFile];
                     [fileHandle closeFile];
                     UIImage *image  = [[UIImage alloc] initWithData:data];
                     _sendImageView.image = image;
                     [self setImageViewFrame:image];
                 }else{
                     if ([chat.resource_url containsString:@".gif"] || [chat.resource_url containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                         [_sendImageView setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                         } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                             [weakSelf setImageViewFrame:image];
                             DRLog(@"加载gif图片");
                         }];
                     }else{
                         [_sendImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                             [weakSelf setImageViewFrame:image];
                             DRLog(@"加载图片");
                         }];
                     }
                 }
             }
         }
     }
}

//播放UI
- (void)refreVoiceUI:(NoticeChats *)chat{
    _playerView.hidden = chat.content_type.intValue == 1?NO:YES;
    _rePlayView.hidden = YES;
    _playerView.voiceUrl = chat.resource_url;
    _playerView.timeLen = chat.resource_len;
    CGFloat orineY = chat.isShowTime ? CGRectGetMaxY(self.timeL.frame) : 14;
    if (!chat.is_self.integerValue) {
        
        _iconImageView.frame = CGRectMake(15, orineY, 35, 35);
        _sendImageView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, orineY, 100, 138);
        
        if (chat.content_type.intValue == 1) {//语音
            if (chat.resource_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, orineY, 120, 35);
                [self.playerView refreWithFrame];
            }else if (chat.resource_len.integerValue >= 5 && chat.resource_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, orineY, 120+chat.resource_len.integerValue, 35);
                [self.playerView refreWithFrame];
            }else{
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,orineY, 120+chat.resource_len.integerValue, 35);
                [self.playerView refreWithFrame];
            }
            self.playerView.isSelf = NO;
            
            self.redView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame)+5, self.playerView.frame.origin.y+30/2, 4, 4);
            if (chat.content_type.intValue == 1) {
            
                if (!chat.read_at.integerValue) {
                    self.redView.hidden = NO;
                }else{
                    self.redView.hidden = YES;
                }
            }else{
                self.redView.hidden = YES;
            }
            
            self.playerView.timeLen = chat.nowTime.integerValue?chat.nowTime: chat.resource_len;
            self.playerView.slieView.progress = chat.nowPro >0 ?chat.nowPro:0;
            
            self.playerView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
            self.playerView.slieView.trackTintColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
            self.playerView.slieView.progressTintColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
            
            [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_img":@"Imag_reply_img_ye") forState:UIControlStateNormal];
            _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame)+5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            if (chat.content_type.intValue == 1) {//重播按钮位置

                if (chat.isPlaying) {
                    _rePlayView.hidden = NO;
                }else{
                    _rePlayView.hidden = YES;
                }
    
            }else{
                _rePlayView.hidden = YES;
            }
        }
    }else{
        _iconImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35, orineY, 35, 35);
        _sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35-12-100, orineY, 100, 138);
        if (chat.content_type.intValue == 1) {
            self.playerView.backgroundColor = GetColorWithName(VMainThumeColor);
            self.playerView.slieView.trackTintColor = GetColorWithName(VMainThumeColor);
            self.playerView.slieView.progressTintColor = GetColorWithName(VMainThumeWhiteColor);

            self.playerView.timeLen = chat.nowTime.integerValue?chat.nowTime: chat.resource_len;
            self.playerView.slieView.progress = chat.nowPro >0 ?chat.nowPro:0;
            
            self.redView.hidden = YES;
            
            _sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35-12-100, orineY, 100, 138);
            
            if (chat.resource_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120, orineY, 120, 35);
                [self.playerView refreWithFrame];
            }else if (chat.resource_len.integerValue >= 5 && chat.resource_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120-chat.resource_len.integerValue, orineY, 120+chat.resource_len.integerValue, 35);
                [self.playerView refreWithFrame];
            }else{
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120-chat.resource_len.integerValue, orineY, 120+chat.resource_len.integerValue, 35);
                [self.playerView refreWithFrame];
            }

            self.playerView.isSelf = YES;
            [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Imag_reply_imgRight":@"Imag_reply_imgRight_ye") forState:UIControlStateNormal];
            _rePlayView.frame = CGRectMake(self.playerView.frame.origin.x-self.playerView.frame.size.height-5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            if (chat.content_type.intValue == 1) {//重播按钮位置
                
                if (chat.isPlaying) {
                    _rePlayView.hidden = NO;
                }else{
                    _rePlayView.hidden = YES;
                }
                
            }else{
                _rePlayView.hidden = YES;
            }
            if (chat.isFailed) {
                _rePlayView.hidden = NO;
                [_rePlayView setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_senFailed_b":@"Image_senFailed_y") forState:UIControlStateNormal];
            }
            
            
            if (chat.isSaveCace) {
                _rePlayView.hidden = YES;
                self.failButton.hidden = NO;
                self.failButton.frame = CGRectMake(self.playerView.frame.origin.x-self.playerView.frame.size.height-5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            }
        }
    }
    
    if (self.isServeChat) {
        self.playerView.isGroupChatSelf = chat.isSelf;
    }
}

//根据图片尺寸设置图片比例
- (void)setImageViewFrame:(UIImage *)image{
    self.chat.isFinish = YES;
    CGFloat orineY = self.chat.isShowTime ? CGRectGetMaxY(self.timeL.frame) : 14;
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    CGFloat beishu = imageHeight/imageWidth;
    if (beishu < 0.86){
        if (self.chat.is_self.intValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-172,_iconImageView.frame.origin.y, 172, 172*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, _iconImageView.frame.origin.y,172,172*beishu);
        }
    }else if (beishu <= 1.15 && beishu > 0.95) {
        if (self.chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-120,_iconImageView.frame.origin.y, 120, 120*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, _iconImageView.frame.origin.y,120,120*beishu);
        }
    }else if (beishu >= 2.76) {
        if (self.chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-50,_iconImageView.frame.origin.y, 50,138);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, _iconImageView.frame.origin.y,50,138);
        }
    }
    else  if (beishu <= 1.38) {
        if (self.chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35-12-100,orineY, 100, 100*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, orineY,100,100*beishu);
        }
    }
    if (_chat.isSaveCace) {
        self.failButton.hidden = NO;
        self.failButton.frame = CGRectMake(self.sendImageView.frame.origin.x-35-5, self.sendImageView.frame.origin.y+(self.sendImageView.frame.size.height-35)/2, 35, 35);
    }
}

- (void)failClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(failReSendchatM:)]) {
        [self.delegate failReSendchatM:self.chat];
    }
}

//查看大图
- (void)bigTag{
    NSArray *array = [_chat.resource_url componentsSeparatedByString:@"?"];
    if (!array.count) {
        return;
    }
   
    if (self.chat.content_type.intValue == 2 && !self.chat.isSelf) {
        self.chat.read_at = [NoticeTools getNowTimeTimestamp];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        self.sendImageView.image = UIImageNamed(@"Image_otherxinfengyidu");
        [parm setObject:self.chat.read_at forKey:@"readAt"];
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"chats/%@/%@",self.chat.chat_id,self.chat.dialog_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        } fail:^(NSError *error) {
        }];
    }
    
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.sendImageView;
    item.largeImageURL     = [NSURL URLWithString:self.chat.resource_url];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:_sendImageView toContainer:toView animated:YES completion:nil];
}

//点击头像
- (void)userInfoTap{
    if (self.needHelp || self.isLead  || (self.isServeChat && !self.mangagerCode)) {
        return;
    }
    if ([_chat.from_user_id isEqualToString:[NoticeTools getuserId]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{

        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _chat.from_user_id;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)sendPeopleTap{
    if (_chat.content_type.intValue == 9 && _chat.sendUserM && _chat.sendUserM.user_id) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = _chat.sendUserM.user_id;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
