//
//  NoticeCustumButtonInToView.h
//  NoticeXi
//
//  Created by li lei on 2021/7/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCustumButtonInToView : UIView
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, copy) void (^clickvoiceBtnBlock)(NSInteger type);
@property (nonatomic, strong) UIButton *currentButton;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIImageView *moveImageView;
- (void)showShareView;
@end

NS_ASSUME_NONNULL_END
