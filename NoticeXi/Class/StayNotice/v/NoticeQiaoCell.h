//
//  NoticeQiaoCell.h
//  NoticeXi
//
//  Created by li lei on 2023/3/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeStaySys.h"
#import "NoticeShareLinkCell.h"
#import "YYKit.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeQiaoqiaoDeledate <NSObject>
@optional
- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section;

- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;

@end


@interface NoticeQiaoCell : BaseCell<NoticePlayerNumbersDelegate>
@property (nonatomic, strong) NoticeStaySys *qiaoModel;
@property (nonatomic, copy) void(^longtapBlock)(NoticeStaySys *stay);
@property (nonatomic, strong) UIImageView *helpImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NoticeShareLinkCell *linkView;
@property (nonatomic, strong) UIImageView *chatIntoImageView;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) UILabel *readNumL;
@property (nonatomic, strong) YYAnimatedImageView *sendImageView;
@property (nonatomic, weak)  id<NoticeQiaoqiaoDeledate>delegate;
@end

NS_ASSUME_NONNULL_END
