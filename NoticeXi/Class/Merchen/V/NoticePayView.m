//
//  NoticePayView.m
//  NoticeXi
//
//  Created by li lei on 2021/9/25.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePayView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeWebViewController.h"

@implementation NoticePayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2] ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popTap)];
        [self addGestureRecognizer:tap];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 523+30)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.backView.layer.cornerRadius =20;
        self.backView.layer.masksToBounds = YES;
        
        [self addSubview:self.backView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, 12, 24, 24)];
        [cancelBtn setImage:UIImageNamed(@"Image_blackX") forState:UIControlStateNormal];
        [self.backView addSubview:cancelBtn];
        cancelBtn.userInteractionEnabled = NO;
        
        UIButton *buyBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, DR_SCREEN_WIDTH-40, 115)];
        [self.backView addSubview:buyBtn1];
        [buyBtn1 setImage:UIImageNamed([NoticeTools getLocalImageNameCN:@"treezhifoot"]) forState:UIControlStateNormal];
        [buyBtn1 addTarget:self action:@selector(buyClick1) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50+145, DR_SCREEN_WIDTH-40, 115)];
        [self.backView addSubview:buyBtn];
        [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(buyBtn.frame)+26, DR_SCREEN_WIDTH-40, 115)];
        [self.backView addSubview:payBtn];
        if ([NoticeTools getLocalType] == 1) {
            [buyBtn setImage:UIImageNamed(@"Image_buytaobaoen") forState:UIControlStateNormal];
            [payBtn setImage:UIImageNamed(@"Image_buypayen") forState:UIControlStateNormal];
        }else if ([NoticeTools getLocalType] == 2){
            [buyBtn setImage:UIImageNamed(@"Image_buytaobaoja") forState:UIControlStateNormal];
            [payBtn setImage:UIImageNamed(@"Image_buypayja") forState:UIControlStateNormal];
        }else{
            [buyBtn setImage:UIImageNamed(@"Image_buytaobao") forState:UIControlStateNormal];
            [payBtn setImage:UIImageNamed(@"Image_buypay") forState:UIControlStateNormal];
        }
        
        [payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
        

        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"skipTaobao" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                self.opTaoBao = [NoticeOpenTbModel mj_objectWithKeyValues:dict[@"data"]];
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }
    return self;
}

- (void)buyClick1{
    if (!self.opTaoBao) {
        return;
    }
    //店铺id，商品id，网页链接由后台返回
    //打开商品详情
    NSString *url = [NSString stringWithFormat:@"taobao://item.taobao.com/item.htm?id=%@",self.opTaoBao.product_id_2];
    if (!self.opTaoBao.product_id_2) {//没有商品id就跳转到店铺
        url = @"taobao://shop.m.taobao.com/shop/shop_index.htm?shop_id=339691242";
    }
    NSURL *taobaoUrl = [NSURL URLWithString:url];

    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:taobaoUrl]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
         
                [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        DRLog(@"跳转成功");
                        self.hasGoToBuy = YES;
                    }
                }];
            }
        } else {
            [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    DRLog(@"跳转成功");
                }
            }];
        }
    }else{
        [self popTap];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        self.hasGoToBuy = YES;
        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.url = self.opTaoBao.product_id_2?[NSString stringWithFormat:@"https://item.taobao.com/item.htm?spm=a1z10.3-c.w4002-23655650347.9.4a2a2f7dz5F2s1&id=%@",self.opTaoBao.product_id_2]:@"https://shop339691242.taobao.com/?spm=a230r.7195193.1997079397.2.34522aaazGyYlu";
        ctl.isFromShare = YES;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)buyClick{
    //店铺id，商品id，网页链接由后台返回
    //打开商品详情
    NSString *url = [NSString stringWithFormat:@"taobao://item.taobao.com/item.htm?id=%@",self.opTaoBao.product_id];
    if (!self.opTaoBao.product_id) {//没有商品id就跳转到店铺
        url = @"taobao://shop.m.taobao.com/shop/shop_index.htm?shop_id=339691242";
    }
    NSURL *taobaoUrl = [NSURL URLWithString:url];

    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:taobaoUrl]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
         
                [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        DRLog(@"跳转成功");
                        self.hasGoToBuy = YES;
                    }
                }];
            }
        } else {
            [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    DRLog(@"跳转成功");
                }
            }];
        }
    }else{
        [self popTap];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        BaseNavigationController *nav = nil;
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        }
        self.hasGoToBuy = YES;
        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.url = self.opTaoBao.product_id?[NSString stringWithFormat:@"https://item.taobao.com/item.htm?spm=a1z10.3-c.w4002-23655650347.9.4a2a2f7dz5F2s1&id=%@",self.opTaoBao.product_id]:@"https://shop339691242.taobao.com/?spm=a230r.7195193.1997079397.2.34522aaazGyYlu";
        ctl.isFromShare = YES;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)payClick{
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // iTunesConnect 苹果后台配置的产品ID
//    [NoticeSaveModel clearPayInfo];
//    NoticePaySaveModel *payInfo = [[NoticePaySaveModel alloc] init];
//    payInfo.productId = @"com.gmdoc.xi";
//    payInfo.userId = [NoticeTools getuserId];
//    [NoticeSaveModel savePayInfo:payInfo];
    [appdel.payManager startPurchWithID:@"com.gmdoc.xi" money:nil toUserId:[NoticeTools getuserId] userNum:nil isNiming:nil completeHandle:^(SIAPPurchType type, NSData *data) {
                            
    }];
}

- (void)show{
 
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-523, DR_SCREEN_WIDTH, 523+30);
        
    }];
}

- (void)popTap{
    [UIView animateWithDuration:0.2 animations:^{
        self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 523+30);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
