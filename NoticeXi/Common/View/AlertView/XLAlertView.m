//
//  XLAlertView.m
//  NoticeXi
//
//  Created by li lei on 2018/10/25.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "XLAlertView.h"
#import "NoticeTimerTools.h"
///alertView 宽
#define AlertW 260
///各个栏目之间的距离
#define XLSpace 10.0


@implementation XLAlertView
{
    NSInteger getBackTime;
}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle white:(BOOL)white{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [[UIColor colorWithHexString:@"#FCFCFC"] colorWithAlphaComponent:1];
        self.alertView.layer.cornerRadius = 10.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 122);
        self.alertView.layer.position = self.center;
        
        if (title.length && title) {
            
            self.titleLbl = [self GetAdaptiveLable:CGRectMake(2*XLSpace, 2*XLSpace, AlertW-4*XLSpace, 20) AndText:title andIsTitle:YES];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.titleLbl];
            self.titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
            CGFloat titleW = self.titleLbl.bounds.size.width;
            CGFloat titleH = self.titleLbl.bounds.size.height;
            
            self.titleLbl.frame = CGRectMake((AlertW-titleW)/2, 2*XLSpace, titleW, titleH);
            
        }
        if (message) {
            
            self.msgLbl = [self GetAdaptiveLable:CGRectMake(XLSpace, CGRectGetMaxY(self.titleLbl.frame)+XLSpace-title.length?0:20, AlertW-2*XLSpace, 20) AndText:message andIsTitle:NO];
            self.msgLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.msgLbl];
            
            CGFloat msgW = self.msgLbl.bounds.size.width;
            CGFloat msgH = self.msgLbl.bounds.size.height;
            self.msgLbl.textColor = [UIColor colorWithHexString:@"333333"];
            self.msgLbl.frame = self.titleLbl?CGRectMake((AlertW-msgW)/2, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, msgW, msgH):CGRectMake((AlertW-msgW)/2, 2*XLSpace-10, msgW, msgH);
        }
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+XLSpace, AlertW, 0.5):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*XLSpace, AlertW, 1);
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        [self.alertView addSubview:self.lineView];
        
        //两个按钮
        if (cancleTitle && sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2, 40);
            [self.cancleBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        
        if (cancleTitle && sureTitle) {
            self.verLineView = [[UIView alloc] init];
            self.verLineView.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), CGRectGetMaxY(self.lineView.frame),1, 40);
            self.verLineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
            [self.alertView addSubview:self.verLineView];
        }
        
        if(sureTitle && cancleTitle){
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.verLineView.frame), CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2+1, 40);
            [self.sureBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            self.sureBtn.tag = 2;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
            
        }
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    }
    
    return self;
}

- (instancetype)initNewWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        self.alertView.layer.cornerRadius = 10.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 122);
        self.alertView.layer.position = self.center;
        
        if (title.length && title) {
    
            self.titleLbl = [self GetAdaptiveLable:CGRectMake(0, 2*XLSpace, AlertW, 20) AndText:title andIsTitle:YES];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            self.titleLbl.font = SIXTEENTEXTFONTSIZE;
            [self.alertView addSubview:self.titleLbl];
            self.titleLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            CGFloat titleW = self.titleLbl.bounds.size.width;
            CGFloat titleH = self.titleLbl.bounds.size.height;
            
            self.titleLbl.frame = CGRectMake((AlertW-titleW)/2, 2*XLSpace, titleW, titleH);
            
        }
        if (message) {
            
            self.msgLbl = [self GetAdaptiveLable:CGRectMake(XLSpace, CGRectGetMaxY(self.titleLbl.frame)+XLSpace-title.length?0:20, AlertW-2*XLSpace, 20) AndText:message andIsTitle:NO];
            self.msgLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.msgLbl];
            
            CGFloat msgW = self.msgLbl.bounds.size.width;
            CGFloat msgH = self.msgLbl.bounds.size.height;
            self.msgLbl.textColor = [UIColor colorWithHexString:@"#ACB3BF"];
            self.msgLbl.frame = self.titleLbl?CGRectMake((AlertW-msgW)/2, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, msgW, msgH):CGRectMake((AlertW-msgW)/2, 2*XLSpace-10, msgW, msgH);
        }
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+XLSpace+5, AlertW, 1):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*XLSpace+5, AlertW, 1);
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.alertView addSubview:self.lineView];
        
        //两个按钮
        if (cancleTitle && sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame)+5, (AlertW-1)/2, 40);
            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
            self.cancleBtn.tag = 2;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        
        if (cancleTitle && sureTitle) {
            self.verLineView = [[UIView alloc] init];
            self.verLineView.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), CGRectGetMaxY(self.lineView.frame),1, 48);
            self.verLineView.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
            [self.alertView addSubview:self.verLineView];
        }
        
        if(sureTitle && cancleTitle){
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.verLineView.frame), CGRectGetMaxY(self.lineView.frame)+5, (AlertW-1)/2+1, 40);
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
            self.sureBtn.tag = 1;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
            
        }
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight+5);
        self.alertView.layer.position = self.center;
        
        self.cancleBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        self.sureBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        
        [self addSubview:self.alertView];
        
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle
{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [[NoticeTools isWhiteTheme]?[UIColor colorWithHexString:@"#FCFCFC"] : GetColorWithName(VBackColor) colorWithAlphaComponent:1];
        self.alertView.layer.cornerRadius = 10.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 122);
        self.alertView.layer.position = self.center;
        
        if (title.length && title) {
            
            self.titleLbl = [self GetAdaptiveLable:CGRectMake(2*XLSpace, 2*XLSpace, AlertW-4*XLSpace, 20) AndText:title andIsTitle:YES];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.titleLbl];
            self.titleLbl.textColor = GetColorWithName(VMainTextColor);
            CGFloat titleW = self.titleLbl.bounds.size.width;
            CGFloat titleH = self.titleLbl.bounds.size.height;
            
            self.titleLbl.frame = CGRectMake((AlertW-titleW)/2, 2*XLSpace, titleW, titleH);
            
        }
        if (message) {
            
            self.msgLbl = [self GetAdaptiveLable:CGRectMake(XLSpace, CGRectGetMaxY(self.titleLbl.frame)+XLSpace-title.length?0:20, AlertW-2*XLSpace, 20) AndText:message andIsTitle:NO];
            self.msgLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.msgLbl];
            
            CGFloat msgW = self.msgLbl.bounds.size.width;
            CGFloat msgH = self.msgLbl.bounds.size.height;
            self.msgLbl.textColor = GetColorWithName(VMainTextColor);
            self.msgLbl.frame = self.titleLbl?CGRectMake((AlertW-msgW)/2, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, msgW, msgH):CGRectMake((AlertW-msgW)/2, 2*XLSpace-10, msgW, msgH);
        }
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+XLSpace, AlertW, 0.5):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*XLSpace, AlertW, 1);
        self.lineView.backgroundColor = GetColorWithName(VlineColor);
        [self.alertView addSubview:self.lineView];
        
        //两个按钮
        if (cancleTitle && sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2, 40);
            [self.cancleBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        
        if (cancleTitle && sureTitle) {
            self.verLineView = [[UIView alloc] init];
            self.verLineView.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), CGRectGetMaxY(self.lineView.frame),1, 40);
            self.verLineView.backgroundColor = GetColorWithName(VlineColor);
            [self.alertView addSubview:self.verLineView];
        }
        
        if(sureTitle && cancleTitle){
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.verLineView.frame), CGRectGetMaxY(self.lineView.frame), (AlertW-1)/2+1, 40);
            [self.sureBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            self.sureBtn.tag = 2;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
            
        }
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        
        self.cancleBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        self.sureBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        
        [self addSubview:self.alertView];
        
        if ([sureTitle isEqualToString:[NoticeTools getLocalStrWith:@"accunt.surezx"]]) {
            [self.cancleBtn setTitleColor:[NoticeTools getWhiteColor:@"#E92121" NightColor:@"#8C1515"] forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        }
    }
    
    return self;
}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message callBtn:(NSString *)cancleTitle{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:1];
        self.alertView.layer.cornerRadius = 10.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 100);
        self.alertView.layer.position = self.center;
        
        if (title) {
            
            self.titleLbl = [self GetAdaptiveLable:CGRectMake(2*XLSpace, 2*XLSpace, AlertW-4*XLSpace, 20) AndText:title andIsTitle:YES];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.titleLbl];
            self.titleLbl.textColor = GetColorWithName(VMainTextColor);
            CGFloat titleW = self.titleLbl.bounds.size.width;
            CGFloat titleH = self.titleLbl.bounds.size.height;
            
            self.titleLbl.frame = CGRectMake((AlertW-titleW)/2, 2*XLSpace, titleW, titleH);
            
        }
        if (message) {
            
            self.msgLbl = [self GetAdaptiveLable:CGRectMake(XLSpace, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, AlertW-2*XLSpace, 20) AndText:message andIsTitle:NO];
            self.msgLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.msgLbl];
            
            CGFloat msgW = self.msgLbl.bounds.size.width;
            CGFloat msgH = self.msgLbl.bounds.size.height;
            self.msgLbl.textColor = GetColorWithName(VDarkTextColor);
            self.msgLbl.frame = self.titleLbl?CGRectMake((AlertW-msgW)/2, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, msgW, msgH):CGRectMake((AlertW-msgW)/2, 2*XLSpace, msgW, msgH);
        }
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+XLSpace, AlertW, 0.5):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*XLSpace, AlertW, 0.5);
        self.lineView.backgroundColor = GetColorWithName(VMainTextColor);
        [self.alertView addSubview:self.lineView];
        
        //两个按钮
        if (cancleTitle) {
            UIView *bav = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 0.5)];
            bav.backgroundColor = GetColorWithName(VlineColor);
            [self.alertView addSubview:bav];
            self.lineView.backgroundColor = bav.backgroundColor;
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(bav.frame), AlertW, 40);
            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            self.cancleBtn.layer.cornerRadius = 10.0;
            self.cancleBtn.layer.masksToBounds = YES;
            self.cancleBtn.backgroundColor = GetColorWithName(VBackColor);
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title name:(NSString *)name time:(NSString *)time creatTime:(NSInteger)creatTime{
    if (self == [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        //
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];//
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrder) name:@"SHOPCANCELORDER" object:nil];
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [[UIColor colorWithHexString:@"#FCFCFC"] colorWithAlphaComponent:1];
        self.alertView.layer.cornerRadius = 10.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 100);
        self.alertView.layer.position = self.center;
        self.time = time.intValue ? time.intValue: 60;
        title = [NSString stringWithFormat:@"你的随机昵称:%@\n等待店主接单...%lds后订单失效",name,self.time];
        
        if (title) {
            
            self.titleLbl = [self GetAdaptiveLable:CGRectMake(2*XLSpace, 2*XLSpace, AlertW-4*XLSpace, 20) AndText:title andIsTitle:YES];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.titleLbl];
            self.titleLbl.textColor = [UIColor colorWithHexString:@"#333333"];
            CGFloat titleW = self.titleLbl.bounds.size.width;
            CGFloat titleH = self.titleLbl.bounds.size.height;
            
            self.titleLbl.frame = CGRectMake((AlertW-titleW)/2, 2*XLSpace, titleW, titleH);
            
        }
        self.name = name;

        
        [self timeChange];
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+XLSpace, AlertW, 0.5):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*XLSpace, AlertW, 0.5);
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.alertView addSubview:self.lineView];
        
        NSString *cancleTitle = @"取消订单";
        
        //两个按钮
        if (cancleTitle) {
            UIView *bav = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 10)];
            bav.backgroundColor = self.alertView.backgroundColor;
            [self.alertView addSubview:bav];
            self.lineView.backgroundColor = bav.backgroundColor;
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 40);
            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            self.cancleBtn.layer.cornerRadius = 10.0;
            self.cancleBtn.layer.masksToBounds = YES;
            self.cancleBtn.backgroundColor = self.alertView.backgroundColor;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    
    }
    
    return self;
    
}

- (void)timeChange{
    __weak typeof(self) weakSelf = self;
    DRLog(@"倒计时%ld",self.time);
    
    NSTimeInterval interval = 1.0;
    self.timerName = [NoticeTimerTools timerTask:^{
        
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.time -= (NSInteger)interval;
        if(strongSelf.time > 0){
            strongSelf.titleLbl.attributedText = [NoticeTools getStringWithLineHight:3 string:[NSString stringWithFormat:@"你的随机昵称:%@\n等待店主接单...%lds后订单失效",strongSelf.name,strongSelf.time]];
        }else{
            [strongSelf outTimeCancel];
        }
    } start:0 interval:interval repeats:YES async:NO];
}

- (void)outTimeCancel{
    [NoticeTimerTools deleteTimer:self.timerName];
    self.timerName = nil;
    if (self.orderId) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:self.orderId forKey:@"orderId"];
        [parm setObject:@"4" forKey:@"orderType"];
        [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        } fail:^(NSError * _Nullable error) {
        }];
    }
    if (self.resultIndex) {
        self.resultIndex(1);
    }
    [self removeFromSuperview];
}

- (void)cancelOrder{
    [NoticeTimerTools deleteTimer:self.timerName];
    self.timerName = nil;
    [self removeFromSuperview];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancleBtn:(NSString *)cancleTitle{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [[UIColor colorWithHexString:@"#FCFCFC"] colorWithAlphaComponent:1];
        self.alertView.layer.cornerRadius = 10.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 100);
        self.alertView.layer.position = self.center;
        
        if (title) {
            
            self.titleLbl = [self GetAdaptiveLable:CGRectMake(2*XLSpace, 2*XLSpace, AlertW-4*XLSpace, 20) AndText:title andIsTitle:YES];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.titleLbl];
            self.titleLbl.textColor = [UIColor colorWithHexString:@"#333333"];
            CGFloat titleW = self.titleLbl.bounds.size.width;
            CGFloat titleH = self.titleLbl.bounds.size.height;
            
            self.titleLbl.frame = CGRectMake((AlertW-titleW)/2, 2*XLSpace, titleW, titleH);
            
        }
        if (message) {
            
            self.msgLbl = [self GetAdaptiveLable:CGRectMake(XLSpace, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, AlertW-2*XLSpace, 20) AndText:message andIsTitle:NO];
            //self.msgLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.msgLbl];
            
            CGFloat msgW = self.msgLbl.bounds.size.width;
            CGFloat msgH = self.msgLbl.bounds.size.height;
            self.msgLbl.textColor = GetColorWithName(VDarkTextColor);
            self.msgLbl.frame = self.titleLbl?CGRectMake((AlertW-msgW)/2, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, msgW, msgH):CGRectMake((AlertW-msgW)/2, 2*XLSpace, msgW, msgH);
        }
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+XLSpace, AlertW, 0.5):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*XLSpace, AlertW, 0.5);
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#EBECF0"];
        [self.alertView addSubview:self.lineView];
        
        //两个按钮
        if (cancleTitle) {
            UIView *bav = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 10)];
            bav.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
            [self.alertView addSubview:bav];
            self.lineView.backgroundColor = bav.backgroundColor;
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), AlertW, 40);
            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            self.cancleBtn.layer.cornerRadius = 10.0;
            self.cancleBtn.layer.masksToBounds = YES;
            self.cancleBtn.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, AlertW, alertHeight);
        self.alertView.layer.position = self.center;
        
        [self addSubview:self.alertView];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle right:(BOOL)right{
    if (self == [super init]) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.alertView.layer.cornerRadius = 10.0;
        
        self.alertView.frame = CGRectMake(0, 0,DR_SCREEN_WIDTH-60, 100);
        self.alertView.layer.position = self.center;
        
       
        
        if (title) {
            
            self.titleLbl = [self GetAdaptiveLable:CGRectMake(2*XLSpace, 2*XLSpace, AlertW-4*XLSpace, 20) AndText:title andIsTitle:YES];
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.titleLbl];
            self.titleLbl.textColor = [UIColor colorWithHexString:@"#25262E"];
            CGFloat titleW = self.titleLbl.bounds.size.width;
            CGFloat titleH = self.titleLbl.bounds.size.height;
            
            self.titleLbl.frame = CGRectMake(( self.alertView.frame.size.width-titleW)/2, 2*XLSpace, titleW, titleH);
            
        }
        if (message) {
            
            self.msgLbl = [self GetAdaptiveLable:CGRectMake(XLSpace, CGRectGetMaxY(self.titleLbl.frame)+XLSpace,  self.alertView.frame.size.width-2*XLSpace, 20) AndText:message andIsTitle:NO];
            self.msgLbl.textAlignment = NSTextAlignmentCenter;
            
            [self.alertView addSubview:self.msgLbl];
            
            CGFloat msgW = self.msgLbl.bounds.size.width;
            CGFloat msgH = self.msgLbl.bounds.size.height;
            self.msgLbl.textColor = [UIColor colorWithHexString:@"#5C5F66"];
            self.msgLbl.frame = self.titleLbl?CGRectMake((self.alertView.frame.size.width-msgW)/2, CGRectGetMaxY(self.titleLbl.frame)+XLSpace, msgW, msgH):CGRectMake(( self.alertView.frame.size.width-msgW)/2, 2*XLSpace, msgW, msgH);
        }
        
        self.lineView = [[UIView alloc] init];
        self.lineView.frame = self.msgLbl?CGRectMake(0, CGRectGetMaxY(self.msgLbl.frame)+XLSpace+12,  self.alertView.frame.size.width, 0.5):CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame)+2*XLSpace,  self.alertView.frame.size.width, 1);
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.alertView addSubview:self.lineView];
        
        //两个按钮
        if (cancleTitle && sureTitle) {
            
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), ( self.alertView.frame.size.width-1)/2, 40);
            [self.cancleBtn setTitle:sureTitle forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:right ? [UIColor colorWithHexString:@"#5C5F66"] : [UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        
        self.verLineView = [[UIView alloc] init];
        self.verLineView.frame = CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), CGRectGetMaxY(self.lineView.frame),1, 40);
        self.verLineView.backgroundColor =  [UIColor colorWithHexString:@"#F7F8FC"];
        [self.alertView addSubview:self.verLineView];
        
        if(sureTitle && cancleTitle){
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.verLineView.frame), CGRectGetMaxY(self.lineView.frame), ( self.alertView.frame.size.width-1)/2+1, 40);
            [self.sureBtn setTitle:cancleTitle forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:right ? [UIColor colorWithHexString:WHITEMAINCOLOR] : GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
            self.sureBtn.tag = 2;
            [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
            
        }
        //计算高度
        CGFloat alertHeight = cancleTitle?CGRectGetMaxY(self.cancleBtn.frame):CGRectGetMaxY(self.sureBtn.frame);
        self.alertView.frame = CGRectMake(0, 0,  self.alertView.frame.size.width, alertHeight);
        self.alertView.layer.position = self.center;
  
        [self addSubview:self.alertView];
    }
    
    return self;
}

#pragma mark - 弹出 -
- (void)showXLAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 回调 -设置只有2 -- > 确定才回调
- (void)buttonEvent:(UIButton *)sender
{
    [self.timer invalidate];
    self.timer = nil;
    if (self.resultIndex) {
        self.resultIndex(sender.tag);
    }
    [self removeFromSuperview];
}

- (void)dissMissView{
    [self removeFromSuperview];
}

-(UILabel *)GetAdaptiveLable:(CGRect)rect AndText:(NSString *)contentStr andIsTitle:(BOOL)isTitle
{
    UILabel *contentLbl = [[UILabel alloc] initWithFrame:rect];
    contentLbl.numberOfLines = 0;
    contentLbl.text = contentStr;
    contentLbl.textColor = [UIColor colorWithHexString:@"#030303"];
    contentLbl.textAlignment = NSTextAlignmentCenter;
    if (isTitle) {
        contentLbl.font = [UIFont boldSystemFontOfSize:16.0];
    }else{
        contentLbl.font = [UIFont systemFontOfSize:13.0];
    }
    
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle *mParaStyle = [[NSMutableParagraphStyle alloc] init];
    mParaStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [mParaStyle setLineSpacing:3.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:mParaStyle range:NSMakeRange(0,[contentStr length])];
    [contentLbl setAttributedText:mAttrStr];
    [contentLbl sizeToFit];
    
    return contentLbl;
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
