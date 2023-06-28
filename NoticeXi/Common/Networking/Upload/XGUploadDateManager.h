//
//  XGUploadDateManager.h
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/4/23.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NoticeFile.h"
typedef enum : NSUInteger {
	XGUploadImageTypeUserAvatar,
	XGUploadImageTypeUserCardID,
} XGUploadImageType;

typedef void(^XGNetworkTaskCompletionHandler)(NSError *error, NSString *Message,NSString *bucketId,BOOL sussess);
typedef void(^XGNetworkTaskProgressHandler)(CGFloat progress);

@interface XGUploadDateManager : NSObject

+ (instancetype)sharedManager;
- (void)uploadMoreWithImageArr:(NSMutableArray *)imageArr noNeedToast:(BOOL)noneedTosat parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler;
- (void)uploadImageWithImage:(UIImage *)image parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler;
- (void)uploadImageWithImageData:(NSData *)imageData parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler;
- (void)uploadVoiceWithVoicePath:(NSString *)path parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler;

- (void)uploadNoToastVoiceWithVoicePath:(NSString *)path parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler;

- (void)uploadTxtWithTxtData:(NSData *)txtData parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler;

- (void)noShowuploadImageWithImageData:(NSData *)imageData parm:(NSMutableDictionary *)parm progressHandler:(XGNetworkTaskProgressHandler)progressHandler complectionHandler:(XGNetworkTaskCompletionHandler)completionHandler;
@end
