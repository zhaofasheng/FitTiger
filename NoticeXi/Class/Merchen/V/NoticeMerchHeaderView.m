//
//  NoticeMerchHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2021/11/26.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeMerchHeaderView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeWebViewController.h"
@implementation NoticeMerchHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, DR_SCREEN_WIDTH-40, frame.size.height)];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        [self addSubview:self.backView];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
    
        self.descL = [[UILabel alloc] initWithFrame:CGRectMake(10, (DR_SCREEN_WIDTH-40)*3/4, DR_SCREEN_WIDTH-50-90, 0)];
        self.descL.numberOfLines = 2;
        self.descL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.descL.font = THRETEENTEXTFONTSIZE;
        [self.backView addSubview:self.descL];
        
        self.lookBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-54, (DR_SCREEN_WIDTH-40)*3/4+12, 54, 24)];
        self.lookBtn.layer.cornerRadius = 12;
        self.lookBtn.layer.masksToBounds = YES;
        [self.lookBtn setTitle:[NoticeTools getLocalStrWith:@"qu.kankan"] forState:UIControlStateNormal];
        [self.lookBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.lookBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        self.lookBtn.backgroundColor = [UIColor colorWithHexString:@"#DB9A58"];
        [self.backView addSubview:self.lookBtn];
        [self.lookBtn addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
    

    }
    return self;
}

- (void)lookClick{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    //店铺id，商品id，网页链接由后台返回
    //打开商品详情
    NSString *url = [NSString stringWithFormat:@"taobao://item.taobao.com/item.htm?id=%@",self.model.skip_url];
    if (!self.model.skip_url) {//没有商品id就跳转到店铺
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
        ctl.url = self.model.skip_url?[NSString stringWithFormat:@"https://item.taobao.com/item.htm?spm=a1z10.3-c.w4002-23655650347.9.4a2a2f7dz5F2s1&id=%@",self.model.skip_url]:@"https://shop339691242.taobao.com/?spm=a230r.7195193.1997079397.2.34522aaazGyYlu";
        ctl.isFromShare = YES;
        ctl.isMerechant = YES;
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)setModel:(NoticeOpenTbModel *)model{
    _model = model;
    if (model.type.intValue == 1) {
        self.scroImgView = [[ADBannerAutoPlayView alloc]
                                         initWithFrame:CGRectMake(0,0, self.backView.frame.size.width, self.backView.frame.size.height)];
        [self.backView addSubview:self.scroImgView];
        [self.backView sendSubviewToBack:self.scroImgView];
        self.scroImgView.bannerDelegate = self;
        self.scroImgView.clickBlock = ^(NSIndexPath * indexPath)
        {
            NSInteger tag = 0;
            if (indexPath.row == 0) {
                tag = 0;
            }else{
                tag = indexPath.row-1;
            }
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.largeImageURL = [NSURL URLWithString:model.image_val[tag]];
            YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
            UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            [view presentFromImageView:nil
                           toContainer:toView
                              animated:YES completion:nil];
        };
        self.scroImgView.bottomView.frame = CGRectMake(0,self.backView.frame.size.height-_model.height, DR_SCREEN_WIDTH-40, _model.height);
    }else{

        SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
        configuration.shouldAutoPlay = NO;     //自动播放
        configuration.supportedDoubleTap = YES;     //支持双击播放暂停
        configuration.shouldAutorotate = YES;   //自动旋转
        configuration.repeatPlay = NO;     //重复播放
        configuration.statusBarHideState = SelStatusBarHideStateAlways;     //设置状态栏隐藏
        configuration.sourceUrl = [NSURL URLWithString:_model.video_val];     //设置播放数据源
        configuration.videoGravity = SelVideoGravityResizeAspect;   //拉伸方式
        
        _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-40)*3/4) configuration:configuration];
        [self.backView addSubview:_player];
    }

    
    self.descL.attributedText = model.attser;
    self.descL.frame = CGRectMake(10, self.backView.frame.size.height-_model.height, DR_SCREEN_WIDTH-50-90, _model.height);
    self.lookBtn.frame = CGRectMake(self.backView.frame.size.width-10-54,self.descL.frame.origin.y+(_model.height-24)/2, 54, 24);
}

-(NSArray *)ADGetBannerSourceBannerAutoPlayView:(ADBannerAutoPlayView *)bannerView
{
    return self.model.image_val;
}

-(BannerSourceType)bannerSourceOrigin
{
    return sourceNetType;
}

-(NSTimeInterval)getTheTimeToAutoBannerShow
{
    return 5.0f;
}

-(BannerScrollDirection)getBannerScrollDirction
{
    return bannerScrollRight;
}

@end
