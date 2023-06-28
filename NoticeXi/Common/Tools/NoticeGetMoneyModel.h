//
//  NoticeGetMoneyModel.h
//  NoticeXi
//
//  Created by li lei on 2022/6/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessAliPayBlock)(NSString *codeAuth);// 访问成功block
typedef void (^SuccessWeChatBlock)(NSString *openId);// 访问成功block
typedef void (^failBlock)(NSString *errmsg);// 访问失败block
NS_ASSUME_NONNULL_BEGIN

@interface NoticeGetMoneyModel : NSObject

+ (void)aliPaySuccess;

@end

NS_ASSUME_NONNULL_END
