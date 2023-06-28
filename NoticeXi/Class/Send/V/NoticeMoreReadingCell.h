//
//  NoticeMoreReadingCell.h
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceReadModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMoreReadingCell : UICollectionViewCell
@property (nonatomic, strong) NoticeVoiceReadModel *readModel;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *contentL;
@end

NS_ASSUME_NONNULL_END
