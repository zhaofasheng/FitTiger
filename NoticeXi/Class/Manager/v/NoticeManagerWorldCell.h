//
//  NoticeManagerWorldCell.h
//  NoticeXi
//
//  Created by li lei on 2019/9/4.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoiticePlayerView.h"
#import "NoticeVoiceListModel.h"
#import "NoticeManagerImgList.h"
#import "NoticeMoivceInCell.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeManagerVoiceListClickDelegate <NSObject>
@optional
- (void)hasClickShareWith:(NSInteger)tag;
- (void)hasClickMoreWith:(NSInteger)tag;
- (void)hasClickReplyWith:(NSInteger)tag;
- (void)startPlayAndStop:(NSInteger)tag;
- (void)startRePlayer:(NSInteger)tag;
- (void)stopPlay;
- (void)otherPinbSuccess;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
- (void)readPointSetSuccess:(NSInteger)index;
- (void)editSuccess:(NSInteger)index;
@end

@interface NoticeManagerWorldCell : BaseCell<NoticePlayerNumbersDelegate>
@property (nonatomic, weak) id<NoticeManagerVoiceListClickDelegate>delegate;
@property (nonatomic, strong) NoticeVoiceListModel *worldM;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIButton *priBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) NoticeManagerImgList *imgListView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NoticeMoivceInCell *movieView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UILabel *contentL;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) UIView *contentVL;
@property (nonatomic, strong) UIView *buttonEditView;

@property (nonatomic, strong) UILabel *textContentLabel;
@end

NS_ASSUME_NONNULL_END
