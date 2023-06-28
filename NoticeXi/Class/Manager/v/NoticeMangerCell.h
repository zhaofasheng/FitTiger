//
//  NoticeMangerCell.h
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeManagerModel.h"
#import "NoiticePlayerView.h"
#import "NoticeGroupChatModel.h"
#import "NoticeDanMuListModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeManagerVoiceClickDelegate <NSObject>
@optional
- (void)userstartPlayAndStop:(NSInteger)tag;
- (void)userstartRePlayer:(NSInteger)tag;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
- (void)pointSetsuccessindex:(NSInteger)tag;
- (void)otherHeaderWith:(NoticeManagerModel *)model;
@end
@interface NoticeMangerCell : BaseCell
@property (nonatomic, strong) NoticeManagerModel *mangerModel;
@property (nonatomic, strong) NoticeDanMuListModel *danMu;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *contView;
@property (nonatomic, strong) UIImageView *chatImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, weak) id<NoticeManagerVoiceClickDelegate>delegate;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL ishs;
@property (nonatomic, assign) BOOL noTap;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *contentVL;
@property (nonatomic, strong) NoticeGroupChatModel *chatModel;
@end

NS_ASSUME_NONNULL_END
