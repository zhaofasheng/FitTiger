//
//  NoticeRecoderController.h
//  NoticeXi
//
//  Created by li lei on 2022/3/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeRecoderController : UIViewController
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, assign) BOOL isFromActivity;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicId;
@end

NS_ASSUME_NONNULL_END
