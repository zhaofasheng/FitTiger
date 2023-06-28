//
//  CQCountdownButton.h
//  CQCountdownButton
//
//  Created by 蔡强 on 2018/3/8.
//  Copyright © 2018年 kuaijiankang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CQCountdownButton;

@protocol CQCountDownButtonDataSource <NSObject>

// 设置起始倒计时秒数
- (NSInteger)startCountdownNumOfCountdownButton:(CQCountdownButton *)countdownButton;

@end

@protocol CQCountDownButtonDelegate <NSObject>

// 倒计时按钮点击时回调
- (void)countdownButtonDidClick:(CQCountdownButton *)countdownButton;
// 倒计时过程中的回调
- (void)countdownButtonDidCountdown:(CQCountdownButton *)countdownButton withRestCountdownNum:(NSInteger)restCountdownNum;
// 倒计时结束时的回调
- (void)countdownButtonDidEndCountdown:(CQCountdownButton *)countdownButton;

@end

@interface CQCountdownButton : UIButton

@property (nonatomic, weak) id <CQCountDownButtonDataSource> dataSource;
@property (nonatomic, weak) id <CQCountDownButtonDelegate> delegate;

- (void)setAction;
- (void)onClick;
/** 开始倒计时 */
- (void)startCountDown;
/** 释放timer */
- (void)releaseTimer;

@end
