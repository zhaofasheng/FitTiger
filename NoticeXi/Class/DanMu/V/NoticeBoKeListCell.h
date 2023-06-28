//
//  NoticeBoKeListCell.h
//  NoticeXi
//
//  Created by li lei on 2022/9/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBoKeListCell : BaseCell
@property (nonatomic, strong) NoticeDanMuModel *model;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *likeImage;
@property (nonatomic, assign) BOOL isChoice;
@end

NS_ASSUME_NONNULL_END
