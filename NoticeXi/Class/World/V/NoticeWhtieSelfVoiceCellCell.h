//
//  NoticeWhtieSelfVoiceCellCell.h
//  NoticeXi
//
//  Created by li lei on 2022/11/9.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceImgList.h"
#import "NoticeShareToWorld.h"
#import "NoticeVoicePinbi.h"
#import "NoticeMoivceInCell.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeBgmHasChoiceShowView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeWhiteSelfVoiceListClickDelegate <NSObject>
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

- (void)clickHS:(NoticeVoiceListModel *)hsVoiceModel;
@end

@interface NoticeWhtieSelfVoiceCellCell : BaseCell<NoticeShareToWorldSuccess,NoticePinbiClickSuccess,LCActionSheetDelegate,NoticeBBSComentInputDelegate>
@property (nonatomic, weak) id<NoticeWhiteSelfVoiceListClickDelegate>delegate;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) UIView *topicView;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UILabel *contentTextL;

@property (nonatomic, strong) UIView *comBackView;
@property (nonatomic, strong) UIImageView *comImagV;
@property (nonatomic, strong) UILabel *comNumL;


@property (nonatomic, strong) UILabel *dialNumL;
@property (nonatomic, assign) BOOL noShowTop;
@property (nonatomic, assign) BOOL noShowShareStatus;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL noPushToToice;
@property (nonatomic, assign) BOOL needlongTap;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) NoticeShareToWorld *shareWorld;
@property (nonatomic, strong) UIButton *hsButton;
@property (nonatomic, strong) UIButton *sendBGBtn;
@property (nonatomic, strong) UIButton *otherMoreBtn;
@property (nonatomic, strong) UIButton *hadAddBtn;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIImageView *addZJImageView;
@property (nonatomic, strong) UILabel *bgL;
@property (nonatomic, assign) BOOL isAddToZj;//是否是添加心情到专辑页面
@property (nonatomic, assign) BOOL isShareVoice;
@property (nonatomic, strong) NSString *zjmodelId;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic,copy) void (^joinSuccessBlock)(BOOL join);
@property (nonatomic, strong) UILabel *shareL;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) NoticeMoivceInCell *movieView;
@property (nonatomic,copy) void (^deleteVoiceFromZj)(NoticeVoiceListModel *voiceM);
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, assign) BOOL hasJoinCurrentZj;
@property (nonatomic, assign) BOOL needTouMing;
@property (nonatomic, assign) BOOL isPaixuByShare;
@property (nonatomic, strong) UIButton *rePlayView;
@property (nonatomic, strong) SelVideoPlayer *player;
@property (nonatomic, strong) SelPlayerConfiguration *configuration;
@property (nonatomic, strong) UIImageView *videoImageView;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIImageView *statsImgV;
@property (nonatomic, strong) UILabel *statusL;

@property (nonatomic, strong) UIImageView *numImageView;
@property (nonatomic, strong) UILabel *redNumL;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, strong) UIView *commentView;

@property (nonatomic, strong) NoticeBgmHasChoiceShowView *bgmChoiceView;

@property (nonatomic, strong) NSString *albumId;
@end

NS_ASSUME_NONNULL_END
