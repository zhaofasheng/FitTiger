//
//  NoticeZjCell.h
//  NoticeXi
//
//  Created by li lei on 2019/8/13.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeZjCell : UICollectionViewCell
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic, strong) NoticeZjModel *urlModel;
@property (nonatomic, strong) UIImageView *zjImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIImageView *markImgV;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, assign) BOOL isText;
@property (nonatomic, strong) NoticeZjModel *firModel;
@property (nonatomic, strong) NoticeZjModel *nofirModel;
@property (nonatomic, strong) UIView *mbView;
@end

NS_ASSUME_NONNULL_END
