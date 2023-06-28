//
//  NoticePaySaveModel.h
//  NoticeXi
//
//  Created by li lei on 2022/6/2.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePaySaveModel : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *isNiming;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userNum;

@end

NS_ASSUME_NONNULL_END
