//
//  KMTagListView.h
//  KMTag
//
//  Created by chavez on 2017/7/13.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KMTagListView;
@protocol KMTagListViewDelegate<NSObject>

- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content;

@end

@interface KMTagListView : UIScrollView

@property (nonatomic, weak)id<KMTagListViewDelegate> delegate_;
@property (nonatomic, assign) BOOL hasImge;//带图片的标签
- (void)setupSubViewsWithTitles:(NSArray *)titles;
@property (nonatomic, strong) NSMutableArray *labelItems;
- (void)setupCustomeSubViewsWithTitles:(NSArray *)titles;
- (void)setupCustomeImgSubViewsWithTitles:(NSMutableArray *)titles;
@end
