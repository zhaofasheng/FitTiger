//
//  NoticeShowNewUserLeader.h
//  NoticeXi
//
//  Created by li lei on 2022/3/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGAudioPlayer.h"
#import "NoticeNewChatVoiceView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeShowNewUserLeader : UIView<NoticeRecordDelegate>
@property (nonatomic, assign) NSInteger type;//任务类型1，发心情，2回声
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UIButton *giveUpBtn;
@property (nonatomic, strong) UIButton *recoBtn;
@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) LGAudioPlayer *voicePlayer;
@property (nonatomic, strong) LGAudioPlayer *noNextPlayer;
@property (nonatomic, strong) UIView *acceptView;
@property (nonatomic, assign) BOOL canNext;
@property (nonatomic, strong) UIView *voiceView;
@property (nonatomic, strong) UIImageView *chatImageV;
@property (nonatomic, strong) NoticeNewChatVoiceView *chatView;
@property (nonatomic, strong) NoticeVoiceListModel *hsVoiceM;
@property (nonatomic, strong) UIImageView *playTapImg;
@property (nonatomic, strong) UIButton *iconBtn;
- (void)show;
- (void)finishShow;
@end

NS_ASSUME_NONNULL_END
