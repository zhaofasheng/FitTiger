//
//  NoticeRecoderBoKeVoiceView.h
//  NoticeXi
//
//  Created by li lei on 2022/9/23.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGVoiceRecorder.h"
#import "NoticePointView.h"
#import "NoticeRecoderEditView.h"
#import "NoticeChoiceBgmTypeView.h"
#import "NoticeAudioJoinToAudioModel.h"
#import "NoticeActShowView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeRecoderBoKeVoiceView : UIView
@property (nonatomic, copy) void(^sureFinishBlock)(NSString *path,NSString *tiemLength);
@property (nonatomic, strong) LGVoiceRecorder * __nullable recorder;
@property (nonatomic, assign) NSUInteger audioTimeLen;
@property (nonatomic, assign) BOOL isSureFinish;//确定录制完成
@property (nonatomic, assign) BOOL startRecoder;
@property (nonatomic, assign) BOOL isGiveUp;
@property (nonatomic, assign) BOOL isReRecoder;//删除重新录制
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *minL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *recodImageView;
@property (nonatomic, assign) BOOL isRecoderClick;//重新录制
@property (nonatomic, strong) NSString *localAACUrl; //aac地址
@property (nonatomic, strong) NSTimer * __nullable recordTimer; //录音定时器
@property (nonatomic, assign) BOOL isBeginFromContion;//从暂停录音状态继续录音
@property (nonatomic, assign) BOOL isPauseRecoding;//暂停录音状态
@property (nonatomic, assign) NSInteger oldRecodingTime;//暂停录音时记录当前时间
@property (nonatomic, assign) BOOL isRecoding;//判断是否在录制
@property (nonatomic, assign) NSInteger currentRecodTime;
@property (nonatomic, strong) UILabel *reingLabel;
@property (nonatomic, assign) BOOL isShowFinish;//暂停了显示了完成UI
@property (nonatomic, strong) UILabel *sureLabel;
@property (nonatomic, strong) UIButton *reRecoderBtn;
@property (nonatomic, strong) UILabel *reLabel;
@property (nonatomic, strong) LGAudioPlayer *voicePlayer;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL rePlay;
@property (nonatomic, assign) BOOL hasCutEd;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) NoticePointView * __nullable drawView;
@property (nonatomic, strong) NoticePointView * __nullable drawView1;
@property (nonatomic, strong) NSString * __nullable addAudioPath;
@property (nonatomic, strong) NSString * __nullable bgmPath;
@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) NoticeRecoderEditView *editVoiceView;

@property (nonatomic, strong) UIView *recodBtnView;
@property (nonatomic, strong) UIView *playAndEditView;
@property (nonatomic, strong) NoticeChoiceBgmTypeView *bgmView;
@property (nonatomic, strong) NoticeAudioJoinToAudioModel *audioToAudio;
@property (nonatomic, strong) NoticeActShowView *showView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIView *bgmNameView;
@property (nonatomic, strong) UILabel *bgmNameL;

- (void)show;
@end

NS_ASSUME_NONNULL_END
