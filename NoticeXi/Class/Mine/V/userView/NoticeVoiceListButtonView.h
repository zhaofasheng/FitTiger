//
//  NoticeVoiceListButtonView.h
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFireworksButton.h"


@protocol NoticeBottomCellDelegate <NSObject>

- (void)shareAndLikeClick;
- (void)replayClick:(UIButton *_Nullable)button;
- (void)moreClick;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceListButtonView : UIView

@property (nonatomic, weak) id<NoticeBottomCellDelegate>delegate;

@property (nonatomic, strong) MCFireworksButton *firstImageView;
@property (nonatomic, strong) UILabel *firstL;
@property (nonatomic, strong) UIButton *replyBytton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UILabel *thirdL;

- (void)refreshColor;
@end

NS_ASSUME_NONNULL_END
