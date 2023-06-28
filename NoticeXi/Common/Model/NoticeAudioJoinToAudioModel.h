//
//  NoticeAudioJoinToAudioModel.h
//  NoticeXi
//
//  Created by li lei on 2022/4/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface NoticeAudioJoinToAudioModel : NSObject

@property (nonatomic, strong) NSString *resouceAudioPath;//音频原始文件地址
@property (nonatomic, strong) NSString *resouceTime;//音频原始文件时长

@property (nonatomic, strong) void(^audioBlock)(NSString *currentAudioPath,NSInteger reuslt);//0成功，1合成失败  2。bgm无效无法播放

@property (nonatomic, strong) void(^editAudioBlock)(NSString *currentAudioPath,NSString *audioTimeL,NSInteger reuslt);//0成功，1合成失败  2。bgm无效无法播放

/// 合成音频
/// @param audioPath 录音文件地址
/// @param bgmPath 背景音乐地址
/// @param isTuiJian 是否是推荐
- (void)recoderAudioPath:(NSString *)audioPath bgmPath:(NSString *)bgmPath isTuijian:(BOOL)isTuiJian;


/// 拼接录音 追加某个音频在某个音频的后面
/// @param fromPath 前段音频路径
/// @param toPath 后段音频路径
- (void)addAudio:( NSString*)fromPath toAudio:( NSString*)toPath;


/// 剪切音频 这里是截取一段音频
/// @param audioPath 音频文件地址
/// @param fromTime 开始剪切时间
/// @param toTime 结束剪切时间点
- (void)cutAudio:( NSString*)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime;


/// 切隔音频，这里是切割开始时间-结束时间的音频，然后中间的音频切掉，头尾音频再拼接
/// @param audioPath 音频文件地址
/// @param fromTime 开始切割时间
/// @param toTime 结束切割时间
- (void)getFirstAndLastAudio:( NSString*)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime;

- (void)audioPathAndBgmPath:(NSString *)audioPath bgmPath:(NSString *)bgmPath;
@end

NS_ASSUME_NONNULL_END
