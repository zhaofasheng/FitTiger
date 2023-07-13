//
//  NoticeTieTieCaleModel.h
//  NoticeXi
//
//  Created by li lei on 2022/10/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTieTieCaleModel : NSObject

@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSArray *months;//月份数量
@property (nonatomic, strong) NSMutableArray *monthModels;

@property (nonatomic, strong) NSString *month;//月份
@property (nonatomic, strong) NSArray *days;//天数
@property (nonatomic, strong) NSMutableArray *dayModels;

@property (nonatomic, strong) NSString *day;//日期天
@property (nonatomic, strong) NSString *collection;
@property (nonatomic, strong) NSString *voice;
@property (nonatomic, strong) NSString *img_url;

@end

NS_ASSUME_NONNULL_END
