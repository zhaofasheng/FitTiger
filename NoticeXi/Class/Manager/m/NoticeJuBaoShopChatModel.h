//
//  NoticeJuBaoShopChatModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/20.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeJuBaoShopChatModel : NSObject

@property (nonatomic, strong) NSString *jubaiId;
@property (nonatomic, strong) NSString *type_id;//1=人身攻击，2=色情暴力，3=垃圾广告，4=无响应
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *resource_id;
@property (nonatomic, strong) NSString *shop_id;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString *report_status;//1=待处理，2=停1天 3=听三天 4=关店 5=禁一天6永久禁号 7忽略
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *shop_name;

@property (nonatomic, strong) NSDictionary *from_user_info;
@property (nonatomic, strong) NoticeAbout *fromeUserM;

@property (nonatomic, strong) NSDictionary *to_user_info;
@property (nonatomic, strong) NoticeAbout *toUserM;

@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *from_report_num;
@property (nonatomic, strong) NSString *to_report_num;
@property (nonatomic, strong) NSString *second;
@property (nonatomic, strong) NSString *unit_price;
@end

NS_ASSUME_NONNULL_END
