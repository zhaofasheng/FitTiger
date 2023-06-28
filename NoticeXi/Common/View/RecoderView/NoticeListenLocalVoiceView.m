//
//  NoticeListenLocalVoiceView.m
//  NoticeXi
//
//  Created by li lei on 2021/7/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeListenLocalVoiceView.h"

@implementation NoticeListenLocalVoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
        
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 330)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#A6B9CC"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 10;
        self.keyView.layer.masksToBounds = YES;
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,40, DR_SCREEN_WIDTH-40, 165)];
        backImageView.image = UIImageNamed(@"Image_localplayBack");
        [self.keyView addSubview:backImageView];
        backImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
        [backImageView addGestureRecognizer:playTap];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, DR_SCREEN_WIDTH-40, 32)];
        titleL.font = XGTwentyEigthBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        titleL.text = @"0s";
        titleL.textAlignment = NSTextAlignmentCenter;
        self.timeL = titleL;
        [backImageView addSubview:titleL];
        
        self.svagPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(40,(backImageView.frame.size.height-40)/2-20,backImageView.frame.size.width-80, 40)];
        self.parser = [[SVGAParser alloc] init];
        
        [self.parser parseWithNamed:@"huitont3" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            self.svagPlayer.videoItem = videoItem;
        } failureBlock:nil];

        [backImageView addSubview:self.svagPlayer];
        
        self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake((backImageView.frame.size.width-120)/2, backImageView.frame.size.height-40-5, 120, 40)];
        [self.playBtn setImage:UIImageNamed(@"Image_yuplayBtn") forState:UIControlStateNormal];
        self.playBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [self.playBtn setTitle:[NoticeTools getLocalStrWith:@"recoder.clickplay"] forState:UIControlStateNormal];
        [self.playBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        [backImageView addSubview:self.playBtn];
        [self.playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.keyView.frame.size.height-50-35, (DR_SCREEN_WIDTH-60)/2, 35)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"em.rerecoder"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        cancelBtn.layer.cornerRadius = 8;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
        cancelBtn.layer.borderWidth = 1;
        [self.keyView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame)+20, self.keyView.frame.size.height-50-35, (DR_SCREEN_WIDTH-60)/2, 35)];
        [sureBtn setTitle:[NoticeTools getLocalStrWith:@"read.send"] forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        sureBtn.layer.cornerRadius = 8;
        sureBtn.layer.masksToBounds = YES;
        [self.keyView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-30, 5, 30, 30)];
        [closeBtn setImage:UIImageNamed(@"Image_whiteclose") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(justCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.keyView addSubview:closeBtn];
        
    }
    return self;
}

- (UIButton *)recoBtn{
    if (!_recoBtn) {
        _recoBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-196, self.keyView.frame.size.height-50-35-119, 196, 119)];
        [_recoBtn setBackgroundImage:UIImageNamed(@"Image_hszhiyin4") forState:UIControlStateNormal];
        [self.keyView addSubview:_recoBtn];
    
    }
    return _recoBtn;
}


- (void)setTimeLength:(NSUInteger)timeLength{
    _timeLength = timeLength;
    self.rePlay = YES;
    self.timeL.text = [NSString stringWithFormat:@"%lds",timeLength];
}

- (void)playClick{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (self.rePlay) {
        self.rePlay = NO;
        [appDelegate.audioPlayer stopPlaying];
        self.isPause = YES;
    }
    
    self.isPause = !self.isPause;
    __weak typeof(self) weakSelf = self;

    if (!self.isPause) {
        [self.svagPlayer startAnimation];
        [self.playBtn setImage:UIImageNamed(@"Image_yupauseBtn") forState:UIControlStateNormal];
        [self.playBtn setTitle:[NoticeTools getLocalStrWith:@"recoder.clickpause"] forState:UIControlStateNormal];
        if (!self.isPlaying) {//判断是否在播放
            [appDelegate.audioPlayer startPlayWithUrl:self.localPath isLocalFile:YES];
        }else{
            [appDelegate.audioPlayer pause:NO];
        }
        
        appDelegate.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            weakSelf.isPlaying = YES;
        };
        
        appDelegate.audioPlayer.playComplete = ^{//音频播放完成
            weakSelf.isPause = YES;
            weakSelf.isPlaying = NO;
            weakSelf.timeL.text = [NSString stringWithFormat:@"%lds",weakSelf.timeLength];
            [weakSelf.playBtn setTitle:[NoticeTools getLocalStrWith:@"recoder.clickplay"] forState:UIControlStateNormal];
            [weakSelf.playBtn setImage:UIImageNamed(@"Image_yuplayBtn") forState:UIControlStateNormal];
            [weakSelf.svagPlayer pauseAnimation];
        };
        
        appDelegate.audioPlayer.playingBlock = ^(CGFloat currentTime) {
            NSString *str = [NSString stringWithFormat:@"%@s",[NSString stringWithFormat:@"%.f",weakSelf.timeLength-currentTime]];
            if (weakSelf.timeLength - currentTime <= 0) {
                str = @"0s";
            }
            weakSelf.timeL.text= str;
        };
        
    }else{
        [self.svagPlayer pauseAnimation];
        [self.playBtn setTitle:[NoticeTools getLocalStrWith:@"recoder.clickplay"] forState:UIControlStateNormal];
        [appDelegate.audioPlayer pause:self.isPause];
    }
}

- (LGAudioPlayer *)voicePlayer
{
    if (!_voicePlayer) {
        _voicePlayer = [[LGAudioPlayer alloc] init];
   
    }
    return _voicePlayer;
}

- (void)showShareView{
    if (self.isLead) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"27" ofType:@"m4a"];
        [self.voicePlayer startPlayWithUrl:path isLocalFile:YES];
        self.recoBtn.frame = CGRectMake(DR_SCREEN_WIDTH-196, self.keyView.frame.size.height-50-35-119-50, 196, 119);
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.recoBtn.frame = CGRectMake(DR_SCREEN_WIDTH-196, self.keyView.frame.size.height-50-35-119, 196, 119);
        } completion:nil];
    }
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+10, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];
}

- (void)cancelClick{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.audioPlayer stopPlaying];
    if (self.sendBlock) {
        self.sendBlock(NO);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)justCancel{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.showt"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.audioPlayer stopPlaying];
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
            }];
        }
    };
    [alerView showXLAlertView];
 
}

- (void)sureClick{
    if (self.sendBlock) {
        self.sendBlock(YES);
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
@end
