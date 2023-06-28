//
//  AppDelegate+Notification.h
//  XGFamilyTerminal
//
//  Created by HandsomeC on 2018/5/5.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Notification)

- (void)configurationJPushWithLaunchOptions:(NSDictionary *)launchOptions;
- (void)regsigerTencent;
- (void)jpushSetAlias;
- (void)deleteAlias;
@end
