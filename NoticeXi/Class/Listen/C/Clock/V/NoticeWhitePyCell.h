//
//  NoticeWhitePyCell.h
//  NoticeXi
//
//  Created by li lei on 2022/12/15.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeClockPyModel.h"
#import "NoticeClockButtonView.h"
#import "NoticeManager.h"
#import "LXAdvertScrollview.h"
#import "NoticeLelveImageView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticewhiteClockClickDelegate <NSObject>
@optional
- (void)hasClickReplyWith:(NSInteger)tag;
- (void)startPlayAndStop:(NSInteger)tag;
- (void)startRePlayer:(NSInteger)tag;
- (void)stopPlay;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;

- (void)editManager:(NSInteger)tag;
@optional
- (void)delegateSuccess:(NSInteger)index;
- (void)deleteSuccessFor:(NoticeClockPyModel *)deleM;
@end

@interface NoticeWhitePyCell : BaseCell<NoticePlayerNumbersDelegate,NoticeClockButtonDelegate,NoticeManagerUserDelegate,LCActionSheetDelegate>
@property (nonatomic, strong) NoticeClockPyModel *pyModel;
@property (nonatomic, weak) id <NoticewhiteClockClickDelegate>delegate;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *pickerL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isNeedPost;
@property (nonatomic, assign) BOOL isGoToUserCenter;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *mbView;
@property (nonatomic, strong) NoticeManager *magager;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) NoticeClockButtonView *buttonView;
@property (nonatomic, assign) BOOL isTc;//是否是台词
@property (nonatomic, assign) BOOL isSetPicker;//是否是台词
@property (nonatomic, assign) BOOL isTcPage;//是否是台词
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) NSString *managerCode;
@property (nonatomic, strong) UIButton *priBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *allDeleteBtn;
@property (nonatomic, strong) UIView *buttonEditView;
@property (nonatomic, strong) UIImageView *luyinMarkImage;
@property (nonatomic, strong) UILabel *numRecL;
@property (nonatomic, strong) UIImageView *pickImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) BOOL isUserPy;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, assign) BOOL noNeedPush;
@property (nonatomic, assign) BOOL isDisappear;
@property (nonatomic, strong) LXAdvertScrollview *noticeView;
@property (nonatomic, strong) LCActionSheet *selfSheet;
@property (nonatomic, strong) LCActionSheet *otherSheet;
@property (nonatomic, strong) LCActionSheet *selfFirstSheet;
@property (nonatomic, strong) UIView *hotBackView;
@property (nonatomic,copy) void (^deletePyBlock)(NoticeClockPyModel *pyModel);
@property (nonatomic,copy) void (^setNimingBlock)(BOOL isNIming);
@end

NS_ASSUME_NONNULL_END
