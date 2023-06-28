//
//  NoticeQuestionDetailCell.h
//  NoticeXi
//
//  Created by li lei on 2021/6/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeUserQuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeQuestionDetailCell : BaseCell
@property (nonatomic, strong) NoticeUserQuestionModel *questionM;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *headerV;
@property (nonatomic, strong) UILabel *headL;
@end

NS_ASSUME_NONNULL_END
