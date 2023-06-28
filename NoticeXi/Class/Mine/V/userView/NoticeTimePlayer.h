//
//  NoticeTimePlayer.h
//  NoticeXi
//
//  Created by li lei on 2018/12/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceListModel.h"
#import "LGAudioPlayer.h"
#import "WMPageController.h"
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeTimeListPlayDelegate <NSObject>
@optional
- (void)showTimeListDelegate;
- (void)currentPlayModel:(NoticeVoiceListModel*)currentModel;
- (void)noDataClick;
@end

@interface NoticeTimePlayer : UIView

@property (nonatomic, weak)  id<NoticeTimeListPlayDelegate>delegate;
@property (nonatomic, strong) NoticeAbout *realisAbout;
@property (nonatomic,strong) UISlider * slider;
@property (nonatomic, strong) UILabel *minTimeLabel;
@property (nonatomic, strong) UILabel *maxTimeLabel;
@property (nonatomic, strong)  UIButton *playButton;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) NoticeVoiceListModel *currentModel;
@property (nonatomic, strong) UILabel *noDataView;
@property (nonatomic, assign) BOOL needPasue;
@property (nonatomic, assign) BOOL needStop;
@property (nonatomic, assign) BOOL needPass;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, strong)  UIButton *typeButton;
@property (nonatomic, strong) NSMutableArray *voiceArr;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) NSString *playType;
@property (nonatomic, strong) UIImageView *lockImageV;

@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *timeStart;
@property (nonatomic, assign) BOOL isFirstGetIn;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) BOOL needReMemeber;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSString *zjId;

@property (nonatomic, strong) UILabel *textL;

- (void)choicePlay:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
