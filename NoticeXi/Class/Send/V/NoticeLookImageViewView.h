//
//  NoticeLookImageViewView.h
//  NoticeXi
//
//  Created by li lei on 2022/3/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeLookPhotoRecCell.h"
#import "NoticeCustomView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeLookImageViewView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, strong) NoticeVoiceTypeModel *currentModel;
@property (nonatomic, strong) NoticeCustomView *imageShowView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^cancelBlock)(BOOL cancel);
@end

NS_ASSUME_NONNULL_END
