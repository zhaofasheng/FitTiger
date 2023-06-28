//
//  CYWWaterFallLayout.m
//  NoticeXi
//
//  Created by li lei on 2023/2/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
// 瀑布流

#import "CYWWaterFallLayout.h"


@interface CYWWaterFallLayout ()

 
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes;

@property (nonatomic, strong) NSArray<NSNumber *> *heightsForColumnArray;

@end
 
@implementation CYWWaterFallLayout

- (void)prepareLayout

{
    [super prepareLayout];

    [_layoutAttributes removeAllObjects];

    NSInteger column = self.columnCount;

    NSInteger section = 0;

    NSInteger numberOfItem = [self.collectionView numberOfItemsInSection:section];

    NSMutableArray<NSNumber *> *allColumnMaxY = [NSMutableArray array];

    for (int currentColumn = 0; currentColumn < column; currentColumn++)

    {

        allColumnMaxY[currentColumn] = @(0);

    }

    for (int index = 0; index < numberOfItem; index++)

    {

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];

        CGFloat minColumnMaxY = allColumnMaxY[0].floatValue;

        NSInteger itemColumn = 0;

        for (int columnIndex = 0; columnIndex < column; columnIndex++)
        {
            CGFloat columnMaxyValue = allColumnMaxY[columnIndex].floatValue;

            if (minColumnMaxY > columnMaxyValue)
            {
                minColumnMaxY = columnMaxyValue;

                itemColumn = columnIndex;
            }
        }

        // 这里获取item的UICollectionViewLayoutAttributes布局属性，如果是高度根据手动计算出来的，那么在下面直接设置item的高度就好。(网上看到大多都是能确定item高度的瀑布流布局方式)

        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];


        CGFloat itemY = minColumnMaxY + self.minimumLineSpacing;

        CGFloat itemX = self.sectionInset.left + (self.minimumInteritemSpacing + self.itemWidth) * itemColumn;
        NoticeVoiceListModel *model = nil;
        if (index <= self.dataList.count-1) {
            model = self.dataList[index];

        }
        CGRect itemRect = CGRectMake(itemX, itemY, self.itemWidth,model.height);

        layoutAttributes.frame = itemRect;

        [self.layoutAttributes addObject:layoutAttributes];

        allColumnMaxY[itemColumn] = @(CGRectGetMaxY(itemRect));
    }

    _heightsForColumnArray = allColumnMaxY;

}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect

{

    return self.layoutAttributes;

}

- (CGSize)collectionViewContentSize {

    CGSize size = [super collectionViewContentSize];

    if (_heightsForColumnArray.count == 0) {

        return size;

    }

    CGFloat height = _heightsForColumnArray[0].floatValue;

    for (int i = 0; i < _heightsForColumnArray.count; i++)

    {

        if (height < _heightsForColumnArray[i].floatValue)

        {

            height = _heightsForColumnArray[i].floatValue;

        }

    }

    return CGSizeMake(size.width, height + self.sectionInset.bottom);

}

#pragma mark - Getter

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributes

{

    if (!_layoutAttributes)

    {

        _layoutAttributes = [NSMutableArray<UICollectionViewLayoutAttributes *> array];

    }

    return _layoutAttributes;

}

@end
