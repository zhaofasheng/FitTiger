//
//  PlayerView.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2016/11/1.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CLPlayerMaskView.h"
#import "CLGCDTimerManager.h"

static NSString *CLPlayer_sliderTimer = @"CLPlayer_sliderTimer";
static NSString *CLPlayer_tapTimer = @"CLPlayer_tapTimer";

// 播放器的几种状态
typedef NS_ENUM(NSInteger, CLPlayerState) {
    CLPlayerStateFailed,     // 播放失败
    CLPlayerStateBuffering,  // 缓冲中
    CLPlayerStatePlaying,    // 播放中
    CLPlayerStateStopped,    // 停止播放
};
// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, CLPanDirection){
    CLPanDirectionHorizontalMoved, // 横向移动
    CLPanDirectionVerticalMoved,   // 纵向移动
};

@interface CLPlayerView ()

/** 播发器的几种状态 */
@property (nonatomic, assign) CLPlayerState    state;
/**控件原始Farme*/
@property (nonatomic, assign) CGRect           customFarme;
/**父类控件*/
@property (nonatomic, strong) UIView           *fatherView;
/**视频拉伸模式*/
@property (nonatomic, copy) NSString           *fillMode;
/**状态栏*/
@property (nonatomic, strong) UIView           *statusBar;
/**全屏标记*/
@property (nonatomic, assign) BOOL             isFullScreen;
/**工具条隐藏标记*/
@property (nonatomic, assign) BOOL             isDisappear;
/**用户点击播放标记*/
@property (nonatomic, assign) BOOL             isUserPlay;
/**记录控制器状态栏状态*/
@property (nonatomic, assign) BOOL             statusBarHiddenState;
/**点击最大化标记*/
@property (nonatomic, assign) BOOL             isUserTapMaxButton;
/**播放完成标记*/
@property (nonatomic, assign) BOOL             isEnd;
/**播放器*/
@property (nonatomic, strong) AVPlayer         *player;
/**playerLayer*/
@property (nonatomic, strong) AVPlayerLayer    *playerLayer;
/**播放器item*/
@property (nonatomic, strong) AVPlayerItem     *playerItem;
/**遮罩*/
@property (nonatomic, strong) CLPlayerMaskView *maskView;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat          sumTime;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) CLPanDirection   panDirection;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL             isVolume;
/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL             isDragged;
/**缓冲判断*/
@property (nonatomic, assign) BOOL             isBuffering;
/**音量滑杆*/
@property (nonatomic, strong) UISlider         *volumeViewSlider;

/**返回按钮回调*/
@property (nonatomic, copy) void (^BackBlock) (UIButton *backButton);
/**播放完成回调*/
@property (nonatomic, copy) void (^EndBlock) (void);

@end

@implementation CLPlayerView

#pragma mark - 懒加载


#pragma mark - 视频拉伸方式
-(void)setVideoFillMode:(VideoFillMode)videoFillMode{
    _videoFillMode = videoFillMode;
    switch (videoFillMode){
        case VideoFillModeResize:
            //拉伸视频内容达到边框占满，但不按原比例拉伸
            _fillMode = AVLayerVideoGravityResize;
            break;
        case VideoFillModeResizeAspect:
            //按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑
            _fillMode = AVLayerVideoGravityResizeAspect;
            break;
        case VideoFillModeResizeAspectFill:
            //原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分会被剪切
            _fillMode = AVLayerVideoGravityResizeAspectFill;
            break;
    }
}

#pragma mark - 重复播放
- (void)setRepeatPlay:(BOOL)repeatPlay{
    _repeatPlay = repeatPlay;
}

#pragma mark - 传入播放地址
- (void)setUrl:(NSURL *)url{
    _url                      = url;
    self.playerItem           = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:_url]];
    //创建
    _player                   = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer              = [AVPlayerLayer playerLayerWithPlayer:_player];
    //全屏拉伸
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
    //设置静音模式播放声音

    _playerLayer.videoGravity = _fillMode;
    //放到最下面，防止遮挡
    [self.layer insertSublayer:_playerLayer atIndex:0];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
-(void)setPlayerItem:(AVPlayerItem *)playerItem{
    if (_playerItem == playerItem){
        return;
    }
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        //重置播放器
        [self resetPlayer];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayDidEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
        [playerItem addObserver:self
                     forKeyPath:@"status"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        [playerItem addObserver:self
                     forKeyPath:@"loadedTimeRanges"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        [playerItem addObserver:self
                     forKeyPath:@"playbackBufferEmpty"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    }
}
- (void)setState:(CLPlayerState)state{
    if (_state == state) {
        return;
    }
    _state = state;
    if (state == CLPlayerStateBuffering) {
        [self.maskView.activity starAnimation];
    }else if (state == CLPlayerStateFailed){
        [self.maskView.activity stopAnimation];
        self.maskView.failButton.hidden   = NO;
        self.maskView.playButton.selected = NO;
#ifdef DEBUG
        NSLog(@"加载失败");
#endif
    }else{
        [self.maskView.activity stopAnimation];
        if (_isUserPlay) {
            [self playVideo];
        }
    }
}
#pragma mark - 隐藏或者显示状态栏方法
- (void)setStatusBarHidden:(BOOL)hidden{
    //设置是否隐藏
    self.statusBar.hidden = hidden;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        //初始值
        _isFullScreen            = NO;
        _isDisappear             = NO;
        _isUserPlay              = NO;
        _isUserTapMaxButton      = NO;
        _isEnd                   = NO;
        _repeatPlay              = NO;
        _mute                    = NO;
        _isLandscape             = NO;
        _smallGestureControl     = NO;
        _autoRotate              = YES;
        _fullGestureControl      = YES;
        _statusBarHiddenState    = self.statusBar.isHidden;
        _progressBackgroundColor = [UIColor colorWithRed:0.54118
                                                   green:0.51373
                                                    blue:0.50980
                                                   alpha:1.00000];
        _progressPlayFinishColor = [UIColor whiteColor];
        _progressBufferColor     = [UIColor colorWithRed:0.84118
                                                   green:0.81373
                                                    blue:0.80980
                                                   alpha:1.00000];
        self.videoFillMode           = VideoFillModeResize;
        self.topToolBarHiddenType    = TopToolBarHiddenNever;
        self.fullStatusBarHiddenType = FullStatusBarHiddenNever;
  
        [self creatUI];
        //添加工具条定时消失
        self.toolBarDisappearTime = 10;
    }
    return self;
}
#pragma mark - 创建播放器UI
- (void)creatUI{
    self.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayingNotice) name:@"stopvideoplay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayingNotice) name:@"revideoplay" object:nil];
    
    //
    
    //最上面的View
    [self addSubview:self.maskView];
}
#pragma mark - 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {

            self.player.muted = self.mute;
        }
        else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            self.state = CLPlayerStateFailed;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration             = self.playerItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        [self.maskView.progress setProgress:timeInterval / totalDuration animated:NO];
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        // 当缓冲是空的时候
        if (self.playerItem.isPlaybackBufferEmpty) {
            [self bufferingSomeSecond];
        }
    }
}

#pragma mark - 缓冲较差时候
//卡顿缓冲几秒
- (void)bufferingSomeSecond{
    self.state   = CLPlayerStateBuffering;
    _isBuffering = NO;
    if (_isBuffering){
        return;
    }
    _isBuffering = YES;
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pausePlay];
    //延迟执行
    [self performSelector:@selector(bufferingSomeSecondEnd)
               withObject:@"Buffering"
               afterDelay:5];
}
//卡顿缓冲结束
- (void)bufferingSomeSecondEnd{
    [self playVideo];
    // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
    _isBuffering = NO;
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    }
}
//计算缓冲进度
- (NSTimeInterval)availableDuration{
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
#pragma mark - 拖动进度条
//开始
-(void)cl_progressSliderTouchBegan:(CLSlider *)slider{
    //暂停
    [self pausePlay];
    //销毁定时消失工具条定时器
    [self destroyToolBarTimer];
}
//结束
-(void)cl_progressSliderTouchEnded:(CLSlider *)slider{
    if (slider.value != 1) {
        _isEnd = NO;
    }
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
        [self bufferingSomeSecond];
    }else{
        //继续播放
        [self playVideo];
    }
    //重新添加工具条定时消失定时器
    self.toolBarDisappearTime = _toolBarDisappearTime;
}

- (void)stopPlayingNotice{
    [self pausePlay];
}

- (void)startPlayingNotice{
    [self resetPlay];
}

#pragma mark - 播放完成
- (void)moviePlayDidEnd:(NSNotification *)notifi{
    DRLog(@"结束播放");
    if ([self.playerItem isEqual:notifi.object]) {
        _isEnd = YES;
        [self resetPlay];
    }else{
        DRLog(@"音频结束");
    }

}
- (void)endPlay:(EndBolck) end{
    self.EndBlock = end;
}
#pragma mark - 暂停播放
- (void)pausePlay{
    self.maskView.playButton.selected = NO;
    [_player pause];

}
#pragma mark - 播放
- (void)playVideo{

    [_player play];
}
#pragma mark - 重新开始播放
- (void)resetPlay{
    _isEnd = NO;
    [_player seekToTime:CMTimeMake(0, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self playVideo];
    DRLog(@"继续播放");
}
#pragma mark - 销毁播放器
- (void)destroyPlayer{
    [self pausePlay];
    //销毁定时器
    [self destroyAllTimer];
    //取消延迟执行的缓冲结束代码
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(bufferingSomeSecondEnd)
                                               object:@"Buffering"];

    //移除
    [self.playerLayer removeFromSuperlayer];
    [self removeFromSuperview];
    self.playerLayer = nil;
    self.player      = nil;
}
#pragma mark - 重置播放器
- (void)resetPlayer{

}
#pragma mark - 取消定时器
//销毁所有定时器
- (void)destroyAllTimer{
    [[CLGCDTimerManager sharedManager] cancelTimerWithName:CLPlayer_sliderTimer];
    [[CLGCDTimerManager sharedManager] cancelTimerWithName:CLPlayer_tapTimer];
}
//销毁定时消失定时器
- (void)destroyToolBarTimer{
    [[CLGCDTimerManager sharedManager] cancelTimerWithName:CLPlayer_tapTimer];
}

#pragma mark - layoutSubviews
-(void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.maskView.frame    = self.bounds;
}
#pragma mark - dealloc
- (void)dealloc{

    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];

#ifdef DEBUG
    NSLog(@"播放器被销毁了");
#endif
}

@end

