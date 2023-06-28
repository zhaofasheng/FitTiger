//
//  NoticeMerchantModel.h
//  NoticeXi
//
//  Created by li lei on 2021/11/29.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeOpenTbModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMerchantModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *skip_url;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSMutableArray *subModelArr;

@end

NS_ASSUME_NONNULL_END
