//
//  NoticeSayToSelfCell.h
//  NoticeXi
//
//  Created by li lei on 2021/4/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeSayToSelf.h"
#import "NoticeZjDialogModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeSayToSelfClickDelegate <NSObject>
@optional
- (void)userstartPlayAndStop:(NSInteger)tag;
- (void)userstartRePlayer:(NSInteger)tag;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
- (void)deleteVoiceSelf:(NSInteger)index;
- (void)deleteVoiceWithModel:(NoticeSayToSelf *)model;
- (void)moveVoiceWithModel:(NoticeSayToSelf *)model;
@end
@interface NoticeSayToSelfCell : BaseCell<LCActionSheetDelegate>
@property (nonatomic, strong) NoticeSayToSelf *sayModel;
@property (nonatomic, weak) id<NoticeSayToSelfClickDelegate>delegate;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *dateL;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, assign) BOOL needLongTap;
@property (nonatomic, assign) BOOL isDiaLog;
@end

NS_ASSUME_NONNULL_END
