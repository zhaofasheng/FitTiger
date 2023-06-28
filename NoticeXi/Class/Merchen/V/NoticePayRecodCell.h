//
//  NoticePayRecodCell.h
//  NoticeXi
//
//  Created by li lei on 2021/12/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticePayReodModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePayRecodCell : BaseCell
@property (nonatomic, strong) NoticePayReodModel *model;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) CBAutoScrollLabel *numL;
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, assign) BOOL isSend;
@end

NS_ASSUME_NONNULL_END
