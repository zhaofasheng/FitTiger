//
//  NoticeSharePersonCell.h
//  NoticeXi
//
//  Created by li lei on 2020/10/22.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyFriends.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSharePersonCell : BaseCell
@property (nonatomic, strong) NoticeMyFriends *friendM;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@end

NS_ASSUME_NONNULL_END
