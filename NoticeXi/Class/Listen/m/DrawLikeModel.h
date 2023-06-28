//
//  DrawLikeModel.h
//  NoticeXi
//
//  Created by li lei on 2019/7/10.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawLikeModel : NSObject

@property (nonatomic, strong) NSString *artwork_id;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *likeId;
@property (nonatomic, strong) NSString *like_type;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *identity_type;
@end

NS_ASSUME_NONNULL_END
