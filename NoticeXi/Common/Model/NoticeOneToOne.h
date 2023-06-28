//
//  NoticeOneToOne.h
//  NoticeXi
//
//  Created by li lei on 2018/12/28.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeOTOModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeOneToOne : NSObject
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NoticeOTOModel *chatM;
@end

NS_ASSUME_NONNULL_END
