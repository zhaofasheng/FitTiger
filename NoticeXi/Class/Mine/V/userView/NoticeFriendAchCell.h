//
//  NoticeFriendAchCell.h
//  NoticeXi
//
//  Created by li lei on 2020/5/11.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeFriendAcdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeFriendAchCell : BaseCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *achL;
@property (nonatomic, strong) NoticeFriendAcdModel *achModel;
@property (nonatomic, assign) BOOL isSelf;
@end

NS_ASSUME_NONNULL_END
