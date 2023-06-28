//
//  NoticeTeamSetController.h
//  NoticeXi
//
//  Created by li lei on 2023/6/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeGroupListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamSetController : NoticeBaseListController
@property (nonatomic, strong) NoticeGroupListModel *teamModel;
@property (nonatomic, strong) NSString *identity;
@property (nonatomic,copy) void (^personBlock)(NSMutableArray *personArr,NSMutableArray *syArr);
@end

NS_ASSUME_NONNULL_END
