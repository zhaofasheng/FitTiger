//
//  NoticeFriendRquestViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeFriendRquestViewController : NoticeBaseListController
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) NSString *pushType;
@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, assign) BOOL isFromPushOfBoke;
@property (nonatomic, assign) BOOL isFromPushOfArt;
@end

NS_ASSUME_NONNULL_END
