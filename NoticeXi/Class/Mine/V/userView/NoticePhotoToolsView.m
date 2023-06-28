//
//  NoticePhotoToolsView.m
//  NoticeXi
//
//  Created by li lei on 2019/6/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticePhotoToolsView.h"
#import "AppDelegate.h"
@implementation NoticePhotoToolsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#252525"] colorWithAlphaComponent:1];
        self.funView = [[NoticeTimeFunView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, 49)];
        self.funView.isPhoto = YES;
        self.funView.delegate = self;
        [self addSubview:self.funView];
        
        self.playBcakView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, DR_SCREEN_WIDTH,45+BOTTOM_HEIGHT)];
        [self addSubview:self.playBcakView];
        
        _minTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,7, GET_STRWIDTH(@"00:00", 9, 9), 9)];
        _minTimeLabel.text = @"0:00";
        _minTimeLabel.font = [UIFont systemFontOfSize:9];
        _minTimeLabel.textColor = [UIColor colorWithHexString:@"#FBF8F5"];
        _minTimeLabel.alpha = [NoticeTools isWhiteTheme] ? 0.6 : 1;
        [self.playBcakView addSubview:_minTimeLabel];
        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_minTimeLabel.frame)+10, _minTimeLabel.frame.origin.y-2, DR_SCREEN_WIDTH-30-30-_minTimeLabel.frame.size.width*2-22, 13)];
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        [_slider setThumbImage:UIImageNamed(@"Image_trak_sgj") forState:UIControlStateNormal];
        _slider.alpha = 0.6;
         [_slider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
        
        [self.playBcakView addSubview:_slider];
        
        _maxTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_slider.frame)+10,2, GET_STRWIDTH(@"00:00", 9, 9), 9)];
        _maxTimeLabel.text = @"0:00";
        _maxTimeLabel.font = [UIFont systemFontOfSize:9];
        _maxTimeLabel.textColor = [UIColor colorWithHexString:@"#FBF8F5"];
        _maxTimeLabel.alpha = [NoticeTools isWhiteTheme] ? 0.6 : 1;
        [self.playBcakView addSubview:_maxTimeLabel];
        
        self.isReplay = YES;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_maxTimeLabel.frame)+8, _minTimeLabel.frame.origin.y-7,22,22)];
        [button setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionsClick:) forControlEvents:UIControlEventTouchUpInside];
        _playButton = button;
        [self.playBcakView addSubview:button];
        
        self.playBcakView.hidden = YES;
        
        self.contentL = [[UILabel alloc] init];
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#72727f"];

        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 49, DR_SCREEN_WIDTH-30,DR_SCREEN_HEIGHT-49-NAVIGATION_BAR_HEIGHT)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.hidden = YES;
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.contentL];
        self.scrollView.delegate = self;
    }
    return self;
}

//滑动进度条
- (void)handleSlide:(UISlider *)slider{
 
    if (self.isReplay) {//如果还没播放过，则要先进行播放设置
        [self actionsClick:nil];
    }
    // 先暂停
    self.isPasue = YES;
    [self.audioPlayer pause:self.isPasue];
    //[self.playButton setImage:UIImageNamed(self.isPasue ? @"Image_play_sgj" : @"Image_stop_sgj") forState:UIControlStateNormal];
    
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(slider.value, 1) completionHandler:^(BOOL finished) {
        
        if (finished) {
            self.isPasue = NO;
            [self.audioPlayer pause:self.isPasue];
            [self.playButton setImage:UIImageNamed(self.isPasue ? ([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") : @"Image_stop_sgj") forState:UIControlStateNormal];
        }
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
       CGFloat contentYoffset = scrollView.contentOffset.y;
    DRLog(@"%f",contentYoffset);
    if (contentYoffset < -80) {
        if (self.hideBlock) {
            self.hideBlock(YES);
        }
    }
}

- (void)hasClickShareToWorld{
    self.isPasue = YES;
    [self.audioPlayer pause:self.isPasue];
    [self.playButton setImage:UIImageNamed(self.isPasue ? ([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") : @"Image_stop_sgj") forState:UIControlStateNormal];
}

- (void)actionsClick:(UIButton *)button{
    NoticeVoiceListModel *model = _currentModel;
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:model.voice_url isLocalFile:NO];
        [self addNumbers:model];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        [self.audioPlayer pause:self.isPasue];
        [self.playButton setImage:UIImageNamed(self.isPasue ?([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") : @"Image_stop_sgj") forState:UIControlStateNormal];
        if (!self.isPasue) {//增加收听数
            [self addNumbers:model];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
        }else{
            [weakSelf.playButton setImage:UIImageNamed(@"Image_stop_sgj") forState:UIControlStateNormal];
        }
    };
    
    self.audioPlayer.playComplete = ^{
        [weakSelf.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        
        if ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  !((model.voice_len.integerValue-currentTime)>0) || [[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"-1"] || ([[NSString stringWithFormat:@"%.f",model.voice_len.integerValue-currentTime] isEqualToString:@"0"] && [model.voice_len isEqualToString:@"1"])) {
            weakSelf.maxTimeLabel.text = [weakSelf getMMSSFromSS:model.voice_len];
            [weakSelf.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
            weakSelf.isReplay = YES;
            weakSelf.audioPlayer.playComplete = ^{
               weakSelf.slider.value = 0;
            };
            [weakSelf likeVoice:model];
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
    };
}

- (void)likeVoice:(NoticeVoiceListModel *)playerM{
    if ([playerM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {//如果是自己的心情就不点赞
        return;
    }
    if (playerM.is_collected.intValue) {
        return;
    }
    [self.funView likeAndShareTap];
}


- (void)setIsRefresh:(BOOL)isRefresh{
    _isRefresh = isRefresh;
    self.isReplay = YES;
    [self.audioPlayer stopPlaying];
    self.slider.value = 0;
    self.minTimeLabel.text = [self getMMSSFromSS:@"0"];
    self.maxTimeLabel.text = [self getMMSSFromSS:_currentModel.voice_len];
    [self.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
}

- (void)timeListHasClickReplySuccessDelegate{
    self.isRefresh = YES;
}

- (void)timeListHasClickReplyDelegate{
    self.isPasue = YES;
    [self.audioPlayer pause:self.isPasue];
    [self.playButton setImage:UIImageNamed(self.isPasue ? ([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") : @"Image_stop_sgj") forState:UIControlStateNormal];
}

- (void)setCurrentModel:(NoticeVoiceListModel *)currentModel{
    _currentModel = currentModel;
    self.maxTimeLabel.text = [self getMMSSFromSS:currentModel.voice_len];
    self.slider.maximumValue = currentModel.voice_len.integerValue;
    self.slider.minimumValue = 0;
    
    self.scrollView.hidden = currentModel.content_type.intValue == 2?NO:YES;
    self.playBcakView.hidden = !self.scrollView.hidden;
    
    self.contentL.attributedText = currentModel.allTextAttStr;
    self.contentL.frame = CGRectMake(0,0, DR_SCREEN_WIDTH-30, currentModel.textHeight);
    self.funView.listenL.hidden = self.playBcakView.hidden;
    self.scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH-30, currentModel.textHeight);
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

//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];

    NSString *str_minute = [NSString stringWithFormat:@"%d",(int)seconds/60];

    NSString *str_second = [NSString stringWithFormat:@"%d",(int)seconds%60];
    //format of time
    if (str_second.integerValue < 10) {
        str_second = [NSString stringWithFormat:@"0%@",str_second];
    }
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
    
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        _audioPlayer = [[LGAudioPlayer alloc] init];
        
    }
    return _audioPlayer;
}
@end
