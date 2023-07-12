//
//  NoticeTeamChatCell.h
//  NoticeXi
//
//  Created by li lei on 2023/6/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeTeamChatModel.h"
#import "NoticeClickHeaderTeamView.h"
#import "NoticeUseTextView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticePlayTapDeledate <NSObject>
@optional

- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section;
- (void)startRePlayAndStop:(NSInteger)tag section:(NSInteger)section;

@end

@interface NoticeTeamChatCell : BaseCell<NoticePlayerNumbersDelegate>
@property (nonatomic, strong) NoticeTeamChatModel *chatModel;
@property (nonatomic, weak) id<NoticePlayTapDeledate>delegate;
@property (nonatomic, strong) NSIndexPath *currentPath;
@property (nonatomic,copy) void (^refreshHeightBlock)(NSIndexPath *indxPath);
@property (nonatomic,copy) void (^clickHeaderBlock)(BOOL hideKeyBord);
@property (nonatomic,copy) void (^replyMsgBlock)(NoticeTeamChatModel *useMsgModel);
@property (nonatomic,copy) void (^reSendMsgBlock)(NoticeTeamChatModel *MsgModel);
@property (nonatomic, strong) YYAnimatedImageView *sendImageView;//图片消息
@property (nonatomic, strong) UIImageView *iconImageView;//头像
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIButton *failButton;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) NoticeClickHeaderTeamView *iconClickView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSString *isjoin;
@property (nonatomic, copy) void (^locationUseBlock)(NoticeTeamChatModel *locationgMsg);
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NoticeUseTextView *replyMsgView;
@property (nonatomic, strong) NSMutableArray *photoArr;
@end

NS_ASSUME_NONNULL_END
