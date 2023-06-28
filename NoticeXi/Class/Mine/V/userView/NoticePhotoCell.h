//
//  NoticePhotoCell.h
//  NoticeXi
//
//  Created by li lei on 2018/10/25.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSmallArrModel.h"
#import "NoticeCoverModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticePhotoManagerDelegate <NSObject>

@optional
- (void)delegateImageAt:(NSInteger)index;

@end

@interface NoticePhotoCell : UICollectionViewCell

@property (nonatomic, weak) id <NoticePhotoManagerDelegate>delegate;
@property (nonatomic, strong) NoticeCoverModel *coverModel;
@property (nonatomic, strong) UIImageView *imageCellView;
@property (nonatomic, strong) NoticeSmallArrModel *smallModel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *allDataArr;
@property (nonatomic, strong) NSMutableArray *lagerUrlArr;
@property (nonatomic, assign) BOOL isUserSet;

@property (nonatomic, strong) UIButton *delegteButton;
@end

NS_ASSUME_NONNULL_END
