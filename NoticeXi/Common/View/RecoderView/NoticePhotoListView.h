//
//  NoticePhotoListView.h
//  NoticeXi
//
//  Created by li lei on 2021/3/23.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePhotoListView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *line;
@property (nonatomic,copy) void (^choiceBlock)(UIImage *image);
@end

NS_ASSUME_NONNULL_END
