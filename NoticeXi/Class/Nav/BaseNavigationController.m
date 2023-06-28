
#import "BaseNavigationController.h"
#import "UIImage+Color.h"
#import "NoticeDrawViewController.h"
#import "NoticeManagerController.h"
#import "NoticeTuYaChatWithOtherController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeImageViewController.h"
#import "NoticeSendViewController.h"
#import "NoticeSCViewController.h"
#import "NoticeTextVoiceController.h"
#import "NoticeRecoderController.h"
@interface BaseNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
	[super viewDidLoad];
    //self.modalPresentationStyle = UIModalPresentationFullScreen;
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer*)pan{
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self.viewControllers count] > 0) {
		viewController.hidesBottomBarWhenPushed = YES;
        
	}
	[super pushViewController:viewController animated:animated];
	if ([self.viewControllers count] > 1 && !viewController.navigationItem.leftBarButtonItem) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 22, 44);
        [backButton setImage:[UIImage imageNamed:@"Image_blackBack"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	}
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeDrawViewController class]]) {//当是画画界面的时候，不允许返回
        return NO;
    }
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeManagerController class]]) {//当是管理员界面的时候，不允许返回
        return NO;
    }
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeTuYaChatWithOtherController class]]) {
        return NO;
    }
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeUserInfoCenterController class]]) {
        return NO;
    }
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeTextVoiceController class]]) {
        return NO;
    }
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeRecoderController class]]) {
        return NO;
    }
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeImageViewController class]]) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.noPop) {
            return NO;
        }
        
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.noPop) {
        return NO;
    }
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeSendViewController class]]) {
        return NO;
    }
    if ([self.childViewControllers[self.childViewControllers.count-1] isKindOfClass:[NoticeSCViewController class]]) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.noPop) {
            return NO;
        }
    }//
    //
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

- (void)backToPageAction
{
    [self popViewControllerAnimated:YES];
}

+ (void)initialize
{
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];
        //添加背景色
        appperance.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        appperance.shadowImage = [[UIImage alloc]init];
        appperance.shadowColor = nil;
        //设置字体颜色大小
        [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#41434D"],NSFontAttributeName:XGTwentyBoldFontSize}];
        
        UINavigationBar *navgationBar = [UINavigationBar appearance];
        navgationBar.standardAppearance = appperance;
        navgationBar.scrollEdgeAppearance = appperance;
        
    }else{
        
        UINavigationBar *navgationBar = [UINavigationBar appearance];
        [navgationBar setShadowImage:[UIImage new]];//设置阴影图片
        navgationBar.tintColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];//设置导航条颜色
        CGFloat width = DR_SCREEN_WIDTH;
        [navgationBar setBackgroundImage:[UIImage imageFromColor:[[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1] size:CGSizeMake(width, NAVIGATION_BAR_HEIGHT)] forBarMetrics:UIBarMetricsDefault];//设置背景图片和颜色
        [navgationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#41434D"],NSFontAttributeName:XGTwentyBoldFontSize}];//设置文字颜色
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGETHEMCOLORNOTICATION" object:nil];
}


@end
