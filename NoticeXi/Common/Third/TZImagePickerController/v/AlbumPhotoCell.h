//
//  AlbumPhotoCell.h
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "TZAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AlbumPhotoCell : BaseCell

@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) TZAlbumModel *albumM;
@end

NS_ASSUME_NONNULL_END
