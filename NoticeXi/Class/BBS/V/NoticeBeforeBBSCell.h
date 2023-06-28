//
//  NoticeBeforeBBSCell.h
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeBBSModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBeforeBBSCell : BaseCell
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *comNumL;

@property (nonatomic, strong) NoticeBBSModel *bbsModel;
@end

NS_ASSUME_NONNULL_END
