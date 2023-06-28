//
//  NoticePowerCell.h
//  NoticeXi
//
//  Created by li lei on 2021/8/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeLelveImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePowerCell : BaseCell

@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) NoticeLelveImageView *lelveImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *topFgView;
@property (nonatomic, strong) UIView *bottomFgView;
@property (nonatomic, strong) UILabel *leaveL;
@property (nonatomic, strong) UILabel *numL;
@end

NS_ASSUME_NONNULL_END
