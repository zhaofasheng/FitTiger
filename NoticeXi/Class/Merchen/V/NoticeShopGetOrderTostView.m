//
//  NoticeShopGetOrderTostView.m
//  NoticeXi
//
//  Created by li lei on 2022/7/12.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopGetOrderTostView.h"
#import "NoticeShopChatController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeOcToSwift.h"
@implementation NoticeShopGetOrderTostView
{
    UILabel *_titleL;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-90)/2, NAVIGATION_BAR_HEIGHT+60, 90, 90)];
        imageView.layer.cornerRadius = 45;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        imageView.image = UIImageNamed(@"Image_ordericonchant");
        [self addSubview:imageView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+23, DR_SCREEN_WIDTH, 22)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = SIXTEENTEXTFONTSIZE;
        titleL.textColor = [UIColor whiteColor];
        titleL.text = @"店铺有新的订单来了";
        [self addSubview:titleL];
        _titleL = titleL;
        
        NSArray *imageArr = @[@"callimg_jujie",@"callimg_jieshou"];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-228)/2+158*i, DR_SCREEN_HEIGHT-70-BOTTOM_HEIGHT-120, 70, 70)];
            [button setBackgroundImage:UIImageNamed(imageArr[i]) forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(getOrCancel:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.floatView.isPlaying) {
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
        }
        appdel.floatView.hidden = YES;
    }
    return self;
}

- (void)setIsAudioCalling:(BOOL)isAudioCalling{
    _isAudioCalling = isAudioCalling;
    if(isAudioCalling){
        _titleL.text = @"店铺有新的订单(语音通话)来了";
    }
}

- (void)dissMiseeShow{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.hasShowCallView = NO;
    [self removeFromSuperview];
    self.hasShow = NO;
}

- (void)getOrCancel:(UIButton *)button{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.hasShowCallView = NO;
    if (self.isAudioCalling) {
        if (button.tag == 1) {
            if(self.acceptBlock){
                self.acceptBlock(YES);
            }
        }else{
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"确定拒绝订单吗？" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                
                if (buttonIndex == 1 || buttonIndex == 2) {
                    [self dissMiseeShow];
                    if(buttonIndex == 2){
                        if(self.endOpenBlock){
                            self.endOpenBlock(YES);
                        }
                    }else{
                        if(self.acceptBlock){
                            self.acceptBlock(NO);
                        }
                    }
                }
                
            } otherButtonTitleArray:@[@"拒绝",@"拒绝，并结束营业"]];
         
            [sheet show];
        }
        return;
    }
    self.hasShow = NO;
    if (button.tag == 1) {
        if (self.noClick) {
            return;
        }
        self.noClick = YES;
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/%@",self.orderModel.orderId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            self.noClick = NO;
            DRLog(@"接单%@",dict);
            if (success) {//接单成功
                NoticeByOfOrderModel *orderM = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                NoticeShopChatController *ctl = [[NoticeShopChatController alloc] init];
                ctl.orderM = orderM;
                [nav.topViewController.navigationController pushViewController:ctl animated:YES];
                [self dissMiseeShow];
            }
        } fail:^(NSError * _Nullable error) {
            self.noClick = NO;
        }];
    }else{
        
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"确定拒绝订单吗？" cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            
            if (buttonIndex == 1 || buttonIndex == 2) {
                [self dissMiseeShow];
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                [parm setObject:self.orderModel.orderId forKey:@"orderId"];
                [parm setObject:buttonIndex==1?@"3":@"5" forKey:@"orderType"];
                [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                       [[NoticeOcToSwift topViewController] showToastWithText:buttonIndex==1?@"已拒绝":@"已拒绝，店铺已结束营业"];
                    }
                } fail:^(NSError * _Nullable error) {
                }];
            }
       
        } otherButtonTitleArray:@[@"拒绝",@"拒绝，并结束营业"]];
     
        [sheet show];
    }
}

- (void)showCallView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    self.hasShow = YES;
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
