//
//  NoticeUserShareCell.h
//  NoticeXi
//
//  Created by li lei on 2022/5/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeFriendAcdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeUserShareCell : BaseCell
@property (nonatomic, strong) NoticeFriendAcdModel *friendM;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *moreL;
@property (nonatomic, strong) UILabel *nameL;

@end

NS_ASSUME_NONNULL_END
