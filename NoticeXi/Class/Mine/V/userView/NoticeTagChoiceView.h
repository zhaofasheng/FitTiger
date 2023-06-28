//
//  NoticeTagChoiceView.h
//  NoticeXi
//
//  Created by li lei on 2020/5/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTagChoiceView : UIView
@property (nonatomic,copy) void (^newBlock)(BOOL isNew);
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secBtn;
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, assign) BOOL isNew;
- (void)showTostView;
@end

NS_ASSUME_NONNULL_END
