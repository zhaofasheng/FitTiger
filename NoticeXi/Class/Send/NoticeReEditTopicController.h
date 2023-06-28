//
//  NoticeReEditTopicController.h
//  NoticeXi
//
//  Created by li lei on 2020/5/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeReEditTopicController : UIViewController
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic,copy) void (^reEditBlock)(NoticeVoiceListModel *voiceM);
@end

NS_ASSUME_NONNULL_END
