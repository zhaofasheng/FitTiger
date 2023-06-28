
#import "LGVoiceRecorder.h"

#define ALPHA 0.02f                 // 音频振幅调解相对值 (越小振幅就越高)
#define AACFile @"temporaryRadio.wav"

@interface LGVoiceRecorder ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) NSFileManager *fileManager;


@end

@implementation LGVoiceRecorder

- (void)dealloc
{
    if (self.isRecording) [self.recorder stop];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //清除之前的音频缓存
        self.currentTime = 0;
        self.audioTimeLength = 0;
        [self cleanCache];
    }
    return self;
}

- (void)cleanCache
{
    NSString *aacRecordFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:AACFile];
    if ([self.fileManager fileExistsAtPath:aacRecordFilePath]) {
        [self.fileManager removeItemAtPath:aacRecordFilePath error:nil];
    }
}

- (void)startRecording
{
    if (self.isRecording) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTOPPLAYCENTERMUSIC" object:nil];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//录音的时候设置不黑屏
//    //开始录音
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.recorder prepareToRecord];
    
    [self.recorder record];
    
    if ([self.recorder isRecording]) {
        self.isRecording = YES;
        if (self.audioStartRecording) {
            self.audioStartRecording(YES);
        }
    } else {
        if (self.audioStartRecording) {
            self.audioStartRecording(NO);
        }
    }
}

- (float)levels {
    [self.recorder updateMeters];
    double aveChannel = pow(10, (ALPHA * [self.recorder averagePowerForChannel:0]));
    if (aveChannel <= 0.05f) aveChannel = 0.05f;
    if (aveChannel >= 1.0f) aveChannel = 1.0f;
    return aveChannel*100;
}

- (void)stopRecording
{
     [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    if (!self.isRecording) {
        return;
    }
    self.audioTimeLength = self.recorder.currentTime;
    [self.recorder stop];
    
    self.isRecording = NO;
}

- (void)reRecording
{
     [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    if (self.isRecording) {
        [self stopRecording];
    }
    self.audioTimeLength = 0;
    [self cleanCache];
}

- (void)pauseRecording{
    [self.recorder pause];

}

- (void)contuintRecording{
    [self.recorder record];
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (flag) {
        //暂存录音文件路径
        NSString *aacRecordFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:AACFile];
     
        if (self.audioFinishRecording) {
            self.audioFinishRecording(aacRecordFilePath, self.audioTimeLength);
        }
        self.isRecording = NO;
    } else {
        if (self.audioRecordingFail) {
            self.audioRecordingFail(@"录音时长小于设定最短时长");
        }
    }
}

#pragma mark setter and getter
- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSTimeInterval)currentTime
{
    return self.recorder.isRecording ? self.recorder.currentTime :0.0;
}

- (AVAudioRecorder *)recorder
{
    if (!_recorder) {
        //暂存录音文件路径
        NSString *aacRecordFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:AACFile];
        NSDictionary *recordSetting = @{ AVSampleRateKey        : @44100,                      // 采样率
                                         AVFormatIDKey          : @(kAudioFormatLinearPCM),     // 音频格式
                                         AVLinearPCMBitDepthKey : @16,                          // 采样位数 默认 16
                                         AVNumberOfChannelsKey  : @1,                   // 通道的数目
                                         AVEncoderAudioQualityKey : @(AVAudioQualityMax)
                                         };
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:aacRecordFilePath] settings:recordSetting error:nil];
        _recorder.meteringEnabled = YES;
        _recorder.delegate = self;
    }
    return _recorder;
}

@end

