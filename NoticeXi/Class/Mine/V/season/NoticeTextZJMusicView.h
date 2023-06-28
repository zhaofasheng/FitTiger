//
//  NoticeTextZJMusicView.h
//  NoticeXi
//
//  Created by li lei on 2021/1/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextZJMusicView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIButton *musicBtn;
@property (nonatomic,copy) void (^musicTapBlock)(NSInteger tap);
@property (nonatomic,copy) void (^stopMusicTapBlock)(BOOL stop);
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

NS_ASSUME_NONNULL_END
