//
//  NoticeVoteView.h
//  NoticeXi
//
//  Created by li lei on 2020/11/23.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NoticeClockPyModel.h"

#define SCREEN_W                 [UIScreen mainScreen].bounds.size.width
#define SCREEN_H                 [UIScreen mainScreen].bounds.size.height
#define kMainWindow              [UIApplication sharedApplication].keyWindow
NS_ASSUME_NONNULL_BEGIN


@interface NoticeVoteView : UIView
@property (nonatomic, copy) void (^clickBlock)(NSInteger type);

@property (nonatomic, strong) NoticeClockPyModel *pyModel;
/// 是否取消 消失的动画效果 默认NO
@property (nonatomic, assign) BOOL isAnimation;

/// 显示
-(void)showWithView:(UIView *)view;
/// 移除
- (void)dismiss;

@property (nonatomic, strong) YYAnimatedImageView *sendImageView;
@property (nonatomic, strong) UIView *keyBackView;
@property (nonatomic, strong) UIImageView *backImageView;
/// 自动计算上下尖头
@property (nonatomic) CGFloat top_H;

@property (nonatomic, strong) UIImageView *tianshiImgView;
@property (nonatomic, strong) UILabel *tsL;
@property (nonatomic, strong) UIImageView *moguiImgView;
@property (nonatomic, strong) UILabel *mgL;
@property (nonatomic, strong) UIImageView *shenImgView;
@property (nonatomic, strong) UILabel *sL;
@end

NS_ASSUME_NONNULL_END
