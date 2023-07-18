//
//  NoticeTabbarController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTabbarController.h"
#import "NoticeMineViewController.h"
#import "NoticeListenViewController.h"
#import "NoticeJieYouMainController.h"
#import "BaseNavigationController.h"
#import "NoticeYunXin.h"
#import "AppDelegate+Notification.h"
#import "NoticeNoNet.h"
#import "NoticeStaySys.h"
#import "NoticeSocketManger.h"
#import "NoticeNoticenterModel.h"
#import "NoticeAreaModel.h"
#import "NoticeTextVoiceController.h"
#import "NoticeKnowSendTextView.h"
#import "AppDelegate.h"
#import "NoticeSendViewController.h"
#import "NoticeBodyController.h"
#import "NoticeShowNewUserLeader.h"
#import "NoticeXi-Swift.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeImageViewController.h"
#import "NoticeSCViewController.h"
#import "NoticeBannerModel.h"
#import "NoticeSendBoKeController.h"
#import "NoticeRecoderController.h"
#import "NoticreSendHelpController.h"
//获取全局并发队列和主队列的宏定义
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()

@interface NoticeTabbarController ()<AxcAE_TabBarDelegate,NoticeRecordDelegate>
@property (nonatomic,strong)UIButton *button;
@property (nonatomic, assign) NSInteger oldSelectIndex;
@property (nonatomic, strong) UIViewController *oldController;
@property (nonatomic, strong) NSArray *controllerArr;
@property (nonatomic, assign) NSInteger indexFlag;
@property (nonatomic, strong) UIView *bdgeView;
@property (nonatomic, strong) NoticeSocketManger *sockeetManger;
@property (nonatomic, strong) UIImageView *leaderImageView;
@property (nonatomic, assign) NSInteger timeReduce;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *leaderView;
@property (nonatomic, strong) UIImageView *leaderButton;
@property (nonatomic, strong) UIImageView *leaderTitleImageV;
@property (nonatomic, assign) NSInteger clickNum;
@property (nonatomic, assign) NSInteger leadType;
@property (nonatomic, assign) BOOL isBusy;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, assign) BOOL hasClickShop;//是否点击过解忧杂货铺
@property (nonatomic, assign) BOOL isLead;//新手指南
@property (nonatomic, strong) UIImageView *leadImageView;
@property (nonatomic, strong) UIView *fgView;
@property (nonatomic, strong) UIImageView *leadImageView1;
@property (nonatomic, strong) UIView *fgView1;
@property (nonatomic, assign) BOOL isCalling;
@property (nonatomic, assign) BOOL newClick;
@property (nonatomic, assign) NSInteger oldCtlSelectIndex;
@property (nonatomic, assign) UInt64 currentCallId;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@property (nonatomic, strong) UIView *mbsView;

@property (nonatomic, strong) NoticeShowNewUserLeader *showLeader;
@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) NoticeBannerModel *bannerM;
@property (nonatomic, strong) NoticeNewRecoderInputView *recoderInputView;


@end

@implementation NoticeTabbarController
{
    NSInteger loginCount;
}

- (NoticeShowNewUserLeader *)showLeader{
    if (!_showLeader) {
        _showLeader = [[NoticeShowNewUserLeader alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _showLeader;
}

- (void)refreshUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            [NoticeSaveModel saveUserInfo:userIn];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshUserInfo];

}

//获取当前皮肤
- (void)changeSkin{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];

            if (userIn.token) {
              [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];
            
            
            if (userIn.spec_bg_default_photo.length > 10) {

                dispatch_async(globalQueue,^{
                  //子线程下载图片
                      NSURL *url=[NSURL URLWithString:userIn.spec_bg_default_photo];
                      NSData *data=[NSData dataWithContentsOfURL:url];
                  //将网络数据初始化为UIImage对象
                      UIImage *image=[UIImage imageWithData:data];
                      if(image!=nil){
                      //回到主线程设置图片，更新UI界面
                          dispatch_async(mainQueue,^{
                              UIImage *gqImage = image;
                              appdel.backDefaultImg = gqImage;

                              if (userIn.spec_bg_type.intValue == 1) {//默认背景
                                  appdel.backImg = image;
                                  appdel.alphaValue = [[NoticeComTools getAlphaValue] floatValue];
                                  appdel.effect = [[NoticeComTools getEffect] floatValue];
                                  if (!(appdel.alphaValue > 0)) {
                                      appdel.alphaValue = 0.3;
                                  }
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGESKINNOTICIONHS" object:nil];
                              }
                          });
                      }
                      else{
                          DRLog(@"图片下载出现错误");
                      }
                  });
                
                if (userIn.spec_bg_type.intValue == 1) {
                    return;
                }
            }
            
            if (userIn.spec_bg_type.intValue == 3) {//没有背景
                appdel.alphaValue = 0;
                appdel.backImg = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGESKINNOTICIONHS" object:nil];
                return;
            }
            
            if (userIn.spec_bg_photo_url.length > 10 && userIn.spec_bg_type.intValue == 2) {//自定义背景图
                
                dispatch_async(globalQueue,^{
                  //子线程下载图片
                      NSURL *url=[NSURL URLWithString:userIn.spec_bg_photo_url];
                      NSData *data=[NSData dataWithContentsOfURL:url];
                  //将网络数据初始化为UIImage对象
                      UIImage *image=[UIImage imageWithData:data];
                      if(image!=nil){
                      //回到主线程设置图片，更新UI界面
                          dispatch_async(mainQueue,^{
                              UIImage *gqImage = image;
                              if (userIn.spec_bg_type.intValue == 2) {
                                  appdel.alphaValue = [[NoticeComTools getAlphaValue] floatValue];
                                  appdel.effect = [[NoticeComTools getEffect] floatValue];
                                  if (!(appdel.alphaValue > 0)) {
                                      appdel.alphaValue = 0.3;
                                  }
                                  appdel.backImg = gqImage;
                                  appdel.custumeImg = [UIImage imageWithData:data];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGESKINNOTICIONHS" object:nil];
                              }
                          });
                      }
                      else{
                          appdel.alphaValue = 0;
                          appdel.backImg = nil;
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGESKINNOTICIONHS" object:nil];
                      }
                  });

            }
            if (userIn.spec_bg_skin_url.length > 10 && userIn.spec_bg_type.intValue == 4) {//专属背景图
                
                dispatch_async(globalQueue,^{
                  //子线程下载图片
                      NSURL *url=[NSURL URLWithString:userIn.spec_bg_skin_url];
                      NSData *data=[NSData dataWithContentsOfURL:url];
                  //将网络数据初始化为UIImage对象
                      UIImage *image=[UIImage imageWithData:data];
                      if(image!=nil){
                      //回到主线程设置图片，更新UI界面
                          dispatch_async(mainQueue,^{
                              UIImage *gqImage = image;
                              appdel.alphaValue = [[NoticeComTools getAlphaValue] floatValue];
                              appdel.effect = [[NoticeComTools getEffect] floatValue];
                              if (!(appdel.alphaValue > 0)) {
                                  appdel.alphaValue = 0.3;
                              }
                              appdel.backImg = gqImage;
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGESKINNOTICIONHS" object:nil];
                          });
                      }
                      else{
                          appdel.alphaValue = 0;
                          appdel.backImg = nil;
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGESKINNOTICIONHS" object:nil];
                      }
                  });
            }else{
                appdel.alphaValue = 0;
                appdel.effect = 0;
                appdel.backImg = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGESKINNOTICIONHS" object:nil];
            }
        }
        
    } fail:^(NSError *error) {
        
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    loginCount = 0;
    if (![NoticeSaveModel getUserInfo]) {
        return;
    }
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectGroup) name:@"GROUPMASSAGENOTICE" object:nil];//社团消息推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaderTap:) name:@"NOTICELEAERTAPNOTICE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:@"REFRESHUUSERINFOFORNOTICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelect:) name:@"CHANGETHEROOTSELECT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelecttext:) name:@"CHANGETHEROOTSELECTTEXT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin) name:@"CHANGESKINATTABBAR" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkinimg) name:@"NOTICECHANGESKINNOTICIONHS" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leadRecoder:) name:@"NOTICESTARTRECODERLEADE" object:nil];//新手指南录音
    
    [self addChildViewControllers];
    
    NoticeSocketManger *socketManger = [[NoticeSocketManger alloc] init];
    self.sockeetManger = socketManger;
    [self.sockeetManger reConnect];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.payManager = [STRIAPManager shareSIAPManager];
    appdel.socketManager = self.sockeetManger;
    [self changeSkin];
    
    self.backGroundImageView = [[NoticeCustumBackImageView alloc] initWithFrame:CGRectMake(-20, -20, DR_SCREEN_WIDTH+40, DR_SCREEN_HEIGHT+40)];
    [self.view addSubview:self.backGroundImageView];
    self.backGroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backGroundImageView.clipsToBounds = YES;
    self.backGroundImageView.hidden = NO;
    self.backGroundImageView.image = UIImageNamed(@"defaultMain");
    
    // 图片视差效果：水平方向
    UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectX.maximumRelativeValue = @(-50);
    effectX.minimumRelativeValue = @(50);
    [self.backGroundImageView addMotionEffect:effectX];

    // 图片视差效果：垂直方向
    UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    effectY.maximumRelativeValue = @(-50);
    effectY.minimumRelativeValue = @(50);
    [self.backGroundImageView addMotionEffect:effectY];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    UIView *mbV = [[UIView alloc] initWithFrame:self.backGroundImageView.bounds];
    [self.backGroundImageView addSubview:mbV];
    self.mbsView = mbV;
    
    self.mbsView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.3];
    [self.view sendSubviewToBack:self.backGroundImageView];
    
    appdel.floatView.frame = CGRectMake(DR_SCREEN_WIDTH-92, (DR_SCREEN_HEIGHT-56)/2, 92, 56);
    
    self.oldCtlSelectIndex = 99;
    
    //注册登录腾讯
    [appdel.audioChatTools regTencent];
    [self redCirRequest];

}

- (void)redCirRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.4.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];

            if(stay.likeModel.num.intValue || stay.other_commentModel.num.intValue || stay.comModel.num.intValue || stay.voice_whisperModel.num.intValue || stay.sysM.num.intValue){
                [self.tabBar showBadgeOnItemIndex:4];
            }else{
                [self.tabBar hideBadgeOnItemIndex:4];
            }
        }
    } fail:^(NSError *error) {
    }];
}

- (void)changeSkinimg{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.backImg) {
        self.mbsView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"]colorWithAlphaComponent:appdel.alphaValue>0?(appdel.alphaValue>0.8?0.8:appdel.alphaValue) :0.3];
        if (appdel.backImg) {
            self.backGroundImageView.hidden = NO;
            self.backGroundImageView.image =  [UIImage boxblurImage:appdel.backImg withBlurNumber:appdel.effect];
        }else{
            self.backGroundImageView.hidden = YES;
        }
    }else{
        self.backGroundImageView.hidden = YES;
    }
}

- (NSString *)getNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSInteger x = arc4random() % 99999999999999999;
    return  [NSString stringWithFormat:@"%@//%ld",currentTimeString,(long)x];
}


- (void)addChildViewControllers{
    // 创建选项卡的数据 想怎么写看自己，这块我就写笨点了
    
    NoticeMineViewController *mineVc = [[NoticeMineViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    mineVc.hasRedViewBlock = ^(BOOL showRed) {
        if(showRed){
            [weakSelf.tabBar showBadgeOnItemIndex:4];
        }else{
            [weakSelf.tabBar hideBadgeOnItemIndex:4];
        }
    };
    
    NSArray *arr = @[[[BaseNavigationController alloc] initWithRootViewController:[[NoticeBodyController alloc] init]],[[BaseNavigationController alloc] initWithRootViewController:[[NoticeJieYouMainController alloc] init]],[[BaseNavigationController alloc] initWithRootViewController:[[NoticeListenViewController alloc] init]],[[BaseNavigationController alloc] initWithRootViewController:mineVc]];
    NSArray *arr2 = @[[NoticeTools getLocalStrWith:@"main.bk"],[NoticeTools chinese:@"树洞" english:@"Diary" japan:@"デイリー"],[NoticeTools getLocalStrWith:@"jieyou.jy"],[NoticeTools getLocalStrWith:@"tabbar.mine"]];
 
    NSArray <NSDictionary *>*VCArray =
    @[@{@"vc":arr[2],@"normalImg":@"home",@"selectImg":@"btn_toolbar_voice_selected",@"itemTitle":arr2[0]},
      @{@"vc":arr[0],@"normalImg":@"ting",@"selectImg":@"btn_toolbar_listen_selected",@"itemTitle":arr2[1]},
      @{@"vc":[UIViewController new],@"normalImg":@"complaint",@"selectImg":@"complaint_select",@"itemTitle":@""},
      @{@"vc":arr[1],@"normalImg":@"message",@"selectImg":@"btn_toolbar_bottle_selected",@"itemTitle":arr2[2]},
      @{@"vc":arr[3],@"normalImg":@"me",@"selectImg":@"btn_toolbar_me_selected",@"itemTitle":arr2[3]}];
    // 1.遍历这个集合
    // 1.1 设置一个保存构造器的数组
    NSMutableArray *tabBarConfs = @[].mutableCopy;
    // 1.2 设置一个保存VC的数组
    NSMutableArray *tabBarVCs = @[].mutableCopy;
    [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 2.根据集合来创建TabBar构造器
        AxcAE_TabBarConfigModel *model = [AxcAE_TabBarConfigModel new];
        model.pictureWordsMargin = 0;
        // 3.item基础数据三连
        model.itemTitle = [obj objectForKey:@"itemTitle"];
        model.selectImageName = [obj objectForKey:@"selectImg"];
        model.normalImageName = [obj objectForKey:@"normalImg"];
        model.normalColor = [UIColor colorWithHexString:@"#8A8F99"];
        model.interactionEffectStyle = AxcAE_TabBarInteractionEffectStyleSpring;
    
        model.selectColor = [UIColor colorWithHexString:@"#14151A"];
        if (idx == 2 ) { // 如果是中间的
            model.interactionEffectStyle = AxcAE_TabBarInteractionEffectStyleNone;
            // 设置凸出 矩形
            model.bulgeStyle = AxcAE_TabBarConfigBulgeStyleSquare;
            // 设置凸出高度
            model.bulgeHeight = ISIPHONEXORLATER?20: 30;
            // 设置成图片文字展示
            model.itemLayoutStyle = AxcAE_TabBarItemLayoutStylePicture;
            // 设置图片
            model.selectImageName = @"btn_home_post";
            model.normalImageName = @"btn_home_post";
            model.selectBackgroundColor = model.normalBackgroundColor = [UIColor clearColor];
            model.backgroundImageView.hidden = YES;
            // 设置图片大小c上下左右全边距
            model.componentMargin = UIEdgeInsetsMake(10, 10, 10, 10 );
            // 设置图片的高度为40
            model.icomImgViewSize = CGSizeMake(self.tabBar.frame.size.width / 5, 60);
            model.titleLabelSize = CGSizeMake(self.tabBar.frame.size.width / 5, 20);
            // 设置大小/边长 自动根据最大值进行裁切
            model.itemSize = CGSizeMake(self.tabBar.frame.size.width / 5 + 15.0 ,self.tabBar.frame.size.height + 40);
        }
        // 备注 如果一步设置的VC的背景颜色，VC就会提前绘制驻留，优化这方面的话最好不要这么写
        // 示例中为了方便就在这写了
        UIViewController *vc = [obj objectForKey:@"vc"];
        // 5.将VC添加到系统控制组
        [tabBarVCs addObject:vc];
        // 5.1添加构造Model到集合
        [tabBarConfs addObject:model];
    }];
    // 使用自定义的TabBar来帮助触发凸起按钮点击事件
    TestTabBar *testTabBar = [TestTabBar new];
    testTabBar.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    [self setValue:testTabBar forKey:@"tabBar"];
    
    self.viewControllers = tabBarVCs;

    //去掉tabBar顶部线条
    CGRect rect = CGRectMake(0, 0,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -6);
    
    self.tabBar.layer.shadowOpacity = 0.1;

    self.axcTabBar = [AxcAE_TabBar new] ;
    self.axcTabBar.tabBarConfig = tabBarConfs;
    // 7.设置委托
    self.axcTabBar.delegate = self;
    // 8.添加覆盖到上边
    [self.tabBar addSubview:self.axcTabBar];

    self.axcTabBar.frame = self.tabBar.bounds;
}


- (void)setNewSelect:(NSInteger)index{
    [self axcAE_TabBar:self.axcTabBar selectIndex:0];
}

// 9.实现代理，如下：
static NSInteger lastIdx = 0;
- (void)axcAE_TabBar:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{


    if (index!=2) {
        self.oldSelectIndex = index;
    }

    if (index != 2) { // 不是中间的就切换
        if (@available(iOS 13.0, *)) {
            UIImpactFeedbackGenerator *impactor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleRigid];
            [impactor impactOccurred];
        }
        // 通知 切换视图控制器
        [self setSelectedIndex:index];
        lastIdx = index;
    }else{ // 点击了中间
//       // 点击中间tabbarItem，不切换，让当前页面跳转

        [self.axcTabBar setSelectIndex:lastIdx WithAnimation:NO]; // 换回上一个选中状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPPLAYERNotification" object:nil];
        
        [self.recoderInputView show];
    }
}

- (void)leadRecoder:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *type = nameDictionary[@"type"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    
    if (type.intValue == 2) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.isOther = YES;
        ctl.isLead = YES;
        ctl.userId = @"717789";

        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                        withSubType:kCATransitionFromTop
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionDefault
                                                                               view:nav.topViewController.navigationController.view];
        [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        return;
    }
    
    if (type.intValue == 100) {

        NoticeLeaderController *ctl = [[NoticeLeaderController alloc] init];
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                        withSubType:kCATransitionFromTop
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionDefault
                                                                               view:nav.topViewController.navigationController.view];
        [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        return;
    }
    
    if (type.intValue == 101) {
        [self.showLeader finishShow];
        return;
    }
    if (type.intValue == 3) {//新手任务4
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"article" Accept:@"application/vnd.shengxi.v4.9.20+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                NoticeBannerModel *bannerM = [NoticeBannerModel mj_objectWithKeyValues:dict[@"data"]];
                self.bannerM = bannerM;
            }
        } fail:^(NSError * _Nullable error) {
        }];
        self.leadType = 3;
        self.read = NO;
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        [rootWindow addSubview:self.fgView];
        [rootWindow bringSubviewToFront:self.fgView];
        self.leadImageView.hidden = NO;
        self.leadImageView.image = UIImageNamed(@"Image_lyzhiying1");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"44" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        self.leadImageView.frame = CGRectMake(DR_SCREEN_WIDTH/5*3, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-150-50, 86, 150);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.leadImageView.frame = CGRectMake(DR_SCREEN_WIDTH/5*3, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-150, 86, 150);
        } completion:nil];
        return;
    }
    if (type.intValue == 4) {//新手任务5

        self.leadType = 4;
        self.read = NO;
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        [rootWindow addSubview:self.fgView];
        [rootWindow bringSubviewToFront:self.fgView];
        self.leadImageView.hidden = NO;
        self.leadImageView.image = UIImageNamed(@"Image_kfzhiyin1");
        NSString *path = [[NSBundle mainBundle] pathForResource:@"54" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
        self.leadImageView.frame = CGRectMake(DR_SCREEN_WIDTH/5, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-150-50, 86, 150);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.leadImageView.frame = CGRectMake(DR_SCREEN_WIDTH/5, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-150, 86, 150);
        } completion:nil];
        return;
    }
    self.isLead = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPPLAYERNotification" object:nil];
    [self.recoderInputView show];
    
    
    [self.recoderInputView addSubview:self.fgView1];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"104" ofType:@"m4a"];
    [appdel.audioPlayer startPlayWithUrl:path isLocalFile:YES];
    self.leadImageView1.frame = CGRectMake((DR_SCREEN_WIDTH-210)/2-7, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-32-190-30-120, 94,206);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        self.leadImageView1.frame = CGRectMake((DR_SCREEN_WIDTH-210)/2-7, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-32-190-120, 94,206);
    } completion:nil];
}

- (UIView *)fgView{
    if (!_fgView) {
        _fgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _fgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIButton *closBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 52, 28)];
        [closBtn setBackgroundImage:UIImageNamed(@"Image_leaclose") forState:UIControlStateNormal];
        [closBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_fgView addSubview:closBtn];
        
        _fgView.userInteractionEnabled = YES;
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-151-50, 190, 151)];
        [_fgView addSubview:imageV];
        imageV.image = UIImageNamed(@"Image_lyzhiying1");
        imageV.userInteractionEnabled = YES;
        self.leadImageView = imageV;
        self.leadImageView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tingjianClick)];
        [imageV addGestureRecognizer:tap];
            
    }
    return _fgView;
}

- (UIView *)fgView1{
    if (!_fgView1) {
        _fgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _fgView1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIButton *closBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2, 52, 28)];
        [closBtn setBackgroundImage:UIImageNamed(@"Image_leaclose") forState:UIControlStateNormal];
        [closBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_fgView1 addSubview:closBtn];
        
        _fgView1.userInteractionEnabled = YES;
        
        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-151-50, 190, 151)];
        [_fgView1 addSubview:imageV1];
        imageV1.image = UIImageNamed(@"Image_lyzhiying100");
        imageV1.userInteractionEnabled = YES;
        self.leadImageView1 = imageV1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tingjianClick2)];
        [imageV1 addGestureRecognizer:tap];
            
    }
    return _fgView1;
}

- (void)tingjianClick2{
    [self.fgView1 removeFromSuperview];
    [self.recoderInputView removeFromSuperview];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionDefault
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeRecoderController *ctl = [[NoticeRecoderController alloc] init];
    ctl.isLead = YES;
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
}

- (void)tingjianClick{
    if (self.read) {
        [self tingjianClick1];
        return;
    }
    if (self.leadType == 3) {
        [self axcAE_TabBar:self.axcTabBar selectIndex:3];
    }else{
        [self axcAE_TabBar:self.axcTabBar selectIndex:1];
    }
    [self leaderRead];
}

- (void)tingjianClick1{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = YES;
    if (self.leadType != 3) {
        [self.fgView removeFromSuperview];
        NoticeSCViewController *ctl = [[NoticeSCViewController alloc] init];
        ctl.navigationItem.title = @"声昔小二";
        ctl.toUser = [NSString stringWithFormat:@"%@1",socketADD];
        ctl.toUserId = @"1";
        ctl.isLead = YES;
        NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
        if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
            BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
        }
        return;
    }
    if (!self.bannerM) {
        return;
    }
    [self.fgView removeFromSuperview];
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    NoticeImageViewController *ctl = [[NoticeImageViewController alloc] init];
    ctl.url = self.bannerM.http_attr_pc;
    ctl.isLead = YES;
    ctl.bannerM = self.bannerM;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                    withSubType:kCATransitionFromTop
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionDefault
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];

}

- (void)leaderRead{
    self.read = YES;
    if (self.leadType == 4) {
        //
        self.leadImageView.image = UIImageNamed(@"Image_kfzhiyin2");
        self.leadImageView.hidden = NO;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"55" ofType:@"m4a"];
        [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];

        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.leadImageView.frame = CGRectMake(DR_SCREEN_WIDTH-96, STATUS_BAR_HEIGHT, 96, 140);
        } completion:nil];
        return;
    }
    self.leadImageView.image = UIImageNamed(@"Image_lyzhiying2");
    self.leadImageView.hidden = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"45" ofType:@"m4a"];
    [self.audioPlayer startPlayWithUrl:path isLocalFile:YES];
    self.leadImageView.frame = CGRectMake((DR_SCREEN_WIDTH-335)/2, NAVIGATION_BAR_HEIGHT+20+100, 335, 229);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        self.leadImageView.frame = CGRectMake((DR_SCREEN_WIDTH-335)/2, NAVIGATION_BAR_HEIGHT+20, 335, 229);
    } completion:nil];
}

- (void)closeClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定放弃任务吗？" sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf axcAE_TabBar:weakSelf.axcTabBar selectIndex:0];
            [weakSelf.recoderInputView removeFromSuperview];
            [weakSelf.fgView removeFromSuperview];
            [weakSelf.fgView1 removeFromSuperview];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            NoticeLeaderController *ctl = [[NoticeLeaderController alloc] init];
            CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                            withSubType:kCATransitionFromTop
                                                                               duration:0.3f
                                                                         timingFunction:kCAMediaTimingFunctionDefault
                                                                                   view:nav.topViewController.navigationController.view];
            [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
            [nav.topViewController.navigationController pushViewController:ctl animated:NO];
        }
    };
    [alerView showXLAlertView];
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (void)leaderTap:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *type = nameDictionary[@"type"];
    self.showLeader.type = type.intValue;
    [self.showLeader show];
}


- (void)axcAE_TabBarDouble:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{
    if ((self.oldSelectIndex == 4) && (index != 4)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESTOPPLAYCENTERMUSIC" object:nil];
    }
    if (index != self.oldCtlSelectIndex) {
        self.oldCtlSelectIndex = index;
        self.newClick = YES;
        if (index == 3) {
            if (self.hasClickShop) {//点击过才发通知刷新数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHSHOPDATANOTICETION" object:nil];
            }else{
                self.hasClickShop = YES;
            }
            
        }
    }else{
        if (index == 1) {
            if (self.newClick) {
                self.newClick = NO;
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RECLICKREFRESHDATA" object:nil];
        }
        if (index == 0) {
            if (self.newClick) {
                self.newClick = NO;
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RECLICKREFRESHBOKEDATA" object:nil];
        }
    }
}

//选择发送心情类型
- (NoticeNewRecoderInputView *)recoderInputView{
    if (!_recoderInputView) {
        _recoderInputView = [[NoticeNewRecoderInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
   
        _recoderInputView.callBlock = ^(NSInteger type) {
            CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"moveIn"
                                                                            withSubType:kCATransitionFromTop
                                                                               duration:0.3f
                                                                         timingFunction:kCAMediaTimingFunctionDefault
                                                                                   view:[NoticeTools getTopViewController].navigationController.view];
            [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
            if (type == 1) {
                NoticeRecoderController *ctl = [[NoticeRecoderController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
            }else if (type == 2){
                NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
            }else if (type == 3){
                NoticeSendBoKeController *ctl = [[NoticeSendBoKeController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
            }else if (type == 4){
                NoticreSendHelpController *ctl = [[NoticreSendHelpController alloc] init];
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
            }
        };

    }
    return _recoderInputView;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if(self.axcTabBar){
        self.axcTabBar.selectIndex = selectedIndex;
    }
}

- (void)changeSelect:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *status = nameDictionary[@"voiceStatus"];
    if (status.intValue == 3) {
        [self axcAE_TabBar:self.axcTabBar selectIndex:4];
    }else{
        [self axcAE_TabBar:self.axcTabBar selectIndex:1];
    }
    
}

- (void)changeSelecttext:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *status = nameDictionary[@"voiceStatus"];
    if (status.intValue == 3) {
        [self axcAE_TabBar:self.axcTabBar selectIndex:4];
    }else{
        [self axcAE_TabBar:self.axcTabBar selectIndex:1];
    }
    
}

- (void)changeSelectGroup{
    
    [self axcAE_TabBar:self.axcTabBar selectIndex:1];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
   // self.axcTabBar.selectIndex = self.oldSelectIndex;
    self.axcTabBar.frame = self.tabBar.bounds;
 
    [self.axcTabBar viewDidLayoutItems];
}

@end
