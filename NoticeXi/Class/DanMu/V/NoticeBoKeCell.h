//
//  NoticeBoKeCell.h
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBoKeCell : BaseCell<LCActionSheetDelegate>
@property (nonatomic, strong) NoticeDanMuModel *model;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, assign) BOOL isMine;

@property (nonatomic, strong) UIButton *moreBtn;
@end

NS_ASSUME_NONNULL_END
