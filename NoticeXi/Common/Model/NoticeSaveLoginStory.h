//
//  NoticeSaveLoginStory.h
//  NoticeXi
//
//  Created by li lei on 2021/5/13.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSaveLoginStory : NSObject
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *avatar_url;//头像地址
@property (nonatomic, strong) NSString *loginType;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *openId;
@end

NS_ASSUME_NONNULL_END
