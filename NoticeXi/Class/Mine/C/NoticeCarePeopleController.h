//
//  NoticeCarePeopleController.h
//  NoticeXi
//
//  Created by li lei on 2021/4/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCarePeopleController : NoticeBaseListController
@property (nonatomic, assign) BOOL isOfCared;
@property (nonatomic, assign) BOOL isLikeEachOther;
@property (nonatomic, assign) BOOL clearNotice;
@property (nonatomic, strong) NSString *resourceId;
@end

NS_ASSUME_NONNULL_END
