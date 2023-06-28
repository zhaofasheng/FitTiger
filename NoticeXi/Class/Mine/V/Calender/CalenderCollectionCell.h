//
//  CalenderCollectionCell.h
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalenderModel;

@interface CalenderCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) CalenderModel *model;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *bootomLine;
@property (nonatomic, strong) UIImageView *anImageView;
@end
