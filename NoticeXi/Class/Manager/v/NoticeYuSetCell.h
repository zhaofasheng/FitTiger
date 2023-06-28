//
//  NoticeYuSetCell.h
//  NoticeXi
//
//  Created by li lei on 2019/9/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeYuSetModel.h"
@protocol NoticeYuSetClickDelegate <NSObject>
@optional
- (void)startPlayAndStop:(NSInteger)tag;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
- (void)reRecord:(NSInteger)index;
- (void)reInput:(NSInteger)index;
@end
NS_ASSUME_NONNULL_BEGIN

@interface NoticeYuSetCell : BaseCell<NoticePlayerNumbersDelegate>

@property (nonatomic, weak) id <NoticeYuSetClickDelegate>delegate;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) NoticeYuSetModel *model;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *reButton;
@property (nonatomic, strong) UIImageView *messageImage;
@end

NS_ASSUME_NONNULL_END
