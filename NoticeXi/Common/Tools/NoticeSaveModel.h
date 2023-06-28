//
//  NoticeSaveModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeUserInfoModel.h"
#import "NoticeAreaModel.h"
#import "NoticeAbout.h"
#import "NoticeSaveLoginStory.h"
#import "NoticePaySaveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSaveModel : NSObject


/**
 退出登录清楚缓存
 */
+ (void)outLoginClearData;

/**
 用户信息缓存

 @param userInfo 用户模型
 */
+ (void)saveUserInfo:(NoticeUserInfoModel *)userInfo;

+ (void)savePayInfo:(NoticePaySaveModel *)payInfo;
+ (NoticePaySaveModel *)getPayInfo;
+ (void)clearPayInfo;
/**
 获取缓存用户信息

 @return 用户信息模型
 */
+ (NoticeUserInfoModel *)getUserInfo;


+ (void)saveLogin:(NoticeSaveLoginStory *)userInfo;

+ (NoticeSaveLoginStory *)getLoginInfo;

//保存封面页设置
+ (void)saveSetCenter:(NoticeAbout *)setM;
//获取封面页设置
+ (NoticeAbout *)getCenterSetM;
//缓存找寻模块用户信息
+ (void)saveFindUserInfo:(NoticeUserInfoModel *)userInfo;
//获取找寻模块用户信息
+ (NoticeUserInfoModel *)getFindUserInfo;
/**
 保存国家地区
 */
+(void)saveArea:(NoticeAreaModel *)area;
+(NoticeAreaModel *)getArea;

//判断性格
+ (BOOL)isNounE;

/**
 获取设备UUID

 @return UUID
 */
+(NSString *)getUUID;
+ (void)setUUIDIFNO;
/**
 获取当前版本号
 */
+ (NSString *)getVersion;

/**
 设备详情
 */
+ (NSString *)getDeviceInfo;


/**
 保存token
 */
+ (void)saveToken:(NSString *)token;
+ (NSString *)getToken;

//保存上一次刷新token时间
+ (void)saveLastRefresh:(NSString *)time;
+ (NSString *)getLastRefreshTime;
@end

NS_ASSUME_NONNULL_END
