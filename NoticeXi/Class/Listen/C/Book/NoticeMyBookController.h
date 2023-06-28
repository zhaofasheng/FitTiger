//
//  NoticeMyBookController.h
//  NoticeXi
//
//  Created by li lei on 2019/12/24.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"
#import "NoticeAbout.h"
#import "NoticeMBSPlayerView.h"
#import "NoticeCustumeNavView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyBookController : WMPageController
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NoticeAbout *realisAbout;
@property (nonatomic, strong) NoticeMBSPlayerView *mbsPlayerView;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@end

NS_ASSUME_NONNULL_END
