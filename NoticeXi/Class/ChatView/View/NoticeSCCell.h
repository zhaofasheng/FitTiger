//
//  NoticeSCCell.h
//  NoticeXi
//
//  Created by li lei on 2019/1/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoiticePlayerView.h"
#import "NoticeChats.h"
#import "NoticeChangeTextView.h"
#import "NoticeTextView.h"
#import "NoticeShareLinkCell.h"
#import "NoticeWhiteCardChatView.h"
#import "NoticeShareVoiceChatView.h"
#import "NoticeSharePyChatView.h"
#import "NoticeShareLineChatView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeSCDeledate <NSObject>

@optional
- (void)longTapCancelWithSection:(NSInteger)section tag:(NSInteger)tag;
- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section;
- (void)startRePlayAndStop:(NSInteger)tag section:(NSInteger)section;
- (void)beginDrag:(NSInteger)tag section:(NSInteger)section;
- (void)endDrag:(NSInteger)tag section:(NSInteger)section;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag section:(NSInteger)section;
- (void)failReSend:(NSInteger)section row:(NSInteger)row chatM:(NoticeChats *)chat;
- (void)failReSendchatM:(NoticeChats *)chat;

@end

@interface NoticeSCCell : BaseCell<NoticePlayerNumbersDelegate>
@property (nonatomic, weak) id<NoticeSCDeledate>delegate;
@property (nonatomic, strong) YYAnimatedImageView *sendImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UIButton *failButton;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) NoticeChats *chat;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, assign) BOOL needHelp;
@property (nonatomic, assign) BOOL noLongTap;
@property (nonatomic, assign) BOOL isServeChat;
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, strong) NSIndexPath *currentPath;
@property (nonatomic, strong) NSMutableArray *lagerPhotoArr;
@property (nonatomic,copy) void (^refreshHeightBlock)(NSIndexPath *indxPath);
@property (nonatomic, strong) NoticeShareLinkCell *linkView;
@property (nonatomic, strong) NoticeTextView *contentL;
@property (nonatomic, strong) UIView *contentVL;
@property (nonatomic, strong) UIImageView *threeImageView;

@property (nonatomic, strong) NoticeWhiteCardChatView *cardView;
@property (nonatomic, strong) NoticeShareVoiceChatView *shareVoiceView;
@property (nonatomic, strong) NoticeShareLineChatView *shareLineView;
@property (nonatomic, strong) NoticeSharePyChatView *sharepyView;

@property (nonatomic, strong) UIView *sendLevelView;
@property (nonatomic, strong) UIImageView *sendIconImageView;
@property (nonatomic, strong) UILabel *sendNameL;

@property (nonatomic, strong) NSString *mangagerCode;
@end

NS_ASSUME_NONNULL_END
