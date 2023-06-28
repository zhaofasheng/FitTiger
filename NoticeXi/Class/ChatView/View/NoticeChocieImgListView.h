//
//  NoticeChocieImgListView.h
//  NoticeXi
//
//  Created by li lei on 2022/5/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZAssetCell.h"
#import "NoticeAlbumView.h"
#import "TZImagePickerController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChocieImgListView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,NoticeAlbumChoiceDelegate>
@property (nonatomic, strong) NSMutableArray *abumArrary;
@property (nonatomic, strong) TZAlbumModel *model;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) void (^didSelectPhotosMBlock)(NSMutableArray *photoArr);
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) FSCustomButton *titleButton;
@property (nonatomic, strong) NoticeAlbumView *albumView;
@property (assign, nonatomic) BOOL isDrop;
@property (assign, nonatomic) NSInteger limitNum;
@property (nonatomic, strong) NSMutableArray *assetArr;
- (void)refreshImage;
@end

NS_ASSUME_NONNULL_END
