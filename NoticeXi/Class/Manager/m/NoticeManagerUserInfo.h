//
//  NoticeManagerUserInfo.h
//  NoticeXi
//
//  Created by li lei on 2019/8/30.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeManagerUserInfo : NSObject
@property (nonatomic, strong) NSString *identity_type;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *avatar_url;
@end

NS_ASSUME_NONNULL_END
