//
//  NoticeOTOModel.h
//  NoticeXi
//
//  Created by li lei on 2018/12/28.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeOTOModel : NSObject
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *keyword;
@property (nonatomic, strong) NSString *app_content;
@property (nonatomic, strong) NSString *forced_update;
@property (nonatomic, strong) NSString *stop_at;

@property (nonatomic, strong) NSDictionary *matchInfo;
@end

NS_ASSUME_NONNULL_END
