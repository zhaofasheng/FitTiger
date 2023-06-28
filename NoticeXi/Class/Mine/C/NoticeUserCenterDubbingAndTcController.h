//
//  NoticeUserCenterDubbingAndTcController.h
//  NoticeXi
//
//  Created by li lei on 2023/2/27.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//


#import "WMPageController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserCenterDubbingAndTcController : WMPageController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) NSInteger relation_status;
@end

NS_ASSUME_NONNULL_END
