//
//  NoticeAudioJoinToAudioModel.m
//  NoticeXi
//
//  Created by li lei on 2022/4/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeAudioJoinToAudioModel.h"
#import "NoticeSaveVoiceTools.h"
@implementation NoticeAudioJoinToAudioModel


/// 音频合成的方法，可以实现音频合成，不同音频音量的不同
/// @param audioPath 录音的音频文件地址
/// @param bgmPath 本地或者网络的音频文件地址
/// @param isTuiJian 这个是自己项目的bool值，可以不管
- (void)recoderAudioPath:(NSString *)audioPath bgmPath:(NSString *)bgmPath isTuijian:(BOOL)isTuiJian{
    
    AVURLAsset *audioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    AVURLAsset *bgmAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:bgmPath]];
    
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    CMTime bgmDuration = bgmAsset.duration;//录音时长
    float bgmDurationSeconds = CMTimeGetSeconds(bgmDuration);//bgm时长
    
    AVMutableComposition *compostion = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *bgmAudio = [compostion addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    if (audioDurationSeconds > bgmDurationSeconds) {//如果录音时长大于bgm时长，则bgm时间合成为原时长，否则截取为bgm时间
        [bgmAudio insertTimeRange:CMTimeRangeMake(kCMTimeZero, bgmAsset.duration) ofTrack:[bgmAsset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:kCMTimeZero error:nil];
        
        AVMutableCompositionTrack *bgmAudio1 = [compostion addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
        if (bgmDurationSeconds*2 > audioDurationSeconds) {//如果bgm双倍合成大于录音时长，则取录音时长
            [bgmAudio1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(audioDurationSeconds-bgmDurationSeconds,bgmAsset.duration.timescale)) ofTrack:[bgmAsset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:bgmAsset.duration error:nil];
            
        }else{
            [bgmAudio1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(0,bgmAsset.duration.timescale)) ofTrack:[bgmAsset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:bgmAsset.duration error:nil];
        }
    }else{
        [bgmAudio insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[bgmAsset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:kCMTimeZero error:nil];
    }
    
    AVMutableCompositionTrack *audio = [compostion addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    [audio insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[audioAsset tracksWithMediaType:AVMediaTypeAudio].firstObject atTime:kCMTimeZero error:nil];
    
    NSString *_filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    _filePath = [_filePath stringByAppendingPathComponent:@"user"];
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([manage createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil])
    {
        _filePath = [_filePath stringByAppendingPathComponent:@"testAudio.aac"];
    }
    
    //修改背景音乐的音量，这个可以修改不同音轨的音量，实现不同音轨音频的音量不一样以及淡入淡出效果
    AVMutableAudioMix *videoAudioMixTools = [AVMutableAudioMix audioMix];
    NSMutableArray * params = [[NSMutableArray alloc] initWithCapacity:0];
    if (bgmAsset) {
        //调节音量
        //获取音频轨道
        AVMutableAudioMixInputParameters *firstAudioParam = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:bgmAudio];
        //设置音轨音量,可以设置渐变,设置为1.0就是全音量
        [firstAudioParam setVolumeRampFromStartVolume:0.2 toEndVolume:0.2 timeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)];
        [firstAudioParam setTrackID:bgmAudio.trackID];
        [params addObject:firstAudioParam];
    }
    
    videoAudioMixTools.inputParameters = [NSArray arrayWithArray:params];
    
    //合并音频
    AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:compostion presetName:AVAssetExportPresetAppleM4A];
    NSString *outPutFilePath = [[_filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Audio.m4a"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    __weak typeof(self) weakSelf = self;
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];
    session.outputFileType = @"com.apple.m4a-audio";
    session.shouldOptimizeForNetworkUse = YES;
    session.audioMix = videoAudioMixTools;
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //放在主线程中
                // 调用播放方法,这里已经合成完毕，可以上传到自己后台，也可以当地播放
                DRLog(@"合成位置%@",outPutFilePath);
                if (weakSelf.audioBlock) {
                    weakSelf.audioBlock(outPutFilePath, 0);
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                DRLog(@"输出错误");
                if (weakSelf.audioBlock) {
                    weakSelf.audioBlock(outPutFilePath, 1);
                }
            });
            
        }
    }];
}

- (void)audioPathAndBgmPath:(NSString *)audioPath bgmPath:(NSString *)bgmPath{
    AVURLAsset *audioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    AVURLAsset *bgmAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:bgmPath]];
    
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);//录音时长
    
    CMTime bgmDuration = bgmAsset.duration;//录音时长
    float bgmDurationSeconds = CMTimeGetSeconds(bgmDuration);//bgm时长
    
    if (bgmDurationSeconds > audioDurationSeconds){//bgm时长大于录音时长的时候开始合成
        [self recoderAudioPath:audioPath bgmPath:bgmPath isTuijian:NO];
    }else{//否则拼接bgm
        
    }
}

- (void)addAudio:(NSString*)fromPath toAudio:( NSString*)toPath isAddBgm:(BOOL)isAddBgm{
    // 1. 获取两个音频源
    AVURLAsset*audioAsset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:fromPath]];
    AVURLAsset*audioAsset2 = [ AVURLAsset assetWithURL:[NSURL fileURLWithPath:toPath]];
    
    // 2. 获取两个音频素材中的素材轨道
    AVAssetTrack*audioAssetTrack1 = [[audioAsset1 tracksWithMediaType: AVMediaTypeAudio] firstObject];
    AVAssetTrack*audioAssetTrack2 = [[audioAsset2 tracksWithMediaType: AVMediaTypeAudio] firstObject];

    
    // 3. 向音频合成器, 添加一个空的素材容器
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID: 0];
    
    // 4. 向素材容器中, 插入音轨素材
    [audioTrack insertTimeRange: CMTimeRangeMake(kCMTimeZero, audioAsset2.duration) ofTrack:audioAssetTrack2 atTime:kCMTimeZero error: nil];
    [audioTrack insertTimeRange: CMTimeRangeMake(kCMTimeZero, audioAsset1.duration) ofTrack:audioAssetTrack1 atTime:audioAsset2.duration error: nil];
    
    NSString *_filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    _filePath = [_filePath stringByAppendingPathComponent:@"user"];
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([manage createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil])
    {
        _filePath = [_filePath stringByAppendingPathComponent:@"testaddAudio.aac"];
    }
    
    NSString *outPutFilePath = [[_filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"addAudio.m4a"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    
    // 5. 根据合成器, 创建一个导出对象, 并设置导出参数
    AVAssetExportSession*session = [[AVAssetExportSession alloc] initWithAsset:composition presetName: AVAssetExportPresetAppleM4A];
    session.outputFileType = @"com.apple.m4a-audio";
    session.shouldOptimizeForNetworkUse = YES;
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];

    // 导出类型
    session.outputFileType = AVFileTypeAppleM4A;
    __weak typeof(self) weakSelf = self;
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //放在主线程中
                // 调用播放方法,这里已经合成完毕，可以上传到自己后台，也可以当地播放
                DRLog( @"导出成功，路径是：%@", outPutFilePath);
                if(isAddBgm){
                    return;
                }
                if (weakSelf.editAudioBlock && !isAddBgm) {
                    AVURLAsset*cutasset = [ AVURLAsset assetWithURL:[NSURL fileURLWithPath:outPutFilePath]];
                    weakSelf.editAudioBlock(outPutFilePath,[NSString stringWithFormat:@"%.f",CMTimeGetSeconds(cutasset.duration)], 0);
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                DRLog(@"输出错误");
                if(isAddBgm){
                    return;
                }
                if (weakSelf.editAudioBlock && !isAddBgm) {
                    weakSelf.editAudioBlock(outPutFilePath, @"0", 1);
                }
            });
        }
    }];
}

//头尾相接合并俩音频
- (void)addAudio:(NSString*)fromPath toAudio:( NSString*)toPath{
    [self addAudio:fromPath toAudio:toPath isAddBgm:NO];
}

- (void)cutAudio:(NSString*)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime{
  
    NSString *_filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    _filePath = [_filePath stringByAppendingPathComponent:@"user"];
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([manage createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil])
    {
        _filePath = [_filePath stringByAppendingPathComponent:@"testcutAudio.aac"];
    }
    
    if ([audioPath containsString:@"cutAudio.m4a"]) {//如果源文件和输出文件名称一样，则拷贝一份
        DRLog(@"存在一样的");
        NSString *timeS = [NoticeSaveVoiceTools getNowTmp];
        if ([NoticeSaveVoiceTools copyItemAtPath:audioPath toPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",timeS,[audioPath pathExtension]]]]) {
            audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[NoticeSaveVoiceTools getNowTmp],[audioPath pathExtension]]];
        }
    }

    // 1. 获取音频源
    AVURLAsset*asset = [ AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    NSString *outPutFilePath = [[_filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"cutAudio.m4a"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    
    // 2. 创建一个音频会话, 并且,设置相应的配置
    AVAssetExportSession*session = [AVAssetExportSession exportSessionWithAsset:asset presetName: AVAssetExportPresetAppleM4A];
    session.shouldOptimizeForNetworkUse = YES;
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];
    CMTime startTime = CMTimeMake(fromTime, 1);
    CMTime endTime = CMTimeMake(toTime < 1 ? CMTimeGetSeconds(asset.duration) : toTime, 1);
    session.timeRange = CMTimeRangeFromTimeToTime(startTime, endTime);
    //导出类型
    session.outputFileType = AVFileTypeAppleM4A;
    
    __weak typeof(self) weakSelf = self;
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //放在主线程中
                // 调用播放方法,这里已经合成完毕，可以上传到自己后台，也可以当地播放
//                DRLog( @"导出成功，路径是：%@", outPutFilePath);
//                if ([[NSFileManager defaultManager] fileExistsAtPath:audioPath])
//                {
//                    [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
//                }
                if (weakSelf.editAudioBlock) {
                    AVURLAsset*cutasset = [ AVURLAsset assetWithURL:[NSURL fileURLWithPath:outPutFilePath]];
                    weakSelf.editAudioBlock(outPutFilePath,[NSString stringWithFormat:@"%.f",CMTimeGetSeconds(cutasset.duration)], 0);
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                DRLog(@"输出错误");
                if (weakSelf.editAudioBlock) {
                    weakSelf.editAudioBlock(outPutFilePath, @"0", 1);
                }
            });
        }
    }];
}

- (void)getFirstAndLastAudio:(NSString *)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime{
    [self cut1:audioPath fromTime:fromTime toTime:toTime];
}

//获取切割的头部音频
- (void)cut1:(NSString*)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime{
    // 1. 获取音频源

    AVURLAsset*asset = [ AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];

    NSString *_filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    _filePath = [_filePath stringByAppendingPathComponent:@"user"];
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([manage createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil])
    {
        _filePath = [_filePath stringByAppendingPathComponent:@"testcutgetAudio.aac"];
    }
    
    NSString *outPutFilePath = [[_filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"cutgetAudio.m4a"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    
    // 2. 创建一个音频会话, 并且,设置相应的配置
    AVAssetExportSession*session = [AVAssetExportSession exportSessionWithAsset:asset presetName: AVAssetExportPresetAppleM4A];
    session.shouldOptimizeForNetworkUse = YES;
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];

    CMTime startTime = CMTimeMake(0, 1);
    CMTime endTime = CMTimeMake(fromTime, 1);//切割的前端音频终点为起点
    session.timeRange = CMTimeRangeFromTimeToTime(startTime, endTime);
    // 导出类型
    session.outputFileType = AVFileTypeAppleM4A;

    __weak typeof(self) weakSelf = self;
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //放在主线程中
                // 调用播放方法,这里已经合成完毕，可以上传到自己后台，也可以当地播放
                DRLog( @"导出成功切割1，路径是：%@", outPutFilePath);
       
                [weakSelf cut2:audioPath fromTime:fromTime toTime:toTime firstAudioPath:outPutFilePath];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.editAudioBlock) {
                    weakSelf.editAudioBlock(outPutFilePath, @"0", 1);
                }
            });
        }
    }];
}

//获取切割后的尾部音频
- (void)cut2:(NSString*)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime firstAudioPath:(NSString *)firstpath{
    // 1. 获取音频源

    AVURLAsset*asset = [ AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];

    NSString *_filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    _filePath = [_filePath stringByAppendingPathComponent:@"user"];
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([manage createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil])
    {
        _filePath = [_filePath stringByAppendingPathComponent:@"testcut1getAudio.aac"];
    }
    
    NSString *outPutFilePath = [[_filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"cut1getAudio.m4a"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
    }
    
    // 2. 创建一个音频会话, 并且,设置相应的配置
    AVAssetExportSession*session = [AVAssetExportSession exportSessionWithAsset:asset presetName: AVAssetExportPresetAppleM4A];
    session.shouldOptimizeForNetworkUse = YES;
    session.outputURL = [NSURL fileURLWithPath:outPutFilePath];

    CMTime startTime = CMTimeMake(toTime, 1);//切割的第二端音频起点为终点
    CMTime endTime = asset.duration;//切割的终点为最后时间
    session.timeRange = CMTimeRangeFromTimeToTime(startTime, endTime);
    // 导出类型
    session.outputFileType = AVFileTypeAppleM4A;
        
    __weak typeof(self) weakSelf = self;
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //放在主线程中
                // 调用播放方法,这里已经合成完毕，可以上传到自己后台，也可以当地播放
                DRLog( @"导出成功切割2，路径是：%@", outPutFilePath);
                [weakSelf addAudio:outPutFilePath toAudio:firstpath];
//                
//                if (weakSelf.editAudioBlock) {
//                    AVURLAsset*cutasset = [ AVURLAsset assetWithURL:[NSURL fileURLWithPath:outPutFilePath]];
//                    weakSelf.editAudioBlock(outPutFilePath,[NSString stringWithFormat:@"%.f",CMTimeGetSeconds(cutasset.duration)], 0);
//                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                DRLog(@"输出错误");
                if (weakSelf.editAudioBlock) {
                    weakSelf.editAudioBlock(outPutFilePath, @"0", 1);
                }
            });
        }
    }];
}
@end
