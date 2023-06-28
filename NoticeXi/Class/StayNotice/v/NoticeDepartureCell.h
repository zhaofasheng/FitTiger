//
//  NoticeDepartureCell.h
//  NoticeXi
//
//  Created by li lei on 2023/3/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDataLikeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDepartureCell : BaseCell
@property (nonatomic, strong) NoticeDataLikeModel *lyModel;
@property (nonatomic, strong) NoticeDataLikeModel *voiceComModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconMarkView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UIImageView *helpImageView;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) void(^clickHelpTitleBlock)(NoticeDataLikeModel *model);
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UIImageView *comImageView;
@end

NS_ASSUME_NONNULL_END
