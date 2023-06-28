//
//  CalenderHeaderView.h
//  YZCCalender
//
//  Created by Jason on 2018/1/18.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeChangeCanlderThumeDelegate <NSObject>

@optional
- (void)changeThumeImageView:(NSInteger)section;

@end

@interface CalenderHeaderView : UICollectionReusableView
@property (nonatomic, weak) id<NoticeChangeCanlderThumeDelegate>delegate;
@property (nonatomic, strong) UILabel *yearAndMonthLabel;
@property (nonatomic, strong) UIImageView *thumeImageView;
@property (nonatomic, strong) UIView *croLineView;
@property (nonatomic, assign) NSInteger section;
@end
