//
//  NoticeCalenderPlayerView.h
//  NoticeXi
//
//  Created by li lei on 2019/12/31.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NoticeCanclderStopOrLookDelegate <NSObject>
@optional
- (void)StopOrLookClick:(BOOL)isStop;
@end

@interface NoticeCalenderPlayerView : UIView
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, weak) id<NoticeCanclderStopOrLookDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
