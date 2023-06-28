//
//  NoticeSaveVoiceCell.h
//  NoticeXi
//
//  Created by li lei on 2022/8/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceSaveModel.h"
#import "NoticeVoiceImgList.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeNewSaveVoiceListDelegate <NSObject>
@optional
- (void)startPlayAndStop:(NSInteger)tag;
- (void)startRePlayer:(NSInteger)tag;
- (void)stopPlay;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag progross:(CGFloat)pro;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;

@end

@interface NoticeSaveVoiceCell : BaseCell
@property (nonatomic, strong) NoticeVoiceSaveModel *saveModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<NoticeNewSaveVoiceListDelegate>delegate;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, strong) UILabel *contentTextL;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) void (^deleteOrSendBlock)(BOOL send,NSInteger index);

@end

NS_ASSUME_NONNULL_END
