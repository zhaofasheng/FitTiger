//
//  NoticeSaveModel.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSaveModel.h"
#import "UNNotificationsManager.h"
#import "TUICore.h"
#import "TUICallKit.h"
#import "TUILogin.h"
#import <ImSDK_Plus/ImSDK_Plus.h>
#import "NoticeCallView.h"
#import "TUICallingStatusManager.h"
static NSString *const kXGUserInfo = @"XGUserInfo";
static NSString *const kXGarea = @"XGArea";
static NSString *const KForUUID = @"KForUUID";
static NSString *const KFToken = @"KFToken";

@implementation NoticeSaveModel

+ (void)outLoginClearData{
    [NoticeTools changeThemeWith:@"whiteColor"];
    //退出登录，清楚当前用户所有闹钟
    if ([NoticeComTools getCloclSetModel]) {
        NoticeColockSetModel *setM = [NoticeComTools getCloclSetModel];
        setM.isOpen = @"0";
        [NoticeComTools saveClockModel:setM];
    }
    
 
    if ([NoticeSaveModel getUserInfo]){
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"logout" Accept:@"application/vnd.shengxi.v5.5.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            
        } fail:^(NSError * _Nullable error) {
            
        }];
    }
    [UNNotificationsManager removeNotificationWithIdentifer:@"shengxinaozhong"];
    [UNNotificationsManager removeAllNotification];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kXGUserInfo];
    [userDefaults removeObjectForKey:KFToken];
    [userDefaults removeObjectForKey:[NSString stringWithFormat:@"payinfo%@",[NoticeTools getuserId]]];
    [NoticeTools outLoginClearData];
    [userDefaults synchronize];
    

    
    //退出腾讯云登录
    [TUILogin logout:^{

    } fail:^(int code, NSString *msg) {

    }];
}

+ (void)savePayInfo:(NoticePaySaveModel *)payInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[payInfo mj_keyValues] forKey:[NSString stringWithFormat:@"payinfo%@",[NoticeTools getuserId]]];
    [userDefaults synchronize];
}

+ (NoticePaySaveModel *)getPayInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic  = [userDefaults objectForKey:[NSString stringWithFormat:@"payinfo%@",[NoticeTools getuserId]]];
    return [NoticePaySaveModel mj_objectWithKeyValues:userInfoDic];
}

+ (void)clearPayInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:[NSString stringWithFormat:@"payinfo%@",[NoticeTools getuserId]]];
}

+ (void)saveUserInfo:(NoticeUserInfoModel *)userInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[userInfo mj_keyValues] forKey:kXGUserInfo];
    [userDefaults synchronize];
}

+ (void)saveFindUserInfo:(NoticeUserInfoModel *)userInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[userInfo mj_keyValues] forKey:[NSString stringWithFormat:@"%@findKeyWordPeopleKeyinfo",[[NoticeSaveModel getUserInfo]user_id]]];
    [userDefaults synchronize];
}



+ (void)saveSetCenter:(NoticeAbout *)setM{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[setM mj_keyValues] forKey:[NSString stringWithFormat:@"%@SetCenterinfo",[[NoticeSaveModel getUserInfo]user_id]]];
    [userDefaults synchronize];
}

+ (NoticeAbout *)getCenterSetM{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic  = [userDefaults objectForKey:[NSString stringWithFormat:@"%@SetCenterinfo",[[NoticeSaveModel getUserInfo]user_id]]];
    return [NoticeAbout mj_objectWithKeyValues:userInfoDic];
}

+(NoticeUserInfoModel *)getFindUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic  = [userDefaults objectForKey:[NSString stringWithFormat:@"%@findKeyWordPeopleKeyinfo",[[NoticeSaveModel getUserInfo]user_id]]];
    return [NoticeUserInfoModel mj_objectWithKeyValues:userInfoDic];
}

+ (BOOL)isNounE{
    return [[NoticeSaveModel getUserInfo] isNounE];
}

+ (NoticeUserInfoModel *)getUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic  = [userDefaults objectForKey:kXGUserInfo];
    return [NoticeUserInfoModel mj_objectWithKeyValues:userInfoDic];
}


+ (void)saveLogin:(NoticeSaveLoginStory *)userInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[userInfo mj_keyValues] forKey:@"logininfo"];
    [userDefaults synchronize];
}

+ (NoticeSaveLoginStory *)getLoginInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic  = [userDefaults objectForKey:@"logininfo"];
    return [NoticeSaveLoginStory mj_objectWithKeyValues:userInfoDic];
}

+ (void)saveToken:(NSString *)token{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:KFToken];
    [userDefaults synchronize];
}
+ (NSString *)getToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userInfoDic  = [userDefaults objectForKey:KFToken];
    return userInfoDic;
}

+ (void)saveLastRefresh:(NSString *)time{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:time forKey:@"refreshTimesss"];
    [userDefaults synchronize];
}
+ (NSString *)getLastRefreshTime{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userInfoDic  = [userDefaults objectForKey:@"refreshTimesss"];
    return userInfoDic;
}

+ (void)saveArea:(NoticeAreaModel *)area{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[area mj_keyValues] forKey:kXGarea];
    [userDefaults synchronize];
}

+(NoticeAreaModel*)getArea{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic  = [userDefaults objectForKey:kXGarea];
    return [NoticeAreaModel mj_objectWithKeyValues:userInfoDic];
}

+ (NSString *)getUUID{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid  = [userDefaults objectForKey:KForUUID];
    if (!uuid && !uuid.length) {
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
        NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        NSMutableString *tmpResult = result.mutableCopy;
        // 去除“-”
        NSRange range = [tmpResult rangeOfString:@"-"];
        while (range.location != NSNotFound) {
            [tmpResult deleteCharactersInRange:range];
            range = [tmpResult rangeOfString:@"-"];
        }
        [userDefaults setObject:tmpResult forKey:KForUUID];
        [userDefaults synchronize];
    }
    if (!uuid && uuid.length < 6) {
        uuid = @"EAKFHDSLKGJSKDJGLDSJFLKDJFL";
    }
    return uuid;
}

+ (void)setUUIDIFNO{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid  = [userDefaults objectForKey:KForUUID];
    if (!uuid) {
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
        NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        NSMutableString *tmpResult = result.mutableCopy;
        // 去除“-”
        NSRange range = [tmpResult rangeOfString:@"-"];
        while (range.location != NSNotFound) {
            [tmpResult deleteCharactersInRange:range];
            range = [tmpResult rangeOfString:@"-"];
        }
        [userDefaults setObject:tmpResult forKey:KForUUID];
        [userDefaults synchronize];
    }
}


+ (NSString *)getVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSString *)getDeviceInfo{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    return [NSString stringWithFormat:@"%@/%@/%@",deviceName,phoneModel,phoneVersion];
}

@end
