//
//  NoticeHasOrNoBuyTostView.h
//  NoticeXi
//
//  Created by li lei on 2021/8/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeHasOrNoBuyTostView : UIView

@property (nonatomic, strong)  UIImageView *backImageView;
- (instancetype)initWithShowBuy:(BOOL)buy;
- (void)showChoiceView;
- (instancetype)initWithShowUser:(NoticeUserInfoModel *)userM points:(NSString *)points;
@end

NS_ASSUME_NONNULL_END
