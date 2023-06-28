//
//  NoticeSureSendUserTostView.h
//  NoticeXi
//
//  Created by li lei on 2022/6/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSureSendUserTostView : UIView
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) void(^sureBlock)(BOOL sure);
- (void)show;
@end

NS_ASSUME_NONNULL_END
