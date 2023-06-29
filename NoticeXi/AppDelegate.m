//
//  AppDelegate.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "AppDelegate.h"

#import "NoticeTabbarController.h"
#import "NoticeLoginViewController.h"
#import "BaseNavigationController.h"
#import "NoticeHowToUserViewController.h"
#import "NoticeSendViewController.h"
#import "AppDelegate+Share.h"
#import "AppDelegate+Tencent.h"
#import "AppDelegate+Notification.h"
#import "AFHTTPSessionManager.h"
#import "NoticeStaySys.h"
#import "NoticeVideoViewController.h"
#import "NoticeOTOModel.h"
#import "UNNotificationsManager.h"
#import "NoticeSetSecondPWController.h"
#import "ZFSDateFormatUtil.h"
#import "NoticeShengWangTools.h"
#import "AFNetworking.h"
#import "NoticeShopChatController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NoticeNewUserLeadViewController.h"
#import "JPUSHService.h"
NSString* const yunAppKey = @"dd8114c96a13f86d8bf0f7de477d9cd9";

//  在APPDelegate.m中声明一个通知事件的key
NSString *const AppDelegateReceiveRemoteEventsNotification = @"AppDelegateReceiveRemoteEventsNotification";

@interface AppDelegate ()

@property (nonatomic, assign) NSInteger outTime;
@property (nonatomic, strong) UILabel *dismissLabel;


@end

@implementation AppDelegate

{
    UIBackgroundTaskIdentifier _backIden;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //新版本4月29下午2.17
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    [NoticeTools changeThemeWith:@"whiteColor"];
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
    }
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NoticeAssestPointModel *cachePointM = [NoticeComTools getAssestPointModel];
    if (cachePointM.hasSave) {
        self.floatPoint = CGPointMake(cachePointM.inPointX, cachePointM.inPointY);
        self.floatViewIsOut = cachePointM.floatViewIsOut;
    }
    
    [NoticeSaveModel setUUIDIFNO];
    [self regreiteShare];
    
    [NoticeTools setLangue];//设置默认语言
    
    [Bugly startWithAppId:@"7342677883"];
    
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopVoiceChat) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketReConnect) name:@"CHANGEROOTCONTROLLEFROMOPENRNOTICATION" object:nil];
    //开屏录音切换根视图
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openRootVC) name:@"CHANGEROOTCONTROLLEFROMOPENRNOTICATION" object:nil];
    //切换主页面通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootVC) name:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootNactionVC) name:@"CHANGEROOTCONTROLLERNOTICATIONNEEDACTION" object:nil];
    //更新用户信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:@"REFRESHUSERINFORNOTICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRootVC) name:@"GETROOTCONTROLLEFROMOPENRNOTICATION" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tencentDevicetoken) name:@"ONREPORTDEVICETOKEN" object:nil];
    
    //这里一定要做，否则如果图片URL一样，图片不一样则不会更新图片
    [NoticeTools setImageIfSameUrl];
    [self getRootVC];
    if ([NoticeSaveModel getUserInfo]){
        [self getOrder];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self mustExit];
    });
    
    /** 极光推送 */
    [self configurationJPushWithLaunchOptions:launchOptions];
    
    return YES;
}

- (void)getRootVC{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.6];//设置动画时间
    animation.type = kCATransitionReveal;//设置动画类型
    animation.subtype = kCATransitionFromLeft;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    if ([NoticeSaveModel getUserInfo]) {//已经登录
        
        if (![NoticeComTools getShowLeader]) {
            NoticeNewUserLeadViewController *vc = [[NoticeNewUserLeadViewController alloc] init];
            BaseNavigationController *leadVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
            self.window.rootViewController = leadVC;
            return;
        }
        
        if ([NoticeTools needSecondCheckForLogin]) {//判断是否需要二次登录
            NoticeSetSecondPWController *vc = [[NoticeSetSecondPWController alloc] init];
            vc.isCheck = YES;
            vc.isFromMain = YES;
            BaseNavigationController *pdVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
            self.window.rootViewController = pdVC;
        }else{
            NoticeTabbarController *tabbarVC = [[NoticeTabbarController alloc] init];
            self.window.rootViewController = tabbarVC;
        }
        
        [self jpushSetAlias];
        [self regsigerTencent];//注册腾讯云
    }else{
        [NoticeTools saveType:0];
        NoticeLoginViewController *vc = [[NoticeLoginViewController alloc] init];
        BaseNavigationController *loginVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = loginVC;
    }
}

- (void)socketReConnect{
    NoticeSocketManger *socketManger = [[NoticeSocketManger alloc] init];
    [socketManger reConnect];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager = socketManger;
}

//刷新数据
- (void)refreshUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            if (userIn.token) {
                [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];
        }
    } fail:^(NSError *error) {
    }];
}

//切换试图
- (void)changeMainVC{
    NoticeHowToUserViewController *ctl = [[NoticeHowToUserViewController alloc] init];
    self.window.rootViewController = ctl;
}

//切换根视图
- (void)changeRootVC{
    
    if ([NoticeSaveModel getUserInfo]) {//已经登录
        if (![NoticeComTools getShowLeader]) {
            NoticeNewUserLeadViewController *vc = [[NoticeNewUserLeadViewController alloc] init];
            BaseNavigationController *leadVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
            self.window.rootViewController = leadVC;
            return;
        }
        
        NoticeTabbarController *tabbarVC = [[NoticeTabbarController alloc] init];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.6];//设置动画时间
        animation.type = kCATransitionReveal;//设置动画类型
        animation.subtype = kCATransitionFromLeft;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
        [self jpushSetAlias];
        self.window.rootViewController = tabbarVC;
        [self regsigerTencent];
    }else{
        if (self.floatView.isPlaying) {
            self.floatView.noRePlay = YES;
            [self.floatView.audioPlayer stopPlaying];
        }
       
        NoticeLoginViewController *vc = [[NoticeLoginViewController alloc] init];
        BaseNavigationController *loginVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = loginVC;
    }
}

//主动退出登录
- (void)changeRootNactionVC{
    NoticeLoginViewController *vc = [[NoticeLoginViewController alloc] init];
    BaseNavigationController *loginVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.6];//设置动画时间
    animation.type = kCATransitionReveal;//设置动画类型
    animation.subtype = kCATransitionFromRight;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    self.window.rootViewController = loginVC;
    if (self.floatView.isPlaying) {
        self.floatView.noRePlay = YES;
        [self.floatView.audioPlayer stopPlaying];
    }
}

- (void)openRootVC{
    if ([NoticeSaveModel getUserInfo]) {//已经登录
        NoticeTabbarController *tabbarVC = [[NoticeTabbarController alloc] init];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.6];//设置动画时间
        animation.type = kCATransitionFade;//设置动画类型
        animation.subtype = kCATransitionFromTop;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
        self.window.rootViewController = tabbarVC;
    }else{
        NoticeLoginViewController *vc = [[NoticeLoginViewController alloc] init];
        BaseNavigationController *loginVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.6];//设置动画时间
        animation.type = kCATransitionReveal;//设置动画类型
        animation.subtype = kCATransitionFromRight;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
        self.window.rootViewController = loginVC;
    }
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusReadyToPlay) {
                if (weakSelf.audioPlayer.isLocalFile) {
                    //录音
                } else {
                    //网络
                    DRLog(@"duration %f",duration);
                }
            } else {
                if (status == AVPlayerItemStatusFailed) {
                    [YZC_AlertView showViewWithTitleMessage:@"播放失败，请重试"];
                }
                if (weakSelf.audioPlayer.isLocalFile) {
                } else {
                    //网络音频
                }
            }
        };
    }
    return _audioPlayer;
}

- (NoticeFloatView *)floatView{
    if (!_floatView) {
        _floatView = [[NoticeFloatView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-92,(DR_SCREEN_HEIGHT-56)/2, 92, 56)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewMoved:)];
        [_floatView addGestureRecognizer:pan];
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        [rootWindow addSubview:_floatView];
        _floatView.hidden = YES;
    }
    return _floatView;
}

- (NoticeAudioChatTools *)audioChatTools{
    if(!_audioChatTools){
        _audioChatTools = [[NoticeAudioChatTools alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _audioChatTools;
}

- (void)dragViewMoved:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:rootWindow];
        if (self.floatView.frame.origin.y > DR_SCREEN_HEIGHT-56) {
            self.floatView.center = CGPointMake(self.floatView.center.x, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-56);
        }else if(self.floatView.center.y < NAVIGATION_BAR_HEIGHT+28){
            self.floatView.center = CGPointMake(self.floatView.center.x,28+NAVIGATION_BAR_HEIGHT);
        }
        else{
            self.floatView.center = CGPointMake(self.floatView.center.x, self.floatView.center.y + translation.y);
        }
        
        if (CGRectGetMaxY(self.floatView.frame) > (DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-30)) {
            if (self.dismissLabel.hidden) {
                self.dismissLabel.hidden = NO;
                [rootWindow bringSubviewToFront:self.dismissLabel];
                [rootWindow bringSubviewToFront:self.floatView];
                [UIView animateWithDuration:0.3 animations:^{
                    self.dismissLabel.frame = CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-30, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+30);
                    
                }];
            }
        }else{
            if (!self.dismissLabel.hidden) {
                self.dismissLabel.hidden = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    self.dismissLabel.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+30);
                }];
            }
        }
        
        [panGestureRecognizer setTranslation:CGPointZero inView:rootWindow];
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        _dismissLabel.hidden = YES;
        _dismissLabel.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+30);
        
        if (self.floatView.frame.origin.y > (DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-30)) {
            self.floatView.hidden = YES;
            [NoticeTools setHidePlay:@"1"];
            if (self.floatView.isPlaying) {
                self.floatView.noRePlay = YES;
                [self.floatView.audioPlayer stopPlaying];
            }
        }
        if (self.floatView.frame.origin.y > DR_SCREEN_HEIGHT-56-TAB_BAR_HEIGHT) {
            self.floatView.center = CGPointMake(self.floatView.center.x, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-56);
        }
    }
}

- (void)shopVoiceChat{
    if (self.floatView.isPlaying) {
        self.floatView.noRePlay = YES;
        [self.floatView.audioPlayer stopPlaying];
    }
}

- (UILabel *)dismissLabel{
    if (!_dismissLabel) {
        _dismissLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+30)];
        _dismissLabel.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        _dismissLabel.font = SIXTEENTEXTFONTSIZE;
        _dismissLabel.textColor = [UIColor whiteColor];
        _dismissLabel.textAlignment = NSTextAlignmentCenter;
        _dismissLabel.text = [NoticeTools getLocalStrWith:@"play.tuo"];
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        [rootWindow addSubview:_dismissLabel];
        _dismissLabel.hidden = YES;
    }
    return _dismissLabel;
}

- (void)mustExit{
    
    [[DRNetWorking shareInstance] requestNoTosat:[NSString stringWithFormat:@"apps/2/%@",[NoticeSaveModel getVersion]] Accept:nil parmaer:nil success:^(NSDictionary *dict, BOOL success) {
       
        if (success) {
         
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                [self hsUpdateApp];
                return ;
            }
            NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
            NoticeOTOModel *model = [NoticeOTOModel mj_objectWithKeyValues:dict[@"data"]];
            if ([model.forced_update isEqualToString:@"1"]) {
               
                [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSArray *results = responseObject[@"results"];
                    if (results && results.count > 0) {
                        NSDictionary *response = results.firstObject;
                        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];// 软件的当前版本
                        NSString *lastestVersion = response[@"version"];  //AppStore 上软件的最新版本
                        if ([lastestVersion compare:currentVersion] == NSOrderedDescending) {
                            NoticePinBiView *ppinV = [[NoticePinBiView alloc] initWithStopServer:6 dayNum:0];
                            [ppinV showTostView];
                        }
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }else if (model.stop_at.integerValue){
                NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
                if (model.stop_at.integerValue > currentTime) {
                    NSInteger dayN = [NSString stringWithFormat:@"%.1f",(model.stop_at.integerValue - currentTime)/86400].integerValue;
                    [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        NSArray *results = responseObject[@"results"];
                        if (results && results.count > 0) {
                            NSDictionary *response = results.firstObject;
                            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];// 软件的当前版本
                            NSString *lastestVersion = response[@"version"];  // AppStore 上软件的最新版本
                            if ([lastestVersion compare:currentVersion] == NSOrderedDescending) {
                                NoticePinBiView *ppinV = [[NoticePinBiView alloc] initWithStopServer:7 dayNum:dayN+1];
                                [ppinV showTostView];
                            }
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
                }
            }
            else{
                 [self hsUpdateApp];
            }
        }else{
            [self hsUpdateApp];
        }
    } fail:^(NSError *error) {
        [self hsUpdateApp];
    }];
}

- (void)hsUpdateApp{
    NSString *url = @"http://itunes.apple.com/cn/lookup?id=1358222995";
    [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *results = responseObject[@"results"];
        if (results && results.count > 0) {
            NSDictionary *response = results.firstObject;
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];// 软件的当前版本
            NSString *lastestVersion = response[@"version"];// AppStore 上软件的最新版本
            NSString *newMessage = response[@"releaseNotes"];
            if ([lastestVersion compare:currentVersion] == NSOrderedDescending) {
                // 给出提示是否前往 AppStore 更新
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"版本有更新" message:newMessage preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *trackViewUrl = response[@"trackViewUrl"];// AppStore 上软件的地址
                    if (trackViewUrl) {
                        NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
                        if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                            [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
                        }
                    }
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:[NoticeTools getLocalStrWith:@"main.cancel"] style:UIAlertActionStyleCancel handler:nil]];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

// 判断是否最新版本号（大于或等于为最新）
- (BOOL)isLastestVersion:(NSString *)currentVersion compare:(NSString *)lastestVersion {
    if (currentVersion && lastestVersion) {
        // 拆分成数组
        NSMutableArray *currentItems = [[currentVersion componentsSeparatedByString:@"."] mutableCopy];
        NSMutableArray *lastestItems = [[lastestVersion componentsSeparatedByString:@"."] mutableCopy];
        // 如果数量不一样补0
        NSInteger currentCount = currentItems.count;
        NSInteger lastestCount = lastestItems.count;
        if (currentCount != lastestCount) {
            NSInteger count = labs(currentCount - lastestCount);// 取绝对值
            for (int i = 0; i < count; ++i) {
                if (currentCount > lastestCount) {
                    [lastestItems addObject:@"0"];
                } else {
                    [currentItems addObject:@"0"];
                }
            }
        }
        // 依次比较
        BOOL isLastest = YES;
        for (int i = 0; i < currentItems.count; ++i) {
            NSString *currentItem = currentItems[i];
            NSString *lastestItem = lastestItems[i];
            if (currentItem.integerValue != lastestItem.integerValue) {
                isLastest = currentItem.integerValue > lastestItem.integerValue;
                break;
            }
        }
        return isLastest;
    }
    return NO;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    //授权返回码
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        DRLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        DRLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    self.needStop = YES;
    [NoticeTools setneedConnect:NO];
    if (self.hasMoveFloatView) {//缓存播放流助手位置
        NoticeAssestPointModel *cachePointM = [NoticeAssestPointModel new];
        cachePointM.firstGetin = YES;
        cachePointM.inPointX = self.floatPoint.x;
        cachePointM.inPointY = self.floatPoint.y;
        cachePointM.floatViewIsOut = self.floatViewIsOut;
        [NoticeComTools saveAssestPointModel:cachePointM];
    }
    
    //清除角标
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = @(0);
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"clearBadge" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    [JPUSHService setBadge:0];
    
    [self beginTask];

}

/// app进入后台后保持运行
- (void)beginTask {
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //如果在系统规定时间3分钟内任务还没有完成，在时间到之前会调用到这个方法
        [self endBack];
    }];
}
 
/// 结束后台运行，让app挂起
- (void)endBack {
    //切记endBackgroundTask要和beginBackgroundTaskWithExpirationHandler成对出现
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

- (void)extracted{
    [[DRNetWorking shareInstance] refreshTokenOk:^(NSDictionary *dict, BOOL success) {
    }];
}

//获取订单
- (void)getOrder{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/select?type=2" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            DRLog(@"订单%@",dict);

            NoticeByOfOrderModel *orderModel = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
            if(orderModel.goods_type.intValue == 2){
                return;
            }
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/cache/%@",orderModel.orderId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict1, BOOL success1) {
                if (success1) {
                    DRLog(@"不显示订单");
                }
            } fail:^(NSError * _Nullable error) {
            }];
            
            if ([orderModel.shop_user_id isEqualToString:[NoticeTools getuserId]]) {//这个订单自己是店主
                if (orderModel.order_type.intValue == 1) {
                    if(!self.hasShowCallView){
                        self.socketManager.callView.orderModel = orderModel;
                        [self.socketManager.callView showCallView];
                    }
                
                }else if (orderModel.order_type.intValue == 2){//用户取消订单
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"对方取消了订单" message:nil cancleBtn:@"好的，知道了"];
                    [alerView showXLAlertView];
                    [self.socketManager.callView dissMiseeShow];
                }else if (orderModel.order_type.intValue == 4){//订单超时
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"有订单失效了" message:@"可在「解忧杂货铺-订单信息」中查看" cancleBtn:@"知道了"];
                    [alerView showXLAlertView];
                    [self.socketManager.callView dissMiseeShow];
                }else if (orderModel.order_type.intValue == 5){//已接单，进入聊天界面
                    NoticeTabbarController *tabBar = (NoticeTabbarController *)self.window.rootViewController;//获取window的跟视图,并进行强制转换
                    BaseNavigationController *nav = nil;
                    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                    }
                    if (!self.isInShopChat) {
                        self.isInShopChat = YES;
                        NoticeShopChatController *ctl = [[NoticeShopChatController alloc] init];
                        ctl.orderM = orderModel;
                        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                    }
                    [self.socketManager.callView dissMiseeShow];
                }else if (orderModel.order_type.intValue == 6){//订单完成
                    if (self.isInShopChat) {//进入了聊天界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPFINISHED" object:nil];
                    }
                    [self.socketManager.callView dissMiseeShow];
                }else if (orderModel.order_type.intValue == 7){//订单被举报
                    if (self.isInShopChat) {//进入了聊天界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPHASJUBAOED" object:nil];
                    }
                    [self.socketManager.callView dissMiseeShow];
                }
            }else{//这个订单自己是用户
                if (orderModel.order_type.intValue == 3) {//店主取消订单
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"对方暂无法接单，请尝试其它店铺" message:nil cancleBtn:@"好的，知道了"];
                    [alerView showXLAlertView];
                }else if (orderModel.order_type.intValue == 4){//订单超时
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已超时失效，请尝试其它店铺" message:nil cancleBtn:@"知道了"];
                    [alerView showXLAlertView];
                }else if (orderModel.order_type.intValue == 5){//已接单，进入聊天界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPCANCELORDER" object:nil];
                    NoticeTabbarController *tabBar = (NoticeTabbarController *)self.window.rootViewController;//获取window的跟视图,并进行强制转换
                    BaseNavigationController *nav = nil;
                    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                    }
                    if (!self.isInShopChat) {
                        self.isInShopChat = YES;
                        NoticeShopChatController *ctl = [[NoticeShopChatController alloc] init];
                        ctl.orderM = orderModel;
                        
                        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                    }
                }else if (orderModel.order_type.intValue == 7){//订单被举报
                    if (self.isInShopChat) {//进入了聊天界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPHASJUBAOED" object:nil];
                    }
                    [self.socketManager.callView dissMiseeShow];
                }else if (orderModel.order_type.intValue == 6){//订单完成
                    if (self.isInShopChat) {//进入了聊天界面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOPFINISHEDHOUTAI" object:nil];
                    }
                    [self.socketManager.callView dissMiseeShow];
                }
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    // 进前台 设置不接受远程控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    if (![NoticeSaveModel getUserInfo]) {
        return;
    }

    [NoticeTools setneedConnect:YES];
    [self.socketManager reConnect];

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"apps/2/%@",[NoticeSaveModel getVersion]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
    } fail:^(NSError * _Nullable error) {
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHSBACKAPP" object:nil];//刷新悄悄话会话列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETFOREGROUNDSTNOTICION" object:nil];//告诉声昔小铺从别的app返回了
    
    if ([NoticeSaveModel getUserInfo]){
        [self getOrder];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    self.hasShowCallView = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"APPWASKILLED" object:nil];//程序杀死，挂断电话
}

- (void)tencentDevicetoken{
    [self onReportToken:self.deviceToken];
}

@end
