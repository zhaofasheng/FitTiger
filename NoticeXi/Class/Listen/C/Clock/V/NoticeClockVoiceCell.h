//
//  NoticeClockVoiceCell.h
//  NoticeXi
//
//  Created by li lei on 2019/11/12.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockVoiceCell : BaseCell
@property (nonatomic, strong) NoticeClockChaceModel *cacheModel;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *stopLabel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *choiceImgView;
@end

NS_ASSUME_NONNULL_END
