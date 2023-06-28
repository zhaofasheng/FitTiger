//
//  NoticeSuperMangerClickPersongController.h
//  NoticeXi
//
//  Created by li lei on 2023/6/19.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeTeamChatModel.h"
#import "YYPersonItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSuperMangerClickPersongController : NoticeBaseListController
@property (nonatomic, strong) YYPersonItem *person;
@property (nonatomic, strong) NoticeTeamChatModel *chatModel;
@property (nonatomic,copy) void (^clickButtonTagBlock)(NSString *clickStr);
@property (nonatomic,copy) void (^cancelManageBlock)(NSString *userId);
@property (nonatomic, strong) NSString *identity;
@end

NS_ASSUME_NONNULL_END
