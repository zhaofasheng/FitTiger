//
//  NoticeRoundArmView.h
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeRoundArmView : UIView<CAAnimationDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *ruondImageView;
@property (nonatomic, assign) BOOL isAnationm;
@property (nonatomic, assign) CGFloat circleAngle;
@property (nonatomic, strong) NSString *whiteColor;
@property (nonatomic, strong) NSString *nightColor;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) void (^hideBlock)(BOOL hide);
@property (nonatomic, copy) void (^timeBlock)(NSInteger typeTime,NSInteger allTime,NSString *whiteColor,NSString *nightColor);//1:学习  2:躺尸 3：活动拉伸  4培养兴趣  5:刷最近追的剧 6阅读 7游戏
- (void)showTostView;
@end

NS_ASSUME_NONNULL_END
