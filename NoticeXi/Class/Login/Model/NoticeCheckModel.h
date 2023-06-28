//
//  NoticeCheckModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCheckModel : NSObject
@property (nonatomic, strong) NSString *is_exist;
@property (nonatomic, strong) NSString *is_forbid;
@property (nonatomic, strong) NSDictionary *user_info;
@property (nonatomic, strong) NoticeUserInfoModel *userM;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *loginToken;
@end

NS_ASSUME_NONNULL_END
