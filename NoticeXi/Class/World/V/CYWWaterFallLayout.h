//
//  CYWWaterFallLayout.h
//  NoticeXi
//
//  Created by li lei on 2023/2/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYWWaterFallLayout : UICollectionViewFlowLayout


//数据
@property (nonatomic,strong) NSArray *dataList;//传入网络数据动态高度

@property (nonatomic, assign) CGFloat itemWidth;//宽度

@property (nonatomic, assign) NSInteger columnCount;//列数
@end

NS_ASSUME_NONNULL_END
