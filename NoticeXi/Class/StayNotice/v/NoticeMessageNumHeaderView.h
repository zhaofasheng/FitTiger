//
//  NoticeMessageNumHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2022/8/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMessageNumHeaderView : UIView

@property (nonatomic, strong) UILabel *arcL;
@property (nonatomic, strong) UILabel *sysL;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, strong) UILabel *msgL;
@property (nonatomic, copy) void(^pushBlock)(NSInteger push);
@end

NS_ASSUME_NONNULL_END
