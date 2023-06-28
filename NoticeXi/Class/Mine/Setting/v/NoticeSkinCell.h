//
//  NoticeSkinCell.h
//  NoticeXi
//
//  Created by li lei on 2021/9/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSkinModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSkinCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) NoticeSkinModel *skinModel;
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) UILabel *lelveL;

@end

NS_ASSUME_NONNULL_END
