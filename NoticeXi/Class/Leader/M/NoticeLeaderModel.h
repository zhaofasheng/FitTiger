//
//  NoticeLeaderModel.h
//  NoticeXi
//
//  Created by li lei on 2022/3/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeRecesouceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeLeaderModel : NSObject

@property (nonatomic, strong) NSString *leadId;

@property (nonatomic, strong) NSString *admin_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *result;
@property (nonatomic, strong) NSMutableArray *firstArr;
@property (nonatomic, strong) NSArray *result_two;
@property (nonatomic, strong) NSMutableArray *secondArr;
@property (nonatomic, strong) NSArray *result_three;
@property (nonatomic, strong) NSMutableArray *thirdArr;
@property (nonatomic, strong) NSString *task_status;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *is_complete;


@end

NS_ASSUME_NONNULL_END
