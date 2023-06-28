//
//  NoticePiPeiFriendListViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/5/28.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"
#import "NoticePiPeiSet.h"
#import "NoticeMyFriends.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePiPeiFriendListViewController : BaseTableViewController
@property (nonatomic, assign) BOOL isPhone;
@property (nonatomic, strong) NSString  *hasUserId;
@property (nonatomic,copy) void (^pipeiBlock)(NoticeMyFriends *user);
@end

NS_ASSUME_NONNULL_END
