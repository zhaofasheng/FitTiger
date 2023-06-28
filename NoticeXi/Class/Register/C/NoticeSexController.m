//
//  NoticeSexController.m
//  NoticeXi
//
//  Created by li lei on 2020/7/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeSexController.h"
#import "NoticeConnectPhoneController.h"
#import "NoticeVideoViewController.h"
@interface NoticeSexController ()
@property (strong, nonatomic)  UILabel *topTitleL;
@end

@implementation NoticeSexController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-341)/2, 100, 341, 92)];
    imageView.image = UIImageNamed(@"Image_mingbail");
    [self.view addSubview:imageView];
    
    for (int i = 0; i < 1; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-205)/2, CGRectGetMaxY(imageView.frame)+70+69*i, 205, 44)];
        [btn setBackgroundImage:UIImageNamed(@"Image_zuojzij") forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)choiceClick:(UIButton *)button{
    NoticeVideoViewController *ctl = [[NoticeVideoViewController alloc] init];
    ctl.phone = self.phone;
    ctl.isRemember = !self.isRemember;
    ctl.isThird = self.isThird;
    ctl.areaModel = self.areaModel;
    ctl.regModel = self.regModel;
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
