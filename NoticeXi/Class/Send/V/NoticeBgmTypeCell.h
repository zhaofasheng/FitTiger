//
//  NoticeBgmTypeCell.h
//  NoticeXi
//
//  Created by li lei on 2022/4/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTextZJMusicModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBgmTypeCell : UICollectionViewCell
@property (nonatomic, strong) NoticeTextZJMusicModel *model;
@property (nonatomic,copy) void (^useMusicBlock)(NoticeTextZJMusicModel *model);
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *playBtn;
@property (nonatomic, strong) CBAutoScrollLabel *nameL;
@property (nonatomic, strong) UIButton *useButton;

@end

NS_ASSUME_NONNULL_END
