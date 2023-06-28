//
//  NoticeRecoderTryListenView.h
//  NoticeXi
//
//  Created by li lei on 2022/3/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWCircleView.h"
#import "NoticeChangeVoiceView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeRecoderTryListenView : UIView

@property (nonatomic, strong,nullable) NSString *locaPath;
@property (nonatomic, strong) NSString *currentPath;
@property (nonatomic, strong,nullable) NSString *timeLen;
@property (nonatomic,copy) void (^actionBlock)(NSInteger type,NSString *timeLen,NSString *locaPath);//0取消 1重录 2下一步
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) LGAudioPlayer *voicePlayer;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL rePlay;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, weak) HWCircleView *progressView;
@property (nonatomic, strong) NoticeChangeVoiceView *changeView;
@property (nonatomic, strong) NoticeVoiceTypeModel *vocieTypeM;
@property (nonatomic, strong) UIButton *voiceTypeBtn;
@property (nonatomic, strong) UILabel *changeTypeL;
@property (nonatomic, strong) NoticeActShowView *showView;
@property (nonatomic, strong) UIImageView *clickFinishImageView;
@property (nonatomic, assign) BOOL isLead;//新手指南
- (void)show;
@end

NS_ASSUME_NONNULL_END
