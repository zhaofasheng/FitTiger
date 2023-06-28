//
//  NoticeDrawList.h
//  NoticeXi
//
//  Created by li lei on 2019/7/8.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDrawList : NSObject

@property (nonatomic, assign) NSInteger fromType;//判断最后一个数据来自哪个接口
@property (nonatomic, strong) NSString *drawId;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *topic_name;
@property (nonatomic, strong) NSString *topic_id;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, strong) NSString *artwork_url;
@property (nonatomic, strong) NSString *is_private;
@property (nonatomic, strong) NSString *viewed_num;//浏览数量
@property (nonatomic, strong) NSString *anonymous_like_num;//匿名点赞数量
@property (nonatomic, strong) NSString *publicly_like_num;//公开点赞数量
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *artwork_status;//美术品状态，1：正常，2：用户删除，3：系统删除
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *topName;
@property (nonatomic, strong) NSString *like_type;
@property (nonatomic, strong) NSString *identity_type;
@property (nonatomic, strong) NSString *hide_at;//大于l0表示已隐藏
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) NSString *graffiti_switch;
@property (nonatomic, strong) NSString *graffiti_num;
@property (nonatomic, strong) NSString *being_graffiti;//是否被当前用户涂鸦过
@property (nonatomic, strong) NSDictionary *user_info;
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *collection_id;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *dialog_num;//和别人的涂鸦对话数量
@property (nonatomic, strong) NSString *chat_num;//自己的涂鸦对话数量
@property (nonatomic, strong) NSString *top_id;
@property (nonatomic, strong) NSString *topId;
@property (nonatomic, strong) NSString *collectionId;
@property (nonatomic, assign) BOOL isBlack;
@property (nonatomic, assign) BOOL hasGetBlack;
@property (nonatomic, assign) BOOL isPick;

@property (nonatomic, strong) NSString *levelName;//等级
@property (nonatomic, strong) NSString *levelImgName;//等级图片
@property (nonatomic, strong) NSString *levelImgIconName;//等级头像
@end

NS_ASSUME_NONNULL_END
