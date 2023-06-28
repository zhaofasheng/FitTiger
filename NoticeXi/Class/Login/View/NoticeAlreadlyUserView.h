//
//  NoticeAlreadlyUserView.h
//  NoticeXi
//
//  Created by li lei on 2021/5/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeAlreadlyUserView : UIView

@property (nonatomic,copy) void (^choicebtnTag)(NSInteger tag);
@property (nonatomic, strong)  UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIView *contentView;

- (instancetype)initWithShowUserInfo;
- (void)showInfoView;

@end

NS_ASSUME_NONNULL_END
