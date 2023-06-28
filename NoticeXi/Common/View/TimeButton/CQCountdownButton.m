//
//  CQCountdownButton.m
//  CQCountdownButton
//
//  Created by 蔡强 on 2018/3/8.
//  Copyright © 2018年 kuaijiankang. All rights reserved.
//

#import "CQCountdownButton.h"

@interface CQCountdownButton ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CQCountdownButton {
    // 剩余倒计时
    NSInteger _restCountDownNum;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setAction{
    [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
}

// 按钮点击
- (void)onClick {
    if ([self.dataSource respondsToSelector:@selector(startCountdownNumOfCountdownButton:)]) {
        _restCountDownNum = [self.dataSource startCountdownNumOfCountdownButton:self];
    }
    if ([self.delegate respondsToSelector:@selector(countdownButtonDidClick:)]) {
        [self.delegate countdownButtonDidClick:self];
    }
}

// 开始倒计时
- (void)startCountDown {
    if (self.timer) {
        [self releaseTimer];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshButton) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 刷新按钮
- (void)refreshButton {
    _restCountDownNum --;
    
    if ([self.delegate respondsToSelector:@selector(countdownButtonDidCountdown:withRestCountdownNum:)]) {
        [self.delegate countdownButtonDidCountdown:self withRestCountdownNum:_restCountDownNum];
    }
    
    if (_restCountDownNum == 0) {
        [self releaseTimer];
        
        if ([self.delegate respondsToSelector:@selector(countdownButtonDidEndCountdown:)]) {
            [self.delegate countdownButtonDidEndCountdown:self];
        }
        
    }
}

- (void)releaseTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc {
    NSLog(@"倒计时按钮已释放");
}

@end
