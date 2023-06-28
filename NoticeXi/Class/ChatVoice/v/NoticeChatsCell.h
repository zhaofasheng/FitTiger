//
//  NoticeChatsCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeChats.h"
#import "YYKit.h"
#import "NoticeShareLinkCell.h"
@protocol NoticeLongTapDeledate <NSObject>
@optional
- (void)deleteWithIndex:(NSInteger)tag section:(NSInteger)section;
- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section;
- (void)startRePlayAndStop:(NSInteger)tag section:(NSInteger)section;
- (void)dissMissList;
- (void)beginDrag:(NSInteger)tag section:(NSInteger)section;
- (void)endDrag:(NSInteger)tag section:(NSInteger)section;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag section:(NSInteger)section;
- (void)dissMissTap;
- (void)clickBigImageDelegete;
- (void)failReSendchatM:(NoticeChats *_Nullable)chat;
@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChatsCell : BaseCell<NoticePlayerNumbersDelegate>
@property (nonatomic, weak) id<NoticeLongTapDeledate>delegate;
@property (nonatomic, strong) NoticeChats *chat;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, assign) BOOL needMark;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) NoticeShareLinkCell *linkView;
@property (nonatomic, strong) YYAnimatedImageView *sendImageView;
@property (nonatomic, strong) UIButton *failButton;
@property (nonatomic, assign) BOOL isLead;//新手指南
@end

NS_ASSUME_NONNULL_END
