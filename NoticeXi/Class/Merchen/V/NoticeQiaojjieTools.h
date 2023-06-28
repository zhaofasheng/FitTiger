//
//  NoticeQiaojjieTools.h
//  NoticeXi
//
//  Created by li lei on 2022/7/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^clikSureBlock)(NSInteger tag);

@interface NoticeQiaojjieTools : UIView
+ (void)showWithJieDanTitle:(NSString *)title orderId:(NSString *)orderId time:(NSString *)time creatTime:(NSString *)creatTime clickBlcok:(clikSureBlock)clickBlock;
+ (void)showWithTitle:(NSString *)title msg:(NSString *)msg button1:(NSString *)button1 button2:(NSString *)button2 clickBlcok:(clikSureBlock _Nullable)clickBlock;
+ (void)showWithTitle:(NSString *)title;
+ (void)showWithJieDanTitle:(NSString *)title roomId:(NSString *)roomId time:(NSString *)time creatTime:(NSString *)creatTime clickBlcok:(clikSureBlock)clickBlock;
@end

NS_ASSUME_NONNULL_END
