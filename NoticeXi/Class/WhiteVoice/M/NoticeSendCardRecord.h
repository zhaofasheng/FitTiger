//
//  NoticeSendCardRecord.h
//  NoticeXi
//
//  Created by li lei on 2021/1/11.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendCardRecord : NSObject
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString *card_no;
@property (nonatomic, strong) NSString *resource_id;
@property (nonatomic, strong) NSString *log_status;//记录状态，1:正常，2:用户删除，3:系统删除
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSDictionary *from_user_info;
@property (nonatomic, strong) NoticeAbout *fromUserInfo;
@end

NS_ASSUME_NONNULL_END
