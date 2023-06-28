//
//  NoticeUserCenterVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2023/2/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"
#import "JXPagerView.h"
#import "NoticeVoiceGroundController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserCenterVoiceController : WMPageController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NoticeVoiceGroundController *voiceVC;
@property (nonatomic, strong) NoticeVoiceGroundController *textVC;
@property (nonatomic,copy) void (^playVoice)(BOOL play);
@property (nonatomic, assign) NSInteger relation_status;
@end

NS_ASSUME_NONNULL_END
