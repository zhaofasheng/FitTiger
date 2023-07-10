//
//  NoticeNewVoiceListCell.h
//  NoticeXi
//
//  Created by li lei on 2021/3/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMoivceInCell.h"
#import "NoticeVoicePinbi.h"
#import "NoticeCustumBackImageView.h"
#import "LXAdvertScrollview.h"
#import "NoiticePlayerView.h"
#import "NoticeVoiceImageView.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeVoiceCommentView.h"
#import "NoticeBgmHasChoiceShowView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeNewPlayerVoiceDelegate <NSObject>

@optional
- (void)hasClickShareWith:(NSInteger)tag;
- (void)hasClickMoreWith:(NSInteger)tag;
- (void)hasClickReplyWith:(NSInteger)tag;
- (void)startPlayAndStop:(NSInteger)tag;
- (void)startRePlayer:(NSInteger)tag;
- (void)stopPlay;
- (void)otherPinbSuccess;
- (void)noGuanzhuSuccess:(NSInteger)index;
- (void)addVoiceToZj;

- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
- (void)clickHS:(NoticeVoiceListModel *_Nullable)hsVoiceModel;


@end

@interface NoticeNewVoiceListCell : BaseCell<NoticePlayerNumbersDelegate,NoticePinbiClickSuccess,UIGestureRecognizerDelegate,NoticeBBSComentInputDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) id<NoticeNewPlayerVoiceDelegate>delegate;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UIView *mbView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIButton *hsButton;
@property (nonatomic, strong) UIButton *sendBGBtn;
@property (nonatomic, strong) UIButton *careButton;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) NoticeBgmHasChoiceShowView *bgmChoiceView;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *bgL;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *likeStatusL;
@property (nonatomic, assign) BOOL noPushToUserCenter;
@property (nonatomic, assign) BOOL needMoreBtn;
@property (nonatomic, assign) BOOL noPush;
@property (nonatomic, assign) BOOL hasDownloadImg;
@property (nonatomic, assign) BOOL isMoving;//滑动中不执行播放
@property (nonatomic, assign) CGFloat movIngPointY;
@property (nonatomic,copy) void (^replyClickBlock)(BOOL isReply);
@property (nonatomic, assign) BOOL isSendLy;//是否是留言
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) UIButton *otherMoreBtn;
@property (nonatomic, assign) BOOL isDisappear;
@property (nonatomic, strong) UIImageView *cdplayView;
@property (nonatomic, strong) UIImageView *voicePlayBackImageView;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UIButton *comButton;
@property (nonatomic, strong) NoticeBBSComentInputView *inputView;
@property (nonatomic, strong) UIImageView *numImageView;
@property (nonatomic, strong) UILabel *redNumL;

@property (nonatomic, assign) BOOL isDown;  //YES  下拉
@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UILabel *lyNumL;

@property (nonatomic,strong) UISlider * slider;
@property (nonatomic, strong) UILabel *minTimeLabel;
@property (nonatomic, strong) UILabel *maxTimeLabel;

@property (nonatomic, strong) UIImageView *voiceimageView;
@property (nonatomic, strong) FSCustomButton *numBtn;
@end

NS_ASSUME_NONNULL_END
