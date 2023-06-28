//
//  NoticeByPersonCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeNearPerson.h"
@protocol NoticeNearByClickDelegate <NSObject>
@optional
- (void)startPlayAndStop:(NSInteger)tag;
- (void)beginDrag:(NSInteger)tag;
- (void)endDrag:(NSInteger)tag;
- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag;
@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeByPersonCell : BaseCell<NoticePlayerNumbersDelegate>
@property (nonatomic, strong) NoticeNearPerson *person;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *storyL;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, weak) id <NoticeNearByClickDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
