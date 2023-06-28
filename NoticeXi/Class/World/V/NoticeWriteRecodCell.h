//
//  NoticeWriteRecodCell.h
//  NoticeXi
//
//  Created by li lei on 2021/12/8.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeWriteRecodModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeWriteRecodCell : UICollectionViewCell
@property (nonatomic, strong) NoticeWriteRecodModel *model;
@property (nonatomic, strong) UILabel *dayL;
@property (nonatomic, strong) UILabel *yearL;
@property (nonatomic, strong) UIImageView *bannereImageV;
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UILabel *likeNumL;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *downButton;
@end

NS_ASSUME_NONNULL_END
