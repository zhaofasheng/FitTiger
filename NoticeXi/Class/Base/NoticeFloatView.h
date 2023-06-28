//
//  NoticeFloatView.h
//  NoticeXi
//
//  Created by li lei on 2020/3/2.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeClockPyModel.h"
#import "HWCircleView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^PlayNextBlock)(void);

typedef void(^PlayCompleteBlock)(void);

typedef void(^StartPlayingBlock)(AVPlayerItemStatus status, CGFloat duration);

typedef void(^AudioPlayingBlock)(CGFloat currentTime);

@protocol NoticeAssestDelegate <NSObject>

@optional
- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing;//1 暂停 2 播放  3停止
- (void)iconTapAssest;
@end

@interface NoticeFloatView : UIImageView
@property (nonatomic, weak) id <NoticeAssestDelegate>assestDelegate;
@property (nonatomic, strong) UIButton *rateButton;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NSString *avatrUrl;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isOut;
@property (nonatomic, assign) BOOL noPushUserCenter;//不允许点击头像
@property (nonatomic, assign) BOOL isNoRefresh;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSMutableArray *voiceArr;
@property (nonatomic, strong) NSMutableArray *pyArr;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, assign) BOOL noRePlay;
@property (nonatomic, strong) NoticeVoiceListModel *currentModel;
@property (nonatomic, strong) NoticeClockPyModel *currentPyModel;
- (void)refreshBack;
- (void)playClick;
/**
 播放完成回调
 */
@property (nonatomic, copy) PlayCompleteBlock playComplete;
/**
 开始播放回调
 */
@property (nonatomic, copy) StartPlayingBlock startPlaying;

@property (nonatomic, copy) AudioPlayingBlock playingBlock;

@property (nonatomic, weak) HWCircleView *progressView;

@property (nonatomic, copy) PlayNextBlock playNext;
@end

NS_ASSUME_NONNULL_END
