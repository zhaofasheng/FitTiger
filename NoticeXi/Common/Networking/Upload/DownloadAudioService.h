//
//  DownloadAudioService.h
//  AudioSpectrumDemo
//
//  Created by li lei on 2021/3/25.
//  Copyright © 2021 adu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^FinishBlock)(NSString *filePath);
typedef void(^Failed)(void);
@interface DownloadAudioService : NSObject
/*
 * url                  音频网址
 * directoryPath  存放的地址
 * fileName         要存的名字
 */
+ (void)downloadAudioWithUrl:(NSString *)url
           saveDirectoryPath:(NSString *)directoryPath
                    fileName:(NSString *)fileName
                      finish:(FinishBlock )finishBlock
                      failed:(Failed)failed;
@end

NS_ASSUME_NONNULL_END
