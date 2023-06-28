//
//  NoticeDesTroyView.h
//  NoticeXi
//
//  Created by li lei on 2020/8/20.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDesTroyView : UIView
@property (nonatomic,copy) void (^sureDestroy)(BOOL sure);
@property (nonatomic,copy) void (^sureCodeBlock)(NSString *code,NSString *key);
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *num1;
@property (nonatomic, strong) NSString *num2;
@property (nonatomic, strong) NSString *num3;
@property (nonatomic, strong) NSString *num4;
@property (nonatomic, strong) NSString *allStr;
@property (nonatomic, strong) NoticeAbout *codeModel;
@property (nonatomic, assign) BOOL isSendSMS;
@property (nonatomic, strong) UIScrollView *scrollView;
- (void)showDestroyView;
- (instancetype)initWithShowDestroy;
- (instancetype)initWithShowSendSMS;
- (instancetype)initWithShowRule;
@end

NS_ASSUME_NONNULL_END
