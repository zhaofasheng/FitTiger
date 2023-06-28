//
//  NoticeCenterInfoTostView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/20.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCenterInfoTostView : UIView
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) UIView *contentView;
- (instancetype)initWithShowUserInfo;
- (void)showChoiceView;
@end

NS_ASSUME_NONNULL_END
