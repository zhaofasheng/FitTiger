//
//  NoticeFloatView.m
//  NoticeXi
//
//  Created by li lei on 2020/3/2.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeFloatView.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeVoiceDetailController.h"
#import "NoticeMBSDetailVoiceController.h"
#import "NoticeMbsDetailTextController.h"
#import "NoticePyComController.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation NoticeFloatView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.layer.cornerRadius = 56/2;
        self.layer.masksToBounds = YES;
        
        self.rateButton = [[UIButton alloc] initWithFrame:CGRectMake(60+8+36, 10, 36, 36)];
        [self.rateButton addTarget:self action:@selector(rateClick) forControlEvents:UIControlEventTouchUpInside];
        self.rateButton.layer.masksToBounds = YES;
        [self.rateButton setTitleColor:[UIColor colorWithHexString:@"#65AFE6"] forState:UIControlStateNormal];
        self.rateButton.titleLabel.font = [UIFont systemFontOfSize:12];
        if ([NoticeTools voicePlayRate] == 1) {
            [self.rateButton setTitle:@"倍速" forState:UIControlStateNormal];
        }else if ([NoticeTools voicePlayRate] == 2){
            [self.rateButton setTitle:@"1.25x" forState:UIControlStateNormal];
        }else if ([NoticeTools voicePlayRate] == 3){
            [self.rateButton setTitle:@"1.5x" forState:UIControlStateNormal];
        }else if ([NoticeTools voicePlayRate] == 4){
            [self.rateButton setTitle:@"2.0x" forState:UIControlStateNormal];
        }
        else{
            [self.rateButton setTitle:@"倍速" forState:UIControlStateNormal];
        }
        self.rateButton.hidden = YES;
        [self addSubview:self.rateButton];
   
        self.changeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-3-36, 10, 36, 36)];
        [self.changeButton setImage:UIImageNamed(@"Image_closeassety") forState:UIControlStateNormal];
        [self addSubview:self.changeButton];
        [self.changeButton addTarget:self action:@selector(openClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
        self.iconImageView.layer.cornerRadius = 20;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.image = UIImageNamed(@"Image_asestdefaut");
        [self addSubview:self.iconImageView];
        self.iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
        [self.iconImageView addGestureRecognizer:tap];
        
        HWCircleView *circleView = [[HWCircleView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.iconImageView addSubview:circleView];
        self.progressView = circleView;
        
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 10, 36, 36)];
        [self.playButton setImage:UIImageNamed(@"Image_assetplay") forState:UIControlStateNormal];//Image_asset_stop
        [self.playButton addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
        self.playButton.hidden = YES;
        [self setupLockScreenControlInfo];
        // 后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apllicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        // 进入前台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apllicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {

        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.playingBlock = ^(CGFloat currentTime) {
            if (weakSelf.voiceArr.count) {
                if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > self.currentModel.voice_len.integerValue) {
                    currentTime = self.currentModel.voice_len.integerValue;
                }
                weakSelf.progressView.progress = currentTime/self.currentModel.voice_len.floatValue;
            }
           
            if (weakSelf.pyArr.count) {
                if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > self.currentPyModel.dubbing_len.integerValue) {
                    currentTime = self.currentPyModel.dubbing_len.integerValue;
                }
                weakSelf.progressView.progress = currentTime/self.currentPyModel.dubbing_len.floatValue;
            }
            
            if (weakSelf.playingBlock) {
                weakSelf.playingBlock(currentTime);
            }
        };
        _audioPlayer.playComplete = ^{
            
            [weakSelf refreshBack];
            if (weakSelf.isNoRefresh) {
                weakSelf.isNoRefresh = NO;
                return;
            }
            
            weakSelf.isPlaying = NO;
            weakSelf.isReplay = YES;
            
            if (weakSelf.playComplete) {
                weakSelf.playComplete();
            }
            
            if (weakSelf.noRePlay) {//不需要循环播放
                weakSelf.noRePlay = NO;
                return;
            }
            
            if (weakSelf.pyArr.count && (weakSelf.pyArr.count-1 >= weakSelf.currentTag+1)) {
                weakSelf.currentTag++;
                weakSelf.currentPyModel.isPlaying = NO;
                weakSelf.currentPyModel = weakSelf.pyArr[weakSelf.currentTag];
                if (weakSelf.playNext) {
                    weakSelf.playNext();
                }
                [weakSelf playClick];
            }else{
                if (weakSelf.pyArr.count) {
                    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                    BaseNavigationController *nav = nil;
                    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
                        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                    }
                    [nav.topViewController showToastWithText:[NoticeTools chinese:@"播放完啦" english:@"That’s all" japan:@"プレイ終了"]];
                }
            }
            
            [weakSelf nextPlayVoice];
        };
        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (weakSelf.startPlaying) {
                weakSelf.startPlaying(status, duration);
            }
            if (status == AVPlayerItemStatusFailed) {
            }else{
                weakSelf.isPlaying = YES;
            }
        };
    }
    return _audioPlayer;
}

- (void)nextPlayVoice{
    if (self.voiceArr.count && (self.voiceArr.count-1 >= self.currentTag+1)) {
        self.currentTag++;
        self.currentModel.isPlaying = NO;
        NoticeVoiceListModel *vocieM = self.voiceArr[self.currentTag];
        if (vocieM.content_type.intValue == 1) {
            self.currentModel = vocieM;
            if (self.playNext) {
                self.playNext();
            }
            [self playClick];
        }else{
            [self nextPlayVoice];
        }
    }else{
        if (self.voiceArr.count) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            [nav.topViewController showToastWithText:[NoticeTools chinese:@"播放完啦" english:@"That’s all" japan:@"プレイ終了"]];
        }
    }
}

- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
   
    [self.playButton setImage:UIImageNamed(isPlaying?@"Image_asset_stop": @"Image_assetplay") forState:UIControlStateNormal];
}

- (void)setIsPasue:(BOOL)isPasue{
    _isPasue = isPasue;
    [self.audioPlayer pause:self.isPasue];
    [self.playButton setImage:UIImageNamed(!isPasue?@"Image_asset_stop": @"Image_assetplay") forState:UIControlStateNormal];
}

- (void)playClick{
    self.hidden = NO;
    [NoticeTools setHidePlay:@"0"];
    if (self.isReplay) {
        self.isReplay = NO;
        //self.isNoRefresh = YES;
        if (self.voiceArr.count) {
            [self.audioPlayer startPlayWithUrl:self.currentModel.voice_url isLocalFile:NO];
        }else if(self.pyArr.count){
            [self.audioPlayer startPlayWithUrl:self.currentPyModel.dubbing_url isLocalFile:NO];
        }
        
    }else{
        if (self.isPlaying) {
            self.isPasue = !self.isPasue;
        }
    }
    
    if (self.assestDelegate && [self.assestDelegate respondsToSelector:@selector(clickStopOrPlayAssest: playing:)]) {
        [self.assestDelegate clickStopOrPlayAssest:self.isPasue playing:self.isPlaying];
    }
}

- (void)controllerPauseOrPlay{
    
    [self playClick];
}

- (void)setupLockScreenControlInfo {
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 锁屏播放
    MPRemoteCommand *playCommand = commandCenter.playCommand;
    playCommand.enabled = YES;
    [playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        DRLog(@"开始播放");
    
        [self controllerPauseOrPlay];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
 

    // 播放和暂停按钮
    MPRemoteCommand *playPauseCommand = commandCenter.togglePlayPauseCommand;
    playPauseCommand.enabled = YES;
 
    [playPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {

        [self controllerPauseOrPlay];
        DRLog(@"停止播放");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
//    // 上一曲
//    MPRemoteCommand *previousCommand = commandCenter.previousTrackCommand;
//    [previousCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//
//        [self nextPlayVoice];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 下一曲
//    MPRemoteCommand *nextCommand = commandCenter.nextTrackCommand;
//    nextCommand.enabled = YES;
//    [nextCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        DRLog(@"下一曲");
//        [self nextPlayVoice];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
}

//更新通知中心控制台媒体信息
- (void)setupLockScreenMediaInfo {
    
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *playingInfo = [NSMutableDictionary new];
    
    if (self.voiceArr.count) {
        //标题
        playingInfo[MPMediaItemPropertyTitle] = self.currentModel.subUserModel.nick_name;
        
        playingInfo[MPMediaItemPropertyArtist] = self.currentModel.subUserModel.nick_name;
    }else if(self.pyArr.count){
        //标题
        playingInfo[MPMediaItemPropertyTitle] = self.currentPyModel.nick_name;
        
        playingInfo[MPMediaItemPropertyArtist] = self.currentPyModel.nick_name;
    }
    
 

    //封面图片
    UIImageView *coverImageView = [[UIImageView alloc] init];
    
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.voiceArr.count?self.currentModel.subUserModel.avatar_url: self.currentPyModel.avatar_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(100, 100) requestHandler:^UIImage * _Nonnull(CGSize size) {
                return image;
            }];
            playingInfo[MPMediaItemPropertyArtwork] = artwork;
            [playingCenter setNowPlayingInfo:playingInfo];
        });
    }];
    
    UIImage *image = coverImageView.image;
    if (image) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(100, 100) requestHandler:^UIImage * _Nonnull(CGSize size) {
            return image;
        }];
        playingInfo[MPMediaItemPropertyArtwork] = artwork;
    }


    [playingCenter setNowPlayingInfo:playingInfo];
}

#pragma mark - 通知方法实现
 
/// 进入后台
- (void)apllicationWillResignActiveNotification:(NSNotification *)n
{
   
    // *让app接受远程事件控制，及锁屏是控制版会出现播放按钮
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // *后台播放代码
    AVAudioSession*session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 上面代码实现后台播放 几分钟后会停止播放
    [self setupLockScreenMediaInfo];
    
}
 
// 进入前台通知
- (void) apllicationWillEnterForegroundNotification:(NSNotification *)n {
    // 进前台 设置不接受远程控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
   [commandCenter.nextTrackCommand removeTarget:self];
    [commandCenter.togglePlayPauseCommand removeTarget:self];
}

- (void)setIsOut:(BOOL)isOut{
    _isOut = isOut;
    if (_isOut) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.changeButton setImage:UIImageNamed(@"Image_closeassetn") forState:UIControlStateNormal];
            self.frame = CGRectMake(DR_SCREEN_WIDTH-184, self.frame.origin.y, 184, 56);
            self.changeButton.frame = CGRectMake(self.frame.size.width-8-20, 18, 20, 20);
            self.playButton.hidden = NO;
            self.rateButton.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.changeButton setImage:UIImageNamed(@"Image_closeassety") forState:UIControlStateNormal];
            self.frame = CGRectMake(DR_SCREEN_WIDTH-92, self.frame.origin.y, 92, 56);
            self.changeButton.frame = CGRectMake(self.frame.size.width-8-20, 18, 20, 20);
            self.playButton.hidden = YES;
            self.rateButton.hidden = YES;
        }];
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatPoint = self.center;
    appdel.floatViewIsOut = _isOut;
    
}

- (void)refreshBack{
    self.progressView.progress = 0;
    [self.playButton setImage:UIImageNamed(@"Image_assetplay") forState:UIControlStateNormal];
}

- (void)openClick{
    self.isOut = !self.isOut;
}

- (void)rateClick{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex > 0) {
            [NoticeTools voicePlayRate:[NSString stringWithFormat:@"%ld",buttonIndex]];
            if ([NoticeTools voicePlayRate] == 1) {
                [self.rateButton setTitle:@"倍速" forState:UIControlStateNormal];
            }else if ([NoticeTools voicePlayRate] == 2){
                [self.rateButton setTitle:@"1.25x" forState:UIControlStateNormal];
            }else if ([NoticeTools voicePlayRate] == 3){
                [self.rateButton setTitle:@"1.5x" forState:UIControlStateNormal];
            }else if ([NoticeTools voicePlayRate] == 4){
                [self.rateButton setTitle:@"2.0x" forState:UIControlStateNormal];
            }
            else{
                [self.rateButton setTitle:@"倍速" forState:UIControlStateNormal];
            }
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.audioPlayer setPlayRate];
        }
    } otherButtonTitleArray:@[@"1.0x",@"1.25x",@"1.5x",@"2.0x"]];
    [sheet show];
}

- (void)setCurrentModel:(NoticeVoiceListModel *)currentModel{
    _currentModel = currentModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:currentModel.subUserModel.avatar_url] placeholderImage:UIImageNamed(@"Image_asestdefaut")];
    
    [self setupLockScreenMediaInfo];
}

- (void)setCurrentPyModel:(NoticeClockPyModel *)currentPyModel{
    _currentPyModel = currentPyModel;
    
    if (currentPyModel.is_anonymous.boolValue) {
        _iconImageView.image = UIImageNamed(@"Image_nimingpeiy");
    }else{
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:currentPyModel.pyUserInfo.avatar_url] placeholderImage:UIImageNamed(@"Image_asestdefaut")];
    }
    
    [self setupLockScreenMediaInfo];
}

- (void)setVoiceArr:(NSMutableArray *)voiceArr{
    _voiceArr = voiceArr;
    [self.pyArr removeAllObjects];
}

- (void)setPyArr:(NSMutableArray *)pyArr{
    _pyArr = pyArr;
    [self.voiceArr removeAllObjects];
}

- (void)iconTap{
    if ((!self.voiceArr.count && !self.pyArr.count) || self.noPushUserCenter) {
        return;
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }

    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionDefault
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    
    if (self.voiceArr.count) {
        if (self.currentModel.resource) {
            NoticeMBSDetailVoiceController *ctl = [[NoticeMBSDetailVoiceController alloc] init];
            ctl.voiceM = self.currentModel;
            ctl.autoPlay = YES;
            ctl.noPushToUserCenter = YES;
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
            return;
        }
        NoticeVoiceDetailController *ctl = [[NoticeVoiceDetailController alloc] init];
        ctl.voiceM = self.currentModel;
        ctl.autoPlay = YES;
        ctl.noPushToUserCenter = YES;
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        
    }

    if (self.pyArr.count) {
        NoticePyComController *ctl = [[NoticePyComController alloc] init];
        ctl.pyMOdel = self.currentPyModel;
        ctl.autoPlay = YES;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

@end
