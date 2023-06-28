//
//  XGUploadDateManager.m
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/4/23.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "XGUploadDateManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import "OSSConstants.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"

@interface XGUploadDateManager()

@property (nonatomic, strong) OSSClient *client;

@property (nonatomic, assign) BOOL authorSucess;
@property (nonatomic, assign) BOOL isHasTostProgross;
@property (nonatomic, assign) NSInteger timePercent;
@property (nonatomic, assign) NSInteger timeOutNum;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation XGUploadDateManager

+ (instancetype)sharedManager{
	
	static XGUploadDateManager *sharedManager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[super allocWithZone:NULL] init];
	});
	return sharedManager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
        
	}
	return self;
}

- (void)timeChange{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    if (self.isHasTostProgross) {
        self.timeOutNum = 0;
        [self.timer invalidate];
        return;
    }
    self.timeOutNum ++;
    if (self.timeOutNum >= 10  && self.timeOutNum <= 30) {
        [nav.topViewController showHUDWithText:[NSString stringWithFormat:@"%ld%%",self.timePercent+=4]];
    }
    
    if (self.timeOutNum >= 30) {
        [self.timer invalidate];
        [nav.topViewController hideHUD];
        if (appdel.sendVoice) {//需要保存到缓存的
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NONETWORKINGGEGCACHE" object:nil];
        }else{
            [nav.topViewController showToastWithText:@"发送失败，当前网络不太稳定"];
        }
        return;
    }
}

- (void)uploadImageWithImageData:(NSData *)imageData parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler{
    
    self.timePercent = 20;
    self.timeOutNum = 0;
    self.isHasTostProgross = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
     [nav.topViewController showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"resource" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"][@"oss"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            if ([dict[@"data"][@"resource_content"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            
            NSString *bucket = nil;
            NSString *bucketN = bucketNameVoice;
            NSString *end_point = nil;
            NSString *bucketId = nil;
            if (![dict[@"data"][@"bucket"] isEqual:[NSNull null]]) {
                bucket = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket"]];
                bucketId = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket_id"]];
                end_point = [NSString stringWithFormat:@"%@",dict[@"data"][@"end_point"]];//
                if (bucket.length) {
                    bucketN = bucket;
                }
            }
            if (end_point.length < 8) {
                end_point = nil;
            }
            
            if ([bucketId isEqualToString:@"(null)"]) {
                bucketId = @"0";
            }
            
            NoticeFile *model= [NoticeFile mj_objectWithKeyValues:dict[@"data"][@"oss"]];
            if (!model.AccessKeyId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return;
            }
            NSString *resourceContentVoice = [NSString stringWithFormat:@"%@",dict[@"data"][@"resource_content"]];
            NSString *accesskeyId = model.AccessKeyId;
            NSString *accessKeySecret = model.AccessKeySecret;
            NSString *securityToken = model.SecurityToken;
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accesskeyId secretKeyId:accessKeySecret securityToken:securityToken];
            self.client = [[OSSClient alloc] initWithEndpoint:end_point?end_point:XGendPoint credentialProvider:credential];
            
            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
            put.bucketName = bucketN;
            put.objectKey = resourceContentVoice;
            put.uploadingData = imageData; // 直接上传NSData
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                });
            };
            OSSTask * putTask = [self.client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                OSSPutObjectResult * result = task.result;
                NSLog(@"result = %@",result);
                if (!task.error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        [self.timer invalidate];
                        self.isHasTostProgross = YES;
                        if (self.timeOutNum >= 30) {
                            completionHandler ? completionHandler(nil, @"上传超时",nil,NO) : nil;
                            return ;
                        }
                        completionHandler ? completionHandler(nil,resourceContentVoice,bucketId,YES) : nil;
                    });
                    DRLog(@"upload object success!");
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                        completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                    });
                    DRLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [nav.topViewController hideHUD];
                self.isHasTostProgross = YES;
                [self.timer invalidate];
                completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
            });
            return;
        }
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [nav.topViewController hideHUD];
            self.isHasTostProgross = YES;
            [self.timer invalidate];
            completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
        });
    }];
}

- (void)noShowuploadImageWithImageData:(NSData *)imageData parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler{
    
    self.timePercent = 20;
    self.timeOutNum = 0;
    self.isHasTostProgross = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"resource" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"][@"oss"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            if ([dict[@"data"][@"resource_content"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            
            NSString *bucket = nil;
            NSString *bucketN = bucketNameVoice;
            NSString *end_point = nil;
            NSString *bucketId = nil;
            if (![dict[@"data"][@"bucket"] isEqual:[NSNull null]]) {
                bucket = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket"]];
                bucketId = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket_id"]];
                end_point = [NSString stringWithFormat:@"%@",dict[@"data"][@"end_point"]];
                if (bucket.length) {
                    bucketN = bucket;
                }
            }
            if (end_point.length < 8) {
                end_point = nil;
            }
            
            if ([bucketId isEqualToString:@"(null)"]) {
                bucketId = @"0";
            }
            
            NoticeFile *model= [NoticeFile mj_objectWithKeyValues:dict[@"data"][@"oss"]];
            if (!model.AccessKeyId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return;
            }
            NSString *resourceContentVoice = [NSString stringWithFormat:@"%@",dict[@"data"][@"resource_content"]];
            NSString *accesskeyId = model.AccessKeyId;
            NSString *accessKeySecret = model.AccessKeySecret;
            NSString *securityToken = model.SecurityToken;
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accesskeyId secretKeyId:accessKeySecret securityToken:securityToken];
            self.client = [[OSSClient alloc] initWithEndpoint:end_point?end_point:XGendPoint credentialProvider:credential];
            
            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
            put.bucketName = bucketN;
            put.objectKey = resourceContentVoice;
            put.uploadingData = imageData; // 直接上传NSData
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                });
            };
            OSSTask * putTask = [self.client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                OSSPutObjectResult * result = task.result;
                NSLog(@"result = %@",result);
                if (!task.error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        [self.timer invalidate];
                        self.isHasTostProgross = YES;
                        if (self.timeOutNum >= 30) {
                            completionHandler ? completionHandler(nil, @"上传超时",nil,NO) : nil;
                            return ;
                        }
                        completionHandler ? completionHandler(nil,resourceContentVoice,bucketId,YES) : nil;
                    });
                    DRLog(@"upload object success!");
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                        completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                    });
                    DRLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [nav.topViewController hideHUD];
                self.isHasTostProgross = YES;
                [self.timer invalidate];
                completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
            });
            return;
        }
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [nav.topViewController hideHUD];
            self.isHasTostProgross = YES;
            [self.timer invalidate];
            completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
        });
    }];
}

- (void)uploadTxtWithTxtData:(NSData *)txtData parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler{
    self.timePercent = 20;
    self.timeOutNum = 0;
    self.isHasTostProgross = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"resource" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"][@"oss"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            if ([dict[@"data"][@"resource_content"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            
            NSString *bucket = nil;
            NSString *bucketN = bucketNameVoice;
            NSString *end_point = nil;
            NSString *bucketId = nil;
            if (![dict[@"data"][@"bucket"] isEqual:[NSNull null]]) {
                bucket = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket"]];
                bucketId = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket_id"]];
                end_point = [NSString stringWithFormat:@"%@",dict[@"data"][@"end_point"]];//
                if (bucket.length) {
                    bucketN = bucket;
                }
            }
            if (end_point.length < 8) {
                end_point = nil;
            }
            
            if ([bucketId isEqualToString:@"(null)"]) {
                bucketId = @"0";
            }
            
            NoticeFile *model= [NoticeFile mj_objectWithKeyValues:dict[@"data"][@"oss"]];
            if (!model.AccessKeyId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return;
            }
            NSString *resourceContentVoice = [NSString stringWithFormat:@"%@",dict[@"data"][@"resource_content"]];
            NSString *accesskeyId = model.AccessKeyId;
            NSString *accessKeySecret = model.AccessKeySecret;
            NSString *securityToken = model.SecurityToken;
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accesskeyId secretKeyId:accessKeySecret securityToken:securityToken];
            self.client = [[OSSClient alloc] initWithEndpoint:end_point?end_point:XGendPoint credentialProvider:credential];
            
            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
            put.bucketName = bucketN;
            put.objectKey = resourceContentVoice;
            put.uploadingData = txtData; // 直接上传NSData
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                });
            };
            OSSTask * putTask = [self.client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                OSSPutObjectResult * result = task.result;
                NSLog(@"result = %@",result);
                if (!task.error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        [self.timer invalidate];
                        self.isHasTostProgross = YES;
                        if (self.timeOutNum >= 30) {
                            completionHandler ? completionHandler(nil, @"上传超时",nil,NO) : nil;
                            return ;
                        }
                        completionHandler ? completionHandler(nil,resourceContentVoice,bucketId,YES) : nil;
                    });
                    DRLog(@"upload TXT object success!");
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                        completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                    });
                    DRLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isHasTostProgross = YES;
                [self.timer invalidate];
                completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
            });
            return;
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)uploadImageWithImage:(UIImage *)image parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler{
    self.timePercent = 20;
    self.timeOutNum = 0;
    self.isHasTostProgross = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [nav.topViewController showHUD];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"resource" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"][@"oss"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            if ([dict[@"data"][@"resource_content"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            
            NSString *bucket = nil;
            NSString *bucketN = bucketNameVoice;
            NSString *end_point = nil;
            NSString *bucketId = nil;
            if (![dict[@"data"][@"bucket"] isEqual:[NSNull null]]) {
                bucket = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket"]];
                bucketId = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket_id"]];
                end_point = [NSString stringWithFormat:@"%@",dict[@"data"][@"end_point"]];
                if (bucket.length) {
                    bucketN = bucket;
                }
            }
            if (end_point.length < 8) {
                end_point = nil;
            }
            
            if ([bucketId isEqualToString:@"(null)"]) {
                bucketId = @"0";
            }
            NoticeFile *model= [NoticeFile mj_objectWithKeyValues:dict[@"data"][@"oss"]];
            if (!model.AccessKeyId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return;
            }
            NSString *resourceContentVoice = [NSString stringWithFormat:@"%@",dict[@"data"][@"resource_content"]];
            NSString *accesskeyId = model.AccessKeyId;
            NSString *accessKeySecret = model.AccessKeySecret;
            NSString *securityToken = model.SecurityToken;
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accesskeyId secretKeyId:accessKeySecret securityToken:securityToken];
            self.client = [[OSSClient alloc] initWithEndpoint:end_point?end_point:XGendPoint credentialProvider:credential];
            
            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
            put.bucketName = bucketN;
            put.objectKey = resourceContentVoice;
            put.uploadingData = UIImageJPEGRepresentation(image, 0.8);// 直接上传NSData
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                });
            };
            OSSTask * putTask = [self.client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                OSSPutObjectResult * result = task.result;
                NSLog(@"result = %@",result);
                if (!task.error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        [self.timer invalidate];
                        self.isHasTostProgross = YES;
                        if (self.timeOutNum >= 30) {
                            completionHandler ? completionHandler(nil, @"上传超时",nil,NO) : nil;
                            return ;
                        }
                        completionHandler ? completionHandler(nil,resourceContentVoice,bucketId,YES) : nil;
                    });
                    DRLog(@"upload object success!");
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                        completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                    });
                    DRLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [nav.topViewController hideHUD];
                self.isHasTostProgross = YES;
                [self.timer invalidate];
                completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
            });
            return;
        }
    } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [nav.topViewController hideHUD];
            self.isHasTostProgross = YES;
            [self.timer invalidate];
            completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
        });
    }];
}

- (void)uploadVoiceWithVoicePath:(NSString *)path parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler{
    self.timePercent = 20;
    self.timeOutNum = 0;
    self.isHasTostProgross = NO;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance]  requestNoNeedLoginWithPath:@"resource" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"][@"oss"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            if ([dict[@"data"][@"resource_content"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            NoticeFile *model= [NoticeFile mj_objectWithKeyValues:dict[@"data"][@"oss"]];
            if (!model.AccessKeyId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return;
            }
            
            NSString *bucket = nil;
            NSString *bucketN = bucketNameVoice;
            NSString *end_point = nil;
            NSString *bucketId = nil;
            if (![dict[@"data"][@"bucket"] isEqual:[NSNull null]]) {
                bucket = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket"]];
                bucketId = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket_id"]];
                end_point = [NSString stringWithFormat:@"%@",dict[@"data"][@"end_point"]];
                if (bucket.length) {
                    bucketN = bucket;
                }
            }
            if (end_point.length < 8) {
                end_point = nil;
            }
        
            if ([bucketId isEqualToString:@"(null)"]) {
                bucketId = @"0";
            }
            
            NSString *resourceContentVoice = [NSString stringWithFormat:@"%@",dict[@"data"][@"resource_content"]];
            
            NSString *accesskeyId = model.AccessKeyId;
            NSString *accessKeySecret = model.AccessKeySecret;
            NSString *securityToken = model.SecurityToken;
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accesskeyId secretKeyId:accessKeySecret securityToken:securityToken];
            self.client = [[OSSClient alloc] initWithEndpoint:end_point?end_point: XGendPoint credentialProvider:credential];
            
            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
            put.bucketName = bucketN;
            put.objectKey = resourceContentVoice;
            put.uploadingFileURL = [NSURL fileURLWithPath:path]; // 直接上传NSData
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                    DRLog(@"%lld---%lld",totalByteSent,totalBytesExpectedToSend);
                });
            };
            OSSTask * putTask = [self.client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                OSSPutObjectResult * result = task.result;
                NSLog(@"result = %@",result);
                if (!task.error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        [self.timer invalidate];
                        self.isHasTostProgross = YES;
                        if (self.timeOutNum >= 30) {
                            completionHandler ? completionHandler(nil, @"上传超时",nil,NO) : nil;
                            return ;
                        }
                        completionHandler ? completionHandler(nil,resourceContentVoice,bucketId,YES) : nil;
                    });
                    DRLog(@"upload object success!");
                } else {
                    NSMutableDictionary *errorDict = [NSMutableDictionary new];
                    if (task.error) {
                        [errorDict setObject:task.error forKey:@"upFail"];
                    }
                    NSException *exception = [NSException exceptionWithName:@"音频文件上传失败" reason:[NSString stringWithFormat:@"%@音频上传接口请求失败\n%@",[[NoticeSaveModel getUserInfo] user_id]?[[NoticeSaveModel getUserInfo] user_id]:@"未知用户",task.error] userInfo:errorDict];//数据上报
                    [Bugly reportException:exception];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [nav.topViewController hideHUD];
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                        completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                    });
                    DRLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
        }else{
            NSException *exception = [NSException exceptionWithName:@"音频上传接口请求失败" reason:[NSString stringWithFormat:@"%@音频上传接口请求失败",[[NoticeSaveModel getUserInfo] user_id]?[[NoticeSaveModel getUserInfo] user_id]:@"未知用户"] userInfo:dict];//数据上报
            [Bugly reportException:exception];
            dispatch_async(dispatch_get_main_queue(), ^{
                [nav.topViewController hideHUD];
                self.isHasTostProgross = YES;
                [self.timer invalidate];
                completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
            });
            return;
        }
    } fail:^(NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [nav.topViewController hideHUD];
            self.isHasTostProgross = YES;
            [self.timer invalidate];
            completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
        });
    }];
    
}

- (void)uploadMoreWithImageArr:(NSMutableArray *)imageArr noNeedToast:(BOOL)noneedTosat parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler{

    if (!noneedTosat) {
        self.timePercent = 20;
        self.timeOutNum = 0;
        self.isHasTostProgross = NO;
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    [nav.topViewController showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"resource" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"][@"oss"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!noneedTosat) {
                        [nav.topViewController hideHUD];
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                    }
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            
            if ([dict[@"data"][@"resource_content"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!noneedTosat) {
                        [nav.topViewController hideHUD];
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                    }
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            
            NoticeFile *model= [NoticeFile mj_objectWithKeyValues:dict[@"data"][@"oss"]];
            if (!model.AccessKeyId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!noneedTosat) {
                        [nav.topViewController hideHUD];
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                    }
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return;
            }
            
            NSString *bucket = nil;
            NSString *bucketN = bucketNameVoice;
            NSString *end_point = nil;
            NSString *bucketId = nil;
            if (![dict[@"data"][@"bucket"] isEqual:[NSNull null]]) {
                bucket = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket"]];
                bucketId = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket_id"]];
                end_point = [NSString stringWithFormat:@"%@",dict[@"data"][@"end_point"]];
                if (bucket.length) {
                    bucketN = bucket;
                }
            }
            if (end_point.length < 8) {
                end_point = nil;
            }
            
            if ([bucketId isEqualToString:@"(null)"]) {
                bucketId = @"0";
            }
            NoticeFile *resourcesArr = [NoticeFile mj_objectWithKeyValues:dict[@"data"]];
            if (!resourcesArr.resource_content.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!noneedTosat) {
                        [nav.topViewController hideHUD];
                        self.isHasTostProgross = YES;
                        [self.timer invalidate];
                    }
                    completionHandler ? completionHandler(nil, @"后台返回图片数据失败",nil,NO) : nil;
                });
                return;
            }
            
            NSString *accesskeyId = model.AccessKeyId;
            NSString *accessKeySecret = model.AccessKeySecret;
            NSString *securityToken = model.SecurityToken;
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accesskeyId secretKeyId:accessKeySecret securityToken:securityToken];
            self.client = [[OSSClient alloc] initWithEndpoint:end_point?end_point: XGendPoint credentialProvider:credential];
            
            if (resourcesArr.resource_content.count == 1) {
                OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                put.bucketName = bucketN;
                put.objectKey = resourcesArr.resource_content[0];
                put.uploadingData =  imageArr[0]; // 直接上传NSData
                put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                    });
                };
                OSSTask * putTask = [self.client putObject:put];
                [putTask continueWithBlock:^id(OSSTask *task) {
                    if (!task.error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (!noneedTosat) {
                                [nav.topViewController hideHUD];
                                self.isHasTostProgross = YES;
                                [self.timer invalidate];
                            }
                            if (self.timeOutNum >= 30) {
                                completionHandler ? completionHandler(nil, @"上传超时",nil,NO) : nil;
                                return ;
                            }
                            completionHandler ? completionHandler(nil,[NoticeTools arrayToJSONString:[NSMutableArray arrayWithArray:resourcesArr.resource_content]],bucketId,YES) : nil;
                        });
                        DRLog(@"upload object success!");
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!noneedTosat) {
                                [nav.topViewController hideHUD];
                                self.isHasTostProgross = YES;
                                [self.timer invalidate];
                            }
                            completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                        });
                        DRLog(@"upload object failed, error: %@" , task.error);
                    }
                    return nil;
                }];
            }
            
            if (resourcesArr.resource_content.count == 2) {
                OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                put.bucketName = bucketN;
                put.objectKey = resourcesArr.resource_content[0];
                put.uploadingData = imageArr[0]; // 直接上传NSData
                put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                    });
                    
                };
                OSSTask * putTask = [self.client putObject:put];
                [putTask continueWithBlock:^id(OSSTask *task) {
                    if (!task.error) {
                        OSSPutObjectRequest *put1 = [OSSPutObjectRequest new];
                        put1.bucketName = bucketN;
                        put1.objectKey = resourcesArr.resource_content[1];
                        put1.uploadingData = imageArr[1]; // 直接上传NSData
                        put1.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                            });
                            
                        };
                        OSSTask * putTask1 = [self.client putObject:put1];
                        [putTask1 continueWithBlock:^id(OSSTask *task1) {
                            if (!task1.error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (!noneedTosat) {
                                        [nav.topViewController hideHUD];
                                        self.isHasTostProgross = YES;
                                        [self.timer invalidate];
                                    }
                                    if (self.timeOutNum >= 30) {
                                        completionHandler ? completionHandler(nil, @"上传超时",nil,NO) : nil;
                                        return ;
                                    }
                                    completionHandler ? completionHandler(nil,[NoticeTools arrayToJSONString:[NSMutableArray arrayWithArray:resourcesArr.resource_content]],bucketId,YES) : nil;
                                });
                                DRLog(@"upload object success!");
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (!noneedTosat) {
                                        [nav.topViewController hideHUD];
                                        self.isHasTostProgross = YES;
                                        [self.timer invalidate];
                                    }
                                    completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                                });
                                DRLog(@"upload object failed, error: %@" , task.error);
                            }
                            return nil;
                        }];
                        DRLog(@"upload object success!");
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!noneedTosat) {
                                [nav.topViewController hideHUD];
                                self.isHasTostProgross = YES;
                                [self.timer invalidate];
                            }
                            completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                        });
                        DRLog(@"upload object failed, error: %@" , task.error);
                    }
                    return nil;
                }];
            }
            
            if (resourcesArr.resource_content.count  == 3) {
                OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                put.bucketName = bucketN;
                put.objectKey = resourcesArr.resource_content[0];
                put.uploadingData = imageArr[0]; // 直接上传NSData
                put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                    });
                    
                };
                OSSTask * putTask = [self.client putObject:put];
                [putTask continueWithBlock:^id(OSSTask *task) {
                    if (!task.error) {//第一张上传成功
                        
                        OSSPutObjectRequest *put1 = [OSSPutObjectRequest new];
                        put1.bucketName = bucketN;
                        put1.objectKey = resourcesArr.resource_content[1];
                        put1.uploadingData = imageArr[1]; // 直接上传NSData
                        put1.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                            });
                            
                        };
                        OSSTask * putTask1 = [self.client putObject:put1];
                        [putTask1 continueWithBlock:^id(OSSTask *task1) {
                            if (!task1.error) {////第二张上传成功
                             
                                OSSPutObjectRequest *put2 = [OSSPutObjectRequest new];
                                put2.bucketName = bucketN;
                                put2.objectKey = resourcesArr.resource_content[2];
                                put2.uploadingData = imageArr[2]; // 直接上传NSData
                                put2.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                                    });
                                    
                                };
                                OSSTask * putTask2 = [self.client putObject:put2];
                                [putTask2 continueWithBlock:^id(OSSTask *task2) {
                                    if (!task2.error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (!noneedTosat) {
                                                [nav.topViewController hideHUD];
                                                self.isHasTostProgross = YES;
                                                [self.timer invalidate];
                                            }
                                            if (self.timeOutNum >= 30) {
                                                completionHandler ? completionHandler(nil, @"上传超时",nil,NO) : nil;
                                                return ;
                                            }
                                            completionHandler ? completionHandler(nil,[NoticeTools arrayToJSONString:[NSMutableArray arrayWithArray:resourcesArr.resource_content]],bucketId,YES) : nil;
                                        });
                                        DRLog(@"upload object success!");
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (!noneedTosat) {
                                                [nav.topViewController hideHUD];
                                                self.isHasTostProgross = YES;
                                                [self.timer invalidate];
                                            }
                                            completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                                        });
                                        DRLog(@"upload object failed, error: %@" , task2.error);
                                    }
                                    return nil;
                                }];
                                
                                DRLog(@"upload object success!");
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (!noneedTosat) {
                                        [nav.topViewController hideHUD];
                                        self.isHasTostProgross = YES;
                                        [self.timer invalidate];
                                    }
                                    completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                                });
                                DRLog(@"upload object failed, error: %@" , task.error);
                            }
                            return nil;
                        }];
                        DRLog(@"upload object success!");
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (!noneedTosat) {
                                [nav.topViewController hideHUD];
                                self.isHasTostProgross = YES;
                                [self.timer invalidate];
                            }
                            completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                        });
                        DRLog(@"upload object failed, error: %@" , task.error);
                    }
                    return nil;
                }];
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!noneedTosat) {
                    [nav.topViewController hideHUD];
                    self.isHasTostProgross = YES;
                    [self.timer invalidate];
                }
                completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
            });
            return;
        }
    } fail:^(NSError *error) {
   
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!noneedTosat) {
                [nav.topViewController hideHUD];
                self.isHasTostProgross = YES;
                [self.timer invalidate];
            }
            completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
        });
    }];
}

- (void)uploadNoToastVoiceWithVoicePath:(NSString *)path parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler{
    [[DRNetWorking shareInstance]  requestNoNeedLoginWithPath:@"resource" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"][@"oss"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            if ([dict[@"data"][@"resource_content"] isEqual:[NSNull null]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return ;
            }
            NoticeFile *model= [NoticeFile mj_objectWithKeyValues:dict[@"data"][@"oss"]];
            if (!model.AccessKeyId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler ? completionHandler(nil, @"后台授权失败",nil,NO) : nil;
                });
                return;
            }
            
            NSString *bucket = nil;
            NSString *bucketN = bucketNameVoice;
            NSString *end_point = nil;
            NSString *bucketId = nil;
            if (![dict[@"data"][@"bucket"] isEqual:[NSNull null]]) {
                bucket = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket"]];
                bucketId = [NSString stringWithFormat:@"%@",dict[@"data"][@"bucket_id"]];
                end_point = [NSString stringWithFormat:@"%@",dict[@"data"][@"end_point"]];
                if (bucket.length) {
                    bucketN = bucket;
                }
            }
            if (end_point.length < 8) {
                end_point = nil;
            }
            
            if ([bucketId isEqualToString:@"(null)"]) {
                bucketId = @"0";
            }
            
            NSString *resourceContentVoice = [NSString stringWithFormat:@"%@",dict[@"data"][@"resource_content"]];
            
            NSString *accesskeyId = model.AccessKeyId;
            NSString *accessKeySecret = model.AccessKeySecret;
            NSString *securityToken = model.SecurityToken;
            id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accesskeyId secretKeyId:accessKeySecret securityToken:securityToken];
            self.client = [[OSSClient alloc] initWithEndpoint:end_point?end_point: XGendPoint credentialProvider:credential];
            
            OSSPutObjectRequest *put = [OSSPutObjectRequest new];
            put.bucketName = bucketN;
            put.objectKey = resourceContentVoice;
            put.uploadingFileURL = [NSURL fileURLWithPath:path];// 直接上传NSData
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progressHandler ? progressHandler(totalByteSent*1.0/totalBytesExpectedToSend) : nil;
                });
            };
            OSSTask * putTask = [self.client putObject:put];
            [putTask continueWithBlock:^id(OSSTask *task) {
                OSSPutObjectResult * result = task.result;
                NSLog(@"result = %@",result);
                if (!task.error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler ? completionHandler(nil,resourceContentVoice,bucketId,YES) : nil;
                    });
                    DRLog(@"upload object success!");
                } else {
                    NSMutableDictionary *errorDict = [NSMutableDictionary new];
                    if (task.error) {
                        [errorDict setObject:task.error forKey:@"upFail"];
                    }
                    NSException *exception = [NSException exceptionWithName:@"音频文件上传失败" reason:[NSString stringWithFormat:@"%@音频上传接口请求失败\n%@",[[NoticeSaveModel getUserInfo] user_id]?[[NoticeSaveModel getUserInfo] user_id]:@"未知用户",task.error] userInfo:errorDict];//数据上报
                    [Bugly reportException:exception];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
                    });
                    DRLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
        }else{
            NSException *exception = [NSException exceptionWithName:@"音频上传接口请求失败" reason:[NSString stringWithFormat:@"%@音频上传接口请求失败",[[NoticeSaveModel getUserInfo] user_id]?[[NoticeSaveModel getUserInfo] user_id]:@"未知用户"] userInfo:dict];//数据上报
            [Bugly reportException:exception];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler ? completionHandler(nil, @"接口请求失败",nil,NO) : nil;
            });
            return;
        }
    } fail:^(NSError *error) {
        NSException *exception = [NSException exceptionWithName:@"音频文件上传失败" reason:[NSString stringWithFormat:@"%@音频上传接口请求失败\n%@",[[NoticeSaveModel getUserInfo] user_id]?[[NoticeSaveModel getUserInfo] user_id]:@"未知用户",error] userInfo:nil];//数据上报
        [Bugly reportException:exception];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler ? completionHandler(nil, [NoticeTools getLocalStrWith:@"up.fail"],nil,NO) : nil;
        });
    }];
}
@end
