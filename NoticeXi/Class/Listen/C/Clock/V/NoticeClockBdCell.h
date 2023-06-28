//
//  NoticeClockBdCell.h
//  NoticeXi
//
//  Created by li lei on 2019/10/22.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeClockBdUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockBdCell : BaseCell

@property (nonatomic, strong) NoticeClockBdUser *bdModel;

@property (nonatomic, strong) UILabel *pmL;
@property (nonatomic, strong) UIImageView *pmImageV;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIImageView *pyIconImageV;
@property (nonatomic, strong) UILabel *bgL;

@property (nonatomic, strong) UIImageView *tcIconImageV;
@property (nonatomic, strong) UILabel *tcL;
@end

NS_ASSUME_NONNULL_END
