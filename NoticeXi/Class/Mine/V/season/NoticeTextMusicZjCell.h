//
//  NoticeTextMusicZjCell.h
//  NoticeXi
//
//  Created by li lei on 2021/1/20.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTextZJMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextMusicZjCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imagView;
@property (nonatomic, strong) UIImageView *choiceImagView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NoticeTextZJMusicModel *musicM;
@end

NS_ASSUME_NONNULL_END
