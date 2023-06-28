//
//  NoticeShopChuliModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/19.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopChuliModel : NSObject

@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSDictionary *from_user_info;
@property (nonatomic, strong) NoticeAbout *userM;
@property (nonatomic, strong) NSString *audit_status;
@end

NS_ASSUME_NONNULL_END
