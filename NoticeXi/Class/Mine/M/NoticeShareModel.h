//
//  NoticeShareModel.h
//  NoticeXi
//
//  Created by li lei on 2020/7/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShareModel : NSObject
@property (nonatomic, strong) NSString *can_share;
@property (nonatomic, strong) NSString *left_times;
@property (nonatomic, strong) NSString *last_shared;
@property (nonatomic, strong) NSString *nearby_at;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) NSString *nextTime;
@end

NS_ASSUME_NONNULL_END
