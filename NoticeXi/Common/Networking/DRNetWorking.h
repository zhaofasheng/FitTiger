//
//  DRNetWorking.h
//  DuoErMerchant
//
//  Created by HandsomeC on 2018/3/13.
//  Copyright © 2018年 赵发生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define BASE_URL @"http://192.168.101.39/api/app/"
//#define bucketNameVoice @"sx-local"//sx-local本地   sx-stag测试   sx-pros生产
//#define yunxinDeleteId @"sx_local_0"//私聊列表要删除的sessionId
//#define socketIP @"192.168.101.39"
//#define socketPort @":9502"
//#define socketADD @"sx-local"
//#define socketHeader @"ws"

//测试环境
#define BASE_URL @"http://stagapi.byebyetext.com/api/app/"
#define bucketNameVoice @"sx-stag"//sx-local本地   sx-stag测试   sx-pros生产
#define yunxinDeleteId @"sx_stag_0"//私聊列表要删除的sessionId
#define socketIP @"47.92.213.243"
#define socketPort @":9502"
#define socketADD @"sx_stag_"
#define socketHeader @"ws"

//正式环境 
//#define BASE_URL @"https://sx.byebyetext.com/api/app/"
//#define bucketNameVoice @"sx-pro"//sx-local本地   sx-stag测试   sx-pro生产
//#define yunxinDeleteId @"sx_pro_0"//私聊列表要删除的sessionId
//#define socketIP @"sx.byebyetext.com/websocket"
//#define socketPort @""
//#define socketADD @"sx_pro_"
//#define socketHeader @"wss"

#define kTimeOutInterval 30 // 请求超时的时间

typedef void (^SuccessBlock)(NSDictionary *_Nullable dict, BOOL success);// 访问成功block
typedef void (^AFNErrorBlock)(NSError * _Nullable error);//访问失败block
typedef void (^progressBlock)(NSString * _Nullable progress);
typedef void (^tokenRefreshBlock)(BOOL success);// token刷新成功

@interface DRNetWorking : NSObject

+ (instancetype _Nullable )shareInstance;

- (void)requestNoNeedLoginWithPath:(NSString *__nullable)path Accept:(NSString *__nullable)Accept isPost:(BOOL)isPost parmaer:(NSMutableDictionary *__nullable)parmaer page:(NSInteger)page success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail;

- (void)requestNoNeedLoginWithPath:(NSString *__nullable)path Accept:(NSString *__nullable)Accept isPost:(BOOL)isPost needMsg:(BOOL)needmsg parmaer:(NSMutableDictionary *__nullable)parmaer page:(NSInteger)page success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail;

- (void)requestNoTosat:(NSString *__nullable)path Accept:(NSString *__nullable)Accept parmaer:(NSMutableDictionary *__nullable)parmaer success:(SuccessBlock _Nullable)success;

//patch请求
- (void)requestWithPatchPath:(NSString *__nullable)path Accept:(NSString *__nullable)Accept parmaer:(NSMutableDictionary * _Nullable)parmaer page:(NSInteger)page success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail;

//DELETE请求
- (void)requestWithDeletePath:(NSString *__nullable)path Accept:(NSString *__nullable)Accept parmaer:(NSMutableDictionary *__nullable)parmaer page:(NSInteger)page success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail;

- (void)refreshTokenOk:(SuccessBlock _Nullable)success;

- (void)requestNoTosat:(NSString *__nullable)path Accept:(NSString *__nullable)Accept parmaer:(NSMutableDictionary *__nullable)parmaer success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail;

- (void)requestOtherPathWith:(NSString *__nullable)path success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail;

- (void)requestCheckPathWith:(NSString *__nullable)path  Accept:(NSString *__nullable)Accept success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail;

@end
