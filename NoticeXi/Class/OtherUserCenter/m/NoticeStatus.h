//
//  NoticeStatus.h
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeFriendStatus.h"
#import "NoticeChatStatus.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeStatus : NSObject
@property (nonatomic, strong) NSDictionary *chatPri;
@property (nonatomic, strong) NSDictionary *confession;
@property (nonatomic, strong) NSDictionary *friendS;
@property (nonatomic, strong) NoticeFriendStatus *friendStatus;
@property (nonatomic, strong) NoticeChatStatus *chatStatus;
@property (nonatomic, strong) NSString *be_in_allowed;
@property (nonatomic, strong) NSString *admired_id;
@property (nonatomic, strong) NSString *AdmiredId;
@property (nonatomic, strong) NSString *close_border;//是否处于闭关模式  1不处于闭关，0处于闭关
@end

NS_ASSUME_NONNULL_END
