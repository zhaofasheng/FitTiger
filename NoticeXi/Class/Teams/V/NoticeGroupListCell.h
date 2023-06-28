//
//  NoticeGroupListCell.h
//  NoticeXi
//
//  Created by li lei on 2023/6/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeGroupListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeGroupListCell : BaseCell
@property (nonatomic, strong) NoticeGroupListModel *groupModel;
@property (nonatomic, strong) UIImageView *groupImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *groupNameL;
@property (nonatomic, strong) UIImageView *peopleNumView;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *msgL;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
