//
//  NoticeFriendVoiceListViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/30.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeFriendVoiceListViewController : BaseTableViewController<NoticeAssestDelegate>
@property (nonatomic,copy) void (^playStatusBlock)(BOOL isPlaying);
@end

NS_ASSUME_NONNULL_END
