//
//  NoticeTeamChatController.h
//  NoticeXi
//
//  Created by li lei on 2023/6/2.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeGroupListModel.h"
#import "NoticeTeamChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTeamChatController : NoticeBaseListController
@property (nonatomic, strong) NoticeGroupListModel *teamModel;
@property (nonatomic, strong) NoticeTeamChatModel *chatM;
@property (nonatomic, strong) NSString *identity;

@end

NS_ASSUME_NONNULL_END
