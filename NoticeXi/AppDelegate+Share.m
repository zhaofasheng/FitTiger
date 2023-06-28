//
//  AppDelegate+Share.m
//  XGFamilyTerminal
//
//  Created by 赵小二 on 2018/7/24.
//  Copyright © 2018年 xiao_5. All rights reserved.
//

#import "AppDelegate+Share.h"
/*分享头文件*/
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
@implementation AppDelegate (Share)

- (void)regreiteShare{
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:@"101461065" appkey:@"459701b937fc61ac1bbad1a0be2c46ce"];
        
        //微信
        [platformsRegister setupWeChatWithAppId:@"wx1c7709f7121a6877" appSecret:@"ad861fb8d0c1d534b488b18b1057945d"];//登录用的
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"3779229073" appSecret:@"578f92af2e698698cab1cf03ffcb009e" redirectUrl:@"http://www.sharesd.cn"];
        
    }];
}

@end
