//
//  NoticeZJCollectionCell.h
//  NoticeXi
//
//  Created by li lei on 2019/12/23.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeZJCollectionCell : UICollectionViewCell
@property (nonatomic, strong) NoticeZjModel *firModel;
@property (nonatomic, strong) NoticeZjModel *nofirModel;
@property (nonatomic, strong) NoticeZjModel *urlModel;
@property (nonatomic, strong) UIImageView *zjImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *markImgV;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, assign) BOOL isText;
@property (nonatomic, assign) BOOL index;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isNoshowSimi;
@end

NS_ASSUME_NONNULL_END
