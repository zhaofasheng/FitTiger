//
//  NoticeTimeTools.h
//  NoticeXi
//
//  Created by li lei on 2019/7/3.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTimeTools : NSObject
+ (NSString *)getCurrentTimeyyyymmdd;
+ (NSString *)needShowTimeMark;//判断当前聊天时间是否是节假日和休息时间
@end

NS_ASSUME_NONNULL_END
