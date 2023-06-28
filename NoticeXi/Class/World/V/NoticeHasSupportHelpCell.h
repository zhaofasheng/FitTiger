//
//  NoticeHasSupportHelpCell.h
//  NoticeXi
//
//  Created by li lei on 2023/5/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeHasSupportHelpModel.h"
#import "NoticeHelpCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeHasSupportHelpCell : BaseCell
@property (nonatomic, strong) NoticeHelpCommentModel *supportModel;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *meL;
@property (nonatomic, strong) NSString *tieFromUserId;
@property (nonatomic, strong) NSString *avaturl;
@end

NS_ASSUME_NONNULL_END
