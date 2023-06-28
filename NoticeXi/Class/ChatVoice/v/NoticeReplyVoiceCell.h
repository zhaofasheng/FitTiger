//
//  NoticeReplyVoiceCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceChat.h"
#import "NoticeVoiceListModel.h"
#import "NoticeShareLinkCell.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeReplyDeleteAndPoliceDeleage <NSObject>
@optional
- (void)longTapWithIndex:(NSInteger)index;
- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section;
- (void)dissMissTap;

- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
@end

@interface NoticeReplyVoiceCell : BaseCell<NoticeRecordDelegate,NoticePlayerNumbersDelegate,NewSendTextDelegate>
@property (nonatomic, strong) UIImageView *sendImageView;
@property (nonatomic, strong) NoticeVoiceChat *chat;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id<NoticeReplyDeleteAndPoliceDeleage>delegate;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) NoticeShareLinkCell *linkView;
@property (nonatomic, copy)  void(^dissMissTapBlock)(BOOL diss);
@end

NS_ASSUME_NONNULL_END
