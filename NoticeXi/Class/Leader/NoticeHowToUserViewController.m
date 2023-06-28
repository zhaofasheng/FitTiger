//
//  NoticeHowToUserViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/22.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHowToUserViewController.h"

@interface NoticeHowToUserViewController ()<UIScrollViewDelegate,UIPageViewControllerDelegate>
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation NoticeHowToUserViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.isPush? -STATUS_BAR_HEIGHT : 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT+STATUS_BAR_HEIGHT)];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH*4, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
//    NSArray *smallImageArr = @[@"p-1",@"p-2",@"p-3",@"p-4"];
//    NSArray *bigImageArr = @[@"x-1",@"x-2",@"x-3",@"x-4"];
//    for (int i = 0; i < 4; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH*i,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
//        imageView.image = [UIImage imageNamed:ISIPHONEXORLATER ? bigImageArr[i] : smallImageArr[i]];
//        imageView.userInteractionEnabled = YES;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.clipsToBounds = YES;
//        [scrollView addSubview:imageView];
//    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-15-27-5-54-20+DR_SCREEN_WIDTH*3, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-30-25-5,27+5+54+20, 30);
    //[btn setImage:UIImageNamed(@"Imageintosx") forState:UIControlStateNormal];
    [btn setTitle:[NSString stringWithFormat:@"进入%@",GETTEXTWITE(@"my.my")] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#839551"] forState:UIControlStateNormal];
    btn.titleLabel.font = NINETEENTEXTFONTSIZE;
    [scrollView addSubview:btn];
    [btn addTarget:self action:@selector(changetRoot) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpBtn.frame = CGRectMake(DR_SCREEN_WIDTH-10-54, STATUS_BAR_HEIGHT+7, 54, 30);
    [jumpBtn setTitleColor:[UIColor colorWithHexString:WHITEBACKCOLOR] forState:UIControlStateNormal];
    jumpBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
    jumpBtn.backgroundColor = [UIColor blackColor];
    jumpBtn.alpha = 0.3;
    jumpBtn.layer.cornerRadius = 5;
    jumpBtn.layer.masksToBounds = YES;
    [jumpBtn addTarget:self action:@selector(changetRoot) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
    label.text = [NoticeTools getLocalStrWith:@"reg.jump"];
    label.font = ELEVENTEXTFONTSIZE;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [jumpBtn addSubview:label];
    [self.view addSubview:jumpBtn];
    
    //124 543
    
    UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(btn.frame.size.width,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-25-40, DR_SCREEN_WIDTH-btn.frame.size.width*2, 40)];
    pageController.numberOfPages = 4;
    pageController.currentPage = 0;
    [pageController addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.currentPageIndicatorTintColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    self.pageControl.pageIndicatorTintColor =  [UIColor colorWithHexString:@"#506E49"];
    [self.view addSubview:pageController];
    self.pageControl = pageController;
}

- (void)pageTurn:(UIPageControl*)sender
{

    self.scrollView.contentOffset = CGPointMake(sender.currentPage*DR_SCREEN_WIDTH, -STATUS_BAR_HEIGHT);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.x/DR_SCREEN_WIDTH;

    // 设置页码
    self.pageControl.currentPage = page;
}

- (void)changetRoot{
    if (self.isPush) {
        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"reveal"
                                                                        withSubType:kCATransitionFromBottom
                                                                           duration:0.3f
                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                               view:self.navigationController.view];
        [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
}

@end
