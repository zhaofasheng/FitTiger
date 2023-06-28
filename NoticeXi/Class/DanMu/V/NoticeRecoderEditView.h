//
//  NoticeRecoderEditView.h
//  NoticeXi
//
//  Created by li lei on 2022/11/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeAudioJoinToAudioModel.h"
#import "GGProgressView.h"
#import "NoticePointView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeRecoderEditView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) NSString *locaPath;
@property (nonatomic, strong) NSString *timeLen;
@property (nonatomic, assign) CGFloat rangWidth;
@property (nonatomic, strong) UIView *rangeView;   //裁剪范围的rang
@property (nonatomic, strong) UIImageView *leftSliderImgView;   //左滑块
@property (nonatomic, strong) UIImageView *rightSliderImgView;  //右滑块
@property (nonatomic, strong) UILabel *minTimeLabel;
@property (nonatomic, strong) UILabel *maxTimeLabel;
@property (nonatomic, assign) CGFloat startTime;            //开始截取的时间
@property (nonatomic, assign) CGFloat endTime;              //结束截取的时间
@property (nonatomic, strong) UIImageView *upOpacityImgView;    //上边白色
@property (nonatomic, strong) UIImageView *downOpacityImgView;  //下班白色
@property (nonatomic, assign) CGFloat timeScale;  //每个像素占多少秒
@property (nonatomic, assign) CGFloat minWidth;   //两个指示器间隔距离最短
@property (nonatomic, strong) UILabel *starL;
@property (nonatomic, strong) UILabel *endL;
@property (nonatomic, assign) CGFloat draFlot;
@property (nonatomic, strong) NoticeAudioJoinToAudioModel *audioToAudio;
@property (nonatomic, strong) NSString * __nullable currentPath;
@property (nonatomic, strong) NSString * __nullable bgmPath;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) LGAudioPlayer *voicePlayer;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL rePlay;
@property (nonatomic, assign) BOOL hasEditEd;
@property (nonatomic, assign) BOOL noNext;
@property (nonatomic, assign) CGFloat contentX;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) GGProgressView *slieView;
@property (nonatomic, copy) void(^sureFinishBlock)(NSString *path,NSString *tiemLength,BOOL hasCut);

@property (nonatomic, strong) NSMutableArray *pointArray;
@property (nonatomic, strong) NoticePointView * __nullable drawView;
@property (nonatomic, strong) NoticePointView * __nullable drawView1;
@property (nonatomic, strong) UIImageView *lineImageView;
@end

NS_ASSUME_NONNULL_END
