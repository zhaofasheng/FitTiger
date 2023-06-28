//
//  NoticePersonality.h
//  NoticeXi
//
//  Created by li lei on 2019/1/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePersonality : NSObject
@property (nonatomic, strong) NSString *personalityId;//性格类型ID
@property (nonatomic, strong) NSString *personality_no;//性格类型编号
@property (nonatomic, strong) NSString *personality_title;//性格类型标题
@property (nonatomic, strong) NSString *personality_desc_long;//性格类型描述
@property (nonatomic, strong) NSString *saying_content;//性格类型名言
@property (nonatomic, strong) NSString *saying_from;//性格类型名言来源
@property (nonatomic, strong) NSString *share_url;//分享地址
@property (nonatomic, strong) NSString *today_join;//今日新加入阵营数量，排除自身
@property (nonatomic, strong) NSString *allDesc;//今日新加入阵营数量，排除自身
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *personName;//性格类型名称
@property (nonatomic, assign) CGFloat webHeight;
@property (nonatomic, strong) NSString *personality_feature;//今日新加入阵营数量，排除自身
@property (nonatomic, assign) BOOL isAll;//是否查看全部描述
@property (nonatomic, assign) BOOL hasLoad;//是否查看全部描述
@end

NS_ASSUME_NONNULL_END
