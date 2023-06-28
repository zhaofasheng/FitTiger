//
//  NoticeVoiceAlbumCell.h
//  NoticeXi
//
//  Created by li lei on 2023/3/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceAlbumCell : BaseCell
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic, strong) UIImageView *zjImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, assign) BOOL isdialog;
@property (nonatomic, strong) UILabel *lastJoinL;
@end

NS_ASSUME_NONNULL_END
