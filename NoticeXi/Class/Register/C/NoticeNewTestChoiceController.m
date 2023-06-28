//
//  NoticeNewTestChoiceController.m
//  NoticeXi
//
//  Created by li lei on 2021/5/15.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewTestChoiceController.h"

@interface NoticeNewTestChoiceController ()<UIGestureRecognizerDelegate>

@end

@implementation NoticeNewTestChoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    label.text = [NoticeTools getLocalStrWith:@"test.title"];
    [self.view addSubview:label];
    
    UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2+30, 100+30, 335-60, 402)];
    imageV3.image = UIImageNamed(@"img_testimg");
    [self.view addSubview:imageV3];
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2+15, 100+15, 335-30, 402)];
    imageV2.image = UIImageNamed(@"img_testimg");
    [self.view addSubview:imageV2];
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2, 100, 335, 402)];
    imageV1.image = UIImageNamed(@"img_testimg");
    [self.view addSubview:imageV1];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    return NO;
}

@end
