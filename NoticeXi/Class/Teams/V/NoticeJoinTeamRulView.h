//
//  NoticeJoinTeamRulView.h
//  NoticeXi
//
//  Created by li lei on 2023/6/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeJoinTeamRulView : UIView
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) NoticeTextView *contentL;
@property (nonatomic,copy) void (^knowBlock)(BOOL know);
- (void)showrulView;
@end

NS_ASSUME_NONNULL_END
