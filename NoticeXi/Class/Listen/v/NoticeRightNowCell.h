//
//  NoticeRightNowCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/9.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceListModel.h"
#import "NoiticePlayerView.h"
#import "NoticeVoiceImageView.h"

@protocol NoticeRightNowCellDelegate <NSObject>

- (void)policeWith:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeRightNowCell : BaseCell

@property (nonatomic, weak) id <NoticeRightNowCellDelegate>delegate;

@property (nonatomic, strong) NoticeVoiceListModel *rightNow;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) NoiticePlayerView *playerView;
@property (nonatomic, strong) UIButton *topiceButton;
@property (nonatomic, strong) NoticeVoiceImageView *imageViewS;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
