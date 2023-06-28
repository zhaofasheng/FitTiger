//
//  NoticerMerchantListCell.h
//  NoticeXi
//
//  Created by li lei on 2021/11/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMerchantModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticerMerchantListCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NoticeMerchantModel *model;

@end

NS_ASSUME_NONNULL_END
