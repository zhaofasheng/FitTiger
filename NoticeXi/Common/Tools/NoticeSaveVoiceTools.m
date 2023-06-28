//
//  NoticeSaveVoiceTools.m
//  NoticeXi
//
//  Created by li lei on 2019/5/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSaveVoiceTools.h"


@implementation NoticeSaveVoiceTools

+ (void)saveVoiceArr:(NSArray *)arr{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeVoiceSaveModel * model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@NoticeLocalVoiceArrary",[NoticeTools getuserId]]];
    [dictArr writeToFile:fileName atomically:YES];
}


+ (NSMutableArray *)getVoiceArrary{
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@NoticeLocalVoiceArrary",[NoticeTools getuserId]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    for (NSDictionary *dic in models) {
        NoticeVoiceSaveModel *voiceM = [NoticeVoiceSaveModel mj_objectWithKeyValues:dic];
        voiceM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:voiceM.pathName];//文件地址是沙盒路径拼接文件名，因为更新的时候沙盒路径会变
        if (voiceM.img1Path) {
            voiceM.img1 = [path stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",voiceM.img1Path]];
        }
        if (voiceM.img2Path) {
            voiceM.img2 = [path stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",voiceM.img2Path]];
        }
        if (voiceM.img3Path) {
            voiceM.img3 = [path stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",voiceM.img3Path]];
        }
        [arrayDict addObject:voiceM];
    }
    return arrayDict;
}

+ (void)savehelpArr:(NSArray *)arr{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeVoiceSaveModel * model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@NoticeLocalhelpArrary",[NoticeTools getuserId]]];
    [dictArr writeToFile:fileName atomically:YES];
}


+ (NSMutableArray *)gethelpArrary{
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@NoticeLocalhelpArrary",[NoticeTools getuserId]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    for (NSDictionary *dic in models) {
        NoticeVoiceSaveModel *voiceM = [NoticeVoiceSaveModel mj_objectWithKeyValues:dic];
        if (voiceM.img1Path) {
            voiceM.img1 = [path stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",voiceM.img1Path]];
        }
        if (voiceM.img2Path) {
            voiceM.img2 = [path stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",voiceM.img2Path]];
        }
        if (voiceM.img3Path) {
            voiceM.img3 = [path stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",voiceM.img3Path]];
        }
        [arrayDict addObject:voiceM];
    }
    return arrayDict;
}

+ (void)savebokeArr:(NSArray *)arr{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeVoiceSaveModel * model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@NoticeLocalbokeArrary",[NoticeTools getuserId]]];
    [dictArr writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getbokepArrary{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@NoticeLocalbokeArrary",[NoticeTools getuserId]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    for (NSDictionary *dic in models) {
        NoticeVoiceSaveModel *voiceM = [NoticeVoiceSaveModel mj_objectWithKeyValues:dic];
        voiceM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:voiceM.pathName];//文件地址是沙盒路径拼接文件名，因为更新的时候沙盒路径会变
        if (voiceM.img1Path) {
            voiceM.img1 = [path stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",voiceM.img1Path]];
        }
        [arrayDict addObject:voiceM];
    }
    return arrayDict;
}


+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath{
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isExistsAtPath:path]) {
        [YZC_AlertView showViewWithTitleMessage:@"路径不存在"];
        return NO;
    }
    //获得目标文件的上级目录
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isExistsAtPath:toDirPath]) {
        // 创建复制路径
        if (![self createDirectoryAtPath:toDirPath error:nil]) {
            return NO;
        }
    }
    // 复制文件，如果不覆盖且文件已存在则会复制失败
    BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:nil];
    
    return isSuccess;
}

#pragma mark - 判断文件(夹)是否存在
+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//获取文件所在的文件夹路径
+ (NSString *)directoryAtPath:(NSString *)path {
    return [path stringByDeletingLastPathComponent];
}

//创建文件路径
+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    /* createDirectoryAtPath:withIntermediateDirectories:attributes:error:
     * 参数1：创建的文件夹的路径
     * 参数2：是否创建媒介的布尔值，一般为YES
     * 参数3: 属性，没有就置为nil
     * 参数4: 错误信息
     */
    BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    return isSuccess;
}

#pragma mark 清空Cashes文件夹
+ (BOOL)removeItemAtPath:(NSString *)path{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark 清空temp文件夹
+ (BOOL)clearTmpDirectory {
    NSArray *subFiles = [self listFilesInTmpDirectoryByDeep:NO];
    BOOL isSuccess = YES;
    
    for (NSString *file in subFiles) {
        NSString *absolutePath = [[self tmpDir] stringByAppendingPathComponent:file];
        isSuccess &= [self removeItemAtPath:absolutePath];
    }
    return isSuccess;
}

//遍历tmp目录
+ (NSArray *)listFilesInTmpDirectoryByDeep:(BOOL)deep {
    return [self listFilesInDirectoryAtPath:[self tmpDir] deep:deep];
}

#pragma mark - 遍历文件夹
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    }else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        }else {
            listArr = nil;
        }
    }
    return listArr;
}

+ (NSString *)cachesDir {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)tmpDir {
    return NSTemporaryDirectory();
}

+ (NSString *)getNowTmp{

    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *currentTimeString = [NSString stringWithFormat:@"%.f",currentTime];
    return currentTimeString;
}

+ (NSString *)getTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
@end
