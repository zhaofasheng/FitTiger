//
//  NoticeMJIDModel.h
//  NoticeXi
//
//  Created by li lei on 2020/11/13.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMJIDModel : NSObject
@property (nonatomic, strong) NSString *allId;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *replys;

@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *success;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *resultStatus;
@property (nonatomic, strong) NSString *auth_code;
@property (nonatomic, strong) NSString *result_code;
@property (nonatomic, strong) NSString *is_collcetion;
@property (nonatomic, strong) NSString *identity_name;
@property (nonatomic, strong) NSString *identity_img_url;
@end

NS_ASSUME_NONNULL_END
