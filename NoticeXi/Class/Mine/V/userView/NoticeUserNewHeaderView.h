//
//  NoticeUserNewHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeLelveImageView.h"
#import "CBAutoScrollLabel.h"
#import "NoticeCustumMusiceModel.h"
#import "SPActivityIndicatorView.h"
#import "NoticeIconFgView.h"
#import "NoticeStaySys.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserNewHeaderView : UIView
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) UILabel *introL;
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) NoticeUserInfoModel *numberDataM;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) CGFloat progross;
@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UILabel *careL;
@property (nonatomic, strong) UILabel *bCareL;
@property (nonatomic, strong) UILabel *bkNumL;
@property (nonatomic, strong) UILabel *helpNumL;
@property (nonatomic, strong) UILabel *zjNumL;
@property (nonatomic, strong) UILabel *timeMarkL;
@property (nonatomic, strong) UIView *noVoiceView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *titlesView;
@property (nonatomic, strong) UIView *titlesView1;
@property (nonatomic, strong) UILabel *noLikeL;
@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UILabel *num1L;
@property (nonatomic, strong) UILabel *num2L;
@property (nonatomic, strong) UILabel *num3L;
@property (nonatomic, strong) UILabel *num4L;

@property (nonatomic, strong) CBAutoScrollLabel *songNameL;
@property (nonatomic, strong) UIImageView *playIconImageView;
@property (nonatomic, strong) UIImageView *playImgV;

@property (nonatomic, strong) LGAudioPlayer *musicPlayer;
@property (nonatomic, strong) NoticeCustumMusiceModel *currentModel;
@property (nonatomic, strong) NSMutableArray *musicArr;

@property (nonatomic, strong) SPActivityIndicatorView *leftAct;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NoticeIconFgView *recFgIconView;
@property (nonatomic, strong) UILabel *recNumL;
@property (nonatomic, strong) NSMutableArray *iconArr;
@property (nonatomic, copy) void(^hasRedViewBlock)(BOOL showRed);
@property (nonatomic, strong) NoticeStaySys *messageModel;
- (void)requestMusicList;
@end

NS_ASSUME_NONNULL_END
