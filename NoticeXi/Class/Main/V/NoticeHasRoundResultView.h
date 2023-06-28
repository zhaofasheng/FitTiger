//
//  NoticeHasRoundResultView.h
//  NoticeXi
//
//  Created by li lei on 2021/1/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeHasRoundResultView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *ruondImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *typeL;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) void (^hideBlock)(BOOL ishidden);
- (void)showTostView;
@end

NS_ASSUME_NONNULL_END
