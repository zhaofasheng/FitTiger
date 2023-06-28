//
//  NoticeVoiceTypeCell.h
//  NoticeXi
//
//  Created by li lei on 2022/3/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceTypeModel.h"
#import "SPActivityIndicatorView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceTypeCell : UICollectionViewCell

@property (nonatomic, strong) NoticeVoiceTypeModel *typeModel;
@property (nonatomic, strong) SPActivityIndicatorView *leftAct;
@property (nonatomic, strong) SPActivityIndicatorView *rightAct;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIImageView *markImageView;

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIView *fgView;

@end

NS_ASSUME_NONNULL_END
