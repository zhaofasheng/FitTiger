//
//  NoticeCenterSetController.h
//  NoticeXi
//
//  Created by li lei on 2019/12/18.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeUserCenterSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCenterSetController : UIViewController
@property (nonatomic, strong) NoticeUserCenterSet *setView;
@property (nonatomic,copy) void (^needMbBlock)(BOOL need);
@property (nonatomic,copy) void (^fenwenBlock)(NSInteger type);

@end

NS_ASSUME_NONNULL_END
