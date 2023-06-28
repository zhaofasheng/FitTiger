//
//  NoticeSaveVoiceTools.h
//  NoticeXi
//
//  Created by li lei on 2019/5/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceSaveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSaveVoiceTools : NSObject

+ (void)saveVoiceArr:(NSArray *)arr;
+ (NSMutableArray *)getVoiceArrary;
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath;
+ (NSString *)getNowTmp;
+ (BOOL)removeItemAtPath:(NSString *)path;
+ (BOOL)clearTmpDirectory;
+ (NSString *)getTimeString;


+ (void)savehelpArr:(NSArray *)arr;
+ (NSMutableArray *)gethelpArrary;

+ (void)savebokeArr:(NSArray *)arr;
+ (NSMutableArray *)getbokepArrary;
@end

NS_ASSUME_NONNULL_END
