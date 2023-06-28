//
//  NoticeMyCareModel.h
//  NoticeXi
//
//  Created by li lei on 2020/1/11.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceListSubModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyCareModel : NSObject
@property (nonatomic, strong) NSString *subId;
@property (nonatomic, strong) NSString *log_id;
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *established_at;
@property (nonatomic, strong) NSString *renewed_at;
@property (nonatomic, strong) NoticeVoiceListSubModel *userInfo;
@property (nonatomic, strong) NSDictionary *subscribeUser;
@end

NS_ASSUME_NONNULL_END
