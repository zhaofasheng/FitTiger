//
//  NoticeBigZjView.h
//  NoticeXi
//
//  Created by li lei on 2019/8/19.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NoticeZjDelegate <NSObject>

@optional
- (void)nodateDelegate;

@end

@interface NoticeBigZjView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <NoticeZjDelegate>delegate;
@property (nonatomic, assign) NSInteger type;//1 好友视角  2非好友视角
@property (nonatomic, strong) UICollectionView *merchantCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSString *allLastId;
@property (nonatomic, strong) NSMutableArray *dataArr;//专辑数据
@property (nonatomic, strong) NSMutableArray *showDataArr;//专辑数据 过滤了无心情的专辑
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isYulan;//YES  下拉
@property (nonatomic, assign) BOOL isFriend;//YES  下拉
@end

NS_ASSUME_NONNULL_END
