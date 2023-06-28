//
//  NoticeActShowView.h
//  NoticeXi
//
//  Created by li lei on 2022/3/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeActShowView : UIView
- (void)show;
- (void)disMiss;
@property (nonatomic, strong) UILabel *titleL;
@property (strong, nonatomic) UIActivityIndicatorView *actView;
@end

NS_ASSUME_NONNULL_END
