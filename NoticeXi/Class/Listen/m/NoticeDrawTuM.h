//
//  NoticeDrawTuM.h
//  NoticeXi
//
//  Created by li lei on 2019/10/25.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDrawTuM : NSObject
@property (nonatomic, strong) NSString *artwork_id;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *graffiti_status;
@property (nonatomic, strong) NSString *graffiti_url;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *graffitiId;
@property (nonatomic, strong) NSString *parent_user_id;//涂鸦绘画作品用户ID
@property (nonatomic, strong) NSString *topic_id;
@property (nonatomic, strong) NSString *topic_name;
@property (nonatomic, strong) NSString *topName;
@property (nonatomic, strong) NSString *user_id;//涂鸦用户ID
@property (nonatomic, strong) NSString *vote_option_one;//你是天使
@property (nonatomic, strong) NSString *vote_option_two;//你是天使
@property (nonatomic, strong) NSString *vote_option;//仅当用户投票了，才返回，1:天使，2:恶魔
@property (nonatomic, strong) NSString *vote_id;
@property (nonatomic, strong) NSString *viewed_num;
@end

NS_ASSUME_NONNULL_END
