//
//  NoticeNewTuiJianCell.h
//  NoticeXi
//
//  Created by li lei on 2021/5/17.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeFriendAcdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewTuiJianCell : BaseCell
@property (nonatomic, strong) NoticeFriendAcdModel *careM;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIButton *careButton;
@end

NS_ASSUME_NONNULL_END
