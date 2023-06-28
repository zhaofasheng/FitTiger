//
//  NoticeAreaModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeAreaModel : NSObject

@property (nonatomic, strong) NSString *area_code;
@property (nonatomic, strong) NSString *area_name;
@property (nonatomic, strong) NSString *phone_code;
@property (nonatomic, strong) NSString *country_id;
@property (nonatomic, strong) NSString *region;

@end

NS_ASSUME_NONNULL_END
