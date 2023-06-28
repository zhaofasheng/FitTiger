//
//  NoticeContributionModel.h
//  NoticeXi
//
//  Created by li lei on 2020/11/13.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeAnnexsModel.h"
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeContributionModel : NSObject
@property (nonatomic, strong) NSString *tougaoId;
@property (nonatomic, strong) NSString *contribution_title;
@property (nonatomic, strong) NSString *contribution_content;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *draft_from;
@property (nonatomic, strong) NSString *draft_id;
@property (nonatomic, strong) NSString *post_id;//帖子ID，为0:未采纳为帖子
@property (nonatomic, strong) NSString *contribution_status;//投稿状态，1：正常，2:用户删除，3:系统删除
@property (nonatomic, strong) NSString *created_at;

@property (nonatomic, strong) NSDictionary *from_user_info;
@property (nonatomic, strong) NoticeAbout *userInfo;

@property (nonatomic, strong) NSMutableArray *annexsArr;
@property (nonatomic, strong) NSArray *annexs;
@end

NS_ASSUME_NONNULL_END
