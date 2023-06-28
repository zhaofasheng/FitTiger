//
//  NoticeVoiceListSubModel.h
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceListSubModel : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *identity_type;
@property (nonatomic, strong) NSString *dialog_num;
@property (nonatomic, strong) NSString *interface_type;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *platform_id;//1安卓 2iOS
@property (nonatomic, strong) NSString *levelName;//等级
@property (nonatomic, strong) NSString *levelImgName;//等级图片
@property (nonatomic, strong) NSString *levelImgIconName;//等级头像
@property (nonatomic, strong) NSString *smallLevelImgName;
@property (nonatomic, strong) NSString *spec_bg_default_photo;
@property (nonatomic, strong) NSString *spec_bg_photo_url;
@property (nonatomic, strong) NSString *spec_bg_skin_url;
@property (nonatomic, strong) NSString *spec_bg_type;
@property (nonatomic, strong) NSString *spec_bg_svg_url;
@property (nonatomic, strong) NSArray *testArr;
@property (nonatomic, assign) BOOL hasTest;//是否有测试结果
- (void)getTsetStr;
@end

NS_ASSUME_NONNULL_END
