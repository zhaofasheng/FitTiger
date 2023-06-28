//
//  DownloadAudioService.m
//  AudioSpectrumDemo
//
//  Created by li lei on 2021/3/25.
//  Copyright © 2021 adu. All rights reserved.
//

#import "DownloadAudioService.h"
#import "AFURLSessionManager.h"

// 日志
#ifdef DEBUG
#define DRLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define DRLog(...)
#endif

@implementation DownloadAudioService
+ (void)downloadAudioWithUrl:(NSString *)url
           saveDirectoryPath:(NSString *)directoryPath
                    fileName:(NSString *)fileName
                      finish:(FinishBlock )finishBlock
                      failed:(Failed)failed
{

    NSString *file_path = [directoryPath stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    DRLog(@"要保存的地址%@",file_path);
    /// 判断文件是否已经存在
    if ([fm fileExistsAtPath:file_path])
    {
        DRLog(@"已经存在%@",file_path);
        finishBlock(file_path);
    }
    /// 不存在时
    else
    {
        NSURL *URL = [NSURL URLWithString:url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //AFN3.0+基于封住URLSession的句柄
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        //请求
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        //下载Task操作
        NSURLSessionDownloadTask *_downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //进度
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                           
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [cachesPath stringByAppendingPathComponent:fileName];

            return [NSURL fileURLWithPath:path];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
            NSString *armFilePath = [filePath path];// 将NSURL转成NSString
            finishBlock(armFilePath);
            DRLog(@"完成的地址%@",filePath);
        }];
        [_downloadTask resume];
    }
}

@end
