//
//  NoticeUserVoiceCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceListModel.h"
#import "NoiticePlayerView.h"
#import "NoticeVoiceImgList.h"
#import "NoticeUserMoview.h"
#import "NoticeSayToSelf.h"
NS_ASSUME_NONNULL_BEGIN
@protocol NoticeUserVoiceClickDelegate <NSObject>
@optional
- (void)userstartPlayAndStop:(NSInteger)tag;
- (void)userstartRePlayer:(NSInteger)tag;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
- (void)deleteVoiceSelf:(NSInteger)index;
@end
@interface NoticeUserVoiceCell : BaseCell
@property (nonatomic, strong) NoticeVoiceListModel *voiceM;
@property (nonatomic, strong) UILabel *topiceLabel;
@property (nonatomic, strong) NoticeVoiceImgList *imageViewS;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *dateL;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, weak) id<NoticeUserVoiceClickDelegate>delegate;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NoticeUserMoview *movieV;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, assign) BOOL isSay;
@property (nonatomic, strong) NoticeSayToSelf *sayModel;
@property (nonatomic, strong) UILabel *contentTextL;
@property (nonatomic, strong) UILabel *titleL;
@end

NS_ASSUME_NONNULL_END
