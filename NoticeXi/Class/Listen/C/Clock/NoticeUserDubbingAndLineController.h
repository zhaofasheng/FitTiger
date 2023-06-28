//
//  NoticeUserDubbingAndLineController.h
//  NoticeXi
//
//  Created by li lei on 2020/8/18.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"
#import "NoticeCustumeNavView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserDubbingAndLineController : WMPageController
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isUserPy;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isFromLine;
@property (nonatomic, assign) BOOL isFromUserCenter;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, assign) BOOL needBackGround;
@end

NS_ASSUME_NONNULL_END
