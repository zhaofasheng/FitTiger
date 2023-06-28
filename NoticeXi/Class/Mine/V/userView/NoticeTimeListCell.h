//
//  NoticeTimeListCell.h
//  NoticeXi
//
//  Created by li lei on 2018/12/20.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTimeListCell : BaseCell

@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *noticeImageV;
@property (nonatomic, strong) UIImageView *lockImageV;
@property (nonatomic, strong) NoticeVoiceListModel *voice;

@end

NS_ASSUME_NONNULL_END
