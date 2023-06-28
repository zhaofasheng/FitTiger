//
//  NoticeMerchHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2021/11/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeOpenTbModel.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "ADBannerAutoPlayView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMerchHeaderView : UIView<ADBannerAutoPlayViewDelegate>

@property (nonatomic, strong) NoticeOpenTbModel *model;

@property (nonatomic, strong) SelVideoPlayer *player;
@property (nonatomic, strong) UILabel *descL;
@property (nonatomic, strong) UIButton *lookBtn;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) ADBannerAutoPlayView *scroImgView;
@end

NS_ASSUME_NONNULL_END
