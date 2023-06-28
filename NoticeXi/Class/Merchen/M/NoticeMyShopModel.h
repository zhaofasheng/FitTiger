//
//  NoticeMyShopModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeMyShopModel : NSObject

@property (nonatomic, strong) NSDictionary *shop;
@property (nonatomic, strong) NoticeMyShopModel *myShopM;
@property (nonatomic, strong) NSString *jingbi;//买家鲸币数量，获取别人店铺信息的时候返回
@property (nonatomic, strong) NSString *get_order_time;//接单等待倒计时时间（单位秒）
@property (nonatomic, strong) NSString *order_over_time;//订单倒计时间（单位秒）

@property (nonatomic, strong) NSString *introduce_len;
@property (nonatomic, strong) NSString *introduce_url;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *audit_status;
@property (nonatomic, strong) NSString *operate_status;//经营状态经营状态 1下线  2上线 3服务中
@property (nonatomic, strong) NSString *order_num;
@property (nonatomic, strong) NSString *income;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *is_stop;
@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, strong) NSArray *role_list;
@property (nonatomic, strong) NSMutableArray *role_listArr;
@property (nonatomic, strong) NSString *role_img_url;


@property (nonatomic, strong) NSMutableArray *goods_list;
@property (nonatomic, strong) NSMutableArray *goods_listArr;

@property (nonatomic, strong) NSDictionary *texts;
@property (nonatomic, strong) NoticeMyShopModel *textModel;//文案模型
@property (nonatomic, strong) NSString *text1;//文字聊天文案
@property (nonatomic, strong) NSString *text1_jinbi;//文字鲸币
@property (nonatomic, strong) NSString *text2;//语音聊天文案
@property (nonatomic, strong) NSString *text2_jinbi;//语音聊天鲸币/分钟

@property (nonatomic, strong) NSArray *label_list;
@property (nonatomic, strong) NSMutableArray *labelArr;

@end

NS_ASSUME_NONNULL_END
