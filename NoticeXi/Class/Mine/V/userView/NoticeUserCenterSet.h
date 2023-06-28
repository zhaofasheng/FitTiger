//
//  NoticeUserCenterSet.h
//  NoticeXi
//
//  Created by li lei on 2019/12/18.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticePhotoCell.h"
#import "NoticeAbout.h"
#import "NoticeCoverModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeUserSetDelegate <NSObject>

@optional
- (void)setNeedCoverView:(BOOL)Need;
- (void)getAminationWithTag:(NSInteger)tag;
- (void)backClick;
@end

@interface NoticeUserCenterSet : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,NoticePhotoManagerDelegate>

@property (nonatomic, strong) UICollectionView *merchantCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, weak) id<NoticeUserSetDelegate>delegate;
@property (nonatomic, strong) NoticeAbout *aobut;
@property (nonatomic, strong) NSMutableArray *dataArr;
- (void)show;
@end

NS_ASSUME_NONNULL_END
