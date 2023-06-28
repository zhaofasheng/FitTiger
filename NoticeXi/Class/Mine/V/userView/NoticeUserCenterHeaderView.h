//
//  NoticeUserCenterHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeLelveImageView.h"
#import "NoticeAddCustumeMusicView.h"
#import "CBAutoScrollLabel.h"
#import "SPActivityIndicatorView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserCenterHeaderView : UIView
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *introL;
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) LGAudioPlayer *musicPlayer;
@property (nonatomic, strong) NoticeCustumMusiceModel *currentModel;
@property (nonatomic, strong) UILabel *noWaveL;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, assign) BOOL isNoReplay;//不需要循环播放
@property (nonatomic, strong) UILabel *careL;
@property (nonatomic, strong) UILabel *bCareL;
@property (nonatomic, strong) UILabel *dayL;
@property (nonatomic, strong) UILabel *admireL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *timeMarkL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *timesL;
@property (nonatomic,copy) void (^changeIcon)(BOOL changeIcon);
@property (nonatomic,copy) void (^playMusic)(BOOL play);
@property (nonatomic, assign) BOOL needToum;
@property (nonatomic, strong) UIImageView *markImage;

@property (nonatomic, strong) NoticeAddCustumeMusicView *custumeMusicView;
@property (nonatomic, strong) UIButton *musicListButton;
@property (nonatomic, strong) UIView *playBackView;
@property (nonatomic, strong) UIButton *addMusicBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) CBAutoScrollLabel *songNameL;
@property (nonatomic, strong) NSMutableArray *musicArr;
@property (nonatomic, strong) SPActivityIndicatorView *leftAct;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSString *listName;
- (void)playTap;
- (void)rePlay;
- (void)iconTapBig;
@end

NS_ASSUME_NONNULL_END
