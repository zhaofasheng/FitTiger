//
//  NoticeMyMovieController.h
//  NoticeXi
//
//  Created by li lei on 2019/4/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"
#import "NoticeAbout.h"
#import "NoticeCustumeNavView.h"
#import "NoticeMBSPlayerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyMovieController : WMPageController
@property (nonatomic, strong) NoticeAbout *realisAbout;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NoticeMBSPlayerView *mbsPlayerView;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@end

NS_ASSUME_NONNULL_END
