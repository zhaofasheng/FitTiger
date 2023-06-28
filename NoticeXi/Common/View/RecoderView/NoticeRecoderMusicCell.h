//
//  NoticeRecoderMusicCell.h
//  NoticeXi
//
//  Created by li lei on 2021/3/22.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTextZJMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeRecoderMusicCell : UICollectionViewCell
@property (nonatomic, strong) NoticeTextZJMusicModel *model;
@property (nonatomic, strong) UIImageView *musiceImageView;
@property (nonatomic, strong) UIView *choiceView;
@property (nonatomic, strong) UIImageView *newsImageView;
@end

NS_ASSUME_NONNULL_END
