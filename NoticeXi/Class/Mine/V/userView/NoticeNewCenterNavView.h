//
//  NoticeNewCenterNavView.h
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeNewCenterNavView : UIView
@property (nonatomic, strong) UIImageView *redV;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIVisualEffectView * toolbar;
@property (nonatomic, assign) BOOL needTm;
@property (nonatomic, strong) UILabel *allNumL;
- (void)refreshData;
@end

NS_ASSUME_NONNULL_END
