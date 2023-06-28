//
//  NoticeAddVoiceToZjController.h
//  NoticeXi
//
//  Created by li lei on 2021/4/21.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeAddVoiceToZjController : NoticeBaseListController
@property (nonatomic, strong) NSString *zjmodelId;
@property (nonatomic,copy) void (^joinSuccessBlock)(BOOL join);
@end

NS_ASSUME_NONNULL_END
