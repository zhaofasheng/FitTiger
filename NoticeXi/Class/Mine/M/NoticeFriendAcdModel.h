//
//  NoticeFriendAcdModel.h
//  NoticeXi
//
//  Created by li lei on 2020/5/11.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeFriendAcdModel : NSObject
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *careId;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *from_user_id;//欣赏来自谁
@property (nonatomic, strong) NSString *is_admire;
@property (nonatomic, strong) NSString *is_myadmire;
@property (nonatomic, assign) BOOL needCare;
@property (nonatomic, assign) BOOL more;
@property (nonatomic, assign) BOOL localData;//本地模拟数据
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *levelImgName;
@property (nonatomic, strong) NSString *smallLevelImgName;
@property (nonatomic, strong) NSString *levelImgIconName;
@property (nonatomic, strong) NSString *levelName;
@property (nonatomic, strong) NSString *is_update;
@end

NS_ASSUME_NONNULL_END
