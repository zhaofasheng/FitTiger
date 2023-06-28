//
//  NoticeSorryController.m
//  NoticeXi
//
//  Created by li lei on 2020/7/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSorryController.h"

@interface NoticeSorryController ()
@property (strong, nonatomic) UIButton *loginBtn;
@end

@implementation NoticeSorryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-326)/2, 100+100,326,50)];
    titleImageView.image = UIImageNamed(@"Image_marktit_b");
    [self.view addSubview:titleImageView];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-160)/2, CGRectGetMaxY(titleImageView.frame)+100, 160, 44)];
    [self.loginBtn setBackgroundImage:UIImageNamed(@"Image_haodene") forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
