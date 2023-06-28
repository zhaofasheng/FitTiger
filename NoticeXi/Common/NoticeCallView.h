//
//  NoticeCallView.h
//  NoticeXi
//
//  Created by li lei on 2023/3/24.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCustomButton.h"
#import "NoticeChatingInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCallView : UIView
@property (nonatomic, strong) NSString *fromUserId;
@property (nonatomic, strong) FSCustomButton *mirButton;
@property (nonatomic, strong) FSCustomButton *muteButton;
@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) NoticeChatingInfoModel *chatInfoModel;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, assign) BOOL isSpeaker;
@property (nonatomic, assign) BOOL closeMicrophone;
@property (nonatomic, assign) BOOL isWaiting;
@property (nonatomic, assign) BOOL isShopSelf;//自己是否是店主
@property (nonatomic, strong) UIImageView *shopIconImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *timeOutL;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, copy) NSString * __nullable timerName;
@property (nonatomic, strong) UILabel *noticeL;
- (void)setUserVolume:(CGFloat)userVolume;
- (void)setShopVolume:(CGFloat)shopVolume;
- (void)showCallView;
- (void)refreshStars;
@end

NS_ASSUME_NONNULL_END
