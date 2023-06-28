//
//  NoticeMbsDeatilVoiceCell.h
//  NoticeXi
//
//  Created by li lei on 2022/2/22.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SpectrumView.h"
#import "NoticeMoivceInCell.h"
#import "NoticeVoicePinbi.h"
#import "NoticeCustumBackImageView.h"
#import "LXAdvertScrollview.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeNewPlayerVoiceDelegates <NSObject>

@optional
- (void)clickPlayeButton:(NSInteger)tag;
- (void)stopPlay;
- (void)clickHS:(NoticeVoiceListModel *_Nullable)hsVoiceModel;
- (void)otherPinbSuccess;

- (void)beginTouchPointY:(CGFloat)beginY;//开始触摸时候的点
- (void)movingTouchPointY:(CGFloat)moveY;//滑动中的点
- (void)endTouchPointY:(CGFloat)endY;
- (void)begTapIsUp:(BOOL)isUp;
@end
@interface NoticeMbsDeatilVoiceCell : BaseCell<NoticePinbiClickSuccess,UIGestureRecognizerDelegate>
@property (nonatomic, weak) id<NoticeNewPlayerVoiceDelegates>delegate;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UIView *mbView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIButton *hsButton;
@property (nonatomic, strong) UIButton *sendBGBtn;
@property (nonatomic, strong) UIButton *careButton;
@property (nonatomic, strong) NoticeCustumBackImageView *backImageView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) SpectrumView *spectrumView;
@property (nonatomic, strong) SpectrumView *spectrumView1;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *bgL;
@property (nonatomic, assign) BOOL noPushToUserCenter;
@property (nonatomic, assign) BOOL needMoreBtn;
@property (nonatomic, assign) BOOL noPush;
@property (nonatomic, assign) BOOL hasDownloadImg;
@property (nonatomic, assign) BOOL isMoving;//滑动中不执行播放
@property (nonatomic, assign) CGFloat movIngPointY;
@property (nonatomic,copy) void (^replyClickBlock)(BOOL isReply);
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NoticeMoivceInCell *movieView;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) NoticeVoicePinbi *pinbTools;
@property (nonatomic, strong) UIButton *otherMoreBtn;
@property (nonatomic, strong) NSArray *begTimeArr;
@property (nonatomic, strong) NSArray *liveTimeArr;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) LXAdvertScrollview *noticeView;
@property (nonatomic, assign) BOOL isDisappear;
@end

NS_ASSUME_NONNULL_END
