//
//  NoticeVoiceListCell.h
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceListModel.h"
#import "NoiticePlayerView.h"
#import "NoticeVoiceImgList.h"
#import "NoticeVoiceListButtonView.h"
#import "NoticeMoivceInCell.h"
#import "NoticeVoicePinbi.h"
#import "NoticeShareToWorld.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"

@protocol NoticeVoiceListClickDelegate <NSObject>
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

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceListCell : BaseCell<NoticeBottomCellDelegate,NewSendTextDelegate,NoticePlayerNumbersDelegate,NoticeRecordDelegate,NoticePinbiClickSuccess,NoticeShareToWorldSuccess>
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NoticeVoiceListModel *friendM;
@property (nonatomic, strong) NoticeVoiceListModel *worldM;
@property (nonatomic, strong) NoticeVoiceListModel *moviceM;
@property (nonatomic, weak) id<NoticeVoiceListClickDelegate>delegate;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) UIImageView *markPlayImageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *topiceButton;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@property (nonatomic, strong) NoticeVoiceListButtonView *buttonView;
@property (nonatomic, strong) UILabel *listenL;
@property (nonatomic, strong) NoticeMoivceInCell *movieView;
@property (nonatomic, assign) BOOL isShowShareTime;
@property (nonatomic, strong) UIImageView *scroImageView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, assign) BOOL isNeedInstead;
@property (nonatomic, assign) BOOL isMovie;
@property (nonatomic, strong) UIView *insteadView;
@property (nonatomic, assign) BOOL isSmallLine;
@property (nonatomic, assign) BOOL needFavietaer;
@property (nonatomic, strong) UILabel *instedL;
@property (nonatomic, strong) UIImageView *instedImageV;
@property (nonatomic, assign) BOOL isWorld;
@property (nonatomic, assign) BOOL isOtherShare;//他人共享心情簿
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) NoticeShareToWorld *shareWorld;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UIButton *bookLikeBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, assign) BOOL isNeedLikeBtn;//是否需要欣赏按钮
@property (nonatomic, assign) BOOL isNeedAllContent;//是否需要显示全部文字
@property (nonatomic, strong) UILabel *textContentLabel;
@property (nonatomic, strong) SelVideoPlayer *player;
@property (nonatomic, strong) SelPlayerConfiguration *configuration;
@property (nonatomic, strong) UIImageView *videoImageView;
@end

NS_ASSUME_NONNULL_END
