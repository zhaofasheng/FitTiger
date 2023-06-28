//
//  NoticePlayerVideoController.m
//  NoticeXi
//
//  Created by li lei on 2021/11/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePlayerVideoController.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "NoticeWebViewController.h"
@interface NoticePlayerVideoController ()
@property (nonatomic, strong) SelVideoPlayer *player;
@end

@implementation NoticePlayerVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        
    if (self.linkUrl) {
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-140)/2, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-20-48, 140, 48)];
        buyBtn.backgroundColor = [UIColor colorWithHexString:@"#DB9A58"];
        buyBtn.layer.cornerRadius = 24;
        buyBtn.layer.masksToBounds = YES;
        [buyBtn setTitle:[NoticeTools getLocalStrWith:@"qu.taob"] forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.view addSubview:buyBtn];
        [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buyClick{
    //店铺id，商品id，网页链接由后台返回
    //打开商品详情
    NSString *url = [NSString stringWithFormat:@"taobao://item.taobao.com/item.htm?id=%@",self.linkUrl];
    if (!self.linkUrl) {//没有商品id就跳转到店铺
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

        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.url = self.linkUrl?[NSString stringWithFormat:@"https://item.taobao.com/item.htm?spm=a1z10.3-c.w4002-23655650347.9.4a2a2f7dz5F2s1&id=%@",self.linkUrl]:@"https://shop339691242.taobao.com/?spm=a230r.7195193.1997079397.2.34522aaazGyYlu";
        ctl.isFromShare = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_player _pauseVideo];
    [_player _deallocPlayer];
    [_player removeFromSuperview];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;     //自动播放
    configuration.supportedDoubleTap = YES;     //支持双击播放暂停
    configuration.shouldAutorotate = YES;   //自动旋转
    configuration.repeatPlay = NO;     //重复播放
    configuration.statusBarHideState = SelStatusBarHideStateAlways;     //设置状态栏隐藏
    configuration.sourceUrl = self.islocal?[NSURL fileURLWithPath:self.videoUrl]: [NSURL URLWithString:self.videoUrl];     //设置播放数据源
    configuration.videoGravity = SelVideoGravityResizeAspect;   //拉伸方式
    
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH) configuration:configuration];
    [self.view addSubview:_player];
}
@end
