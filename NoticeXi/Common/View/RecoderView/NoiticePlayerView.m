//
//  NoiticePlayerView.m
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoiticePlayerView.h"
#import "AppDelegate.h"
@implementation NoiticePlayerView
{
    NSArray *_animatimagesA;
    NSArray *_animatimagesB;
    NSArray *_animatimagesC;
    NSArray *_animatimagesD;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.isPause = YES;
        self.backgroundColor = GetColorWithName(VMainThumeColor);
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.masksToBounds = YES;
        self.isLocal = NO;
        
        self.textL = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.height, 0,frame.size.width-frame.size.height*2,frame.size.height)];
        self.textL.textColor = [NoticeTools getWhiteColor:@"#BCFEFD" NightColor:@"#82B0AF"];
        self.textL.font = TWOTEXTFONTSIZE;
        self.textL.hidden = YES;
        self.textL.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self addSubview:self.textL];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        leftView.backgroundColor = GetColorWithName(VMainThumeColor);
        leftView.layer.cornerRadius = frame.size.height/2;
        leftView.layer.masksToBounds = YES;
        _leftView = leftView;
        [self addSubview:leftView];
        
        _leftLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame)-frame.size.height/2, 0,frame.size.height/2, _leftView.frame.size.height)];
        //_leftLine.backgroundColor = _leftView.backgroundColor;
        [self addSubview:_leftLine];
        
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-frame.size.height, 0, frame.size.height, frame.size.height)];
        _rightView.backgroundColor = GetColorWithName(VMainThumeColor);
        _rightView.layer.cornerRadius = frame.size.height/2;
        _rightView.layer.masksToBounds = YES;
        [self addSubview:_rightView];
        
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(_rightView.frame.origin.x, 0, _leftView.frame.size.width/2, _leftView.frame.size.height)];
       // _rightLine.backgroundColor = GetColorWithName(VMainThumeColor);
        [self addSubview:_rightLine];
        
        self.slieView = [[GGProgressView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        self.slieView.trackTintColor = self.backgroundColor;
        self.slieView.progressTintColor = [UIColor colorWithHexString:@"#0083E0"];
        self.slieView.progressViewStyle=GGProgressViewStyleTrackFillet;
        [self addSubview:self.slieView];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat bugHight = frame.size.height >= 35?28:20;
        self.playButton.frame = CGRectMake(3,(frame.size.height-bugHight)/2, bugHight, bugHight);
        if (frame.size.height == 35) {
            self.playButton.frame = CGRectMake(3,(frame.size.height-bugHight)/2+2, bugHight, bugHight);
        }
        [self.playButton addTarget:self action:@selector(startOrStop) forControlEvents:UIControlEventTouchUpInside];
        [self.playButton setImage:UIImageNamed(@"Image_newplay") forState:UIControlStateNormal];
        [self addSubview:self.playButton];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-frame.size.height/2-GET_STRWIDTH(@"00:1140", 14, 14)+11, (frame.size.height-14)/2, GET_STRWIDTH(@"00:1100", 14, 14), 14)];
        self.timeL.font = XGFourthBoldFontSize;
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.timeL];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startOrStop)];
        [self addGestureRecognizer:tap];
    
    }
    return self;
}

- (void)refreshMoveFrame:(CGFloat)moveX{
    self.reBackFrame = NO;
    self.textL.frame = CGRectMake(self.frame.size.height-moveX, 0,self.contentWidth, self.frame.size.height);
}

- (void)setTimeLen:(NSString *)timeLen{
    if ([timeLen isEqualToString:@"-0"]) {
        timeLen = @"0";
    }
    _timeLen = timeLen;
    
    if (self.isSendBoke) {
        self.timeL.text = [self getMMSSFromSS:timeLen];
    }else{
        self.timeL.text = [NSString stringWithFormat:@"%@s",timeLen];
    }
}


- (void)rePlayAudio{
    [self startOrStop];
}

- (void)startOrStop{
    
    if (self.isThird) {//列表里面的播放的时候单例播放停止
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(startPlay)]) {
            [self.delegate startPlay];
        }
        return;
    }
    
    if (self.noPalyer) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(noPlayerMusic)]) {
            [self.delegate noPlayerMusic];
        }
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (self.tag == appDelegate.currentPlayer.tag) {//往下走，暂停或者播放
        
    }else{//点击的不是当前视图，那么当前视图作为旧视图，重置数据，新视图开始播音
        appDelegate.currentPlayer = nil;
        appDelegate.currentPlayer = self;
        [appDelegate.audioPlayer stopPlaying];
        [appDelegate.currentPlayer.playButton.imageView stopAnimating];
        appDelegate.currentPlayer.timeLen = appDelegate.currentPlayer.timeLen;
        self.isPause = YES;
    }
    
    if (self.rePlay) {
        self.rePlay = NO;
        appDelegate.currentPlayer = nil;
        appDelegate.currentPlayer = self;
        [appDelegate.audioPlayer stopPlaying];
        [appDelegate.currentPlayer.playButton.imageView stopAnimating];
        appDelegate.currentPlayer.timeLen = appDelegate.currentPlayer.timeLen;
        self.isPause = YES;
    }
    
    self.isPause = !self.isPause;
    __weak typeof(self) weakSelf = self;

    if (!self.isPause) {

        [self.playButton setImage:UIImageNamed(self.isSendBoke?@"boke_zantingplay": @"newbtnplay") forState:UIControlStateNormal];
        if (!self.isPlaying) {//判断是否在播放
            [appDelegate.audioPlayer startPlayWithUrl:self.voiceUrl isLocalFile:self.isLocal];
            if (self.delegate && [self.delegate respondsToSelector:@selector(addPlayersNumbers)]) {
                [self.delegate addPlayersNumbers];
            }
            //btn_play  btn_stop
            if (self.isThird) {
                [self.playButton setImage:UIImageNamed(@"btn_stop") forState:UIControlStateNormal];
            }else{
                [self.playButton.imageView startAnimating];
                if (self.delegate && [self.delegate respondsToSelector:@selector(beginP)]) {
                    [self.delegate beginP];
                }
            }
            
        }else{
            
            [appDelegate.audioPlayer pause:NO];
            if (self.isThird) {
                [self.playButton setImage:UIImageNamed(@"btn_stop") forState:UIControlStateNormal];
            }else{
                [self.playButton.imageView startAnimating];
                if (self.delegate && [self.delegate respondsToSelector:@selector(beginP)]) {
                    [self.delegate beginP];
                }
            }
        }
        
        appDelegate.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            weakSelf.isPlaying = YES;
        };
        
        appDelegate.audioPlayer.playComplete = ^{//音频播放完成
            weakSelf.isPause = YES;
            weakSelf.isPlaying = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(endP)]) {
                [self.delegate endP];
            }
            if (weakSelf.isSendBoke) {
                
                weakSelf.timeL.text = [weakSelf getMMSSFromSS:weakSelf.timeLen];
            }else{
                weakSelf.timeL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@s",weakSelf.timeLen] setSize:11 setLengthString:@"s" beginSize:weakSelf.timeLen.length];
            }
            
            weakSelf.slieView.progress = 0;
            [weakSelf.playButton setImage:UIImageNamed(weakSelf.isSendBoke?@"bo_lockplay": @"Image_newplay") forState:UIControlStateNormal];
    
        };
        
        appDelegate.audioPlayer.playingBlock = ^(CGFloat currentTime) {
            NSString *str = [NSString stringWithFormat:@"%@s",[NSString stringWithFormat:@"%.f",weakSelf.timeLen.integerValue-currentTime]];
            if (weakSelf.timeLen.integerValue - currentTime <= 0) {
                str = @"0s";
            }
            
            weakSelf.slieView.progress =  currentTime/weakSelf.timeLen.floatValue;
            if (weakSelf.isSendBoke) {
                
                weakSelf.timeL.text = [weakSelf getMMSSFromSS:[str substringToIndex:str.length-1]];
            }else{
                weakSelf.timeL.attributedText = [DDHAttributedMode setString:str setSize:11 setLengthString:@"s" beginSize:weakSelf.timeLen.length];
            }
        };
        
    }else{
   
        [self.playButton setImage:UIImageNamed(self.isSendBoke?@"bo_lockplay": @"Image_newplay") forState:UIControlStateNormal];
        [appDelegate.audioPlayer pause:self.isPause];
        if (self.isThird) {
            [self.playButton setImage:UIImageNamed(@"btn_play") forState:UIControlStateNormal];
        }else{
            [self.playButton.imageView stopAnimating];
            if (self.delegate && [self.delegate respondsToSelector:@selector(endP)]) {
                [self.delegate endP];
            }
        }
    }
}

- (void)refreWithFrame{
    CGRect  frame = self.frame;
    self.timeL.frame = CGRectMake(frame.size.width-frame.size.height/2-GET_STRWIDTH(@"00:110", 14, 14)+11-3, (frame.size.height-14)/2, GET_STRWIDTH(@"00:101", 14, 14), 14);
    self.slieView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.rightView.frame = CGRectMake(self.frame.size.width-self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
    _rightLine.frame = CGRectMake(_rightView.frame.origin.x, 0, _leftView.frame.size.width/2, _leftView.frame.size.height);
    
    if(!_noNeedLizi){
        self.colorBallLayer.hidden = NO;
    }
    
}

- (void)setNoNeedLizi:(BOOL)noNeedLizi{
    _noNeedLizi = noNeedLizi;
    [_colorBallLayer removeFromSuperlayer];
}

- (CAEmitterLayer *)colorBallLayer{
    if (!_colorBallLayer) {
        //    1.设置 CAEmitterLayer
        CAEmitterLayer *colorBallLayer = [CAEmitterLayer layer];

        [self.layer addSublayer:colorBallLayer];

        _colorBallLayer = colorBallLayer;
        colorBallLayer.renderMode = kCAEmitterLayerAdditive;
        //    发射源的尺寸大小
        colorBallLayer.emitterSize = self.frame.size;
        //    发射源的形状
        colorBallLayer.emitterShape = kCAEmitterLayerLine;
        //    发射模式
        colorBallLayer.emitterMode = kCAEmitterLayerLine;
        //    粒子发射形状的中心点
        colorBallLayer.emitterPosition = CGPointMake(self.layer.bounds.size.width/2, self.layer.bounds.size.height);
        //    2.配置 CAEmitterCell
        CAEmitterCell *colorBallCell = [CAEmitterCell emitterCell];
        //    粒子名称
        colorBallCell.name = @"colorBallCell";
        //    粒子产生率, 默认为 0
        colorBallCell.birthRate = 30.f;
        //    粒子生命周期
        colorBallCell.lifetime = 10.f;
        //    粒子速度, 默认为 0
        colorBallCell.velocity = 5.f;
        //    粒子速度平均量
        colorBallCell.velocityRange = 100.f;
        //    x,y,z 方向上的加速度分量, 三者默认为 0
        colorBallCell.zAcceleration = 15.f;
//        colorBallCell.yAcceleration = 10.0f;
        //    指定纬度, 纬度角代表在 x-z轴平面坐标系中与 x 轴之间的夹角默认为 0
        colorBallCell.emissionLongitude = M_PI;
//        //    发射角度范围,默认为 0, 以锥形分布开的发射角, 角度为弧度制.粒子均匀分布在这个锥形范围内;
        colorBallCell.emissionRange = M_PI_2;// 围绕 x 轴向左90 度
        //    缩放比例, 默认 1
        colorBallCell.scale = 0.05;
        //    缩放比例范围, 默认是 0
        colorBallCell.scaleRange = 0.05;
        //    在生命周期内的缩放速度, 默认是 0
        colorBallCell.scaleSpeed = 0.02;
        //    粒子的内容, 为 CGImageRef 的对象
        colorBallCell.contents = (id)[[UIImage imageNamed:@"Image_white"] CGImage];
        
        colorBallCell.spin = 1.0;
        colorBallCell.spinRange = 2.0;
        
        //    颜色
//        colorBallCell.color = [[UIColor colorWithRed:255/255 green:255/255 blue:70/255 alpha:0.2] CGColor];

        //    添加
        colorBallLayer.emitterCells = @[colorBallCell];
    }
    return _colorBallLayer;
}


- (void)handleSlide:(UISlider *)slider{
    
}

- (void)setIsSelf:(BOOL)isSelf{
    _isSelf = isSelf;
    CGRect  frame = self.frame;
    _leftLine.hidden = YES;
    _leftView.hidden = YES;
    _rightLine.hidden = YES;
    _rightView.hidden = YES;
    self.textL.hidden = YES;
    if (isSelf) {
        self.slieView.progressTintColor = [UIColor colorWithHexString:@"#0083E0"];
        self.playButton.frame = CGRectMake(frame.size.width-frame.size.height/4-(frame.size.height-20)/2-10, (frame.size.height-20)/2, 20, 20);
        self.timeL.frame = CGRectMake(frame.size.height/2-11, (frame.size.height-14)/2, GET_STRWIDTH(@"00:110", 14, 14), 14);
        self.timeL.textAlignment = NSTextAlignmentLeft;
        self.slieView.trackTintColor = [UIColor colorWithHexString:@"#0099E6"];
    }else{
        self.playButton.frame = CGRectMake(frame.size.height/4, (frame.size.height-20)/2, 20, 20);
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.frame = CGRectMake(frame.size.width-frame.size.height/2-GET_STRWIDTH(@"00:110", 14, 14)+11, (frame.size.height-14)/2, GET_STRWIDTH(@"00:101", 14, 14), 14);
        self.slieView.progressTintColor = [UIColor colorWithHexString:@"#383A42"];
        self.slieView.trackTintColor = [UIColor colorWithHexString:@"#25262E"];
    }
}

- (void)setIsGroupChatSelf:(BOOL)isGroupChatSelf{
    _isGroupChatSelf = isGroupChatSelf;
    CGRect  frame = self.frame;
    _leftLine.hidden = YES;
    _leftView.hidden = YES;
    _rightLine.hidden = YES;
    _rightView.hidden = YES;
    self.textL.hidden = YES;
    if (isGroupChatSelf) {
        self.timeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.slieView.progressTintColor = [UIColor colorWithHexString:@"#0083E0"];
        self.playButton.frame = CGRectMake(frame.size.width-frame.size.height/4-(frame.size.height-20)/2-10, (frame.size.height-20)/2, 20, 20);
        self.timeL.frame = CGRectMake(frame.size.height/2-11, (frame.size.height-14)/2, GET_STRWIDTH(@"00:110", 14, 14), 14);
        self.timeL.textAlignment = NSTextAlignmentLeft;
        self.slieView.trackTintColor = [UIColor colorWithHexString:@"#0099E6"];
        self.slieView.layer.borderWidth = 0;
    }else{
        self.playButton.frame = CGRectMake(frame.size.height/4, (frame.size.height-20)/2, 20, 20);
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.frame = CGRectMake(frame.size.width-frame.size.height/2-GET_STRWIDTH(@"00:110", 14, 14)+11, (frame.size.height-14)/2, GET_STRWIDTH(@"00:101", 14, 14), 14);
        self.slieView.progressTintColor = [UIColor colorWithHexString:@"#E1E4F0"];
        self.slieView.layer.borderWidth = 1;
        self.slieView.layer.borderColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.3].CGColor;
        self.slieView.trackTintColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
    }
}

- (void)setIsSendBoke:(BOOL)isSendBoke{
    _isSendBoke = isSendBoke;
    CGRect  frame = self.frame;
    _leftLine.hidden = YES;
    _leftView.hidden = YES;
    _rightLine.hidden = YES;
    _rightView.hidden = YES;
    self.textL.hidden = YES;
    if (_isSendBoke) {
        self.playButton.frame = CGRectMake(frame.size.height/4, (frame.size.height-20)/2, 20, 20);
        [self.playButton setImage:UIImageNamed(@"bo_lockplay") forState:UIControlStateNormal];//
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.frame = CGRectMake(frame.size.width-frame.size.height/2-GET_STRWIDTH(@"00:11", 14, 14), (frame.size.height-14)/2, GET_STRWIDTH(@"00:101", 14, 14), 14);
        self.slieView.progressTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.slieView.layer.borderWidth = 1;
        self.backgroundColor = [[UIColor colorWithHexString:@"#0099E6"] colorWithAlphaComponent:0.1];
        self.slieView.layer.borderColor = [[UIColor colorWithHexString:@"#0099E6"] colorWithAlphaComponent:1].CGColor;
        self.slieView.layer.cornerRadius = 4;
        self.slieView.trackTintColor = [[UIColor colorWithHexString:@"#0099E6"] colorWithAlphaComponent:0.1];
        self.timeL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        self.layer.cornerRadius = 4;
    }
}

- (void)setIsShare:(BOOL)isShare{
    if (isShare) {
        CGRect  frame = self.frame;
        _leftLine.hidden = YES;
        _leftView.hidden = YES;
        _rightLine.hidden = YES;
        _rightView.hidden = YES;
        self.textL.hidden = YES;
        self.backgroundColor = GetColorWithName(VMainThumeColor);
        [self.playButton setImage:_animatimagesC[2] forState:UIControlStateNormal];
        self.playButton.imageView.animationImages = _animatimagesC;
        self.playButton.imageView.animationDuration = _animatimagesC.count*0.5;
        self.playButton.frame = CGRectMake(frame.size.height/4, (frame.size.height-20)/2, 20, 20);
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.frame = CGRectMake(frame.size.width-frame.size.height/2-GET_STRWIDTH(@"00:110", 14, 14)+11, (frame.size.height-14)/2, GET_STRWIDTH(@"00:101", 14, 14), 14);
    }
}

//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = totalTime.integerValue;
    
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


@end
