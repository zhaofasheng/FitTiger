//
//  NoticeZJlistCell.h
//  NoticeXi
//
//  Created by li lei on 2019/8/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeZJlistCell : BaseCell
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic, strong) UIImageView *zjImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, assign) BOOL isLimit;
@end

NS_ASSUME_NONNULL_END
