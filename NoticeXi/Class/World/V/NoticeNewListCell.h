//
//  NoticeNewListCell.h
//  NoticeXi
//
//  Created by li lei on 2021/3/30.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceImgList.h"
#import "NoiticePlayerView.h"
#import "NoticeVoicePinbi.h"
#import "NoticeClipImage.h"
#import "NoticeLelveImageView.h"
#import "NoticeMoivceInCell.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeBgmHasChoiceShowView.h"
@protocol NoticeNewVoiceListClickDelegate <NSObject>
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
@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewListCell : BaseCell<NoticePlayerNumbersDelegate,NoticePinbiClickSuccess,NoticeRecordDelegate,NewSendTextDelegate,NoticeBBSComentInputDelegate>
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, weak) id<NoticeNewVoiceListClickDelegate>delegate;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL noPushTopic;
@property (nonatomic, assign) BOOL isHotLove;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, assign) BOOL isNoShowResouce;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) UIView *topicView;
@property (nonatomic, strong) UIImageView *hsButton;
@property (nonatomic, strong) UIImageView *sendBGBtn;
@property (nonatomic, strong) UIView *hsBackView;
@property (nonatomic, strong) UIView *bgBackView;
@property (nonatomic, strong) NoticeBgmHasChoiceShowView *bgmChoiceView;
@property (nonatomic, strong) UIView *comBackView;
@property (nonatomic, strong) UIImageView *comImagV;
@property (nonatomic, strong) UILabel *comNumL;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) UILabel *bingGL;
@property (nonatomic, strong) UILabel *hsL;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) NoticeMoivceInCell *movieView;
@property (nonatomic, strong) UILabel *contentTextL;
@property (nonatomic, assign) BOOL isGoToMovie;
@property (nonatomic, assign) BOOL isShareVoice;
@property (nonatomic, assign) CGFloat btnWdth;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UIButton *rePlayView;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@property (nonatomic, assign) BOOL needTouming;
@property (nonatomic, strong) UILabel *topL;
@property (nonatomic, strong) SelVideoPlayer *player;
@property (nonatomic, strong) SelPlayerConfiguration *configuration;
@property (nonatomic, strong) UIImageView *videoImageView;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIImageView *statsImgV;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIImageView *numImageView;
@property (nonatomic, strong) UILabel *redNumL;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, strong) UIView *commentView;

@end

NS_ASSUME_NONNULL_END
