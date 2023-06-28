//
//  NoticeMBSPlayerView.h
//  NoticeXi
//
//  Created by li lei on 2019/12/31.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol NoticeMBSliderDelgete <NSObject>

@optional
- (void)clickPlayAndStopButton;
- (void)handleWitSlider:(UISlider *)slider;
@end

@interface NoticeMBSPlayerView : UIView
@property (nonatomic, weak) id <NoticeMBSliderDelgete>delegate;
@property (nonatomic,strong) UISlider * slider;
@property (nonatomic, strong) UILabel *minTimeLabel;
@property (nonatomic, strong) UILabel *maxTimeLabel;
@property (nonatomic, strong)  UIButton *playButton;
- (void)setVoiceModel:(NoticeVoiceModel *)model;
- (void)setCurrentTime:(CGFloat)currentTime voiceM:(NoticeVoiceModel *)voiceM;
@end

NS_ASSUME_NONNULL_END
