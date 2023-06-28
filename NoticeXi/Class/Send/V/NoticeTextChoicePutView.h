//
//  NoticeTextChoicePutView.h
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextChoicePutView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) void (^textBlock)(NSString *name,NSString *content);
@end

NS_ASSUME_NONNULL_END
