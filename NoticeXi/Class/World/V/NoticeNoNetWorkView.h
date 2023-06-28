//
//  NoticeNoNetWorkView.h
//  NoticeXi
//
//  Created by li lei on 2021/12/14.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNoNetWorkView : UIView
@property (nonatomic, strong) NSTimer *waitTimer;
@property (nonatomic, assign) NSInteger time;
- (void)show;
- (void)dissMiss;
@end

NS_ASSUME_NONNULL_END
