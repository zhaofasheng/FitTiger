//
//  NoticeAllMBSController.h
//  NoticeXi
//
//  Created by li lei on 2021/7/30.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"
#import "NoticeCustumeNavView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAllMBSController : WMPageController
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL fromUserCenter;//来自于个人主页
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@end

NS_ASSUME_NONNULL_END
