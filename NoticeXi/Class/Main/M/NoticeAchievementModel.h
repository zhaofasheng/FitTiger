//
//  NoticeAchievementModel.h
//  NoticeXi
//
//  Created by li lei on 2020/4/8.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFSDateFormatUtil.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAchievementModel : NSObject
@property (nonatomic, strong) NSString *achievement_type;
@property (nonatomic, strong) NSString *latest_at;
@property (nonatomic, strong) NSString *started_at;
@property (nonatomic, assign) NSTimeInterval latest_at_timeValue;
@property (nonatomic, assign) NSTimeInterval started_at_timeValue;
@property (nonatomic, assign) NSTimeInterval today_timeValue;
@property (nonatomic, assign) NSTimeInterval yesterDay_timeValue;
@end

NS_ASSUME_NONNULL_END
