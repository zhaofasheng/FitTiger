//
//  NoticeOrderListBaseController.h
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"
#import "NoticeCustumeNavView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeOrderListBaseController : WMPageController
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, assign) BOOL isExpre;
@end

NS_ASSUME_NONNULL_END
