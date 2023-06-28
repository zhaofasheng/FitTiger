//
//  NoticeShopjuBuView.h
//  NoticeXi
//
//  Created by li lei on 2022/7/15.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopjuBuView : UIView
@property (nonatomic, copy) void(^shopjubaoBlock)(NSInteger tag);
- (void)showJuBao;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
