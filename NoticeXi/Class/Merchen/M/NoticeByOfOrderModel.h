//
//  NoticeByOfOrderModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/12.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeByOfOrderModel : NSObject

@property (nonatomic, strong) NSString *user_id;//买家id
@property (nonatomic, strong) NSString *user_nick_name;
@property (nonatomic, strong) NSString *sn;//订单号
@property (nonatomic, strong) NSString *price;//鲸币 //socket的时候是用户支付的价格
@property (nonatomic, strong) NSString *ratio;
@property (nonatomic, strong) NSString *reality_jingbi;//卖家收入鲸币价格
@property (nonatomic, strong) NSString *second;//通话时长
@property (nonatomic, strong) NSString *minute_jingbi;//通话结束后socket消息显示的每分钟鲸币的价格
@property (nonatomic, strong) NSString *shop_id;//店铺id
@property (nonatomic, strong) NSString *goods_id;//商品id
@property (nonatomic, strong) NSString *order_type;//1等待接单2自己取消订单3商家取消4订单超时5接单成功6订单完成7订单被举报8举报处理完成
@property (nonatomic, strong) NSString *created_at;//创建时间
@property (nonatomic, strong) NSString *created_atTime;//下单时间
@property (nonatomic, strong) NSString *orderId;//订单Id
@property (nonatomic, strong) NSString *room_id;//语音聊天房间id
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *goods_img_url;//商品图片
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *get_time;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *goods_type;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *get_order_time;

@property (nonatomic, strong) NSString *completeNum;//完成数量
@property (nonatomic, strong) NSString *failNum;//失效数量

@property (nonatomic, strong) NSString *user_sig;
/*
 店铺状态说明  key=>shopOrder
 //店铺订单消息-有新的订单来了
 const TYPE_ORDER_FROM = 77666;
 //店铺订单消息-店铺取消订单
 const TYPE_SHOP_CANCEL = 77667;
 //店铺订单消息-买家取消订单
 const TYPE_BUY_CANCEL = 77668;
 //订单超时
 const TYPE_ORDER_OVERTIME = 77669;
 //订单接单
 const TYPE_GET_ORDER = 77670;
 //订单被举报
 const TYPE_REPORT = 77671;
 //订单完成
 const TYPE_COMPLETE = 77672;
 */

@property (nonatomic, strong) NSString *type;//推送类型
@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, strong) NoticeByOfOrderModel *resultModel;
@property (nonatomic, strong) NSString *shop_user_id;
@end

NS_ASSUME_NONNULL_END
