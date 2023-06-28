
#import "LGAudioPlayer.h"
@interface LGAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSFileManager *fileManager; //
@property (nonatomic, strong) AVAudioPlayer *audioPlayer; //音频播放器
@property (nonatomic, weak) id observer;
@property (nonatomic, assign) CGFloat volume;
@end

@implementation LGAudioPlayer
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.observer) {
        [self.player removeTimeObserver:self.observer];
        
    }
    [self removeObserver];
    [self.voiceItem removeObserver:self forKeyPath:@"status"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver];
    }
    return self;
}

- (void)addObserver
{
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayings:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.voiceItem];

    //监听是否靠近耳朵
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 监听是否靠近耳朵
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSError *sessionError;
//    if ([[UIDevice currentDevice] proximityState] == YES)
//    {
//        DRLog(@"靠近耳朵听筒");
//        //靠近耳朵
//        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
//    }
//    else
//    {
//        //远离耳朵
//        if ([NoticeTools isOpen]) {
//            DRLog(@"离开耳朵系统设置功放");
//            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];//扬声器模式
//        }else{
//            DRLog(@"离开耳朵系统设置听筒");
//            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//听筒模式
//        }
//    }
}

-(BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

- (void)startPlayWithUrl:(NSURL *)urlStr{
    if ([NoticeTools isOpen]) {
        //AVAudioSessionCategoryPlayAndRecord
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];//扬声器模式
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//听筒模式
    }
  
    //
    
    if (self.playType != NOTICEPLAYCENTERMUSIC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTOPPLAYCENTERMUSIC" object:nil];
    }
    
    if (self.isPlaying) {
        [self stopPlaying];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];//设置不黑屏
   // [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //开启红外感应
    self.isLocalFile = YES;
   
    //本地文件
    NSURL *fileUrl = urlStr;
    [self.voiceItem removeObserver:self forKeyPath:@"status"];
    self.voiceItem = [[AVPlayerItem alloc] initWithURL:fileUrl];

    [self.player replaceCurrentItemWithPlayerItem:self.voiceItem];
    [self.voiceItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //[self graduallyPasueWithDuration:3];
    [self.player play];
    
    self.isPlaying = YES;
    [self setPlayRate];
}

//播放
- (void)startPlayWithUrl:(NSString *)urlStr isLocalFile:(BOOL)isLocalFile
{
    
    if ([NoticeTools isOpen]) {
        //AVAudioSessionCategoryPlayAndRecord
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];//扬声器模式
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//听筒模式
    }
  
    //
    
    if (self.isPlaying) {
        [self stopPlaying];
    }
    
 
    if (self.playType != NOTICEPLAYCENTERMUSIC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTOPPLAYCENTERMUSIC" object:nil];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];//设置不黑屏
   // [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //开启红外感应
    self.isLocalFile = isLocalFile;
    self.url = urlStr;

    //新建item
    if (isLocalFile) {
        //本地文件
        NSURL *fileUrl = [NSURL fileURLWithPath:urlStr ? urlStr : @""];
        [self.voiceItem removeObserver:self forKeyPath:@"status"];
        self.voiceItem = [[AVPlayerItem alloc] initWithURL:fileUrl];
        
    } else {
        [self.voiceItem removeObserver:self forKeyPath:@"status"];
        if ([self hasChinese:urlStr]) {
            NSString* encodedString = [urlStr
            stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet
                                                                URLFragmentAllowedCharacterSet]];
            self.voiceItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:encodedString]];
        }else{
            self.voiceItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr]];
        }

    }

    [self.player replaceCurrentItemWithPlayerItem:self.voiceItem];
    [self.voiceItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //[self graduallyPasueWithDuration:3];
    [self.player play];
    
    self.isPlaying = YES;
    [self setPlayRate];
}

- (void)startPlayWithUrlandRecoding:(NSString *)urlStr isLocalFile:(BOOL)isLocalFile{

    if (self.isPlaying) {
        [self stopPlaying];
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];//设置不黑屏
   // [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //开启红外感应
    self.isLocalFile = isLocalFile;
    self.url = urlStr;

    //新建item
    if (isLocalFile) {
        //本地文件
        NSURL *fileUrl = [NSURL fileURLWithPath:urlStr ? urlStr : @""];
        [self.voiceItem removeObserver:self forKeyPath:@"status"];
        self.voiceItem = [[AVPlayerItem alloc] initWithURL:fileUrl];
        
    } else {
        [self.voiceItem removeObserver:self forKeyPath:@"status"];
        if ([self hasChinese:urlStr]) {
            NSString* encodedString = [urlStr
            stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet
                                                                URLFragmentAllowedCharacterSet]];
            self.voiceItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:encodedString]];
        }else{
            self.voiceItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr]];
        }

    }

    [self.player replaceCurrentItemWithPlayerItem:self.voiceItem];
    [self.voiceItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.player play];
    self.isPlaying = YES;
    [self setPlayRate];
}


-(void)graduallyPasueWithDuration:(NSTimeInterval)duration
{
    self.volume = 0;
    //频率
    static NSTimeInterval frequency = 0.05;
    //定时器执行次数
    __block int overCount = duration / frequency;
    //声音每次降低的偏移量
    float volumeOffset = self.volume / overCount;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), frequency * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        overCount -= 1;
        self.volume += volumeOffset;
        if (overCount < 0) {
            dispatch_source_cancel(_timer);
        }
    });
    dispatch_source_set_cancel_handler(_timer, ^{
        //[self pause];
        self.volume = 1;
        dispatch_group_leave(group);
    });
    dispatch_resume(_timer);
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)setVolume:(CGFloat)volume{
    _volume = volume;
    self.audioPlayer.volume = volume;
}

//实现AVPlayer倍数播放需要实现这个，并且调用播放以后再调用
- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem
{
    for (AVPlayerItemTrack *track in playerItem.tracks)
    {
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeAudio])
        {
            track.enabled = enable;
        }
    }
}

- (void)pause:(BOOL)pause
{
    if (pause) {
        self.isPlaying = NO;
        [[UIApplication sharedApplication] setIdleTimerDisabled: NO];//设置不黑屏
        [self.player pause];
    } else {
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];//设置不黑屏
        [self.player play];
        self.isPlaying = YES;
        [self setPlayRate];
    }
    
}

- (void)setPlayRate{

    if (!self.isPlaying) {
        return;
    }
    
    if (self.isLocalFile) {//本地播放不执行倍速播放
        [self enableAudioTracks:YES inPlayerItem:self.player.currentItem];
        self.player.rate = 1;
        return;
    }
    
    [self enableAudioTracks:YES inPlayerItem:self.player.currentItem];
    if ([NoticeTools voicePlayRate] == 1) {
        self.player.rate = 1.0;
    }else if ([NoticeTools voicePlayRate] == 2){
        self.player.rate = 1.25;
    }else if ([NoticeTools voicePlayRate] == 3){
        self.player.rate = 1.75;
    }else if ([NoticeTools voicePlayRate] == 4){
        self.player.rate = 2;
    }
    else{
        self.player.rate = 1;
    }
    
}

- (void)stopPlayings:(NSNotification *)notifi{

    if ([self.voiceItem isEqual:notifi.object]) {
     
        [self stopPlaying];
    }
}

- (void)stopPlaying
{
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];//设置不黑屏
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //开启红外感应
    if (!self.isPlaying) {
        return;
    }
    self.isPlaying = NO;
    [self.player replaceCurrentItemWithPlayerItem:nil];
    if (self.playComplete) {
        self.playComplete();
    }
}

- (void)voiceItemStateChange:(AVPlayerItemStatus)status
{
    switch (status) {
        case AVPlayerItemStatusReadyToPlay: {
            // 开始播放
            self.isPlaying = YES;
            if (self.startPlaying) {
                self.startPlaying(AVPlayerItemStatusReadyToPlay, self.voiceItem ? CMTimeGetSeconds(self.voiceItem.duration) :0);
            }
            
        } break;
            
        case AVPlayerItemStatusFailed: {
            DRLog(@"音频加载失败");
            self.isPlaying = NO;
            if (self.startPlaying) {
                self.startPlaying(AVPlayerItemStatusFailed, self.voiceItem ? CMTimeGetSeconds(self.voiceItem.duration) :0);
            }
        }
            break;
            
        case AVPlayerItemStatusUnknown: {
            DRLog(@"未知资源");
            self.isPlaying = NO;
            if (self.startPlaying) {
                self.startPlaying(AVPlayerItemStatusUnknown, self.voiceItem ? CMTimeGetSeconds(self.voiceItem.duration) :0);
            }
        }
            break;
            
        default:
            break;
            
    }
}

#pragma mark -setter and getter

- (AVPlayer *)player
{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0;
        _player.automaticallyWaitsToMinimizeStalling = NO;
        __weak typeof(self) weakSelf = self;
       
        _observer =  [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, self.oneSecondGo?1:10) queue:NULL usingBlock:^(CMTime time) {
            if (weakSelf.player.currentItem.status != AVPlayerItemStatusReadyToPlay) {
                return ;
            }
            float current = CMTimeGetSeconds(time);
            //float total = CMTimeGetSeconds(songItem.duration); 
            if (weakSelf.playingBlock && weakSelf.isPlaying) {
                weakSelf.playingBlock(current);
            }
        }];
    }
    return _player;
}

- (NSUInteger)currentTime
{
    return self.audioPlayer.isPlaying ? self.audioPlayer.currentTime : 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerItemStatus status = (AVPlayerItemStatus)[[change objectForKey:@"new"] integerValue];
        [self voiceItemStateChange:status];
    }
}

@end

