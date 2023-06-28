//
//  NoticeVoiceGroundController.h
//  NoticeXi
//
//  Created by li lei on 2021/9/23.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "JXPagerView.h"
#import "NoticeHeaderDataView.h"
#import "NoticeTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceGroundController : BaseTableViewController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) NSInteger type;//1共享的语音心情 2共享的文字心情
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isPager;
@property (nonatomic, assign) BOOL isActivity;
@property (nonatomic, assign) BOOL isDate;//日历
@property (nonatomic, assign) BOOL istietie;//日历的贴贴
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *date;
@property (nonatomic,copy) void (^playVoice)(BOOL play);
@property (nonatomic, strong) NoticeHeaderDataView *dataView;
@property (nonatomic, strong) NoticeTopicModel *activityM;
@property (nonatomic, assign) BOOL isUserCenter;
@property (nonatomic, assign) NSInteger relation_status;
@end

NS_ASSUME_NONNULL_END
