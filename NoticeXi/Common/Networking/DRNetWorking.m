//
//  DRNetWorking.m
//  DuoErMerchant
//
//  Created by HandsomeC on 2018/3/13.
//  Copyright © 2018年 赵发生. All rights reserved.
//

#import "DRNetWorking.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticePinBiView.h"

@implementation DRNetWorking
{
	AFHTTPSessionManager *_manager;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self AFNetworkStatus];
        
        _manager = [AFHTTPSessionManager manager];
        //超时时间
        _manager.requestSerializer.timeoutInterval = kTimeOutInterval;
        //生命获取到的数据格式
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];//afn不会自动解析,数据是data类型,需要自己解析
        //生命上传的是json格式的参数,需要和后台约定,不然会造成后台无法获取参数的情况
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];//上传普通格式
    }
    
    return self;
}

+ (instancetype)shareInstance
{
	static dispatch_once_t onceToken;
	static DRNetWorking  * connect = nil;
	dispatch_once(&onceToken, ^{
		connect = [[DRNetWorking alloc] init];
	});
	return connect;
}

- (NSString *)urlWithPath:(NSString *)path portTag:(NSInteger)portTag{

	return [NSString stringWithFormat:@"%@%@",BASE_URL,path];
}

- (void)showMssage:(NSString *)message{
    
    if ([message containsString:@"您当前仍处于限制沟通状态"] || [message containsString:@"由于您近期多次"] || [message containsString:@"账号"]) {
        NoticePinBiView *pinV = [[NoticePinBiView alloc] initWithWarnTostViewContent:message];
        [pinV showTostView];
        return;
    }
    [YZC_AlertView showViewWithTitleMessage:message];
}

- (void)refreshTokenOk:(SuccessBlock)success{

    [self reManager];
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:[NoticeSaveModel getDeviceInfo] forKey:@"deviceInfo"];
    [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
    [parm setObject:@"2" forKey:@"platformId"];
    if ([NoticeTools getIDFA]) {
        [parm setObject:[NoticeTools getIDFA] forKey:@"deviceId"];
    }else{
        [parm setObject:@"" forKey:@"deviceId"];
    }
   
    [_manager PUT:[self urlWithPath:@"users/refresh" portTag:0] parameters:parm success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                NoticeUserInfoModel *userInfo = [NoticeUserInfoModel mj_objectWithKeyValues:dict[@"data"]];
                [NoticeSaveModel saveToken:userInfo.token];
                [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
                DRLog(@"刷新token成功");
                success(nil,YES);
            }
            else{
                DRLog(@"刷新token失败");
                [NoticeSaveModel outLoginClearData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGESKINATTABBAR" object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DRLog(@"刷新token失败fail");
        [NoticeSaveModel outLoginClearData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
    }];
}

- (void)requestNoTosat:(NSString *)path Accept:(NSString *)Accept parmaer:(NSMutableDictionary *)parmaer success:(SuccessBlock)success{
    
    [self reManager];
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if ([[NoticeSaveModel getToken] length]) {
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[NoticeSaveModel getToken]] forHTTPHeaderField:@"Authorization"];
    }
    if (Accept && ![Accept isEqualToString:@"application/vnd.shengxi.v2.2+json"]) {
        [_manager.requestSerializer setValue:Accept forHTTPHeaderField:@"Accept"];
    }
     DRLog(@"网络请求地址:%@\n请求参数:%@", [self urlWithPath:path portTag:0], [parmaer description]);
    [_manager GET:[self urlWithPath:path portTag:0] parameters:parmaer progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                success(dict,YES);
            }
            else{
//                NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请success失败%@",[self getNowTime]] reason:[NSString stringWithFormat:@"%@\n%@接口请求%@数据错误\n%@",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id]?[[NoticeSaveModel getUserInfo] user_id]:@"未知用户",[self urlWithPath:path portTag:0],[NSString stringWithFormat:@"%@",dict[@"msg"]]] userInfo:dict];//数据上报
//                [Bugly reportException:exception];
                success(dict, NO);
            }
        }else {
            success(@{@"errDesc":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (responses.statusCode == 412) {
         
            [NoticeSaveModel outLoginClearData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
            //  [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
        }else{
            NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请求头失败%@错误代码%ld",[self getNowTime],responses.statusCode] reason:[NSString stringWithFormat:@"%@\n%@请求接口%@失败",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id],[self urlWithPath:path portTag:0]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            [Bugly reportError:error];
        }
    }];
}

- (void)requestNoTosat:(NSString *)path Accept:(NSString *)Accept parmaer:(NSMutableDictionary *)parmaer success:(SuccessBlock)success fail:(AFNErrorBlock)fail{
    [self reManager];
    
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if ([[NoticeSaveModel getToken] length]) {
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[NoticeSaveModel getToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (Accept && ![Accept isEqualToString:@"application/vnd.shengxi.v2.2+json"]) {
        [_manager.requestSerializer setValue:Accept forHTTPHeaderField:@"Accept"];
    }
    
    [_manager GET:[self urlWithPath:path portTag:0] parameters:parmaer progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                success(dict,YES);
            }
            else{
                success(dict, NO);
            }
        }else {
            success(@{@"errDesc":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (responses.statusCode == 412) {
            [NoticeSaveModel outLoginClearData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
        }else{
            NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请求头失败%@错误代码%ld",[self getNowTime],responses.statusCode] reason:[NSString stringWithFormat:@"%@\n%@请求接口%@失败",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id],[self urlWithPath:path portTag:0]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            [Bugly reportError:error];
        }
    }];
}

- (void)requestOtherPathWith:(NSString *__nullable)path success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail{
    DRLog(@"请求接口%@",path);
    [self reManager];
    
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/plain",nil];
    [_manager.requestSerializer setValue:[NSString  stringWithFormat:@"APPCODE %@",@"457aa641da364b94a915d237fa8fb357"] forHTTPHeaderField:@"Authorization"];
   // [_manager.requestSerializer addValue:[NSString  stringWithFormat:@"APPCODE %@" ,  @"457aa641da364b94a915d237fa8fb357"]  forHTTPHeaderField:  @"Authorization"];
    [_manager GET:path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(dict,YES);
        }else {
            success(@{@"errDesc":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        fail(error);
    }];
}

- (void)requestCheckPathWith:(NSString *)path Accept:(NSString *__nullable)Accept success:(SuccessBlock)success fail:(AFNErrorBlock)fail{
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
    
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    if ([[NoticeSaveModel getToken] length]) {
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[NoticeSaveModel getToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (Accept && ![Accept isEqualToString:@"application/vnd.shengxi.v2.2+json"]) {
        [_manager.requestSerializer setValue:Accept forHTTPHeaderField:@"Accept"];
    }
    
    [_manager GET:[self urlWithPath:path portTag:0] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                success(dict,YES);
            }
            else{
                success(dict, NO);
            }
        }else {
            success(@{@"errDesc":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

- (void)requestNoNeedLoginWithPath:(NSString *__nullable)path Accept:(NSString *__nullable)Accept isPost:(BOOL)isPost needMsg:(BOOL)needmsg parmaer:(NSMutableDictionary *__nullable)parmaer page:(NSInteger)page success:(SuccessBlock _Nullable)success fail:(AFNErrorBlock _Nullable)fail{
    [self reManager];
    
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    if ([[NoticeSaveModel getToken] length]) {
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[NoticeSaveModel getToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (Accept && ![Accept isEqualToString:@"application/vnd.shengxi.v2.2+json"]) {
        [_manager.requestSerializer setValue:Accept forHTTPHeaderField:@"Accept"];
    }
    
    DRLog(@"网络请求地址:%@\n请求参数:%@", [self urlWithPath:path portTag:0], [parmaer description]);
    if (!isPost) {
        [_manager GET:[self urlWithPath:path portTag:0] parameters:parmaer progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功
            if (responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                    success(dict,YES);
                }
                else{
                    if (needmsg) {
                        NSString *str = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                        if ([NoticeComTools noTost]) {
                            if (![str isEqualToString:@"由于对方的权限设置，你不能进行该操作"]) {
                                [self showMssage:dict[@"msg"]];
                            }
                        }else{
                             [self showMssage:dict[@"msg"]];
                        }
                        DRLog(@"%@",dict[@"msg"]);
                    }
                    success(dict, NO);
                }
            }else {
                success(@{@"errDesc":@"暂无数据"}, NO);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (responses.statusCode == 415) {
                [YZC_AlertView showTopWithText:@"该帐号已被封禁"];
                [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
                DRLog(@"刷新token失败");
                [NoticeSaveModel outLoginClearData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                return;
            }
            if (responses.statusCode == 412) {
        
                [NoticeSaveModel outLoginClearData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                //  [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
            }else{
                NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请求头失败%@错误代码%ld",[self getNowTime],responses.statusCode] reason:[NSString stringWithFormat:@"%@\n%@请求接口%@失败",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id],[self urlWithPath:path portTag:0]] userInfo:nil];//数据上报
                [Bugly reportException:exception];
                [Bugly reportError:error];
            }
            // 请求失败
            fail(error);
        }];
        
    }else{
        
        [_manager POST:[self urlWithPath:path portTag:0] parameters:parmaer progress:^(NSProgress * _Nonnull uploadProgress) {
            //这里可以获取目前数据请求进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             //请求成功
             if (responseObject) {
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                     success(dict,YES);
                 }
                 else{
                     if (needmsg) {
                         NSString *str = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                         if ([NoticeComTools noTost]) {
                             if (![str isEqualToString:@"由于对方的权限设置，你不能进行该操作"]) {
                                 [self showMssage:dict[@"msg"]];
                             }
                         }else{
                              [self showMssage:dict[@"msg"]];
                         }
                         DRLog(@"%@",dict[@"msg"]);
                     }
                     success(dict, NO);
                 }
             }else {
                 success(@{@"errDesc":@"暂无数据"}, NO);
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
             if (responses.statusCode == 415) {
                 [YZC_AlertView showTopWithText:@"该帐号已被封禁"];
                 [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
                 DRLog(@"刷新token失败");
                 [NoticeSaveModel outLoginClearData];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                 return;
             }
             if (responses.statusCode == 412) {
                 [NoticeSaveModel outLoginClearData];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                 //    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
             }else{
                 [self pareseError:error];
                 NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请求头失败%@错误代码%ld",[self getNowTime],responses.statusCode] reason:[NSString stringWithFormat:@"%@\n%@请求接口%@失败",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id],[self urlWithPath:path portTag:0]] userInfo:nil];//数据上报
                 [Bugly reportException:exception];
                 [Bugly reportError:error];
             }
            
             // 请求失败
             fail(error);
         }];
    }
}

- (void)requestNoNeedLoginWithPath:(NSString *)path Accept:(NSString *)Accept isPost:(BOOL)isPost parmaer:(NSMutableDictionary *)parmaer page:(NSInteger)page success:(SuccessBlock)success fail:(AFNErrorBlock)fail{
    [self reManager];
    
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    if ([[NoticeSaveModel getToken] length]) {
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[NoticeSaveModel getToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (Accept && ![Accept isEqualToString:@"application/vnd.shengxi.v2.2+json"]) {
        [_manager.requestSerializer setValue:Accept forHTTPHeaderField:@"Accept"];
    }
    
    DRLog(@"网络请求地址:%@\n请求参数:%@", [self urlWithPath:path portTag:0], [parmaer description]);
    if (!isPost) {
        [_manager GET:[self urlWithPath:path portTag:0] parameters:parmaer progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功
            if (responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                    success(dict,YES);
                }
                else{
                    NSString *str = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                    if ([NoticeComTools noTost]) {
                        if (![str isEqualToString:@"由于对方的权限设置，你不能进行该操作"]) {
                            [self showMssage:dict[@"msg"]];
                        }
                    }else{
                         [self showMssage:dict[@"msg"]];
                    }
                    DRLog(@"%@",dict[@"msg"]);

                    success(dict, NO);
                }
            }else {
                success(@{@"errDesc":@"暂无数据"}, NO);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if ([path isEqualToString:@"logout"]) {
                // 请求失败
                fail(error);
                return;
            }
            if (responses.statusCode == 415) {
                [YZC_AlertView showTopWithText:@"该帐号已被封禁"];
                [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
                DRLog(@"刷新token失败");
                [NoticeSaveModel outLoginClearData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                return;
            }
            if (responses.statusCode == 412) {
                [NoticeSaveModel outLoginClearData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
            }else{
                NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请求头失败%@错误代码%ld",[self getNowTime],responses.statusCode] reason:[NSString stringWithFormat:@"%@\n%@请求接口%@失败",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id],[self urlWithPath:path portTag:0]] userInfo:nil];//数据上报
                [Bugly reportException:exception];
                [Bugly reportError:error];
            }
            // 请求失败
            fail(error);
        }];
        
    }else{
        
        [_manager POST:[self urlWithPath:path portTag:0] parameters:parmaer progress:^(NSProgress * _Nonnull uploadProgress) {
            //这里可以获取目前数据请求进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             //请求成功
             if (responseObject) {
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                     success(dict,YES);
                 }
                 else{
                     [self showMssage:dict[@"msg"]];
                     DRLog(@"%@",dict[@"msg"]);
                     success(dict, NO);
                 }
             }else {
                 success(@{@"errDesc":@"暂无数据"}, NO);
             }
            
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
             if (responses.statusCode == 415) {
                 [YZC_AlertView showTopWithText:@"该帐号已被封禁"];
                 [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
                 DRLog(@"刷新token失败");
                 [NoticeSaveModel outLoginClearData];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                 return;
             }
             if (responses.statusCode == 412) {
                 [NoticeSaveModel outLoginClearData];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                 //    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
             }else{
                 [self pareseError:error];
                 NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请求头失败%@错误代码%ld",[self getNowTime],responses.statusCode] reason:[NSString stringWithFormat:@"%@\n%@请求接口%@失败",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id],[self urlWithPath:path portTag:0]] userInfo:nil];//数据上报
                 [Bugly reportException:exception];
                 [Bugly reportError:error];
             }
             // 请求失败
             fail(error);
         }];
    }
}

- (void)requestWithPatchPath:(NSString *)path Accept:(NSString *)Accept parmaer:(NSMutableDictionary *)parmaer page:(NSInteger)page success:(SuccessBlock)success fail:(AFNErrorBlock)fail{
    [self reManager];
    
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
  
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if ([[NoticeSaveModel getToken] length]) {
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[NoticeSaveModel getToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (Accept && ![Accept isEqualToString:@"application/vnd.shengxi.v2.2+json"]) {
        [_manager.requestSerializer setValue:Accept forHTTPHeaderField:@"Accept"];
    }
    
    DRLog(@"网络请求地址:%@\n请求参数:%@", [self urlWithPath:path portTag:0], [parmaer description]);
    [_manager PATCH:[self urlWithPath:path portTag:0] parameters:parmaer success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                success(dict,YES);
            }
            else{
                [self showMssage:dict[@"msg"]];
                DRLog(@"%@",dict[@"msg"]);
                success(dict, NO);
            }
        }else {
            success(@{@"errDesc":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (responses.statusCode == 415) {
            [YZC_AlertView showTopWithText:@"该帐号已被封禁"];
            [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
            DRLog(@"刷新token失败");
            [NoticeSaveModel outLoginClearData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
            return;
        }
        
        if (responses.statusCode == 412) {
            [NoticeSaveModel outLoginClearData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
        }else{
            [self pareseError:error];
            NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请求头失败%@错误代码%ld",[self getNowTime],responses.statusCode] reason:[NSString stringWithFormat:@"%@\n%@请求接口%@失败",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id],[self urlWithPath:path portTag:0]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            [Bugly reportError:error];
        }

        // 请求失败
        fail(error);
    }];
}

- (void)requestWithDeletePath:(NSString *)path Accept:(NSString *)Accept parmaer:(NSMutableDictionary *)parmaer page:(NSInteger)page success:(SuccessBlock)success fail:(AFNErrorBlock)fail{
    [self reManager];
    
    NSString *language = @"cn";
    if ([NoticeTools getLocalType] == 1) {
        language = @"en";
    }else if ([NoticeTools getLocalType] == 2){
        language = @"jp";
    }
    [_manager.requestSerializer setValue:language forHTTPHeaderField:@"Lang"];
    
    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if ([[NoticeSaveModel getToken] length]) {
        
        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[NoticeSaveModel getToken]] forHTTPHeaderField:@"Authorization"];
    }
    if (Accept && ![Accept isEqualToString:@"application/vnd.shengxi.v2.2+json"]) {
        [_manager.requestSerializer setValue:Accept forHTTPHeaderField:@"Accept"];
    }
    DRLog(@"网络请求地址:%@\n请求参数:%@", [self urlWithPath:path portTag:0], [parmaer description]);
    [_manager DELETE:[self urlWithPath:path portTag:0] parameters:parmaer success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[NSString stringWithFormat:@"%@",dict[@"code"]] isEqualToString:@"0"]) {
                success(dict,YES);
            }
            else{
//                NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请success失败%@",[self getNowTime]] reason:[NSString stringWithFormat:@"%@\n%@接口请求%@数据错误\n%@",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id]?[[NoticeSaveModel getUserInfo] user_id]:@"未知用户",[self urlWithPath:path portTag:0],[NSString stringWithFormat:@"%@",dict[@"msg"]]] userInfo:dict];//数据上报
//                [Bugly reportException:exception];
                success(dict, NO);
                [self showMssage:dict[@"msg"]];
                DRLog(@"%@",dict[@"msg"]);
                success(dict, NO);
            }
        }else {
            success(@{@"errDesc":@"暂无数据"}, NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        if (responses.statusCode == 415) {
            [YZC_AlertView showTopWithText:@"该帐号已被封禁"];
            [NoticeSaveModel saveLastRefresh:[NoticeTools getNowTimeTimestamp]];
            DRLog(@"刷新token失败");
            [NoticeSaveModel outLoginClearData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
            return;
        }
        if (responses.statusCode == 412) {
            [NoticeSaveModel outLoginClearData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
            //  [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
        }else{
            [self pareseError:error];
            NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"接口请求头失败%@错误代码%ld",[self getNowTime],responses.statusCode] reason:[NSString stringWithFormat:@"%@\n%@请求接口%@失败",[self getNowTime],[[NoticeSaveModel getUserInfo] user_id],[self urlWithPath:path portTag:0]] userInfo:nil];//数据上报
            [Bugly reportException:exception];
            [Bugly reportError:error];
        }

        // 请求失败
        fail(error);
    }];
}

- (void)reManager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        //超时时间
        _manager.requestSerializer.timeoutInterval = kTimeOutInterval;
        //生命获取到的数据格式
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];//afn不会自动解析,数据是data类型,需要自己解析
        //生命上传的是json格式的参数,需要和后台约定,不然会造成后台无法获取参数的情况
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];//上传普通格式
    }
    [_manager.requestSerializer setValue:nil forHTTPHeaderField:@"Lang"];
    [_manager.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
    [_manager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
    [_manager.requestSerializer setValue:nil forHTTPHeaderField:@"Accept"];
}

//未登录状态或者登陆无效状态发送通知到APPDelegate进行跟视图更改 在请求之前判断用户ID是否存在,请求成功后判断用户id是否有效
- (void)sendAuthenticationFailureRequest
{
	
//	[[NSNotificationCenter defaultCenter] postNotificationName:DRUserSessionExpiredNotification object:nil];
}


//网络监听,可在此处进行监听,后可发送通知给单利,在单利里面即可做操作
- (void)AFNetworkStatus{

    AFNetworkReachabilityManager *managerAF = [AFNetworkReachabilityManager sharedManager];
    [managerAF startMonitoring];
    [managerAF setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DRLog(@"未知的网络类型");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DRLog(@"通过WIFI上网");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DRLog(@"通过3G/4G上网");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DRLog(@"当前网络不可达");
                break;
        }
    }];
}

- (void)pareseError:(NSError *)error{
	NSString *msg = nil;
	
	switch(error.code) {
		case NSURLErrorTimedOut:
		case NSURLErrorNetworkConnectionLost:
			msg = @"网络不给力";
			break;
		case NSURLErrorNotConnectedToInternet:
		case NSURLErrorDNSLookupFailed:
			msg = @"无法连接服务器";
			break;
		case NSURLErrorBadURL:
		case NSURLErrorUnsupportedURL:
		case NSURLErrorCannotFindHost:
		case NSURLErrorCannotConnectToHost:
		case NSURLErrorRedirectToNonExistentLocation:
		case NSURLErrorResourceUnavailable:
		case NSURLErrorFileIsDirectory:
		case NSURLErrorFileDoesNotExist:
			msg = @"服务器无法访问";
			break;
		case NSURLErrorCannotParseResponse:
		case NSURLErrorCannotDecodeContentData:
		case NSURLErrorCannotDecodeRawData:
		case NSURLErrorZeroByteResource:
		case NSURLErrorBadServerResponse:
		case NSURLErrorDataLengthExceedsMaximum:
		case NSURLErrorHTTPTooManyRedirects:
			msg = @"返回无效数据";
			break;
		case NSURLErrorUserAuthenticationRequired:
		case NSURLErrorNoPermissionsToReadFile:
			msg = @"无权限访问";
			break;
		default:
			msg = error.localizedDescription;
			break;
	}
	
	if (msg.length || msg) {
		//[YZC_AlertView showViewWithTitleMessage:msg];
	}
}

- (NSString *)getNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSInteger x = arc4random() % 999999999999;
    return  [NSString stringWithFormat:@"%@//%ld",currentTimeString,(long)x];
}
@end
