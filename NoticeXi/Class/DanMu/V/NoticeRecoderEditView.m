//
//  NoticeRecoderEditView.m
//  NoticeXi
//
//  Created by li lei on 2022/11/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeRecoderEditView.h"
@implementation NoticeRecoderEditView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.userInteractionEnabled = YES;

        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        //滑块
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
        UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
        UIImage *leftSliderImg = [UIImage imageNamed:@"resume_btn_control_l"];
        UIImage *rightSliderImg = [UIImage imageNamed:@"resume_btn_control_l"];
                
        self.leftSliderImgView = [[UIImageView alloc] initWithImage:leftSliderImg];
        self.leftSliderImgView.userInteractionEnabled = YES;
        self.leftSliderImgView.frame = CGRectMake(10,NAVIGATION_BAR_HEIGHT+138, 20,240);
        [self.leftSliderImgView addGestureRecognizer:leftPan];
        
        
        self.rightSliderImgView = [[UIImageView alloc] initWithImage:rightSliderImg];
        self.rightSliderImgView.userInteractionEnabled = YES;
        //最大的长度裁剪
        self.rightSliderImgView.frame = CGRectMake(DR_SCREEN_WIDTH-10-20,NAVIGATION_BAR_HEIGHT+138,20,240);
        
        [self.rightSliderImgView addGestureRecognizer:rightPan];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, self.leftSliderImgView.frame.origin.y,DR_SCREEN_WIDTH-40, self.leftSliderImgView.frame.size.height)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backV.userInteractionEnabled = YES;
        [self addSubview:backV];
        
        //指示器范围
        self.rangeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,backV.frame.size.width, self.leftSliderImgView.frame.size.height)];
        [self.rangeView.layer setBorderColor:[UIColor colorWithHexString:@"#FF68A3"].CGColor];
        [self.rangeView.layer setBorderWidth:2.0f];
        self.rangeView.backgroundColor = [[UIColor colorWithHexString:@"#FF68A3"] colorWithAlphaComponent:0.3];
        [backV addSubview:self.rangeView];
        [self.rangeView setHidden:YES];
        
        
        self.slieView = [[GGProgressView alloc] initWithFrame:CGRectMake(0,0,self.rangeView.frame.size.width, self.rangeView.frame.size.height)];
        self.slieView.trackTintColor = [self.backgroundColor colorWithAlphaComponent:0];
        self.slieView.progressTintColor = [[UIColor colorWithHexString:@"#59A1FF"] colorWithAlphaComponent:0.2];
        self.slieView.progressViewStyle = GGProgressViewStyleDefault;
        [self.rangeView addSubview:self.slieView];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, backV.frame.size.width, backV.frame.size.height)];
        self.scrollView.bounces = NO;
        self.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [backV addSubview:self.scrollView];
        self.scrollView.delegate = self;
        
        _starL = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-96*2-20)/2,NAVIGATION_BAR_HEIGHT+42,96, 52)];
        _starL.text = @"00:00";
        _starL.font = THIRTTYBoldFontSize;
        _starL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:_starL];
        _starL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _starL.layer.cornerRadius = 2;
        _starL.layer.masksToBounds = YES;
        _starL.textAlignment = NSTextAlignmentCenter;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_starL.frame)+3,_starL.frame.origin.y+48/2, 14, 4)];
        line.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:line];
        
        _endL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+3,_starL.frame.origin.y, 96,52)];
        _endL.text = @"00:00";
        _endL.font = THIRTTYBoldFontSize;
        _endL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:_endL];
        _endL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _endL.layer.cornerRadius = 2;
        _endL.layer.masksToBounds = YES;
        _endL.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.leftSliderImgView];
        [self addSubview:self.rightSliderImgView];
         
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-60)/2, CGRectGetMaxY(backV.frame)+20, 60, 36)];
        [self.playButton setImage:UIImageNamed(@"playbokeimg") forState:UIControlStateNormal];
        [self addSubview:self.playButton];
        [self.playButton addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(40,CGRectGetMaxY(backV.frame)+146,120,64)];
        sendBtn.layer.cornerRadius = 32;
        sendBtn.layer.masksToBounds = YES;
        sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#FF68A3"] colorWithAlphaComponent:0.5];
        [sendBtn setTitle:[NoticeTools chinese:@"保留" english:@"Preserve" japan:@"保存"] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = NINETEENTEXTFONTSIZE;
        [sendBtn addTarget:self action:@selector(jqClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        self.editButton = sendBtn;
        
        UIButton *sendBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-120,CGRectGetMaxY(backV.frame)+146,120,64)];
        sendBtn1.layer.cornerRadius = 32;
        sendBtn1.layer.masksToBounds = YES;
        sendBtn1.backgroundColor = [[UIColor colorWithHexString:@"#FF68A3"] colorWithAlphaComponent:0.5];
        [sendBtn1 setTitle:[NoticeTools getLocalStrWith:@"py.dele"] forState:UIControlStateNormal];
        [sendBtn1 setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        sendBtn1.titleLabel.font = NINETEENTEXTFONTSIZE;
        [sendBtn1 addTarget:self action:@selector(scClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn1];
        self.deleButton = sendBtn1;
        self.canEdit = NO;
        self.rePlay = YES;
        
        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-66-20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 66, 28)];
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextButton.layer.cornerRadius = 14;
        self.nextButton.layer.masksToBounds = YES;
        self.nextButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.nextButton setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
    }
    return self;
}

- (NoticePointView *)drawView{//上边波纹
    if (!_drawView) {
        NoticePointView *view = [[NoticePointView alloc] initWithFrame:CGRectMake(0,20,DR_SCREEN_WIDTH-40, 100)];
        view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
        [self.scrollView addSubview:view];
        view.colorStr = @"#FF68A3";
        _drawView = view;
    }
    return _drawView;
}

- (NoticePointView *)drawView1{//下方波纹
    if (!_drawView1) {
        NoticePointView *view1 = [[NoticePointView alloc] initWithFrame:CGRectMake(0,120,DR_SCREEN_WIDTH-40, 100)];
        view1.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
        [self.scrollView addSubview:view1];
        view1.colorStr = @"#FF68A3";
        _drawView1 = view1;
        _drawView1.transform = CGAffineTransformMakeScale(1.0,-1.0);//下方播放沿x轴翻转180度
    }
    return _drawView1;
}

- (void)nextClick{
    if (self.noNext) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"保存后，无法再次剪辑噢～" english:@"No more editting after saving:" japan:@"保存後は編集できません: "] message:nil sureBtn:[NoticeTools chinese:@"保存" english:@"Save" japan:@"セーブ"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            if (weakSelf.sureFinishBlock) {
                weakSelf.sureFinishBlock(weakSelf.currentPath?weakSelf.currentPath: weakSelf.locaPath, weakSelf.timeLen, weakSelf.currentPath?YES:NO);
            }
            [weakSelf.voicePlayer stopPlaying];
            [weakSelf removeFromSuperview];
        }
    };
    [alerView showXLAlertView];
    
  
}

- (void)scClick{
    if (!self.canEdit) {
        return;
    }

    [_voicePlayer stopPlaying];
    
    if (self.startTime < 1) {//删除的起点为零，则直接截取后半段
        [[NoticeTools getTopViewController] showHUD];
        [self.audioToAudio cutAudio:self.currentPath?self.currentPath: self.locaPath fromTime:(NSInteger)self.endTime toTime:(NSInteger)self.timeLen.integerValue];
        return;
    }
    
    if ((self.endTime >= self.timeLen.intValue || self.endTime == 0) && self.startTime >=1) {//如果删除的终点为音频总时长，则截取前半段音频
        [[NoticeTools getTopViewController] showHUD];
        [self.audioToAudio cutAudio:self.currentPath?self.currentPath: self.locaPath fromTime:0 toTime:(NSInteger)self.startTime];
        return;
    }
    
    [[NoticeTools getTopViewController] showHUD];
    [self.audioToAudio getFirstAndLastAudio:self.currentPath?self.currentPath: self.locaPath fromTime:(NSInteger)self.startTime toTime:(NSInteger)self.endTime];
}

- (void)jqClick{

    if (!self.canEdit) {
        return;
    }
    [_voicePlayer stopPlaying];
    [[NoticeTools getTopViewController] showHUD];
    [self.audioToAudio cutAudio:self.currentPath?self.currentPath: self.locaPath fromTime:(NSInteger)self.startTime toTime:(NSInteger)self.endTime];
}

- (NoticeAudioJoinToAudioModel *)audioToAudio{
    if (!_audioToAudio) {
        _audioToAudio = [[NoticeAudioJoinToAudioModel alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioToAudio.editAudioBlock = ^(NSString * _Nonnull currentAudioPath, NSString * _Nonnull audioTimeL, NSInteger reuslt) {
            weakSelf.timeLen = audioTimeL;
            weakSelf.currentPath = currentAudioPath;
            [[NoticeTools getTopViewController] hideHUD];
            weakSelf.noNext = NO;
            weakSelf.hasEditEd = YES;
            weakSelf.nextButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
            [weakSelf.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        };
    }
    return _audioToAudio;
}

-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    if (seconds <0) {
        return format_time = @"00:00";
    }
    return format_time;
}

- (void)setTimeLen:(NSString *)timeLen{
    _timeLen = timeLen;
    if (self.timeLen.floatValue <= 0) {
        return;
    }
    
    self.startTime = 0;
    self.endTime = 0;
    
    if ((_timeLen.integerValue / (DR_SCREEN_WIDTH-40)) > 0.1) {//如果每个像素时长大于0.1秒，则固定描述，拉长scrollview滑动距离
        self.timeScale = 0.1;//每个像素0.1秒钟
        self.minWidth = 10;//最短10个像素，加上滑块距离，就是最短三十个像素
    }else{//如果每个像素时长小于0.1秒钟，则按照实际每个像素等于多少秒计算
        self.timeScale = _timeLen.integerValue/self.scrollView.frame.size.width;
        self.minWidth = 2/self.timeScale;
    }

    self.scrollView.contentSize = CGSizeMake(_timeLen.integerValue/self.timeScale, 0);
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:NO];
    self.contentX = 0;
    self.rangeView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-40, self.scrollView.frame.size.height);
    self.slieView.frame = self.rangeView.bounds;
    _starL.text = @"00:00";
    _endL.text = [self getMMSSFromSS:_timeLen.integerValue];
    self.leftSliderImgView.frame = CGRectMake(10,NAVIGATION_BAR_HEIGHT+138, 20,240);
    self.rightSliderImgView.frame = CGRectMake(DR_SCREEN_WIDTH-10-20,NAVIGATION_BAR_HEIGHT+138,20,240);
    self.rangeView.hidden = YES;
    self.canEdit = NO;
    [self refreshEditButton];
    
    self.drawView.frame = CGRectMake(0, 20, _timeLen.integerValue/self.timeScale, 100);
    self.drawView1.frame = CGRectMake(0, 120, _timeLen.integerValue/self.timeScale, 100);
    if (!self.drawView.pointArray.count) {
        self.drawView.pointArray = self.pointArray;
        self.drawView1.pointArray = self.pointArray;
    }
}

- (void)playClick{
    if (self.rePlay) {
        self.rePlay = NO;
        [self.voicePlayer stopPlaying];
        self.isPause = YES;
    }
    
    self.isPause = !self.isPause;
    __weak typeof(self) weakSelf = self;

    if (!self.isPause) {
        [self.playButton setImage:UIImageNamed(@"stopbokeimg") forState:UIControlStateNormal];
        if (!self.isPlaying) {//判断是否在播放
            [self.voicePlayer startPlayWithUrl:self.currentPath?self.currentPath:self.locaPath isLocalFile:YES];

        }else{
            [self.voicePlayer pause:NO];
        }
        
        self.voicePlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            weakSelf.isPlaying = YES;
            if (!weakSelf.rangeView.hidden) {//如果有滑动截取则定位到滑动的地方进行开始播放
                
                [weakSelf.voicePlayer.player seekToTime:CMTimeMake(weakSelf.startTime, 1) completionHandler:^(BOOL finished) {
                    if (finished) {
                    }
                }];
            }
        };
        
        self.voicePlayer.playComplete = ^{//音频播放完成
            weakSelf.isPause = YES;
            weakSelf.isPlaying = NO;
            weakSelf.starL.text = [weakSelf getMMSSFromSS:(NSInteger)weakSelf.startTime];
            [weakSelf.playButton setImage:UIImageNamed(@"playbokeimg") forState:UIControlStateNormal];
            weakSelf.slieView.progress = 0;
        };
                      
        self.voicePlayer.playingBlock = ^(CGFloat currentTime) {
            if (!weakSelf.rangeView.hidden) {//如果有滑动截取则定位到滑动的终点位置结束播放
                if (currentTime >= weakSelf.endTime) {
                    [weakSelf.voicePlayer stopPlaying];
                    weakSelf.slieView.progress = 0;
                    weakSelf.starL.text = [weakSelf getMMSSFromSS:(NSInteger)weakSelf.startTime];
                }else{
                    if (currentTime < weakSelf.startTime) {
                        currentTime = weakSelf.startTime;
                    }
                    weakSelf.starL.text = [weakSelf getMMSSFromSS:(NSInteger)currentTime];
                    weakSelf.slieView.progress = (currentTime-weakSelf.startTime)/(weakSelf.endTime-weakSelf.startTime);
                    if (weakSelf.slieView.progress < 0) {
                        weakSelf.slieView.progress = 0;
                        
                    }
                }
           
            }else{
                weakSelf.starL.text = [weakSelf getMMSSFromSS:(NSInteger)currentTime];
            }
        };
    }else{
        [weakSelf.playButton setImage:UIImageNamed(@"playbokeimg") forState:UIControlStateNormal];
        [self.voicePlayer pause:self.isPause];
    }
}

- (LGAudioPlayer *)voicePlayer
{
    if (!_voicePlayer) {
        _voicePlayer = [[LGAudioPlayer alloc] init];
    }
    return _voicePlayer;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_voicePlayer stopPlaying];
    self.contentX = scrollView.contentOffset.x;
    [self.rangeView setHidden:NO];
    self.startTime = (self.rangeView.frame.origin.x+self.contentX)*self.timeScale;
    self.starL.text = [self getMMSSFromSS:(NSInteger)self.startTime];
    self.endTime = (CGRectGetMaxX(self.rangeView.frame)+self.contentX)*self.timeScale;
    self.endL.text = [self getMMSSFromSS:(NSInteger)self.endTime];
    [self refreshEditButton];
}

#pragma mark - Handele Gesture
- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture {
    [_voicePlayer stopPlaying];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.rangeView setHidden:NO];
    }
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        
        CGFloat sliderW = self.leftSliderImgView.frame.size.width;
        CGFloat sliderH = self.leftSliderImgView.frame.size.height;
        CGFloat sliderY = self.leftSliderImgView.frame.origin.y;
        
        CGFloat rightX = self.rightSliderImgView.frame.origin.x;
        CGFloat leftX = self.leftSliderImgView.frame.origin.x + touchPoint.x;
        
        if (leftX <= 10) {
            leftX = 10;
        }
        if (leftX + sliderW >= rightX - self.minWidth) {
            leftX = rightX - self.minWidth-sliderW;
        }

        self.leftSliderImgView.frame = CGRectMake(leftX, sliderY, sliderW, sliderH);
        self.rangeView.frame = CGRectMake(self.leftSliderImgView.frame.origin.x-10,0,self.rightSliderImgView.frame.origin.x-CGRectGetMaxX(self.leftSliderImgView.frame)+20, self.leftSliderImgView.frame.size.height);
        self.slieView.frame = self.rangeView.bounds;
        self.startTime = (self.rangeView.frame.origin.x+self.contentX)*self.timeScale;
        self.starL.text = [self getMMSSFromSS:(NSInteger)self.startTime];
        self.endTime = (CGRectGetMaxX(self.rangeView.frame)+self.contentX)*self.timeScale;
        self.endL.text = [self getMMSSFromSS:(NSInteger)self.endTime];
   
        [gesture setTranslation:CGPointZero inView:gesture.view];
        [self refreshEditButton];
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.leftSliderImgView.frame.origin.x < 10) {
            self.leftSliderImgView.frame = CGRectMake(10,NAVIGATION_BAR_HEIGHT+138, 20,240);
            self.rangeView.frame = CGRectMake(self.leftSliderImgView.frame.origin.x-10, 0,self.rightSliderImgView.frame.origin.x-CGRectGetMaxX(self.leftSliderImgView.frame)+20, self.leftSliderImgView.frame.size.height);
            self.slieView.frame = self.rangeView.bounds;
            self.startTime = (self.rangeView.frame.origin.x+self.contentX)*self.timeScale;
            self.starL.text = [self getMMSSFromSS:(NSInteger)self.startTime];
            self.endTime = (CGRectGetMaxX(self.rangeView.frame)+self.contentX)*self.timeScale;
            self.endL.text = [self getMMSSFromSS:(NSInteger)self.endTime];
        }
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture {
    [_voicePlayer stopPlaying];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.rangeView setHidden:NO];
    }
    
    CGPoint translation = [gesture locationInView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat sliderY = self.rightSliderImgView.frame.origin.y;
        CGFloat sliderW = self.rightSliderImgView.frame.size.width;
        CGFloat sliderH = self.rightSliderImgView.frame.size.height;
        CGFloat leftX = self.leftSliderImgView.frame.origin.x;
        CGFloat rightX = self.rightSliderImgView.frame.origin.x + translation.x;
        
        if (rightX >= (DR_SCREEN_WIDTH-10-sliderW)) {
            rightX = DR_SCREEN_WIDTH-10-sliderW;
        }
        
        if (rightX <= leftX + _minWidth + sliderW) {
            rightX = leftX + _minWidth + sliderW;
        }
        
        self.rightSliderImgView.frame = CGRectMake(rightX, sliderY, sliderW, sliderH);
        self.rangeView.frame = CGRectMake(self.leftSliderImgView.frame.origin.x-10,0,self.rightSliderImgView.frame.origin.x-CGRectGetMaxX(self.leftSliderImgView.frame)+20, self.leftSliderImgView.frame.size.height);
        self.slieView.frame = self.rangeView.bounds;
        self.startTime = (self.rangeView.frame.origin.x+self.contentX)*self.timeScale;
        self.starL.text = [self getMMSSFromSS:(NSInteger)self.startTime];
        self.endTime = (CGRectGetMaxX(self.rangeView.frame)+self.contentX)*self.timeScale;
        self.endL.text = [self getMMSSFromSS:(NSInteger)self.endTime];
        
        [gesture setTranslation:CGPointZero inView:gesture.view];
        [self refreshEditButton];
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.rightSliderImgView.frame.origin.x > (DR_SCREEN_WIDTH-10-20)) {
            self.rightSliderImgView.frame = CGRectMake(DR_SCREEN_WIDTH-10-20,NAVIGATION_BAR_HEIGHT+138,20,240);
            self.rangeView.frame = CGRectMake(self.leftSliderImgView.frame.origin.x-10,0,self.rightSliderImgView.frame.origin.x-CGRectGetMaxX(self.leftSliderImgView.frame)+20, self.leftSliderImgView.frame.size.height);
            self.slieView.frame = self.rangeView.bounds;
            self.startTime = (self.rangeView.frame.origin.x+self.contentX)*self.timeScale;
            self.starL.text = [self getMMSSFromSS:(NSInteger)self.startTime];
            self.endTime = (CGRectGetMaxX(self.rangeView.frame)+self.contentX)*self.timeScale;
            self.endL.text = [self getMMSSFromSS:(NSInteger)self.endTime];
        }
    }
}

- (void)refreshEditButton{
    if (self.startTime >= 1 || (self.endTime <= self.timeLen.integerValue-1 && self.endTime  > 1)) {
        self.canEdit = YES;
        self.editButton.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        [self.editButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
        self.deleButton.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        [self.deleButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
        self.noNext = YES;
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.nextButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }else{
        self.canEdit = NO;
        self.editButton.backgroundColor = [[UIColor colorWithHexString:@"#FF68A3"] colorWithAlphaComponent:0.5];
        [self.editButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        self.deleButton.backgroundColor = [[UIColor colorWithHexString:@"#FF68A3"] colorWithAlphaComponent:0.5];
        [self.deleButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    }
}

- (void)backClick{
    if (!self.hasEditEd) {
        [_voicePlayer stopPlaying];
        [self removeFromSuperview];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"返回后不会保存当前的效果噢~" english:@"Changes won't be saved:" japan:@"変更は保存されません:"] message:nil sureBtn:[NoticeTools chinese:@"返回" english:@"Go Anyway" japan:@"とにかく行く"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf.voicePlayer stopPlaying];
            [weakSelf removeFromSuperview];
        }
    };
    [alerView showXLAlertView];

}

@end
