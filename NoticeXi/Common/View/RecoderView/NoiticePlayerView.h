//
//  NoiticePlayerView.h
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGProgressView.h"


@protocol NoticePlayerNumbersDelegate <NSObject>

@optional
- (void)addPlayersNumbers;
- (void)noPlayerMusic;
- (void)startPlay;
- (void)stopPlay;
- (void)beginP;
- (void)endP;
@end

NS_ASSUME_NONNULL_BEGIN

@interface NoiticePlayerView : UIView
@property (nonatomic, weak) id<NoticePlayerNumbersDelegate>delegate;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) NSArray *animationImages;
@property (nonatomic, strong) NSString *timeLen;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) NSString *voiceUrl;
@property (nonatomic, strong) NSString *currentPlayTime;
@property (nonatomic, strong) GGProgressView *slieView;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL rePlay;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) BOOL isGroupChatSelf;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, assign) BOOL isThird;
@property (nonatomic, assign) BOOL isSendBoke;
@property (nonatomic, assign) BOOL reBackFrame;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL noPalyer;//点击禁止播放
@property (nonatomic, assign) BOOL isSB;
@property (nonatomic, assign) BOOL noNeedLizi;
@property (nonatomic, strong) UILabel *textL;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *leftLine;

@property (nonatomic, strong) CAEmitterLayer *colorBallLayer;

- (void)refreshMoveFrame:(CGFloat)moveX;
- (void)refreWithFrame;
- (void)rePlayAudio;
@end

NS_ASSUME_NONNULL_END
