
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^VoiceRecorderStartRecordingBlock)(BOOL isSuccess); ///<开始录音回调
typedef void(^VoiceRecorderFinishRecordingBlock)(NSString *aacUrl, NSUInteger audioTimeLength); ///<录音结束回调
typedef void(^VoiceRecordingFailBlock)(NSString *reason);
typedef void(^VoiceRecorderPauseRecordingBlock)(NSString *aacUrl, NSUInteger audioTimeLength); ///<录音暂停回调
@interface LGVoiceRecorder : NSObject
@property (nonatomic, copy) VoiceRecorderStartRecordingBlock audioStartRecording;
@property (nonatomic, copy) VoiceRecorderFinishRecordingBlock audioFinishRecording;
@property (nonatomic, copy) VoiceRecordingFailBlock audioRecordingFail;                      //录制时长过段失败回调
@property (nonatomic, copy) VoiceRecorderPauseRecordingBlock audioPauseBlock;
@property (nonatomic, assign) BOOL isRecording; ///<正在录制中
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, assign) NSUInteger __block audioTimeLength; //录音时长
@property (nonatomic, assign) NSTimeInterval currentTime;

- (float)levels;//返回分贝值

//清除上一次的音频
- (void)cleanCache;

/**
 开始录制
 */
- (void)startRecording;

/**
 停止录制
 */
- (void)stopRecording;

/**
 暂停录制
 */
- (void)pauseRecording;

/**
 继续录制
 */
- (void)contuintRecording;

/**
 重新录制
 */
- (void)reRecording;


@end
