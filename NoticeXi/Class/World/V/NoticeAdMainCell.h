//
//  NoticeAdMainCell.h
//  NoticeXi
//
//  Created by li lei on 2022/1/14.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeWriteRecodModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAdMainCell : BaseCell
@property (nonatomic, strong) NoticeWriteRecodModel *model;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *contentL;
@end

NS_ASSUME_NONNULL_END
