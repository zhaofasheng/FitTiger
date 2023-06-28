//
//  NoticeSacnModel.h
//  NoticeXi
//
//  Created by li lei on 2020/6/30.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeScanResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSacnModel : NSObject
@property (nonatomic, strong) NSString *error_code;//10000表示成功
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, strong) NoticeScanResult *resultModel;
@end

NS_ASSUME_NONNULL_END
