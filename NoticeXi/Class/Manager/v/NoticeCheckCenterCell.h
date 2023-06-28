//
//  NoticeCheckCenterCell.h
//  NoticeXi
//
//  Created by li lei on 2020/6/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeManagerJuBaoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCheckCenterCell : BaseCell
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *topicL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *drawImageView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *sendOrCollBtn;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) NoticeManagerJuBaoModel *jubaoM;
@property (nonatomic, strong) NSString *passCode;
@end

NS_ASSUME_NONNULL_END
