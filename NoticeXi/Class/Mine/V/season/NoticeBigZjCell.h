//
//  NoticeBigZjCell.h
//  NoticeXi
//
//  Created by li lei on 2019/8/19.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBigZjCell : UICollectionViewCell
@property (nonatomic, strong) NoticeZjModel *zjModel;
@property (nonatomic, strong) UIImageView *zjImageView;
@property (nonatomic, strong) UILabel *nameL;
@end

NS_ASSUME_NONNULL_END
