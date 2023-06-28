//
//  NoticeChatToKfController.h
//  NoticeXi
//
//  Created by li lei on 2020/8/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChatToKfController : BaseTableViewController
@property (nonatomic, strong) NSString *toUser;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, strong) NSString *userFlag;
@property (nonatomic, strong) NSString *identType;
@property (nonatomic, assign) BOOL isKeFu;
@property (nonatomic, assign) BOOL isNeedHelp;
@end

NS_ASSUME_NONNULL_END
