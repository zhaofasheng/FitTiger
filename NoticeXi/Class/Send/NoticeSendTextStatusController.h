//
//  NoticeSendTextStatusController.h
//  NoticeXi
//
//  Created by li lei on 2021/4/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceStatusModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendTextStatusController : UIViewController
@property (nonatomic,copy) void (^statusBlock)(NoticeVoiceStatusDetailModel *statusM);
@end

NS_ASSUME_NONNULL_END
