//
//  NoticeTeamMemberListController.h
//  NoticeXi
//
//  Created by li lei on 2023/6/19.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeGroupListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamMemberListController : NoticeBaseListController
@property (nonatomic, assign) BOOL isMamger;
@property (nonatomic, strong) NoticeGroupListModel *teamModel;
@property (nonatomic, strong) NSMutableArray *personArr;
@property (nonatomic, strong) NSMutableArray *syArr;
@property (nonatomic, strong) NSString *identity;
@end

NS_ASSUME_NONNULL_END
