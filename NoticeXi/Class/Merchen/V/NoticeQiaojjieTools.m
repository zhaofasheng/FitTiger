//
//  NoticeQiaojjieTools.m
//  NoticeXi
//
//  Created by li lei on 2022/7/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeQiaojjieTools.h"

@implementation NoticeQiaojjieTools

+ (void)showWithTitle:(NSString *)title msg:(NSString *)msg button1:(NSString *)button1 button2:(NSString *)button2 clickBlcok:(clikSureBlock)clickBlock{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:title message:nil sureBtn:button1 cancleBtn:button2 right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            clickBlock(1);
        }
    };
    [alerView showXLAlertView];
}
+ (void)showWithTitle:(NSString *)title{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:title message:nil cancleBtn:@"知道了"];
    [alerView showXLAlertView];
}

+ (void)showWithJieDanTitle:(NSString *)title orderId:(NSString *)orderId time:(NSString *)time creatTime:(NSString *)creatTime clickBlcok:(clikSureBlock)clickBlock{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil name:title time:time creatTime:creatTime.integerValue];
    alerView.orderId = orderId;
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            clickBlock(1);
        }
    };
    [alerView showXLAlertView];
}

+ (void)showWithJieDanTitle:(NSString *)title roomId:(NSString *)roomId time:(NSString *)time creatTime:(NSString *)creatTime clickBlcok:(clikSureBlock)clickBlock{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil name:title time:time creatTime:creatTime.integerValue];
    alerView.roomId = roomId;
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            clickBlock(1);
        }
    };
    [alerView showXLAlertView];
}

@end
