//
//  NoticeJieYouMainController.m
//  NoticeXi
//
//  Created by li lei on 2022/9/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeJieYouMainController.h"
#import "NoticeShopMyWallectController.h"
#import "NoticeHasServeredController.h"
#import "NoticeXi-Swift.h"
#import "CBAutoScrollLabel.h"
#import "NoticeMyShopModel.h"
#import "NoticeBuyOrderListController.h"
#import "NoticdShopDetailForUserController.h"
#import "NoticeMyJieYouShopController.h"
@interface NoticeJieYouMainController ()

@property (nonatomic, strong) UILabel *allNumL;
@property (nonatomic, strong) UIImageView *bgImaegview;

@property (nonatomic, assign) BOOL openButton;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, strong) UIButton *shopBtn;
@property (nonatomic, strong) UIButton *orderBtn;
@property (nonatomic, strong) UIButton *walletBtn;
@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UILabel *shopNumL;

@property (nonatomic, strong) NSMutableArray *starImgArr;
@property (nonatomic, strong) NSMutableArray *starLabelArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation NoticeJieYouMainController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIBlurEffect *effect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView1 = [[UIVisualEffectView alloc] initWithEffect:effect1];
    effectView1.frame = CGRectMake(0,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT);
    effectView1.alpha = 0.7;
    [self.view addSubview:effectView1];
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    
    self.bgImaegview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sky_13"]];
    self.bgImaegview.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT);
    self.bgImaegview.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImaegview.clipsToBounds = YES;
    [self.view addSubview: self.bgImaegview];
    self.bgImaegview.userInteractionEnabled = YES;
    
    self.markView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-240)/2, self.bgImaegview.frame.size.height-100-94, 240, 94)];
    self.markView.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0];
    self.markView.layer.cornerRadius = 16;
    self.markView.layer.masksToBounds = YES;
    [self.bgImaegview addSubview:self.markView];
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, 240, 22)];
    markL.text = @"摘个星星 和我说说话";
    markL.font = SIXTEENTEXTFONTSIZE;
    markL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    markL.textAlignment = NSTextAlignmentCenter;
    [self.markView addSubview:markL];
    
    self.shopNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, 240, 17)];
    self.shopNumL.font = TWOTEXTFONTSIZE;
    self.shopNumL.textAlignment = NSTextAlignmentCenter;
    self.shopNumL.textColor = [UIColor colorWithHexString:@"#E8D5A4"];
    self.shopNumL.text = @"… 0家店铺营业中 …";
    [self.markView addSubview:self.shopNumL];
    
    [self configureStar];
    
    self.shopBtn = [[UIButton alloc] initWithFrame:CGRectMake(-80, self.bgImaegview.frame.size.height-80-20, 72, 80)];
    [self.shopBtn setBackgroundImage:UIImageNamed(@"Image_jyshopbtn") forState:UIControlStateNormal];
    [self.shopBtn addTarget:self action:@selector(shopClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImaegview addSubview:self.shopBtn];
    
    self.orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(-80, self.bgImaegview.frame.size.height-80-20, 72, 80)];
    [self.orderBtn setBackgroundImage:UIImageNamed(@"Image_jyorderbtn") forState:UIControlStateNormal];
    [self.orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImaegview addSubview:self.orderBtn];
    
    self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(-80, self.bgImaegview.frame.size.height-80-20, 72, 80)];
    [self.buyBtn setBackgroundImage:UIImageNamed(@"Image_jybuybtn") forState:UIControlStateNormal];
    [self.buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImaegview addSubview:self.buyBtn];
    
    self.walletBtn = [[UIButton alloc] initWithFrame:CGRectMake(-80, self.bgImaegview.frame.size.height-80-20, 72, 80)];
    [self.walletBtn setBackgroundImage:UIImageNamed(@"Image_jywalletbtn") forState:UIControlStateNormal];
    [self.walletBtn addTarget:self action:@selector(walletClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImaegview addSubview:self.walletBtn];
 
    
    UIButton *openOrCloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bgImaegview.frame.size.height-80-20, 54, 80)];
    [openOrCloseBtn setBackgroundImage:UIImageNamed(@"Image_jieyouopen") forState:UIControlStateNormal];
    [self.bgImaegview addSubview:openOrCloseBtn];
    [openOrCloseBtn addTarget:self action:@selector(openOrCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    self.openButton = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:@"REFRESHSHOPDATANOTICETION" object:nil];

    if (!self.dataArr.count) {
        [self request];
    }
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
    [refreshButton setBackgroundImage:UIImageNamed(@"shuaxinshop_img") forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
}


- (void)request{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/list" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            for (UILabel *label in self.starLabelArr) {
                label.hidden = YES;
            }
            
            for (UIImageView *imageV in self.starImgArr) {
                imageV.hidden = YES;
            }
            
            [self.dataArr removeAllObjects];
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMyShopModel *model = [NoticeMyShopModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                NoticeMyShopModel *shopM = self.dataArr[0];
                self.markView.frame = CGRectMake((DR_SCREEN_WIDTH-240)/2, self.bgImaegview.frame.size.height-100-94, 240, 94);
                self.shopNumL.text = [NSString stringWithFormat:@"… %@家店铺营业中 …",shopM.total];
                self.markView.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0];
                for (int i = 0; i < self.dataArr.count; i++) {
                    if (i <= 9) {
                        NoticeMyShopModel *listM = self.dataArr[i];
                        UIImageView *imageView = self.starImgArr[i];
                        imageView.hidden = NO;
                        UILabel *label = self.starLabelArr[i];
                        label.hidden = NO;
                        label.text = listM.shop_name;
                    }
                }
            }else{
                self.markView.center = self.bgImaegview.center;
                self.shopNumL.text = @"… 0家店铺营业中 …";
                self.markView.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:1];
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)orderClick{
    NoticeHasServeredController *ctl = [[NoticeHasServeredController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)walletClick{
    NoticeShopMyWallectController *ctl = [[NoticeShopMyWallectController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)shopClick{
    NoticeMyJieYouShopController *ctl = [[NoticeMyJieYouShopController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)buyClick{
    NoticeBuyOrderListController *ctl = [[NoticeBuyOrderListController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)openOrCloseClick:(UIButton *)button{
    self.openButton = !self.openButton;
    CGFloat space = (DR_SCREEN_WIDTH-54-(72*4))/5;
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.openButton) {
            [button setBackgroundImage:UIImageNamed(@"Image_jieyouclose") forState:UIControlStateNormal];
            self.shopBtn.frame = CGRectMake(CGRectGetMaxX(button.frame)+space, self.bgImaegview.frame.size.height-80-20, 72, 80);
            self.orderBtn.frame = CGRectMake(CGRectGetMaxX(self.shopBtn.frame)+space, self.bgImaegview.frame.size.height-80-20, 72, 80);
            self.buyBtn.frame = CGRectMake(CGRectGetMaxX(self.orderBtn.frame)+space, self.bgImaegview.frame.size.height-80-20, 72, 80);
            self.walletBtn.frame = CGRectMake(CGRectGetMaxX(self.buyBtn.frame)+space, self.bgImaegview.frame.size.height-80-20, 72, 80);
        }else{
            [button setBackgroundImage:UIImageNamed(@"Image_jieyouopen") forState:UIControlStateNormal];
            self.shopBtn.frame = CGRectMake(-80, self.bgImaegview.frame.size.height-80-20, 72, 80);
            self.orderBtn.frame = CGRectMake(-80, self.bgImaegview.frame.size.height-80-20, 72, 80);
            self.buyBtn.frame = CGRectMake(-80, self.bgImaegview.frame.size.height-80-20, 72, 80);
            self.walletBtn.frame = CGRectMake(-80, self.bgImaegview.frame.size.height-80-20, 72, 80);
        }
    } completion:^(BOOL finished) {
    }];
}

- (void)configureStar{
    CGRect locationOne      = CGRectMake((DR_SCREEN_WIDTH-28)/2, NAVIGATION_BAR_HEIGHT, 28.f, 28.f);
    CGRect locationTwo      = CGRectMake(DR_SCREEN_WIDTH-90.f-40, CGRectGetMaxY(locationOne)+27, 40.f, 40.f);
    CGRect locationThree    = CGRectMake(35, CGRectGetMaxY(locationOne)+43, 48.f, 48.f);
    CGRect locationaFour    = CGRectMake(CGRectGetMaxX(locationThree)+50, CGRectGetMaxY(locationOne)+104, 20.f, 20.f);
    CGRect locationFive     = CGRectMake(DR_SCREEN_WIDTH-28-30,CGRectGetMaxY(locationTwo)+40, 28.f, 28.f);
    CGRect locationSix      = CGRectMake((DR_SCREEN_WIDTH-56)/2, CGRectGetMaxY(locationOne)+150, 56.f, 56.f);
    CGRect locationSeven    = CGRectMake(DR_SCREEN_WIDTH-52-32, CGRectGetMaxY(locationSix)+9, 32.f, 32.f);
    CGRect locationEight    = CGRectMake(92, CGRectGetMaxY(locationSix)+22, 20.f, 20.f);
    CGRect locationNine    = CGRectMake((DR_SCREEN_WIDTH-36)/2-20, CGRectGetMaxY(locationSix)+76, 36.f, 36.f);
    CGRect locationTen    = CGRectMake(DR_SCREEN_WIDTH-20-89, CGRectGetMaxY(locationSix)+115, 20.f, 20.f);
    NSArray *locationS = @[[NSValue valueWithCGRect:locationOne],
                           [NSValue valueWithCGRect:locationTwo],
                           [NSValue valueWithCGRect:locationThree],
                           [NSValue valueWithCGRect:locationaFour],
                           [NSValue valueWithCGRect:locationFive],
                           [NSValue valueWithCGRect:locationSix],
                           [NSValue valueWithCGRect:locationSeven],
                           [NSValue valueWithCGRect:locationEight],
                           [NSValue valueWithCGRect:locationNine],
                           [NSValue valueWithCGRect:locationTen]];
    
    CGRect locationLabelOne      = CGRectMake((DR_SCREEN_WIDTH-28)/2-8, NAVIGATION_BAR_HEIGHT+32, 44.f, 16.f);
    CGRect locationLabelTwo      = CGRectMake(DR_SCREEN_WIDTH-90.f-44, CGRectGetMaxY(locationOne)+27+44, 48.f, 17.f);
    CGRect locationLabelThree    = CGRectMake(35, CGRectGetMaxY(locationOne)+43+52, 48.f, 17.f);
    CGRect locationLabelFour    = CGRectMake(CGRectGetMaxX(locationThree)+50-12, CGRectGetMaxY(locationOne)+104+24, 44.f, 16.f);
    CGRect locationLabelFive     = CGRectMake(DR_SCREEN_WIDTH-28-30-8,CGRectGetMaxY(locationTwo)+40+32, 44.f, 16.f);
    CGRect locationLabelSix      = CGRectMake((DR_SCREEN_WIDTH-56)/2, CGRectGetMaxY(locationOne)+150+60, 56.f, 20.f);
    CGRect locationLabelSeven    = CGRectMake(DR_SCREEN_WIDTH-52-32-8, CGRectGetMaxY(locationSix)+9+34, 48.f, 17.f);
    CGRect locationLabelEight    = CGRectMake(92-12, CGRectGetMaxY(locationSix)+22+24, 44.f, 16.f);
    CGRect locationLabelNine    = CGRectMake((DR_SCREEN_WIDTH-36)/2-20-6, CGRectGetMaxY(locationSix)+76+40, 48.f, 17.f);
    CGRect locationLabelTen    = CGRectMake(DR_SCREEN_WIDTH-20-89-14, CGRectGetMaxY(locationSix)+115+24, 48.f, 17.f);
    NSArray *locationLabelS = @[[NSValue valueWithCGRect:locationLabelOne],
                           [NSValue valueWithCGRect:locationLabelTwo],
                           [NSValue valueWithCGRect:locationLabelThree],
                           [NSValue valueWithCGRect:locationLabelFour],
                           [NSValue valueWithCGRect:locationLabelFive],
                           [NSValue valueWithCGRect:locationLabelSix],
                           [NSValue valueWithCGRect:locationLabelSeven],
                           [NSValue valueWithCGRect:locationLabelEight],
                           [NSValue valueWithCGRect:locationLabelNine],
                           [NSValue valueWithCGRect:locationLabelTen]];
    
    self.starImgArr = [[NSMutableArray alloc] init];
    self.starLabelArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < locationS.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]init];
        NSValue *value= locationS[i];
        imageview.frame =  [value CGRectValue];
        imageview.image = [UIImage imageNamed:@"circlesofociety_star_10"];
        [imageview.layer addAnimation:[self opacityForever_Animation:i%3+1] forKey:nil];
        imageview.userInteractionEnabled = YES;
        [self.bgImaegview addSubview:imageview];
        imageview.tag = i;
        UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starimgTap:)];
        [imageview addGestureRecognizer:imgTap];
        [self.starImgArr addObject:imageview];
        
        NSValue *labelValue = locationLabelS[i];
        UILabel *label = [[UILabel alloc] initWithFrame:[labelValue CGRectValue]];
        label.tag = i;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor colorWithHexString:@"#FFF9E0"];
        [self.bgImaegview addSubview:label];
        [label.layer addAnimation:[self opacityForever_Animation:i%3+1] forKey:nil];
        UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starLabelTap:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:labelTap];
        [self.starLabelArr addObject:label];
    }
    
    CGRect locationOne1      = CGRectMake(DR_SCREEN_WIDTH-24-48,CGRectGetMaxY(locationOne)+13, 24.f, 24.f);
    CGRect locationTwo1     = CGRectMake(DR_SCREEN_WIDTH-16-135, CGRectGetMaxY(locationOne)+82, 16.f, 16.f);
    CGRect locationThree1    = CGRectMake(75, CGRectGetMaxY(locationOne)+4167, 27.f, 27.f);
    CGRect locationaFour1    = CGRectMake(DR_SCREEN_WIDTH-107-20, CGRectGetMaxY(locationOne)+244, 20.f, 20.f);
    CGRect locationFive1     = CGRectMake(36,CGRectGetMaxY(locationTwo)+273, 16.f, 16.f);
    
    NSArray *locationS1 = @[[NSValue valueWithCGRect:locationOne1],
                           [NSValue valueWithCGRect:locationTwo1],
                           [NSValue valueWithCGRect:locationThree1],
                           [NSValue valueWithCGRect:locationaFour1],
                           [NSValue valueWithCGRect:locationFive1]];
    for (NSInteger i = 0; i < locationS1.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]init];
        NSValue *value= locationS1[i];
        imageview.frame =  [value CGRectValue];
        imageview.image = [UIImage imageNamed:@"circlesofociety_star_10"];
        [imageview.layer addAnimation:[self opacityForever_Animation1:i%3+1] forKey:nil];
        [self.bgImaegview addSubview:imageview];
    }
}

- (void)starimgTap:(UITapGestureRecognizer *)tap{
    UIImageView *imageview = (UIImageView *)tap.view;
    if (imageview.tag <= self.dataArr.count-1) {
        NoticeMyShopModel *model = self.dataArr[imageview.tag];
        if (imageview.tag <= self.starLabelArr.count-1) {
            UILabel *label = self.starLabelArr[imageview.tag];
            label.hidden = YES;
        }

        NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
        ctl.shopModel = model;
        [self.navigationController pushViewController:ctl animated:YES];
        imageview.hidden = YES;
    }
}

- (void)starLabelTap:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    if (label.tag <= self.dataArr.count-1) {
        NoticeMyShopModel *model = self.dataArr[label.tag];
        if (label.tag <= self.starImgArr.count-1) {
           
            UIImageView *iamgeV = self.starImgArr[label.tag];
            iamgeV.hidden = YES;
        }
        NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
        ctl.shopModel = model;
        [self.navigationController pushViewController:ctl animated:YES];
        label.hidden = YES;
        
    }
}

-(CABasicAnimation *)opacityForever_Animation1:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:0.3f];
    animation.toValue = [NSNumber numberWithFloat:0.1f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//没有的话是均匀的动画。
    return animation;
}

-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:0.8f];
    animation.toValue = [NSNumber numberWithFloat:0.2f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//没有的话是均匀的动画。
    return animation;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
