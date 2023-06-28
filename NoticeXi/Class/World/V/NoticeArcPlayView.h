//
//  NoticeArcPlayView.h
//  NoticeXi
//
//  Created by li lei on 2021/9/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceImgList.h"
#import "NoticeVoicePinbi.h"
#import "SVGA.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeARCVoiceClickDelegate <NSObject>
@optional
- (void)hasClickShareWith:(NSInteger)tag;
- (void)hasClickMoreWith:(NSInteger)tag;
- (void)hasClickReplyWith:(NSInteger)tag;
- (void)startPlayAndStop:(NSInteger)tag;
- (void)startRePlayer:(NSInteger)tag;
- (void)stopPlay;
- (void)otherPinbSuccess;
- (void)noGuanzhuSuccess:(NSInteger)index;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
- (void)clickHS:(NoticeVoiceListModel *_Nullable)hsVoiceModel;
- (void)moreMarkSuccess;
- (void)closeTap;
@end

@interface NoticeArcPlayView : UIImageView<NoticePlayerNumbersDelegate,NoticePinbiClickSuccess,NoticeRecordDelegate,NewSendTextDelegate>
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) UIImageView *hsButton;
@property (nonatomic, strong) UIImageView *sendBGBtn;
@property (nonatomic, strong) UIView *hsBackView;
@property (nonatomic, strong) UIView *bgBackView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UIButton *rePlayView;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@property (nonatomic, strong) UILabel *bingGL;
@property (nonatomic, strong) UILabel *hsL;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, weak) id <NoticeARCVoiceClickDelegate>delegate;

@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) SVGAPlayer *svagPlayer;
@end

NS_ASSUME_NONNULL_END
