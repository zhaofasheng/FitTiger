//
//  NoticeChangeRecoderModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/18.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeRecoderModel : NSObject

@property (nonatomic, strong) NSString *recodId;//交易id
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *recharge_balance;
@property (nonatomic, strong) NSString *income_balance;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *transaction_no;
@property (nonatomic, strong) NSString *created_at;//交易时间
@property (nonatomic, strong) NSString *transfer_status;
@property (nonatomic, strong) NSString *shop_name;

@property (nonatomic, strong) NSString *order_sn;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *mark;
@end

NS_ASSUME_NONNULL_END
