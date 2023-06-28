//
//  NoticeMySelfDrawController.h
//  NoticeXi
//
//  Created by li lei on 2020/6/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "WMPageController.h"
#import "NoticeCustumeNavView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMySelfDrawController : WMPageController
@property (nonatomic,copy) void (^setHotBlock)(BOOL goHot);
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@end

NS_ASSUME_NONNULL_END
