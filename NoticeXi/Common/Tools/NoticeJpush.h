//
//  NoticeJpush.h
//  NoticeXi
//
//  Created by li lei on 2018/11/13.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeJpush : NSObject
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *sessionID;
@property (nonatomic, strong) NSString *title;
@end

NS_ASSUME_NONNULL_END
