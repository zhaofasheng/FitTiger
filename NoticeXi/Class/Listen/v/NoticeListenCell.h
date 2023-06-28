//
//  NoticeListenCell.h
//  NoticeXi
//
//  Created by li lei on 2018/11/7.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeWeb.h"
#import "NoticeLeaderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeListenCell : BaseCell
@property (nonatomic, strong) NoticeWeb *web;
@property (nonatomic, strong) NoticeLeaderModel *leadM;
@property (nonatomic, strong) UIImageView *iamgeView;
@property (nonatomic, strong) UIImageView *markView;
@end

NS_ASSUME_NONNULL_END
