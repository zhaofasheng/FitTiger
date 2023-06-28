//
//  NoticreSendHelpController.h
//  NoticeXi
//
//  Created by li lei on 2022/8/3.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceSaveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticreSendHelpController : UIViewController
@property (nonatomic, copy)  void (^upSuccess)(BOOL success);
@property (nonatomic, strong) NoticeVoiceSaveModel *saveModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^deleteSaveModelBlock)(NSInteger index, BOOL noSend);
@property (nonatomic, assign) BOOL isSave;
@end

NS_ASSUME_NONNULL_END
