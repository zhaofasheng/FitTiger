//
//  XLAlertView.h
//  NoticeXi
//
//  Created by li lei on 2018/10/25.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface XLAlertView : UIView
- (void)showXLAlertView;
- (void)dissMissView;
@property (nonatomic,copy) AlertResult resultIndex;
@property (nonatomic, copy) NSString * __nullable timerName;
//弹窗
@property (nonatomic,retain) UIView *alertView;
//title
@property (nonatomic,retain) UILabel *titleLbl;
//内容
@property (nonatomic,retain) UILabel *msgLbl;
//确认按钮
@property (nonatomic,retain) UIButton *sureBtn;
//取消按钮
@property (nonatomic,retain) UIButton *cancleBtn;
//横线线
@property (nonatomic,retain) UIView *lineView;
//竖线
@property (nonatomic,retain) UIView *verLineView;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSString *name;
- (instancetype)initWithTitle:(NSString *)title name:(NSString *)name time:(NSString *)time creatTime:(NSInteger)creatTime;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message callBtn:(NSString *)cancleTitle;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancleBtn:(NSString *)cancleTitle;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle right:(BOOL)right;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle white:(BOOL)white;
- (instancetype)initNewWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

@end
