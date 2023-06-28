//
//  NoticeFile.h
//  NoticeXi
//
//  Created by li lei on 2018/10/30.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeFile : NSObject
@property (nonatomic, strong) NSString *AccessKeyId;
@property (nonatomic, strong) NSString *AccessKeySecret;
@property (nonatomic, strong) NSString *Expiration;
@property (nonatomic, strong) NSString *SecurityToken;
@property (nonatomic, strong) NSArray *resource_content;
@end

NS_ASSUME_NONNULL_END
