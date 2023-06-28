//
//  NoticeYourBdCell.h
//  NoticeXi
//
//  Created by li lei on 2020/4/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeClockBdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeYourBdCell : BaseCell
@property (nonatomic, strong) UILabel *tsLabel;
@property (nonatomic, strong) UILabel *mgLabel;
@property (nonatomic, strong) UILabel *shLabel;
@property (nonatomic, strong) UILabel *tcLabel;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) NoticeClockBdModel *selfBd;
@end

NS_ASSUME_NONNULL_END
