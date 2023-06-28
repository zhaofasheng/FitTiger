//
//  NoticeShopComUserView.h
//  NoticeXi
//
//  Created by li lei on 2023/4/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopComUserView : UIView
@property (nonatomic, strong) UIView *goodView;
@property (nonatomic, strong) UILabel *goodL;

@property (nonatomic, strong) UIView *nomerView;
@property (nonatomic, strong) UILabel *nomerL;

@property (nonatomic, strong) UIView *badView;
@property (nonatomic, strong) UILabel *badL;

@property (nonatomic, strong) UIButton *comButton;

@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) void(^scoreBlock)(NSString *score);
- (void)show;
@end

NS_ASSUME_NONNULL_END
