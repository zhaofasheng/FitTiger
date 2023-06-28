//
//  NoticeTestFinishView.h
//  NoticeXi
//
//  Created by li lei on 2021/6/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTestFinishView : UIView
@property (nonatomic, strong)  UIImageView *backImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *mainL;
@property (nonatomic, strong) UILabel *subL;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, copy) void (^hideBlock)(BOOL hideToPush);
- (instancetype)initWithShowUserInfo;
- (void)showChoiceView;
@end

NS_ASSUME_NONNULL_END
