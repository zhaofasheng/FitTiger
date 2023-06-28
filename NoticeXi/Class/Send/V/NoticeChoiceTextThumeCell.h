//
//  NoticeChoiceTextThumeCell.h
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBackQustionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoiceTextThumeCell : UICollectionViewCell
@property (nonatomic, strong) NoticeBackQustionModel *model;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *contentL;
@end

NS_ASSUME_NONNULL_END
