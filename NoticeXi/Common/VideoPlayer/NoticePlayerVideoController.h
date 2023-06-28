//
//  NoticePlayerVideoController.h
//  NoticeXi
//
//  Created by li lei on 2021/11/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePlayerVideoController : UIViewController

@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *linkUrl;
@property (nonatomic, assign) BOOL islocal;
@end

NS_ASSUME_NONNULL_END
