//
//  NoticePerCell.h
//  NoticeXi
//
//  Created by li lei on 2019/1/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeAllPersonlity.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePerCell : BaseCell
@property (nonatomic, strong) NoticeAllPersonlity *person;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

NS_ASSUME_NONNULL_END
