//
//  NoticeSetSecondPWController.h
//  NoticeXi
//
//  Created by li lei on 2020/4/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSetSecondPWController : UIViewController
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, assign) BOOL isFromMain;
@property (nonatomic,copy) void (^checkModelBlock)(NoticeAbout *aboutM);
@property (nonatomic, strong) NoticeAbout *aboutM;
@end

NS_ASSUME_NONNULL_END
