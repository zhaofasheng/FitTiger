//
//  NoticeClockBdUser.h
//  NoticeXi
//
//  Created by li lei on 2019/11/11.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeClockBdUser : NSObject
@property (nonatomic, strong) NSString *didding_id;
@property (nonatomic, strong) NSDictionary *didding_user_info;
@property (nonatomic, strong) NSString *didding_vote_num;
@property (nonatomic, strong) NoticeUserInfoModel *didding_userM;

@property (nonatomic, strong) NSString *line_id;
@property (nonatomic, strong) NSString *line_vote_num;
@property (nonatomic, strong) NSDictionary *line_user_info;
@property (nonatomic, strong) NoticeUserInfoModel *line_userM;
@end

NS_ASSUME_NONNULL_END
