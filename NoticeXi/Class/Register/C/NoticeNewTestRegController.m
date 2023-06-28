//
//  NoticeNewTestRegController.m
//  NoticeXi
//
//  Created by li lei on 2021/5/14.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewTestRegController.h"
#import "NoticeVideoViewController.h"
#import "NoticeNewTestChoiceController.h"
#import "DRPsychologyViewController.h"
@interface NoticeNewTestRegController ()<UIGestureRecognizerDelegate>

@end

@implementation NoticeNewTestRegController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"test.title"];
    
    UILabel*backView = [[UILabel alloc] initWithFrame:CGRectMake(30, (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-339)/2, DR_SCREEN_WIDTH-60, 339)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    backView.text = [NoticeTools getLocalStrWith:@"test.must"];
    backView.numberOfLines = 0;
    backView.font = EIGHTEENTEXTFONTSIZE;
    backView.textAlignment = NSTextAlignmentCenter;
    backView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-223)/2, backView.frame.origin.y-138/2, 223, 138)];
    imageView.image = UIImageNamed(@"Image_testimage");
    [self.view addSubview:imageView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(48, CGRectGetMaxY(backView.frame)+50, DR_SCREEN_WIDTH-96, 50)];
    btn.layer.cornerRadius = 25;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundImage:UIImageNamed(@"img_buttonback") forState:UIControlStateNormal];
    [btn setTitle:[NoticeTools getLocalStrWith:@"test.now"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(testNowClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isFromhasLogin) {
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        headerV.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        [self.view addSubview:headerV];
        
        UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-50, 50)];
        textL.font = FOURTHTEENTEXTFONTSIZE;
        textL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        textL.text = [NoticeTools getLocalStrWith:@"test.wanc"];
        [headerV addSubview:textL];
        
        UIImageView *iamgeV1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        iamgeV1.image = UIImageNamed(@"Image_testgantanh");
        [headerV addSubview:iamgeV1];
        
        UIImageView *iamgeV2 = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-20, 15, 20, 20)];
        iamgeV2.image = UIImageNamed(@"Image_testinto");
        [headerV addSubview:iamgeV2];
        
        headerV.userInteractionEnabled = YES;
        UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testNowClick)];
        [headerV addGestureRecognizer:headTap];
    }
}

- (void)testNowClick{

    DRPsychologyViewController *ctl = [[DRPsychologyViewController alloc] init];
    ctl.nickName = self.nickName;
    if (self.isFromhasLogin) {
        ctl.isFromMain = YES;
    }else{
        ctl.isReg = YES;
    }
    
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    return YES;
}
@end
