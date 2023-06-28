//
//  NoticeMoreWantController.m
//  NoticeXi
//
//  Created by li lei on 2020/7/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeMoreWantController.h"
#import "NoticeSexController.h"
@interface NoticeMoreWantController ()
@property (strong, nonatomic)  UILabel *topTitleL;
@end

@implementation NoticeMoreWantController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-232)/2, 100+30, 232,55)];
    imageView.image = UIImageNamed(@"Image_haoanp");
    [self.view addSubview:imageView];
    
    NSArray *arr = @[@"Image_wjluzhe",@"Image_jiaoliuz"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-260)/2, CGRectGetMaxY(imageView.frame)+70+69*i, 260, 44)];
        [btn setBackgroundImage:UIImageNamed(arr[i]) forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)choiceClick:(UIButton *)button{
    NoticeSexController *ctl = [[NoticeSexController alloc] init];
    ctl.phone = self.phone;
    ctl.isRemember = button.tag == 0?YES:NO;
    ctl.isThird = self.isThird;
    ctl.areaModel = self.areaModel;
    ctl.regModel = self.regModel;
    [self.navigationController pushViewController:ctl animated:YES];
}
@end
