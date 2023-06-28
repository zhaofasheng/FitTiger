//
//  NoticeMyFriends.h
//  NoticeXi
//
//  Created by li lei on 2018/11/2.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyFriends : NSObject
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *release_at;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, strong) NSString *identity_type;
@property (nonatomic, strong) NSString *renewed_at;
@property (nonatomic, strong) NSString *renew_months;
@property (nonatomic, strong) NSString *admired_at;
@property (nonatomic, strong) NSString *renew_num;
@end

NS_ASSUME_NONNULL_END
