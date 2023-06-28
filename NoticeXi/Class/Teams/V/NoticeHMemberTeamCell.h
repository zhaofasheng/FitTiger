//
//  NoticeHMemberTeamCell.h
//  NoticeXi
//
//  Created by li lei on 2023/6/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "YYPersonItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHMemberTeamCell : BaseCell
@property (nonatomic, strong) YYPersonItem *person;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *markImage;
@end

NS_ASSUME_NONNULL_END
