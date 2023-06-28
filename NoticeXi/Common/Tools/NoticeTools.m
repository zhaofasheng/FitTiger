//
//  NoticeTools.m
//  NoticeXi
//
//  Created by li lei on 2018/10/22.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "NoticeTopicModel.h"
#import <AdSupport/AdSupport.h>
#import "DDHAttributedMode.h"
#import "NoticePsyModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
#import "APAuthInfo.h"
#import "NoticeTeamChatModel.h"
NSString *const NewFeatureVersionKey = @"NewFeatureVersionKey";
#define FileHashDefaultChunkSizeForReadingData 1024*8

@interface CoreArchive : NSObject

/**
 *  保存普通字符串
 */
+ (void)setStr:(NSString *)str key:(NSString *)key;

/**
 *  读取
 */
+ (NSString *)strForKey:(NSString *)key;

@end

@implementation CoreArchive

// 保存普通对象
+ (void)setStr:(NSString *)str key:(NSString *)key{
    
    // 获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 保存
    [defaults setObject:str forKey:key];
    
    // 立即同步
    [defaults synchronize];
    
}

// 读取
+ (NSString *)strForKey:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=(NSString *)[defaults objectForKey:key];
    
    return str;
    
}

@end


@implementation NoticeTools


+(NSString *)getNowTimeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这一点对时间的处理很重要
    NSTimeZone*timeZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *dateNow = [NSDate date];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    return timeStamp;
}

+ (NSString *)getDaoishi:(NSString *)getTime{
    
    NSInteger times = getTime.intValue -  [NoticeTools getNowTimeStamp].intValue;
    
    NSString *hours = [NSString stringWithFormat:@"%02ld",times/3600];
    NSString *minss = [NSString stringWithFormat:@"%02ld",(times%3600)/60];
    NSString *sec = [NSString stringWithFormat:@"%02ld",times%60];
    return [NSString stringWithFormat:@"%@:%@:%@",hours,minss,sec];
}

+ (void)getWeChatsuccess:(SuccessGetBlock)success{

    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
    {
        return;
    }
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
        if (state == SSDKResponseStateSuccess)
         {
             if (!user.credential) {
                 return;
             }
             user.uid = [NSString stringWithFormat:@"%@",user.rawData[@"openid"]];
            
             [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat result:^(NSError *error) {
                 
             }];
             
             success(user.uid,1,user.nickname,user.icon);
             DRLog(@"%@",user.rawData);
         }
         else
         {
             [YZC_AlertView showViewWithTitleMessage:@"授权失败，请重试"];
         }
     }];
}

+ (void)getAlisuccess:(SuccessGetAliBlock)success{
    //生成 auth info 对象
    APAuthInfo *authInfo = [APAuthInfo new];
    authInfo.pid = @"2088141386296446";
    authInfo.appID = @"2021003133627311";
    authInfo.targetID = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    
    //auth type
    NSString *authType = @"AUTHACCOUNT";
    authInfo.authType = authType;
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    
    
    [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        DRLog(@"支付宝%@",resultDic);
        
        NoticeMJIDModel *model = [NoticeMJIDModel mj_objectWithKeyValues:resultDic];
        
        if (model.resultStatus.intValue==9000) {
            
            NSArray *array = [model.result componentsSeparatedByString:@"&"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *str in array) {
                NSArray *array =[str componentsSeparatedByString:@"="];
                dict[array.firstObject] = array.lastObject;
            }

            NoticeMJIDModel *resultM = [NoticeMJIDModel mj_objectWithKeyValues:dict];
            if (resultM.result_code.intValue==200) {
                success(resultM);
            }
        }else{
            [YZC_AlertView showViewWithTitleMessage:@"授权失败，请重试"];
        }
    }];
}

+(BOOL)isWhetherNoUrl:(NSString *)urlStr{
    if(urlStr == nil) {
        return NO;
    }
    NSString *url;
    if (urlStr.length>4 && [[urlStr substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = urlStr;
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

+ (NSArray*)getURLFromStr:(NSString *)string {
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
    options:NSRegularExpressionCaseInsensitive
    error:&error];

    NSArray *arrayOfAllMatches = [regex matchesInString:string
    options:0
    range:NSMakeRange(0, [string length])];

    //NSString *subStr;
    NSMutableArray *arr=[[NSMutableArray alloc] init];

    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch;
        substringForMatch = [string substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    return arr;
}

+ (void)saveTeamChatArr:(NSArray *)arr chatId:(NSString *)userId{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeTeamChatModel * model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeLocalTeamChatArrary%@",userId]];
    [dictArr writeToFile:fileName atomically:YES];
}


+ (NSMutableArray *)getTeamChatArrArrarychatId:(NSString *)userId{
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeLocalTeamChatArrary%@",userId]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in models) {
        NoticeTeamChatModel *chatM = [NoticeTeamChatModel mj_objectWithKeyValues:dic];
        if (chatM.content_type.intValue == 3) {
            chatM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:chatM.pathName];//文件地址是沙盒路径拼接文件名，因为更新的时候沙盒路径会变
            chatM.resource_url = chatM.voiceFilePath;
        }else if (chatM.content_type.intValue == 2) {
            chatM.imgUpPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:chatM.imagePath];
            chatM.resource_url = chatM.imgUpPath;
        }
        [arrayDict addObject:chatM];
    }
    return arrayDict;
}

+ (void)saveChatArr:(NSArray *)arr chatId:(NSString *)userId{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeChatSaveModel * model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeLocalChatArrary%@",userId]];
    [dictArr writeToFile:fileName atomically:YES];
}


+ (NSMutableArray *)getChatArrarychatId:(NSString *)userId{
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeLocalChatArrary%@",userId]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in models) {
        NoticeChatSaveModel *voiceM = [NoticeChatSaveModel mj_objectWithKeyValues:dic];
        if (voiceM.type.intValue == 1) {
            voiceM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:voiceM.pathName];//文件地址是沙盒路径拼接文件名，因为更新的时候沙盒路径会变
        }else{
            voiceM.imgUpPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:voiceM.imagePath];
        }
        [arrayDict addObject:voiceM];
    }
    return arrayDict;
}

+ (void)savehsChatArr:(NSArray *)arr chatId:(NSString *)userId{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeChatSaveModel * model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeLocalhsChatArrary%@",userId]];
    [dictArr writeToFile:fileName atomically:YES];
}


+ (NSMutableArray *)gethsChatArrarychatId:(NSString *)userId{
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeLocalhsChatArrary%@",userId]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in models) {
        NoticeChatSaveModel *voiceM = [NoticeChatSaveModel mj_objectWithKeyValues:dic];
        if (voiceM.type.intValue == 1) {
            voiceM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:voiceM.pathName];//文件地址是沙盒路径拼接文件名，因为更新的时候沙盒路径会变
        }else{
            voiceM.imgUpPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:voiceM.imagePath];
        }
        [arrayDict addObject:voiceM];
    }
    return arrayDict;
}

+ (void)saveGroupChatArr:(NSArray *)arr chatId:(NSString *)userId{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeChatSaveModel * model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeLocalGroupChatArrary%@",userId]];
    [dictArr writeToFile:fileName atomically:YES];
}


+ (NSMutableArray *)getGroupChatArrarychatId:(NSString *)userId{
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeLocalGroupChatArrary%@",userId]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in models) {
        NoticeChatSaveModel *voiceM = [NoticeChatSaveModel mj_objectWithKeyValues:dic];
        if (voiceM.type.intValue == 3) {
            voiceM.voiceFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject] stringByAppendingPathComponent:voiceM.pathName];//文件地址是沙盒路径拼接文件名，因为更新的时候沙盒路径会变
        }else if(voiceM.type.intValue == 2){
            voiceM.imgUpPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:voiceM.imagePath];
        }
        [arrayDict addObject:voiceM];
    }
    return arrayDict;
}

+ (UIColor *)colorWith:(NSString *)colorHex{
    return [UIColor colorWithHexString:colorHex];
}

+ (BOOL)isManager{
    
    NSArray *managerArr = @[@"1",@"5461",@"6100",@"20550",@"32335",@"373682"];
    for (NSString *managerUserId in managerArr) {
        if ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:managerUserId]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isFirstLogininOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"login%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForlogin{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"login%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstDrawOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"draw%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForDraw{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"draw%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstTcOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"tc%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForTc{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"tc%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstOpenClock{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"openClock%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForOpenClock{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"openClock%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstDrawOnThisDeveicetuya{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"drawtuya%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForDrawtuya{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"drawtuya%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (NSString *)getBeiJingTimeWithFormort:(NSString *)formort{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = formort; //@"yyyy-MM-dd";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatDay setTimeZone:timeZone];
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
}

+ (NSString *)getuserId{
    return [[NoticeSaveModel getUserInfo] user_id];
}

+ (NSString *)convertToJsonData:(NSMutableArray *)arr{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (void)setneedConnect:(BOOL)need{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:need ? @"1":@"0" forKey:@"isneedconnect"];
    [cache synchronize];
}
+ (BOOL)needConnect{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
  
    if ([[cache objectForKey:@"isneedconnect"] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)saveYunxinId:(NSString *)yunxinId{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:yunxinId forKey:[NSString stringWithFormat:@"%@yunxinId",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (NSString *)getYunxinId{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    return [cache objectForKey:[NSString stringWithFormat:@"%@yunxinId",[[NoticeSaveModel getUserInfo]user_id]]];
}

+ (void)saveNewTime{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    [cache setObject:[NSString stringWithFormat:@"%.f",currentTime] forKey:[NSString stringWithFormat:@"%@clockVoiceNotice",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (NSString *)getLastTime{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    return [cache objectForKey:[NSString stringWithFormat:@"%@clockVoiceNotice",[[NoticeSaveModel getUserInfo]user_id]]];
}

+ (NSString *)getIDFA{
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return [DDHAttributedMode md5:timeSp];
}


+(NSString *)getNowTimeTimestamp{
    
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
 
    return [NSString stringWithFormat:@"%.f",currentTime];
    
}

+ (void)savePlayType:(NSString *)type{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:type forKey:[NSString stringWithFormat:@"playType%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (NSString *)getPlayType{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    NSString *str = [cache objectForKey:[NSString stringWithFormat:@"playType%@",[[NoticeSaveModel getUserInfo] user_id]]];
    
    return str;
}

+ (BOOL)isFirstLoginOnThisDeveiceForSX{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"click%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
    
}

+ (void)setMarkForClick{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"click%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isAutoPlayer{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"autoPlayer%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSInteger)voiceType{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return 0;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"voiceType%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return 1;
    }else if([[cache objectForKey:[NSString stringWithFormat:@"voiceType%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"2"]){
        return 2;
    }else{
        return 0;
    }
}

+ (void)setVoiceType:(NSString *)type{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:type forKey:[NSString stringWithFormat:@"voiceType%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (NSInteger)voicePlayRate{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return 0;
    }
    return [[cache objectForKey:[NSString stringWithFormat:@"voicePlayRate%@",[[NoticeSaveModel getUserInfo] user_id]]] intValue];
}

+ (void)voicePlayRate:(NSString *)type{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:type forKey:[NSString stringWithFormat:@"voicePlayRate%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (void)setAutoPlayer:(NSString *)autoStr{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:autoStr forKey:[NSString stringWithFormat:@"autoPlayer%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (NSInteger)isFirstShowRoom{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return 0;
    }
    if (![[cache objectForKey:[NSString stringWithFormat:@"showroom%@",[[NoticeSaveModel getUserInfo] user_id]]] intValue]) {
        return 0;
    }
    return [[cache objectForKey:[NSString stringWithFormat:@"showroom%@",[[NoticeSaveModel getUserInfo] user_id]]] intValue];
}

+ (void)setFirstShowRoom:(NSString *)autoStr{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:autoStr forKey:[NSString stringWithFormat:@"showroom%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (NSInteger)Showpic{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"showpic%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return 1;
    }else if ([[cache objectForKey:[NSString stringWithFormat:@"showpic%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"2"]) {
        return 2;
    }else{
        return 0;
    }
}

+ (void)setFirstShowpic:(NSString *)autoStr{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:autoStr forKey:[NSString stringWithFormat:@"showpic%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)Showpic1{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"showpic1%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)setFirstShowpic1{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"showpic1%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)Showpic2{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"showpic2%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)setFirstShowpic2{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"showpic2%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstShowmh{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"showmh%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setFirstShowmh{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"showmh%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstCloseAutoPlayer{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"closeautoPlayer%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setIsFirstAutoPlayer{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"closeautoPlayer%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstCloseVoiceShow{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"closeVoiceShow%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setIsFirstCloseVoiceShow{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"closeVoiceShow%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstClosetextShow{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"closetextShow%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setIsFirstClosetextShow{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"closetextShow%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}


+ (BOOL)isFirstOpenAutoPlayer{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"openautoPlayer%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setIsFirstOpenAutoPlayer{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"openautoPlayer%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstLoginOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[[NoticeSaveModel getUserInfo] user_id]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)isFirstinThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickCenter%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkOfincenter{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickCenter%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstinclickTUYACenter{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickTUYACenter%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkclickTUYACenter{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickTUYACenter%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}


+ (BOOL)isFirstinThisDeveiceMain{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickCenterMain%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkOfincenterMain{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickCenterMain%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isKnowSendMovie{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendmoive%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setKnowSendMovie{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendmoive%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isKnowSendBook{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendbook%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setKnowSendBook{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendbook%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isKnowSendSong{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendsong%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}
+ (void)setKnowSendSong{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendsong%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstinThisDeveiceWorld{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickCenterWorld%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)isFirstchangeimgOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickimg%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setimgForZj{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickimg%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirsttextOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"clicktext%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setsendFortext{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clicktext%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (void)setMarkOfincenterWorld{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickCenterWorld%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstinThisDeveiceThirdVC{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickCenterWorld1%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)isHidePlayThisDeveiceThirdVC{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"hideplay%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)setHidePlay:(NSString *)status{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:status forKey:[NSString stringWithFormat:@"hideplay%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (void)setMarkOfincenterThirdVC{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickCenterWorld1%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstinThisDeveiceMainClock{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickCenterMainClock%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkOfincenterMainClock{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickCenterMainClock%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (void)setMarkOfLogin{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[[NoticeSaveModel getUserInfo] user_id]];
    [cache synchronize];
}

+ (void)saveNeedSecondCheckForLogin:(NSString *)need{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:need forKey:[NSString stringWithFormat:@"secondCheck%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)needSecondCheckForLogin{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"secondCheck%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isFirstLoginOnThisDeveicesub{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickdianliang%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)isFirstLoginOnThisDeveicesubHasPlay{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return YES;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"clickdianliangplay%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)setMarkOfLoginsubPlay{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickdianliangplay%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (void)setMarkOfLoginsub{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"clickdianliang%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstSendOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"send%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForSend{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"send%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstbgmOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendbgm%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForbgmSend{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendbgm%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstworldOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendworld%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForworldSend{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendworld%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstsameOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendsameworld%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForsameSend{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendsameworld%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstownOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendown%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForownSend{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendown%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}



+ (BOOL)isTextOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendtext%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForTextSend{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendtext%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}


+ (NSInteger)getFastButton{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"fastbtn%@",[[NoticeSaveModel getUserInfo] user_id]]] intValue]) {
        return [[cache objectForKey:[NSString stringWithFormat:@"fastbtn%@",[[NoticeSaveModel getUserInfo] user_id]]] intValue];
    }else{
        return 0;
    }
}

+ (void)setfastButtonWith:(NSInteger)type{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:[NSString stringWithFormat:@"%ld",type] forKey:[NSString stringWithFormat:@"fastbtn%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstdeleteZJOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"deleteZJ%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkFordeleteZJ{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"deleteZJ%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstknowdhZJOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"knowdhZJ%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForknowdhZJ{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"knowdhZJ%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstknowdhdeledhOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"deledh%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}



+ (void)setMarkForknowdeledh{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"deledh%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (BOOL)isFirstknowpeiypinglOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"peiypingl%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setMarkForknowpeiypingl{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"peiypingl%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}


+ (void)setMarkForSendMovie{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
      [cache setObject:@"1" forKey:[NSString stringWithFormat:@"sendMovie%@",[[NoticeSaveModel getUserInfo] user_id]]];
      [cache synchronize];
}

+ (BOOL)isFirstSendMovieOnThisDeveice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (![[NoticeSaveModel getUserInfo] user_id]) {
        return NO;
    }
    if ([[cache objectForKey:[NSString stringWithFormat:@"sendMovie%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL)hudongisOpen{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];

    if ([[cache objectForKey:[NSString stringWithFormat:@"hudong%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"1"]) {
        return YES;
    }else if ([[cache objectForKey:[NSString stringWithFormat:@"hudong%@",[[NoticeSaveModel getUserInfo] user_id]]] isEqualToString:@"0"]){
        return NO;
    }
    else{
        return YES;
    }
}

+ (void)setHUDONG:(NSString *)status{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:status forKey:[NSString stringWithFormat:@"hudong%@",[[NoticeSaveModel getUserInfo] user_id]]];
    [cache synchronize];
}

+ (void)saveSessionWith:(NoticeSaveName *)usrM{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if (usrM.name) {
      [cache setObject:usrM.name forKey:[NSString stringWithFormat:@"sx-%@",usrM.sessionId]];
    }
    [cache synchronize];
}

+ (NSString *)getUserNameWith:(NSString *)sessionId{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
  
    return [cache objectForKey:[NSString stringWithFormat:@"sx-%@",sessionId]];
}

+ (void)removeNameWith:(NSString *)sessionId{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache removeObjectForKey:[NSString stringWithFormat:@"sx-%@",sessionId]];
    [cache synchronize];
}

+ (NSArray *)arraryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)arrayToJSONString:(NSMutableArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)convertDictToJsonData:(NSDictionary *)dict{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (BOOL)hasDefaultTheme{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *theme  = [userDefaults objectForKey:@"themeColor"];
    if (theme == nil || (!theme.length)) {//防止无法读取
        return NO;
    }
    return YES;
}

+ (void)changeThemeWith:(NSString *)theme{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:theme forKey:@"themeColor"];
    [userDefaults synchronize];
}

+ (BOOL)isWhiteTheme{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *theme  = [userDefaults objectForKey:@"themeColor"];
    if ([theme isEqualToString:@"whiteColor"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getTextWithSim:(NSString *)simText fantText:(NSString *)fantText{
    if ([NoticeTools isSimpleLau]) {
        return simText;
    }
    return fantText;
}

+ (UIColor *)getWhiteColor:(NSString *)whiteColor NightColor:(NSString *)nightColor{
    return [UIColor colorWithHexString:[NoticeTools isWhiteTheme]? whiteColor:nightColor];
}

+ (NSString *)getThemeColorWithKey:(NSString *)key{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"whiteColor" ofType:@"plist"];
    NSDictionary *colorDict =[NSDictionary dictionaryWithContentsOfFile:path];//获取plist字典
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];//获取保存的主题字段
    NSString *theme  = [userDefaults objectForKey:@"themeColor"];
    if (theme == nil || (!theme.length)) {//防止无法读取
        theme = @"whiteColor";
    }
    
    NSDictionary *themeDict= [colorDict objectForKey:theme];//获取主题字典
    
    return [themeDict objectForKey:key];//获取主题颜色
}

+ (NSString *)getThemeImageNameWithKey:(NSString *)key{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"whiteColor" ofType:@"plist"];
    NSDictionary *colorDict =[NSDictionary dictionaryWithContentsOfFile:path];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *theme  = [userDefaults objectForKey:@"themeColor"];
    if (theme == nil || (!theme.length)) {//防止无法读取
        theme = @"whiteColor";
    }
    if ([theme isEqualToString:@"whiteColor"]) {
       NSDictionary *themeDict= [colorDict objectForKey:@"whiteButtonName"];//获取主题字典
       return [themeDict objectForKey:key];//获取主题颜色
    }
    NSDictionary *themeDict= [colorDict objectForKey:@"nightButtonName"];//获取主题字典
    return [themeDict objectForKey:key];//获取主题颜色
}

+ (NSString *)getLocalStrWith:(NSString *)key{

    //zh-Hans >  zh-Hans
    //en  > en
    //ja > ja
    // 获得 iPhone 当前的语言设置
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *curLanguage = [languages objectAtIndex:0];
  
    if ([curLanguage containsString:@"zh-Hans"]){
        return [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",@"zh-Hans"] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"InfoPlist"];
    }if ([curLanguage containsString:@"ja"]){
        return [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",@"ja"] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"InfoPlist"];
    }
    else{
        return [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",@"en"] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"InfoPlist"];
    }
    
}

+ (NSInteger)getLocalType{

    NSArray *languages = [NSLocale preferredLanguages];
    NSString *curLanguage = [languages objectAtIndex:0];
  
    if ([curLanguage containsString:@"en"]) {//英文
        return 1;
    }else if ([curLanguage containsString:@"ja"]){//日语
        return 2;
    }else{
        return 0;
    }
}
+ (NSString *)chinese:(NSString *)chinese english:(NSString *)english japan:(NSString *)japan{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *curLanguage = [languages objectAtIndex:0];
  
    if ([curLanguage containsString:@"en"]) {//英文
        return english;
    }else if ([curLanguage containsString:@"ja"]){//日语
        return japan;
    }else{
        return chinese;
    }
}

+ (NSString *)getLocalImageNameCN:(NSString *)cn{

    NSArray *languages = [NSLocale preferredLanguages];
    NSString *curLanguage = [languages objectAtIndex:0];
  
    if ([curLanguage containsString:@"en"]) {//英文
        return [NSString stringWithFormat:@"%@en",cn];
    }else if ([curLanguage containsString:@"ja"]){//日语
        return [NSString stringWithFormat:@"%@ja",cn];
    }else{
        return cn;
    }
}

+ (void)setLangue{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]) {
        //设置默认为简体中文
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
    }
}

+ (void)setVoiceOpen:(BOOL)open{
    
    NSString *str = nil;
    if (open) {
        str = @"open";
    }else{
        str = @"close";
    }
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"openVoice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isOpen{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"openVoice"] isEqualToString:@"close"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setVoiceOpenVoice{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"openVoiceFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isOpenVoice{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"openVoiceFirst"] isEqualToString:@"1"]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)setCotentVoiceOpen:(BOOL)open{
    
    NSString *str = nil;
    if (open) {
        str = @"open";
    }else{
        str = @"close";
    }
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:[NSString stringWithFormat:@"openVoiceContent%@",[NoticeTools getuserId]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isCotentOpen{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"openVoiceContent%@",[NoticeTools getuserId]]] isEqualToString:@"open"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)changeToSimple{
    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)changeToTaiwan{
    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant-TW" forKey:@"appLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isSimpleLau{
    return YES;
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"] isEqualToString:@"zh-Hans"]) {
//        return YES;
//    }else{
//        return NO;
//    }
}

+ (void)saveType:(NSInteger)type{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:[NSString stringWithFormat:@"watchtype%@",[[NoticeSaveModel getUserInfo]user_id]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)getType{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"watchtype%@",[[NoticeSaveModel getUserInfo]user_id]]]) {
        return 0;
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"watchtype%@",[[NoticeSaveModel getUserInfo]user_id]]] integerValue];
}

+ (void)savePushStatus:(NSString *)status{
    [[NSUserDefaults standardUserDefaults] setObject:status forKey:@"pushStauts"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getPushStatus{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"pushStauts"] integerValue]) {
        return YES;
    }
    return NO;
}

+ (void)saveChatPushStatus:(NSString *)status{
    [[NSUserDefaults standardUserDefaults] setObject:status forKey:@"ChatPushStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)saveSysTime:(NSString *)time{
    if (!time) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"saveSysTime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getSusTime{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysTime"] integerValue]? [NoticeTools updateTimeForRow:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysTime"]] : @"";
}

+ (void)setSHAKE:(BOOL)need{
    [[NSUserDefaults standardUserDefaults] setObject:need? @"1":@"0" forKey:@"needShake"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)needShake{
   NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"needShake"];
    if ([str isEqualToString:@"1"] || [str isEqualToString:@"0"]) {
        if ([str isEqualToString:@"1"]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        [NoticeTools setSHAKE:YES];
        return YES;
    }
}

+ (void)saveGroupTitle:(NSString *)title assocId:(NSString *)assocId{
    if (!title || !assocId) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:[NSString stringWithFormat:@"saveGroup%@%@",[NoticeTools getuserId],assocId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getGroupTitleWithAssocId:(NSString *)assocId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"saveGroup%@%@",[NoticeTools getuserId],assocId]] ? [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"saveGroup%@%@",[NoticeTools getuserId],assocId]] : @"";
}

+ (void)saveBookTitle:(NSString *)title{
    if (!title) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"saveSysBook"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getBookTitle{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysBook"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysBook"] : @"";
}

+ (void)saveBookTime:(NSString *)time{
    if (!time) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"savebookTime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getBookTime{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"savebookTime"] integerValue]? [NoticeTools updateTimeForRow:[[NSUserDefaults standardUserDefaults] objectForKey:@"savebookTime"]] : @"";
}

+ (void)saveSysTitle:(NSString *)title{
    if (!title) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"saveSysTitle"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getSysTitle{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysTitle"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysTitle"] : @"";
}

+ (void)savefriendTime:(NSString *)time{
    if (!time) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"savefriendTime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getfriendTime{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"savefriendTime"] integerValue]? [NoticeTools updateTimeForRow:[[NSUserDefaults standardUserDefaults] objectForKey:@"savefriendTime"]] : @"";
}

+ (void)saveSysfriend:(NSString *)title{
    if (!title) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"saveSysfriend"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getSysfriend{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysfriend"] isEqualToString:@"请求添加你为学友"]) {
        return GETTEXTWITE(@"stay.newsd");
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysfriend"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"saveSysfriend"] : @"";
}
+(NSString *)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return [str
            stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet
                                                                URLFragmentAllowedCharacterSet]];
        }
    }
    return str;
}

+ (void)saveassocTime:(NSString *)time{
    if (!time) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"saveassocTime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getassocTime{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveassocTime"] integerValue]? [NoticeTools updateTimeForRow:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveassocTime"]] : @"";
}

+ (void)saveassocTitle:(NSString *)title{
    if (!title) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"saveassocTitle"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getassocTitle{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"saveassocTitle"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"saveassocTitle"] : @"";
}


+ (void)saveotherTime:(NSString *)time{
    if (!time) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"saveotherTime"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getotherTime{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"saveotherTime"] integerValue]? [NoticeTools updateTimeForRow:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveotherTime"]] : @"";
}

+ (void)saveotherTitle:(NSString *)title{
    if (!title) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"saveotherTitle"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getotherTitle{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"saveotherTitle"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"saveotherTitle"] : @"";
}

+ (void)outLoginClearData{
    NSUserDefaults *defatu = [NSUserDefaults standardUserDefaults];
    [defatu removeObjectForKey:@"saveotherTitle"];
    [defatu removeObjectForKey:@"saveotherTime"];
    [defatu removeObjectForKey:@"saveSysfriend"];
    [defatu removeObjectForKey:@"savefriendTime"];
    [defatu removeObjectForKey:@"saveSysTitle"];
    [defatu removeObjectForKey:@"saveSysTime"];
}

+(CGFloat)getHeightWithLineHight:(CGFloat)lineHeight font:(CGFloat)font width:(CGFloat)width string:(NSString *)string{
    if (!string) {
        return 0;
    }
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineHeight];
    [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,string.length)];
    CGRect sizestring = [string boundingRectWithSize:CGSizeMake(width,9999999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    return sizestring.size.height;
}

+ (NSMutableAttributedString *)getStringWithLineHight:(CGFloat)lineHeight string:(NSString *)string{
    if (!string) {
        return nil;
    }
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineHeight];
    [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,string.length)];
    return string1;
}

// 显示了版本新特性，保存版本号
+ (void)saveVersion{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    //保存版本号
    [CoreArchive setStr:versionValueStringForSystemNow key:NewFeatureVersionKey];
    
}

+ (BOOL)CanShowLeader{
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    //读取本地版本号
    NSString *versionLocal = [CoreArchive strForKey:NewFeatureVersionKey];
    
    if(versionLocal!=nil && [versionValueStringForSystemNow isEqualToString:versionLocal]){//说明有本地版本记录，且和当前系统版本一致
        
        return NO;
        
    }else{ // 无本地版本记录或本地版本记录与当前系统版本不一致
        
        //保存
        //[CoreArchive setStr:versionValueStringForSystemNow key:NewFeatureVersionKey];
        
        return YES;
    }
}

+ (BOOL)isSameDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    
    if ([currentTimeString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"checkTheTimeThatIsFirstOpenApp"]]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)saveNowDateWithYYYYmmDD{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];

    NSDate *datenow = [NSDate date];

    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentTimeString forKey:@"checkTheTimeThatIsFirstOpenApp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 返回时间格式
 appointStr: 指定的时间格式
 */
+ (NSString *)timeDataAppointFormatterWithTime:(NSInteger)timeInterval appointStr:(NSString *)appointStr {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:appointStr];
    NSString *str = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return str;
}

//判断时间是今天，昨天
+ (NSString *)checkTheDate:(NSInteger)timeInterval{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    NSDate *date = [outputFormatter dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    if(isToday) {
        return  [NSString stringWithFormat:@"今天"];
    }else if (isYesterday){
       
        return [NoticeTools getLocalStrWith:@"em.zt"];
    }
    return string;
}

+(NSString *)updateTimeForRowNear:(NSString *)str {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime =[str floatValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    //秒转分钟
    NSInteger small = time / 60;
    if(small == 0) {
        return [NoticeTools getLocalStrWith:@"group.now"];
        
    }
    if(small < 60) {
        return [NSString stringWithFormat:@"%ld%@",(long)small,[NoticeTools getLocalStrWith:@"group.hour"]];
        
    }
    // 秒转小时
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    NSDate *date = [outputFormatter dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    NSInteger hours = time/3600;
    if (hours >3 && isToday) {
        return [NoticeTools getLocalStrWith:@"minee.today"];
        
    }
    
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    if (isYesterday) {
        return [NoticeTools getLocalStrWith:@"em.zt"];
    }
    
    if (hours<3 && hours > 1) {
        return [NSString stringWithFormat:@"%ld%@",(long)hours,[NoticeTools getLocalStrWith:@"group.hour"]];
        
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 3) {
        if (days == 1) {
            return [NoticeTools getLocalStrWith:@"em.zt"];
        }
        if (days == 2) {
            return @"前天";
        }
    }
    return @"3天前";
}

+ (NSString *)updateTimeForRow:(NSString *)createTimeString{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime =[createTimeString floatValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    //秒转分钟
    NSInteger small = time / 60;
    if(small <= 0) {
        return [NoticeTools getLocalStrWith:@"group.now"];
        
    }
    if(small < 60) {
        return [NSString stringWithFormat:@"%ld%@",(long)small >0?(long)small:1,[NoticeTools getLocalStrWith:@"group.time"]];
        
    }

    // 秒转小时
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    NSDate *date = [outputFormatter dateFromString:string];
    

    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    if (isYesterday) {
        return [NoticeTools getLocalStrWith:@"em.zt"];
    }
    
    NSInteger hours = time/3600;
    //BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    if (hours >=1 && hours <= 24) {
        return [NSString stringWithFormat:@"%ld%@",(long)hours,[NoticeTools getLocalStrWith:@"group.hour"]];
        
    }
    
    NSDateFormatter *tFormatter = [[NSDateFormatter alloc] init];
    [tFormatter setLocale:[NSLocale currentLocale]];
    [tFormatter setDateFormat:@"yyyy"];
    
    if ([[NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]] isEqualToString:[NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]]]]) {
        [tFormatter setDateFormat:@"MM-dd HH:mm:SS"];
        return [NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]];
    }
    [tFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    return [NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]];
}

+ (NSString *)getDayFromNow:(NSString *)createTimeString{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
   // NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [createTimeString longLongValue];
    // 时间差
    //NSTimeInterval time = currentTime - createTime;
    // 秒转小时
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    NSDate *date = [outputFormatter dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    if (isToday) {
        return  [NoticeTools getLocalStrWith:@"minee.today"];
    }
    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    if (isYesterday) {
        return [NoticeTools getLocalStrWith:@"em.zt"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *dateDay = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    return dateDay;
}

+ (NSString *)getHourFormNow:(NSString *)createTimeString{
    NSTimeInterval createTime = [createTimeString longLongValue];
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setLocale:[NSLocale currentLocale]];
    [hourFormatter setDateFormat:@"HH"];
    NSString *hourstring = [hourFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    
    NSDateFormatter *minFormatter = [[NSDateFormatter alloc] init];
    [minFormatter setLocale:[NSLocale currentLocale]];
    [minFormatter setDateFormat:@"mm"];
    NSString *min = [minFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    return [NSString stringWithFormat:@"%ld-%@",(long)hourstring.integerValue,min];
}

+ (NSString *)updateTimeForRowWorld:(NSString *)str{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime =[str floatValue];
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    //秒转分钟
    NSInteger small = time / 60;
    if(small == 0) {
        return [NoticeTools getLocalStrWith:@"group.now"];
        
    }
    if(small < 60) {
        return [NSString stringWithFormat:@"%@%ld%@",[NoticeTools getLocalStrWith:@"em.sentat"],(long)small,[NoticeTools getLocalStrWith:@"group.time"]];
        
    }
    // 秒转小时
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    NSDate *date = [outputFormatter dateFromString:string];
    

    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    if (isYesterday) {
        return [NoticeTools getLocalType]?@"Post yesterday": @"发布于昨天";
    }
    
    NSInteger hours = time/3600;
    //BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    if (hours >=1 && hours <= 24) {
        return [NSString stringWithFormat:@"%@%ld%@",[NoticeTools getLocalStrWith:@"em.sentat"],(long)hours,[NoticeTools getLocalStrWith:@"group.hour"]];
        
    }
    
    NSDateFormatter *tFormatter = [[NSDateFormatter alloc] init];
    [tFormatter setLocale:[NSLocale currentLocale]];
    [tFormatter setDateFormat:@"MM-dd"];
    return [NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"em.sentat"],[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]];
}

+ (NSString *)updateTimeForRowVoice:(NSString *)str{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = str.integerValue;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    //秒转分钟
    NSInteger small = time / 60;
    if(small == 0) {
        return [NoticeTools getLocalStrWith:@"group.now"];
        
    }
    if(small < 60) {
        return [NSString stringWithFormat:@"%ld%@",(long)small,[NoticeTools getLocalStrWith:@"group.time"]];
        
    }
    // 秒转小时
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]];
    NSDate *date = [outputFormatter dateFromString:string];
    

    BOOL isYesterday = [[NSCalendar currentCalendar] isDateInYesterday:date];
    
    if (isYesterday) {
        return [NoticeTools getLocalType]?@"yesterday": @"昨天";
    }
    
    NSInteger hours = time/3600;
    //BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    if (hours >=1 && hours <= 24) {
        return [NSString stringWithFormat:@"%ld%@",(long)hours,[NoticeTools getLocalStrWith:@"group.hour"]];
    }
    
    NSDateFormatter *tFormatter = [[NSDateFormatter alloc] init];
    [tFormatter setLocale:[NSLocale currentLocale]];
    [tFormatter setDateFormat:@"yyyy"];
    
    if ([[NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]] isEqualToString:[NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]]]]) {
        [tFormatter setDateFormat:@"MM-dd HH:mm:SS"];
        return [NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]];
    }
    [tFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    return [NSString stringWithFormat:@"%@",[tFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:createTime]]];
}

+ (void)setImageIfSameUrl{
//    SDWebImageDownloader *imgDownloader = SDWebImageDownloader.sharedDownloader;
//    
//    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
//        
//        NSFileManager *fm = [[NSFileManager alloc] init];
//        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
//        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
//        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
//        
//        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
//        
//        NSDate *lastModifiedDate = nil;
//        
//        if (fileAttr.count > 0) {
//            if (fileAttr.count > 0) {
//                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
//            }
//        }
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
//        
//        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
//        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
//        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
//        
//        return mutableHeaders;
//    };
}

+ (void)saveMoveArr:(NSArray *)arrary{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeTopicModel * model in arrary) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeMovieTopicArrary"];
    [dictArr writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getMovieArr{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeMovieTopicArrary"];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeTopicModel *topic = [NoticeTopicModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }
    
    return arrayDict;
}

+ (void)saveBookArr:(NSArray *)arrary{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeTopicModel * model in arrary) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeBookTopicArrary"];
    [dictArr writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getBookArr{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeBookTopicArrary"];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeTopicModel *topic = [NoticeTopicModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }
    
    return arrayDict;
}

+ (void)saveSongArr:(NSArray *)arrary{
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeTopicModel * model in arrary) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeSongTopicArrary"];
    [dictArr writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getSongArr{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeSongTopicArrary"];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeTopicModel *topic = [NoticeTopicModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }
    
    return arrayDict;
}

+ (void)saveTopicArr:(NSArray *)arrary{
   
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeTopicModel * model in arrary) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeTopicArrary"];
    [dictArr writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getTopicArr{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeTopicArrary"];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeTopicModel *topic = [NoticeTopicModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }

    return arrayDict;
}

+ (void)saveSearchArr:(NSArray *)arrary{
   
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeSearchArrary"];
    [arrary writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getSearchArr{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeSearchArrary"];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray arrayWithArray:models];
    if (!models) {
        return [NSMutableArray new];
    }
    return arrayDict;
}

+ (void)saveSearchGroupArr:(NSArray *)arrary{
   
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeSearchgroupArrary"];
    [arrary writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getSearchgroupArr{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeSearchgroupArrary"];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray arrayWithArray:models];
    if (!models) {
        return [NSMutableArray new];
    }
    return arrayDict;
}


+ (void)saveNearTopicArr:(NSArray *)arrary{
   
    NSMutableArray *dictArr = [[NSMutableArray alloc] init];
    for (NoticeTopicModel * model in arrary) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArr addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeNearTopicArrary"];
    [dictArr writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getNearTopicArr{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"NoticeNearTopicArrary"];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeTopicModel *topic = [NoticeTopicModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }

    return arrayDict;
}

+ (NSString*)getFileMD5WithPath:(NSString*)path
{
    NSString *input = path;
    const char *cStrValue = [input UTF8String];
    if (cStrValue == NULL) {
        cStrValue = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, (CC_LONG)strlen(cStrValue), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

+ (NSMutableArray *)getPsychologyArrary{
    NSMutableArray *arr = [NSMutableArray new];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource: [NoticeTools getLocalType] == 2?@"jaQuestionTest": ([NoticeTools getLocalType]?@"enQuestionTest":@"questionTest") ofType:@"plist"];
    NSDictionary *testDict =[NSDictionary dictionaryWithContentsOfFile:path];//获取plist字典
    
    for (int i = 0; i < [testDict[@"questions"] count]; i++) {
        NSDictionary *dic = testDict[@"questions"][i];
        NoticePsyModel *model = [NoticePsyModel mj_objectWithKeyValues:dic];
        model.tag =[NSString stringWithFormat:@"%d", i];
        model.choiceTag = 100000;
        [arr addObject:model];
    }
    
    return arr;
}

+(NSString *)getNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSInteger x = arc4random() % 99999999999999999;
    return  [NSString stringWithFormat:@"%@//%ld",currentTimeString,(long)x];
}

//返回文案
+(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;//设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}

//获取指定文字间距和行间距的文案高度
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 14;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          
    };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

+ (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font textHeight:(CGFloat)textHeight{
    CGRect rect = CGRectMake(0,0, width,textHeight);
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,INT_MAX));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
        
    }
    CFRelease(myFont);
    CFRelease(frame);
    CGPathRelease(path);
    CFRelease(frameSetter);
    return linesArray;
}

+ (UIViewController *)getTopViewController{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    return nav.topViewController;
}

@end
