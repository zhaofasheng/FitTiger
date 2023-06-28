//
//  NoticeChangeRoleIconView.h
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeRoleIconView : UIView
@property (nonatomic, strong) NoticeMyShopModel *myShopModel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *roleImageView;
@property (nonatomic, strong) UIImageView *roleImageView1;
@property (nonatomic, strong) UIImageView *choiceImage1;
@property (nonatomic, strong) UIImageView *choiceImage2;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, assign) NSString *role;
@property (nonatomic, assign) NSString *url;
@property (nonatomic, copy) void(^refreshRoleBlock)(NSString *role,NSString *url);
- (void)showChoiceView;
@end

NS_ASSUME_NONNULL_END
