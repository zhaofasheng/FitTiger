//
//  NoticeShopCommentModel.h
//  NoticeXi
//
//  Created by li lei on 2023/4/17.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopCommentModel : NSObject
@property (nonatomic, strong) NSString *comId;//评论id
@property (nonatomic, strong) NSString *user_id;//评论用户id
@property (nonatomic, strong) NSString *order_id;//订单id
@property (nonatomic, strong) NSString *shop_id;//店铺id
@property (nonatomic, strong) NSString *marks;//评论内容
@property (nonatomic, strong) NSAttributedString *marksAttTextStr;
@property (nonatomic, assign) CGFloat marksHeight;
@property (nonatomic, strong) NSString *to_user_id;//被评论的用户id
@property (nonatomic, strong) NSString *score;//评分
@property (nonatomic, strong) NSString *type;//买家评价，店铺评价
@property (nonatomic, strong) NSString *created_at;//评论时间

@property (nonatomic, strong) NSAttributedString *labelAtt;
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, strong) NSArray *label_list;//评论标签

@property (nonatomic, strong) NSString *goods_img_url;//商品图片
@property (nonatomic, strong) NSString *room_id;//房间id
@property (nonatomic, strong) NSString *goods_name;//商品名称
@property (nonatomic, strong) NSString *second;//语音聊天时长
@property (nonatomic, strong) NSString *order_created_at;//订单下单时间


@property (nonatomic, strong) NSDictionary *userComment;
@property (nonatomic, strong) NoticeShopCommentModel *userCommentModel;
@property (nonatomic, strong) NSDictionary *shopComment;
@property (nonatomic, strong) NoticeShopCommentModel *shopCommentModel;
@end

NS_ASSUME_NONNULL_END
