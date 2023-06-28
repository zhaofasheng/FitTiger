//
//  NoticePhotoToolsView.h
//  NoticeXi
//
//  Created by li lei on 2019/6/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSmallArrModel.h"
#import "NoticeTimeFunView.h"
#import "LGAudioPlayer.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePhotoToolsView : UIView<NoticeFunTimeListDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NoticeTimeFunView *funView;
@property (nonatomic, strong) NoticeVoiceListModel *currentModel;
@property (nonatomic,strong) UISlider * slider;
@property (nonatomic, strong) UILabel *minTimeLabel;
@property (nonatomic, strong) UILabel *maxTimeLabel;
@property (nonatomic, strong)  UIButton *playButton;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *playBcakView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,copy) void (^hideBlock)(BOOL backHide);
@end

NS_ASSUME_NONNULL_END
