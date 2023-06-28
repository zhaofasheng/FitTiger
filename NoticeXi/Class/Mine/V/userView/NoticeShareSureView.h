//
//  NoticeShareSureView.h
//  NoticeXi
//
//  Created by li lei on 2022/5/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeFriendAcdModel.h"
#import "NoticeClockPyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShareSureView : UIView
- (void)showTost;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) NoticeClockPyModel *pyModel;
@property (nonatomic, strong) NoticeFriendAcdModel *userM;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeClockPyModel *tcModel;
@property (nonatomic, strong) UIImageView *toiconImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *toNameL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *typeL;

@property (nonatomic, copy) void(^dissMissBlock)(BOOL diss);
@end

NS_ASSUME_NONNULL_END
