//
//  NoticeDuiHuanRecoderCell.h
//  NoticeXi
//
//  Created by li lei on 2021/8/6.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDuiHRecoderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDuiHuanRecoderCell : BaseCell
@property (nonatomic, strong) NoticeDuiHRecoderModel *dModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *codeL;
@property (nonatomic, strong) UILabel *timeL;

@end

NS_ASSUME_NONNULL_END
