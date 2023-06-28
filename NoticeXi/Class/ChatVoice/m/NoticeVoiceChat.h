//
//  NoticeVoiceChat.h
//  NoticeXi
//
//  Created by li lei on 2018/11/5.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeVoiceListSubModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceChat : NSObject
@property (nonatomic, strong) NSString *chat_id;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *resource_url;
@property (nonatomic, strong) NSString *resource_len;
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *dialog_num;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *dialog_id;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSString *content_type;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NoticeVoiceListSubModel *subUserModel;//user
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *nowTime;
@property (nonatomic, assign) CGFloat nowPro;
@end

NS_ASSUME_NONNULL_END
