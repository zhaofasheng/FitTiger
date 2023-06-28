
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
typedef void(^PlayCompleteBlock)(void);

typedef void(^StartPlayingBlock)(AVPlayerItemStatus status, CGFloat duration);

typedef void(^AudioPlayingBlock)(CGFloat currentTime);

typedef NS_ENUM(NSUInteger, NOTICEVOICEPLAYTYPE) {
    PLAYCENTERVOICE     = 0, // 播放心情音频播放器默认
    NOTICEPLAYCENTERMUSIC = 1//个人主页歌单播放器
};

@interface LGAudioPlayer : NSObject

/**
 播放完成回调
 */
@property (nonatomic, copy) PlayCompleteBlock playComplete;
@property (nonatomic, strong) AVPlayerItem *voiceItem;
/**
 开始播放回调
 */
@property (nonatomic, copy) StartPlayingBlock startPlaying;

@property (nonatomic, copy) AudioPlayingBlock playingBlock;

@property (nonatomic, assign) NSUInteger currentTime; //当前播放时间
@property (nonatomic, assign) BOOL isPlaying; //播放中
@property (nonatomic, assign) BOOL isLocalFile; ///< 是否是本地文件
@property (nonatomic, assign) BOOL oneSecondGo; //1秒执行一次回调
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) NOTICEVOICEPLAYTYPE playType;//1代表个人主页歌单播放器

/**
 开始播放音频文件
 
 @param urlStr url
 @param isLocalFile 是否是本地文件
 */
- (void)startPlayWithUrl:(NSString *)urlStr isLocalFile:(BOOL)isLocalFile;

//边录音边播放模式
- (void)startPlayWithUrlandRecoding:(NSString *)urlStr isLocalFile:(BOOL)isLocalFile;

//直接播放URL模式
- (void)startPlayWithUrl:(NSURL *)urlStr;

- (void)pause:(BOOL)pause;

- (void)setPlayRate;
/**
 停止播放
 */
- (void)stopPlaying;

@end

