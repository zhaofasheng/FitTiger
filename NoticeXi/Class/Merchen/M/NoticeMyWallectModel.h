//
//  NoticeMyWallectModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/11.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyWallectModel : NSObject

@property (nonatomic, strong) NSString *recharge_balance;
@property (nonatomic, strong) NSString *income_balance;
@property (nonatomic, strong) NSString *total_balance;

@property (nonatomic, strong) NSString *limit_amount;
@property (nonatomic, strong) NSString *proportion_text;


@property (nonatomic, strong) NSString *tixianId;
@property (nonatomic, strong) NSString *identity_name;
@property (nonatomic, strong) NSString *identity_img_url;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSArray *payment_methods;
@property (nonatomic, strong) NSMutableArray *payModelArr;
@end

NS_ASSUME_NONNULL_END
