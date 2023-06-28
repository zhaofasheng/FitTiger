//
//  NoticeShowNewUserLeader.m
//  NoticeXi
//
//  Created by li lei on 2022/3/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShowNewUserLeader.h"
#import "NoticeXi-Swift.h"

@implementation NoticeShowNewUserLeader

- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        UIButton *closBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 52, 28)];
        [closBtn setBackgroundImage:UIImageNamed(@"Image_leaclose") forState:UIControlStateNormal];
        [closBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closBtn];
        
        self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-463, 315, 463)];
        [self addSubview:self.mainImageView];
        self.mainImageView.userInteractionEnabled = YES;
        self.mainImageView.hidden = YES;
    }
    return self;
}

- (UIView *)acceptView{
    if (!_acceptView) {
        _acceptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _acceptView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _acceptView.hidden = YES;
        [self addSubview:_acceptView];
        
        self.getBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-270)/2, DR_SCREEN_HEIGHT-297-48+30, 120, 48)];
        [self.getBtn setBackgroundImage:UIImageNamed(@"Image_getrenwu") forState:UIControlStateNormal];
        [self.getBtn addTarget:self action:@selector(getClick) forControlEvents:UIControlEventTouchUpInside];
        [_acceptView addSubview:self.getBtn];
        
        self.giveUpBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-270)/2+120+30, DR_SCREEN_HEIGHT-297-48+30, 120, 48)];
        [self.giveUpBtn setBackgroundImage:UIImageNamed(@"Image_fangqiwu") forState:UIControlStateNormal];
        [self.giveUpBtn addTarget:self action:@selector(giveUpClick) forControlEvents:UIControlEventTouchUpInside];
        [_acceptView addSubview:self.giveUpBtn];
    }
    return _acceptView;
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.playComplete = ^{
            if (weakSelf.canNext) {
                [weakSelf next];
            }
        };
    }
    return _audioPlayer;
}

- (LGAudioPlayer *)noNextPlayer
{
    if (!_noNextPlayer) {
        _noNextPlayer = [[LGAudioPlayer alloc] init];
    
    }
    return _noNextPlayer;
}

- (LGAudioPlayer *)voicePlayer
{
    if (!_voicePlayer) {
        _voicePlayer = [[LGAudioPlayer alloc] init];
   
    }
    return _voicePlayer;
}

- (UIButton *)recoBtn{
    if (!_recoBtn) {
        _recoBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88)/2, DR_SCREEN_HEIGHT-203-BOTTOM_HEIGHT-10, 88, 203)];
        [_recoBtn setBackgroundImage:UIImageNamed(@"Image_recoderc") forState:UIControlStateNormal];
        _recoBtn.userInteractionEnabled = NO;
        [_recoBtn addTarget:self action:@selector(recClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recoBtn];
        _recoBtn.hidden = YES;
    }
    return _recoBtn;
}

- (UIView *)voiceView{
    if (!_voiceView) {
        _voiceView = [[UIView alloc] initWithFrame:self.mainImageView.bounds];
        [self.mainImageView addSubview:_voiceView];
        _voiceView.userInteractionEnabled = YES;
        
        UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, 136, 40)];
        [playBtn addTarget:self action:@selector(playVoiceClick) forControlEvents:UIControlEventTouchUpInside];
        [_voiceView addSubview:playBtn];
        self.iconBtn = playBtn;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVoiceClick)];
        [_voiceView addGestureRecognizer:tap1];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(56, 30, 279, 42)];
        imageV.image = UIImageNamed(@"Image_hszhiyin1");
        [_voiceView addSubview:imageV];
        self.playTapImg = imageV;
        
        self.chatImageV = [[UIImageView alloc] initWithFrame:CGRectMake(185, 259, 150, 88)];
        self.chatImageV.image = UIImageNamed(@"Image_hszhiyin2");
        [_voiceView addSubview:self.chatImageV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hsClick)];
        [self.chatImageV addGestureRecognizer:tap];
        self.chatImageV.userInteractionEnabled = YES;
        
        UIButton *hsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 259+88, _voiceView.frame.size.width, 45)];
        [hsBtn addTarget:self action:@selector(hsClick) forControlEvents:UIControlEventTouchUpInside];
        [_voiceView addSubview:hsBtn];
    }
    return _voiceView;
}


//下一步
- (void)next{
    self.index++;
    _voiceView.hidden = YES;
    self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-463, 315, 463);
    if (self.index == 1) {
        [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.type == 0) {
                self.mainImageView.image = UIImageNamed(@"Image_leadmain2");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"102" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            }else if (self.type == 1){
                self.mainImageView.image = UIImageNamed(@"Image_hsmian2");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"22" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            }else if (self.type == 2){//交流
                self.mainImageView.image = UIImageNamed(@"Image_leadjl2");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"32" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            }else if (self.type == 3){//每日一阅
                self.mainImageView.image = UIImageNamed(@"Image_lys1");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"42" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            }else if (self.type == 4){//客服
                self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-463, 315, 463);
                self.mainImageView.image = UIImageNamed(@"Image_leadlymain1");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"52" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            }
//
        } completion:nil];
    }else if (self.index == 2){
        self.acceptView.hidden = NO;
        // 先缩小
        self.getBtn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.giveUpBtn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            // 放大
            self.giveUpBtn.transform = CGAffineTransformMakeScale(1, 1);
            self.getBtn.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }else if (self.index == 3){//进入点击录音按钮
        if (self.type == 0) {
            self.mainImageView.hidden = YES;
            self.acceptView.hidden = YES;
            self.recoBtn.hidden = NO;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"104" ofType:@"m4a"];
            [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            self.recoBtn.frame = CGRectMake((DR_SCREEN_WIDTH-88)/2, DR_SCREEN_HEIGHT-203-BOTTOM_HEIGHT-10-30, 88, 203);
            // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
            [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                self.recoBtn.frame = CGRectMake((DR_SCREEN_WIDTH-88)/2, DR_SCREEN_HEIGHT-193-BOTTOM_HEIGHT-(ISIPHONEXORLATER?10:0), 88, 203);
            } completion:nil];
        }else if(self.type == 1){//点击悄悄话
            self.acceptView.hidden = YES;
            self.voiceView.hidden = NO;
            self.playTapImg.image = UIImageNamed(@"Image_hszhiyin1");
            self.playTapImg.frame = CGRectMake(56, 30, 279, 42);
            self.mainImageView.image = UIImageNamed(@"Image_hsmian3");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"24" ofType:@"m4a"];
            [self.noNextPlayer startPlayWithUrl:path isLocalFile:YES];
            self.chatImageV.hidden = NO;
            self.chatImageV.frame = CGRectMake(185, 259-30, 150, 88);
            // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
            [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                self.chatImageV.frame = CGRectMake(185, 259, 150, 88);
                self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-335)/2,NAVIGATION_BAR_HEIGHT+30, 335, 392);
            } completion:nil];
        }else if (self.type == 2){//交流
            NSString *path = [[NSBundle mainBundle] pathForResource:@"34" ofType:@"m4a"];
            [self.noNextPlayer startPlayWithUrl:path isLocalFile:YES];
            self.mainImageView.userInteractionEnabled = YES;
            self.mainImageView.image = UIImageNamed(@"Image_leadjl3");
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-335)/2,NAVIGATION_BAR_HEIGHT+30, 335, 392);
            self.acceptView.hidden = YES;
            self.voiceView.hidden = NO;
            self.iconBtn.frame = CGRectMake(0, 0, 70, 70);
            self.playTapImg.image = UIImageNamed(@"Image_jlzhiyin1");
            self.chatImageV.hidden = YES;
            // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
            [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                self.playTapImg.frame = CGRectMake(52, 52, 217, 40);
                self.mainImageView.center = self.center;
            } completion:nil];
        }else if (self.type == 3 || self.type==4){
            [self disMiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":[NSString stringWithFormat:@"%ld",self.type]}];
        }
    }else if (self.index == 4){//点击录音按钮播放完成
        self.recoBtn.userInteractionEnabled = YES;
        
    }else if (self.index == 5){//完成后的操作1
        if (self.type == 0) {
            _recoBtn.hidden = YES;
            _acceptView.hidden = YES;
            self.mainImageView.hidden = NO;
            
            self.mainImageView.image = UIImageNamed(@"Image_leadmain3");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"107" ofType:@"m4a"];
            [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        }else if (self.type == 1){
            _recoBtn.hidden = YES;
            _acceptView.hidden = YES;
            _voiceView.hidden = YES;
            self.mainImageView.hidden = NO;
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-420, 315, 420);
            self.mainImageView.image = UIImageNamed(@"Image_hsmian4");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"28" ofType:@"m4a"];
            [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        }else if (self.type == 2){
            _recoBtn.hidden = YES;
            _acceptView.hidden = YES;
            _voiceView.hidden = YES;
            self.mainImageView.hidden = NO;
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-420, 315, 420);
            self.mainImageView.image = UIImageNamed(@"Image_leadjl4");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"38" ofType:@"m4a"];
            [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        }else if (self.type == 3){
            _recoBtn.hidden = YES;
            _acceptView.hidden = YES;
            _voiceView.hidden = YES;
            self.mainImageView.hidden = NO;
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-420, 315, 420);
            self.mainImageView.image = UIImageNamed(@"Image_lys2");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"48" ofType:@"m4a"];
            [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        }else if (self.type == 4){
            _recoBtn.hidden = YES;
            _acceptView.hidden = YES;
            _voiceView.hidden = YES;
            self.mainImageView.hidden = NO;
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-420, 315, 420);
            self.mainImageView.image = UIImageNamed(@"Image_leadlymain2");
            NSString *path = [[NSBundle mainBundle] pathForResource:@"58" ofType:@"m4a"];
            [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        }

    }else if (self.index == 6){//完成后的操作1
        if (self.type == 0) {
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_leadmain4");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"108" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }else if(self.type == 1){
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_hsmian5");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"29" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }else if (self.type == 2){
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-420, 315, 420);
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_leadjl5");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"39" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }else if (self.type == 3){
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_lys3");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"49" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }else if (self.type == 4){
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_leadlymain3");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"59" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }
      
    }else if (self.index == 7){//完成后的操作1
        if (self.type == 0) {
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_leadmain5");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"109" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }else if(self.type == 1){
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_hsmian6");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"210" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }else if (self.type == 2){
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-420, 315, 420);
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_leadjl6");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"310" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }else if (self.type == 3){
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-420, 315, 420);
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_lys4");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"410" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }else if (self.type == 4){
            self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-420, 315, 420);
            [UIView transitionWithView:self.mainImageView duration:0.7 options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionCurveEaseOut animations:^{
                self.mainImageView.image = UIImageNamed(@"Image_leadlymain4");
                NSString *path = [[NSBundle mainBundle] pathForResource:@"510" ofType:@"m4a"];
                [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
            } completion:nil];
        }
  
    }else if (self.index == 8){//完成后的操作1
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"100"}];
        [self disMiss];
    }
}

//录音点击
- (void)recClick{
    if (self.type == 0) {
        [self disMiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":[NSString stringWithFormat:@"%ld",self.type]}];
    }else if (self.type == 1){
        self.mainImageView.image = UIImageNamed(@"Image_hsmian2");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"24" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
    }

}

//接受任务
- (void)getClick{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"103" ofType:@"m4a"];
    [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
}

//放弃任务
- (void)giveUpClick{
    [self closeClick];
}
//点击悄悄话
- (void)hsClick{
    if (self.type != 1) {
        return;
    }
    [_voicePlayer stopPlaying];

    NoticeVoiceListModel *model = [[NoticeVoiceListModel alloc] init];
    NoticeVoiceListSubModel *subModel = [[NoticeVoiceListSubModel alloc] init];
    model.voice_id = @"2176928";
    model.isSelf = NO;
    subModel.userId = @"717789";
    model.subUserModel = subModel;
    self.hsVoiceM = model;
    NoticeNewChatVoiceView *chatView = [[NoticeNewChatVoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    chatView.voiceM = model;
    chatView.toUserId = [NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId];
    chatView.isLead = YES;
    chatView.userId = model.subUserModel.userId;
    chatView.chatId = model.chat_id;
    __weak typeof(self) weakSelf = self;
    chatView.hsBlock = ^(BOOL hs) {
        [weakSelf hs];
    };
    self.chatView = chatView;
    [chatView show];
}


- (void)reRecoderLocalVoice{
    [self hs];
}

- (void)hs{
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:GETTEXTWITE(@"chat.limit")];
    recodeView.isHS = YES;
    recodeView.noPushLeade = YES;
    recodeView.isLead = YES;
    recodeView.needLongTap = YES;
    recodeView.hideCancel = NO;
    recodeView.delegate = self;
    
    recodeView.isReply = YES;
    recodeView.startRecdingNeed = YES;
    __weak typeof(self) weakSelf = self;
    recodeView.overGuidelock = ^(BOOL isGiveUp) {
        [weakSelf.chatView close];
        [weakSelf disMiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":@"100"}];
    };
    [recodeView show];
}

//悄悄话
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.aac",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    
   
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *sendDic = [NSMutableDictionary new];
            [sendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.hsVoiceM.subUserModel.userId] forKey:@"to"];
            [sendDic setObject:@"singleChat" forKey:@"flag"];
            
            NSMutableDictionary *messageDic = [NSMutableDictionary new];
            [messageDic setObject:self.hsVoiceM.voice_id forKey:@"voiceId"];
            [messageDic setObject:@"1" forKey:@"dialogContentType"];
            [messageDic setObject:Message forKey:@"dialogContentUri"];
            [messageDic setObject:timeLength forKey:@"dialogContentLen"];
            if (bucketId) {
                [messageDic setObject:bucketId forKey:@"bucketId"];
            }
            [sendDic setObject:messageDic forKey:@"data"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:sendDic];
          
            appdel.canRefresDialNum = YES;
            
            [self.chatView close];
            self.canNext = YES;
            self.index = 4;
            self.mainImageView.hidden = NO;
            [self next];
            
            if (appdel.currentGudeId) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:appdel.currentGudeId forKey:@"taskGuideId"];
                [parm setObject:@"2" forKey:@"platformId"];
                [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"taskGuide" Accept:@"application/vnd.shengxi.v5.3.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHGNEWSTOPLIST" object:nil];
                    }
                } fail:^(NSError * _Nullable error) {
                    
                }];
            }
        }
    }];
}



- (void)playVoiceClick{
    if (self.type == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTARTRECODERLEADE" object:nil userInfo:@{@"type":[NSString stringWithFormat:@"%ld",self.type]}];
        [self disMiss];
        return;
    }
    if (self.type != 1) {
        return;
    }
    [self.voicePlayer startPlayWithUrl:@"https://sx-pro.oss-cn-shenzhen.aliyuncs.com/user-voice/20220315/717789/20220315_105343781437c49b1d923b0f64c1fae805e669.aac" isLocalFile:NO];
}

- (void)finishShow{
    self.index = 4;
    self.canNext = YES;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = YES;
    [appdel.floatView.audioPlayer stopPlaying];
    
    if (appdel.currentGudeId) {
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:appdel.currentGudeId forKey:@"taskGuideId"];
        [parm setObject:@"2" forKey:@"platformId"];
        [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"taskGuide" Accept:@"application/vnd.shengxi.v5.3.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHGNEWSTOPLIST" object:nil];
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
    }
    [self next];
}

- (void)show{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = YES;
    self.index = 0;
    self.canNext = YES;
    self.mainImageView.hidden = NO;
    self.mainImageView.frame = CGRectMake((DR_SCREEN_WIDTH-315)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-463, 315, 463);
    self.acceptView.hidden = YES;
    _voiceView.hidden = YES;
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    if (self.type==0) {//发心情
        self.mainImageView.image = UIImageNamed(@"Image_leadmain1");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"101" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
    }else if (self.type == 1){//回声
        self.mainImageView.image = UIImageNamed(@"Image_hsmian1");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"21" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
    }else if (self.type == 2){//交流
        self.mainImageView.image = UIImageNamed(@"Image_leadjl1");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"31" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
    }else if (self.type == 3){//每日一阅
        self.mainImageView.image = UIImageNamed(@"Image_leadjl1");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"31" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];

    }else if (self.type == 4){//客服
        self.mainImageView.image = UIImageNamed(@"Image_leadjl1");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"31" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];

    }

}

- (void)closeClick{
    if (self.index >= 5) {
        [self disMiss];
        return;
    }
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定放弃任务吗？" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            self.canNext = NO;
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }

            CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                            withSubType:kCATransitionFromLeft
                                                                               duration:0.3f
                                                                         timingFunction:kCAMediaTimingFunctionLinear
                                                                                   view:nav.topViewController.navigationController.view];
            [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
            NoticeLeaderController *ctl = [[NoticeLeaderController alloc] init];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            [weakSelf disMiss];
        }
    };
    [alerView showXLAlertView];
}

- (void)disMiss{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    _voiceView.hidden = YES;
    _recoBtn.hidden = YES;
    _acceptView.hidden = YES;
    [self removeFromSuperview];
    self.canNext = NO;
    [_noNextPlayer stopPlaying];
    [_voicePlayer stopPlaying];
    [self.audioPlayer stopPlaying];
}
@end
