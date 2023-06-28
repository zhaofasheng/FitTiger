//
//  NoticeListenLocalVoiceView.h
//  NoticeXi
//
//  Created by li lei on 2021/7/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGA.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeListenLocalVoiceView : UIView
@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) SVGAPlayer *svagPlayer;

@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, assign) NSUInteger timeLength;
@property (nonatomic, strong) NSMutableArray *atArr;
@property (nonatomic, strong) LGAudioPlayer *voicePlayer;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL rePlay;
@property (nonatomic, strong) UIButton *recoBtn;
@property (nonatomic, copy) void(^sendBlock)(BOOL sureSend);
- (void)showShareView;
@end

NS_ASSUME_NONNULL_END
