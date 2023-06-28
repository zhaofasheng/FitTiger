//
//  NoticeAction.h
//  NoticeXi
//
//  Created by li lei on 2019/3/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeAction : NSObject
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *assoc_id;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *chat_type;
@property (nonatomic, strong) NSString *released_at;
@property (nonatomic, strong) NSString *releaseTime;
@property (nonatomic, strong) NSString *party;
@property (nonatomic, strong) NSString *flag;
@end

NS_ASSUME_NONNULL_END
