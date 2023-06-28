//
//  NoticeTimePlayer.m
//  NoticeXi
//
//  Created by li lei on 2018/12/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTimePlayer.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeTextVoiceController.h"
@implementation NoticeTimePlayer
{
    UIButton *_addbutton;
    UIImageView *_backImageView;
    UIImageView *_coverImageView;
    UILabel *_statL;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.isReplay = YES;
        self.backgroundColor =  GetColorWithName(VBackColor);

        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if ([NoticeTools isWhiteTheme]) {
            backImageView.image = UIImageNamed(@"Image_back_sgj");
        }else{
            backImageView.backgroundColor = GetColorWithName(VBackColor);
        }
        _backImageView = backImageView;
        [self addSubview:backImageView];
        
        NSArray *imagArr = @[@"Image_type_sgj",@"Image_befo_sgj",[NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy",@"Image_next_sgj",@"Image_list_sgj"];
        CGFloat space = (DR_SCREEN_WIDTH-44-26*5)/4;
        for (int i = 0; i < 5; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(22+(space+26)*i, frame.size.height-25-30-BOTTOM_HEIGHT, 26, 30)];
            button.tag = i;
            [button setImage:UIImageNamed(imagArr[i]) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(actionsClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (i == 2) {
                _playButton = button;
            }
            if (i == 0) {
                _typeButton = button;
            }
        }
        
        if ([[NoticeTools getPlayType] isEqualToString:@"one"]) {
            self.playType = @"one";
            [_typeButton setImage:UIImageNamed(@"Image_one_sgj") forState:UIControlStateNormal];
        }else if ([[NoticeTools getPlayType] isEqualToString:@"arm"]){
            self.playType = @"arm";
            [_typeButton setImage:UIImageNamed(@"Image_ram_sgj") forState:UIControlStateNormal];
        }else{
            self.playType = @"list";
            [_typeButton setImage:UIImageNamed(@"Image_type_sgj") forState:UIControlStateNormal];
        }
      
        
        _minTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, frame.size.height-25-30-BOTTOM_HEIGHT-29-9, GET_STRWIDTH(@"00:00", 9, 9), 9)];
        _minTimeLabel.text = @"0:00";
        _minTimeLabel.font = [UIFont systemFontOfSize:9];
        _minTimeLabel.textColor = [NoticeTools isWhiteTheme] ? [UIColor colorWithHexString:@"#FBF8F5"] : GetColorWithName(VMainTextColor);
        _minTimeLabel.alpha = [NoticeTools isWhiteTheme] ? 0.6 : 1;
        [self addSubview:_minTimeLabel];
        
        _maxTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-18-GET_STRWIDTH(@"00:00", 9, 9), frame.size.height-25-30-BOTTOM_HEIGHT-29-9, GET_STRWIDTH(@"00:00", 9, 9), 9)];
        _maxTimeLabel.text = @"0:00";
        _maxTimeLabel.font = [UIFont systemFontOfSize:9];
        _maxTimeLabel.textColor = [NoticeTools isWhiteTheme] ? [UIColor colorWithHexString:@"#FBF8F5"] : GetColorWithName(VMainTextColor);
        _maxTimeLabel.alpha = [NoticeTools isWhiteTheme] ? 0.6 : 1;
        [self addSubview:_maxTimeLabel];
        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_minTimeLabel.frame)+10, _minTimeLabel.frame.origin.y-2, DR_SCREEN_WIDTH-44-20-_minTimeLabel.frame.size.width*2, 13)];
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        [_slider setThumbImage:UIImageNamed(@"Image_trak_sgj") forState:UIControlStateNormal];
        _slider.alpha = 0.6;
        [_slider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(handleSlideEnd:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_slider];
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _audioPlayer = app.audioPlayer;
        
        self.noDataView = [[UILabel alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,frame.size.height-self.addView.frame.size.height)];
        self.noDataView.textAlignment = NSTextAlignmentCenter;
        self.noDataView.textColor = GetColorWithName(VMainThumeColor);
        self.noDataView.font = THRETEENTEXTFONTSIZE;
        self.noDataView.text = @"如何添加心情?";
        self.noDataView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapN = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nodataTosttap)];
        [self.noDataView addGestureRecognizer:tapN];
        [self addSubview:self.noDataView];
        self.noDataView.hidden = YES;
        
        self.textL = [[UILabel alloc] initWithFrame:CGRectMake(78, 15, DR_SCREEN_WIDTH-78*2, 20)];
        self.textL.font = TWOTEXTFONTSIZE;
        self.textL.textColor = [NoticeTools getWhiteColor:@"#B5D1DE" NightColor:@"#778991"];
        [self addSubview:self.textL];
        self.textL.hidden = YES;
        
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 50)];
        leftView.backgroundColor = GetColorWithName(VBackColor);
        if ([NoticeTools isWhiteTheme]) {
            leftView.image = UIImageNamed(@"Image_textBack_b");
        }
        [self addSubview:leftView];
        
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-78, 0, 78, 50)];
        rightView.backgroundColor = GetColorWithName(VBackColor);
        if ([NoticeTools isWhiteTheme]) {
            rightView.image = UIImageNamed(@"Image_textBack_b");
        }
        [self addSubview:rightView];
            
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,frame.size.height-_slider.frame.origin.y)];
        _timeL.textColor = [NoticeTools isWhiteTheme] ? [UIColor colorWithHexString:@"#FBF8F5"] : GetColorWithName(VMainTextColor);
        _timeL.numberOfLines = 0;
        _timeL.font = [UIFont systemFontOfSize:16];
        _timeL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeL];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-47, 10, 47, 22)];
        sendBtn.backgroundColor = GetColorWithName(VMainThumeColor);
        [sendBtn setTitle:[NoticeTools getTextWithSim:@"发心情" fantText:@"發心情"] forState:UIControlStateNormal];
        [sendBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        sendBtn.layer.cornerRadius = 11;
        sendBtn.layer.masksToBounds = YES;
        self.sendButton = sendBtn;
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        
        _lockImageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-22-22, _timeL.frame.origin.y+(_timeL.frame.size.height-22)/2, 22, 22)];
        _lockImageV.image = UIImageNamed(@"Imagelock");
        [self addSubview:_lockImageV];
        _lockImageV.hidden = YES;
    }
    return self;
}

- (void)setIsLimit:(BOOL)isLimit{
    _isLimit = isLimit;
    if (isLimit) {
        self.noDataView.hidden = YES;
        self.sendButton.hidden = YES;
    }
}

- (void)nodataTosttap{
    NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithAddZJView];
    [pinV showTostView];
}

- (void)sendClick{
    _needStop = YES;
    [self next];
    NoticeChoiceRecoderView *choiceView = [[NoticeChoiceRecoderView alloc] initWithShowChoiceSendType];
    choiceView.choiceTag = ^(NSInteger tag) {
        if (tag == 2) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];
        }else{
                
            NoticeRecoderMain *recoderView = [[NoticeRecoderMain alloc] initWithImageView:[NoticeTools isWhiteTheme]?@"sendMain_img":@"sendMain_imgy" type:NoticeRecoderTime];
            recoderView.zjId = self.zjId;
            recoderView.isLongTime = tag == 1?YES:NO;
            [recoderView startRecoder];
        }
    };
    [choiceView showChoiceView];

}

- (void)dealloc{
    [_audioPlayer stopPlaying];
}

//设置当前声昔信息
- (void)setCurrentModel:(NoticeVoiceListModel *)currentModel{
    _currentModel = currentModel;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayModel:)]) {
        [self.delegate currentPlayModel:currentModel];
    }
    
    _lockImageV.hidden = !currentModel.is_private.integerValue;
    self.maxTimeLabel.text = [self getMMSSFromSS:currentModel.voice_len];
    if (!self.isFirstGetIn) {
        if (currentModel.topicName.length && currentModel.topicName) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",currentModel.timeSgj,currentModel.topicName]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:8];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[NSString stringWithFormat:@"%@\n%@",currentModel.timeSgj,currentModel.topicName] length])];
            self.timeL.attributedText = attributedString;
        }else{
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",currentModel.timeSgj]];
            self.timeL.attributedText = attributedString;
        }
    }

    self.timeL.textAlignment = NSTextAlignmentCenter;
    self.slider.maximumValue = currentModel.voice_len.integerValue;
    self.slider.minimumValue = 0;
}

- (void)choicePlay:(NSInteger)index{
    self.currentIndex = index;
    self.currentModel = self.voiceArr[self.currentIndex];
    self.isReplay = YES;
    self.isClick = YES;
    self.slider.value = 0;
    self.maxTimeLabel.text = [self getMMSSFromSS:_currentModel.voice_len];
    self.minTimeLabel.text = [self getMMSSFromSS:@"0"];
    [self startPlay:self.currentModel];
}

- (void)setNeedPasue:(BOOL)needPasue{
    _needPasue = needPasue;
    if (needPasue) {
        self.isPasue = YES;
        [self.audioPlayer pause:YES];
        [self.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
    }
}

- (void)setNeedStop:(BOOL)needStop{
    _needStop = needStop;
    [self.audioPlayer pause:YES];
    if (needStop) {
        self.isReplay = YES;
        [self.audioPlayer stopPlaying];
        self.slider.value = 0;
        if (_currentModel) {
            self.maxTimeLabel.text = [self getMMSSFromSS:_currentModel.voice_len];
            self.minTimeLabel.text = [self getMMSSFromSS:@"0"];
        }
        [self.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
    }
}

//开始或者暂停播放
- (void)startPlay:(NoticeVoiceListModel *)model{
    if (_needStop) {
        [self.audioPlayer pause:YES];
    }
    if (self.isFirstGetIn) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayModel:)]) {
            [self.delegate currentPlayModel:_currentModel];
        }
        if (model.topicName.length && model.topicName) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",model.timeSgj,model.topicName]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:8];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[NSString stringWithFormat:@"%@\n%@",model.timeSgj,model.topicName] length])];
            self.timeL.attributedText = attributedString;
        }else{
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.timeSgj]];
            self.timeL.attributedText = attributedString;
        }
        
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.isFirstGetIn = NO;
    }
    
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.voice_url isLocalFile:NO];
        [self addNumbers:model];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        [self.audioPlayer pause:self.isPasue];
        [self.playButton setImage:UIImageNamed(self.isPasue ? ([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy"): @"Image_stop_sgj") forState:UIControlStateNormal];
        if (!self.isPasue) {//增加收听数
            [self addNumbers:model];
        }
    }
    self.textL.text = model.contentStr;
    self.textL.hidden = YES;//[NoticeTools isCotentOpen];
    
    model.contentWidth = GET_STRWIDTH(model.contentStr, 12, 20);
    model.contentLWidth = DR_SCREEN_WIDTH-78*2;
    model.overContentWidth = model.contentWidth-model.contentLWidth;
    if (model.overContentWidth > 3) {//如果文字长度超出了可显示长度
        self.textL.frame = CGRectMake(78, 15,model.contentWidth, 20);
        self.textL.textAlignment = NSTextAlignmentLeft;
        if (model.voice_len.intValue) {
            model.moveSpeed = model.overContentWidth/model.voice_len.intValue;//文字滚动速度
        }
    }else{
        self.textL.frame = CGRectMake((DR_SCREEN_WIDTH-model.contentWidth)/2, 15,model.contentWidth, 20);
        self.textL.textAlignment = NSTextAlignmentCenter;
    }
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
        }else{
            [weakSelf.playButton setImage:UIImageNamed(@"Image_stop_sgj") forState:UIControlStateNormal];
        }
    };
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.audioPlayer.playComplete = ^{
        weakSelf.textL.hidden = YES;
        weakSelf.isReplay = YES;
        weakSelf.slider.value = 0;
        weakSelf.maxTimeLabel.text = [weakSelf getMMSSFromSS:model.voice_len];
        weakSelf.minTimeLabel.text = [weakSelf getMMSSFromSS:@"0"];
        [weakSelf.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
        if (!weakSelf.isClick) {//手动点击不算
            if (!app.needStop) {
                if ([weakSelf.playType isEqualToString:@"one"]) {
                    [weakSelf onePlay];
                }else{
                    [weakSelf next];
                }
            }else{
                app.needStop = NO;
            }
        }else{
            weakSelf.isClick = NO;
        }

    };

    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        weakSelf.isClick = NO;
        weakSelf.textL.hidden = NO;
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.voice_len.integerValue) {
            currentTime = model.voice_len.integerValue;
        }
   
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  !((model.voice_len.integerValue-currentTime)>0) || [[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-1"] || ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"] && [model.voice_len isEqualToString:@"1"])) {
            weakSelf.maxTimeLabel.text = [weakSelf getMMSSFromSS:model.voice_len];
            [weakSelf.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
            weakSelf.isReplay = YES;
            weakSelf.textL.hidden = YES;
            if (![model.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
                if (!model.is_collected.boolValue) {
                    [weakSelf likeVoice:model];
                }
            }else{//是自己的，需要在没达成成就的时候提交成就
//                if ([NoticeComTools needTostAchmentForSgj]) {
//                    [NoticeComTools noNeedTostAchMentForSgj:@"2"];
//                    NSMutableDictionary *parm = [NSMutableDictionary new];
//                    [parm setObject:@"2" forKey:@"achievementType"];
//                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"achievement" Accept:@"application/vnd.shengxi.v4.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
//                        if (success) {
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHAchment" object:nil];
//                            [[[NoticeAchmentTost alloc] initWithFrame:CGRectZero] showForSgj];
//                        }
//                    } fail:^(NSError * _Nullable error) {
//
//                    }];
//                }
            }
        }
        if (currentTime > model.voice_len.integerValue) {
            weakSelf.maxTimeLabel.text = [weakSelf getMMSSFromSS:model.voice_len];
            weakSelf.minTimeLabel.text = [weakSelf getMMSSFromSS:@"0"];
        }else{
            weakSelf.maxTimeLabel.text = [weakSelf getMMSSFromSS:[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime]];
            weakSelf.minTimeLabel.text = [weakSelf getMMSSFromSS:[NSString stringWithFormat:@"%.f",currentTime]];
        }
        
        if ([weakSelf.maxTimeLabel.text isEqualToString:@"0:00"]) {
            weakSelf.slider.value = model.voice_len.integerValue;
            weakSelf.maxTimeLabel.text = [weakSelf getMMSSFromSS:model.voice_len];
        }
        if ([weakSelf.minTimeLabel.text isEqualToString:[weakSelf getMMSSFromSS:model.voice_len]]) {
            weakSelf.minTimeLabel.text = @"0:00";
        }
        weakSelf.slider.value = currentTime;
        if (model.moveSpeed > 0 && model.overContentWidth > 0) {
            weakSelf.textL.frame = CGRectMake(78-model.moveSpeed*currentTime, 15,model.contentWidth, 20);
        }
    };
}

- (void)likeVoice:(NoticeVoiceListModel *)playerM{
    if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:@"5" forKey:@"needDelay"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",playerM.user_id,playerM.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":playerM.voice_id}];
            playerM.is_collected = @"1";
        }
    } fail:^(NSError *error) {
    }];
}

//滑动进度条
- (void)handleSlide:(UISlider *)slider{

    if (!self.voiceArr.count) {
        return;
    }
    if (self.isReplay) {//如果还没播放过，则要先进行播放设置
        [self startPlay:_currentModel];
    }
    // 先暂停
    self.isPasue = YES;
    [self.audioPlayer pause:self.isPasue];
    if (_currentModel.moveSpeed > 0 && _currentModel.overContentWidth > 0) {
        self.textL.frame = CGRectMake(78-_currentModel.moveSpeed*slider.value, 15,_currentModel.contentWidth, 20);
    }
}

- (void)handleSlideEnd:(UISlider *)slider{

    [self.audioPlayer.player seekToTime:CMTimeMake(slider.value, 1) completionHandler:^(BOOL finished) {
     
        if (finished) {
            self.isPasue = NO;
            [self.audioPlayer pause:self.isPasue];
            [self.playButton setImage:UIImageNamed(self.isPasue ? ([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") : @"Image_stop_sgj") forState:UIControlStateNormal];
        }
    }];
}

//底部五个按钮的点击事件
- (void)actionsClick:(UIButton *)button{
    if (!self.voiceArr.count) {
        if (button.tag < 4) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(noDataClick)]) {
                [self.delegate noDataClick];
            }
            return;
        }
    }
    
    if (button.tag == 2) {//播放、暂停

        if (self.currentModel) {
            [self startPlay:self.currentModel];
        }
    }else if (button.tag == 1){//上一曲
        self.isClick = YES;
        [self before];
    }else if (button.tag == 3){//下一曲
        self.isClick = YES;
        [self next];
    }else if (button.tag == 0){
        if ([self.playType isEqualToString:@"list"]) {
            self.playType = @"arm";
            [_typeButton setImage:UIImageNamed(@"Image_ram_sgj") forState:UIControlStateNormal];
        }else if ([self.playType isEqualToString:@"arm"]){
            self.playType = @"one";
            [_typeButton setImage:UIImageNamed(@"Image_one_sgj") forState:UIControlStateNormal];
        }else{
            self.playType = @"list";
            [_typeButton setImage:UIImageNamed(@"Image_type_sgj") forState:UIControlStateNormal];
        }
        [NoticeTools savePlayType:self.playType];
    }else if (button.tag == 4){
        if (self.delegate && [self.delegate respondsToSelector:@selector(showTimeListDelegate)]) {
            [self.delegate showTimeListDelegate];
        }
    }
}

//下一首歌曲
- (void)next{
    if (_needStop) {
        [self.audioPlayer pause:YES];
        _needStop = NO;
        return;
    }
   if ([self.playType isEqualToString:@"arm"]) {//随机播放
        self.currentIndex =  arc4random() % self.voiceArr.count;
        self.currentModel = self.voiceArr[self.currentIndex];
        [self.audioPlayer stopPlaying];
        self.isReplay = YES;
        [self.audioPlayer pause:YES];
        [self startPlay:_currentModel];
    }else{//
        if (self.currentIndex == self.voiceArr.count-1) {
            self.currentIndex = 0;
            self.currentModel = self.voiceArr[self.currentIndex];
            [self.audioPlayer stopPlaying];
            self.isReplay = YES;
            [self.audioPlayer pause:YES];
            [self startPlay:_currentModel];
        }else if (self.currentIndex < self.voiceArr.count-1){
            self.currentModel = self.voiceArr[self.currentIndex+1];
            self.currentIndex++;
            [self.audioPlayer stopPlaying];
            self.isReplay = YES;
            [self.audioPlayer pause:YES];
            [self startPlay:_currentModel];
        }
    }
}

- (void)onePlay{
    if (_needStop) {
        [self.audioPlayer pause:YES];
        _needStop = NO;
        return;
    }
    self.currentModel = self.voiceArr[self.currentIndex];
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    [self.audioPlayer pause:YES];
    [self startPlay:_currentModel];
}

//上一首歌曲
- (void)before{
    if (_needStop) {
        [self.audioPlayer pause:YES];
        _needStop = NO;
        return;
    }
   if ([self.playType isEqualToString:@"arm"]) {//随机播放
        self.currentIndex =  arc4random() % self.voiceArr.count;
        self.currentModel = self.voiceArr[self.currentIndex];
        [self.audioPlayer stopPlaying];
        self.isReplay = YES;
        [self.audioPlayer pause:YES];
        [self startPlay:_currentModel];
    }else{//单曲循环
        if (self.currentIndex == 0) {//如果当前是第一首
            self.currentIndex = self.voiceArr.count-1;
            self.currentModel = self.voiceArr[self.currentIndex];
            [self.audioPlayer stopPlaying];
            self.isReplay = YES;
            [self.audioPlayer pause:YES];
            [self startPlay:_currentModel];
        }else if (self.currentIndex > 0){
            self.currentModel = self.voiceArr[self.currentIndex-1];
            self.currentIndex--;
            [self.audioPlayer stopPlaying];
            self.isReplay = YES;
            [self.audioPlayer pause:YES];
            [self startPlay:_currentModel];
        }
    }
}

//增加收听数
- (void)addNumbers:(NoticeVoiceListModel *)choiceModel{
    
    NoticeVoiceListModel *model = choiceModel;
    
    NSString *url = [NSString stringWithFormat:@"users/%@/voices/%@",choiceModel.subUserModel.userId,model.voice_id];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            
        }
    } fail:^(NSError *error) {
    }];
}

- (void)setTimeStart:(NSString *)timeStart{
    _timeStart = timeStart;
    if (!timeStart) {
        return;
    }
    self.timeL.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.addView.frame.size.height);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:timeStart];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [timeStart length])];
    self.timeL.attributedText = attributedString;
    self.timeL.textAlignment = NSTextAlignmentCenter;
}

- (void)setRealisAbout:(NoticeAbout *)realisAbout{
    _realisAbout = realisAbout;
    if ([realisAbout.friend_status isEqualToString:@"2"]) {//好友的时候
        [self.addView removeFromSuperview];
    }else if ([realisAbout.friend_status isEqualToString:@"0"]){
        if ([realisAbout.strange_view isEqualToString:@"-1"]) {//非好友，但是全部可见
            [self.addView removeFromSuperview];
        }else if ([realisAbout.strange_view isEqualToString:@"0"]){//非好友，禁止
            [self.addView removeFromSuperview];
            [self addSubview:self.addView];
            _statL.text = [NoticeTools getTextWithSim:@"ta设置了时光机仅限学友收听" fantText:@"ta設置了時光機僅限学友收聽"];
            _addbutton.backgroundColor = [UIColor colorWithHexString:[NoticeTools isWhiteTheme]?WHITEMAINCOLOR:@"#4B8E90"];
            [_addbutton setTitle:@"+ 学友" forState:UIControlStateNormal];
            [_addbutton setTitleColor:[UIColor colorWithHexString:[NoticeTools isWhiteTheme]?@"#FFFFFF":@"#B2B2B2"] forState:UIControlStateNormal];
        }
    }else if ([realisAbout.friend_status isEqualToString:@"1"] && [realisAbout.strange_view isEqualToString:@"0"]){//等待验证
        [self.addView removeFromSuperview];
        [self addSubview:self.addView];
        [_addbutton setTitle:@"等待验证" forState:UIControlStateNormal];
        _statL.text = [NoticeTools getTextWithSim:@"ta设置了时光机仅限学友收听" fantText:@"ta設置了時光機僅限学友收聽"];
        _addbutton.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#181828"];
        [_addbutton setTitleColor:[NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3E3E4A"] forState:UIControlStateNormal];
    }
}

- (void)addClick{
    if (!self.userId || [_realisAbout.friend_status isEqualToString:@"1"]) {
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.userId forKey:@"toUserId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/friendslog",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            self->_realisAbout.friend_status = @"1";
            [self->_addbutton setTitle:@"等待验证" forState:UIControlStateNormal];
            self->_addbutton.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#181828"];
            [self->_addbutton setTitleColor:[NoticeTools getWhiteColor:@"#b2b2b2" NightColor:@"#3E3E4A"] forState:UIControlStateNormal];
            [NoticeAddFriendTools addFriendWithUserId:self.userId];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addFriendNotice" object:nil];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (UIView *)addView{
    if (!_addView) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, _maxTimeLabel.frame.origin.y-5, DR_SCREEN_WIDTH, self.frame.size.height-_maxTimeLabel.frame.origin.y+5)];
        _addView.backgroundColor = GetColorWithName(VBackColor);
        _addbutton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-75)/2, _addView.frame.size.height-15-22-BOTTOM_HEIGHT, 75, 22)];
        [_addbutton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        _addbutton.layer.cornerRadius = 11;
        _addbutton.layer.masksToBounds = YES;
        _addbutton.titleLabel.font = [UIFont systemFontOfSize:9];
        [_addView addSubview:_addbutton];
        
        //sgj.add
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, _addView.frame.size.height-15-22-BOTTOM_HEIGHT)];
        label.font = THRETEENTEXTFONTSIZE;
        label.numberOfLines = 0;
        label.textColor = GetColorWithName(VDarkTextColor);
        [_addView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        _statL = label;
    }
    return _addView;
}

//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",(NSInteger)seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",(NSInteger)seconds%60];
    //format of time
    if (str_second.integerValue < 10) {
        str_second = [NSString stringWithFormat:@"0%@",str_second];
    }
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}
@end
