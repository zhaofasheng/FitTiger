//
//  NoticeVersionController.h
//  NoticeXi
//
//  Created by li lei on 2021/7/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVersionController : NoticeBaseListController
@property (nonatomic, assign) BOOL hasNewVersion;
@property (nonatomic, strong) NSString *versionName;
@end

NS_ASSUME_NONNULL_END
