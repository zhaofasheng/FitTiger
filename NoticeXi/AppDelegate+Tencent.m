//
//  AppDelegate+Tencent.m
//  NoticeXi
//
//  Created by li lei on 2023/3/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "AppDelegate+Tencent.h"

#import <ImSDK_Plus/ImSDK_Plus.h>


@interface AppDelegate ()<V2TIMAPNSListener>

@end

@implementation AppDelegate(Tencent)

- (void)regsigerTencent{

    [V2TIMManager.sharedInstance setAPNSListener:self];
}


- (void)onReportToken:(NSData *)deviceToken
{
    if (deviceToken) {
        V2TIMAPNSConfig *confg = [[V2TIMAPNSConfig alloc] init];
        // 企业证书 ID
        // 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，
        // 控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。
        
        //38113生存环境 38114开发环境
        confg.businessID = 38113;
        confg.token = deviceToken;
        [[V2TIMManager sharedInstance] setAPNS:confg succ:^{
             DRLog(@"%s, 推送证书设置成功", __func__);
        } fail:^(int code, NSString *msg) {
             DRLog(@"%s, 推送证书设置失败, %d, %@", __func__, code, msg);
        }];
    }
}


//清除腾讯IM未读消息角标
- (uint32_t)onSetAPPUnreadCount{
    return 0;
}

@end
