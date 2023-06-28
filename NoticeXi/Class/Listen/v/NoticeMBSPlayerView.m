//
//  NoticeMBSPlayerView.m
//  NoticeXi
//
//  Created by li lei on 2019/12/31.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeMBSPlayerView.h"

@implementation NoticeMBSPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [NoticeTools getWhiteColor:@"#353A3E" NightColor:@"#222238"];
        
        _minTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24,37/2, GET_STRWIDTH(@"00:00", 12, 12), 12)];
        _minTimeLabel.text = @"0:00";
        _minTimeLabel.font = [UIFont systemFontOfSize:12];
        _minTimeLabel.textColor = [NoticeTools isWhiteTheme] ? [UIColor colorWithHexString:@"#FFFFFF"] : [UIColor colorWithHexString:@"#72727F"];
        _minTimeLabel.alpha = [NoticeTools isWhiteTheme] ? 0.6 : 1;
        [self addSubview:_minTimeLabel];
        
        _maxTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-70-GET_STRWIDTH(@"00:00", 12, 12), 37/2,GET_STRWIDTH(@"00:00", 12, 12), 12)];
        _maxTimeLabel.text = @"0:00";
        _maxTimeLabel.font = [UIFont systemFontOfSize:9];
        _maxTimeLabel.textColor = [NoticeTools isWhiteTheme] ? [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.3] : [[UIColor colorWithHexString:@"#72727F"] colorWithAlphaComponent:0.3];
        _maxTimeLabel.alpha = [NoticeTools isWhiteTheme] ? 0.6 : 1;
        [self addSubview:_maxTimeLabel];
        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_minTimeLabel.frame)+10, _minTimeLabel.frame.origin.y-0.5, DR_SCREEN_WIDTH-70-24-20-_minTimeLabel.frame.size.width*2, 13)];
        _slider.minimumTrackTintColor = GetColorWithName(VMainThumeColor);
        [_slider setThumbImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_trak_sgj":@"Image_trak_sgjy") forState:UIControlStateNormal];
        _slider.alpha = 0.6;
        [_slider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
        
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-70+49/2, 28/2, 21,21)];
        [_playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playCkick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
        
        [self addSubview:_slider];
    }
    return self;
}

- (void)playCkick{
    DRLog([NoticeTools getLocalStrWith:@"recoder.clickpause"]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPlayAndStopButton)]) {
        DRLog(@"点击暂停代理方法");
        [self.delegate clickPlayAndStopButton];
    }
}

//滑动进度条
- (void)handleSlide:(UISlider *)slider{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleWitSlider:)]) {
        [self.delegate handleWitSlider:slider];
    }
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

- (void)setVoiceModel:(NoticeVoiceModel *)model{
    self.slider.value = 0;
    self.slider.maximumValue = model.voice_len.integerValue;
    self.slider.minimumValue = 0;
    self.maxTimeLabel.text = [self getMMSSFromSS:model.voice_len];
    self.minTimeLabel.text = [self getMMSSFromSS:@"0"];
}

- (void)setCurrentTime:(CGFloat)currentTime voiceM:(NoticeVoiceModel *)voiceM{
    if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > voiceM.voice_len.integerValue) {
        currentTime = voiceM.voice_len.integerValue;
    }
    
    if ([[NSString stringWithFormat:@"%.f",voiceM.voice_len.integerValue-currentTime] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%.f",voiceM.voice_len.integerValue-currentTime] isEqualToString:@"-0"] ||  !((voiceM.voice_len.integerValue-currentTime)>0) || [[NSString stringWithFormat:@"%.f",voiceM.voice_len.integerValue-currentTime] isEqualToString:@"-1"] || ([[NSString stringWithFormat:@"%.f",voiceM.voice_len.integerValue-currentTime] isEqualToString:@"0"] && [voiceM.voice_len isEqualToString:@"1"])) {
        self.maxTimeLabel.text = [self getMMSSFromSS:voiceM.voice_len];
        [self.playButton setImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_play_sgj":@"Image_play_sgjy") forState:UIControlStateNormal];
    }
    if (currentTime > voiceM.voice_len.integerValue) {
        self.maxTimeLabel.text = [self getMMSSFromSS:voiceM.voice_len];
        self.minTimeLabel.text = [self getMMSSFromSS:@"0"];
    }else{
        self.maxTimeLabel.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%.f",voiceM.voice_len.integerValue-currentTime]];
        self.minTimeLabel.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%.f",currentTime]];
    }
    
    if ([self.maxTimeLabel.text isEqualToString:@"0:00"]) {
        self.slider.value = voiceM.voice_len.integerValue;
        self.maxTimeLabel.text = [self getMMSSFromSS:voiceM.voice_len];
    }
    if ([self.minTimeLabel.text isEqualToString:[self getMMSSFromSS:voiceM.voice_len]]) {
        self.minTimeLabel.text = @"0:00";
    }
    self.slider.value = currentTime;
}

@end
