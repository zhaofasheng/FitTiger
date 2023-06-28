//
//  NoticeChoiceReasonController.m
//  NoticeXi
//
//  Created by li lei on 2020/7/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceReasonController.h"
#import "NoticeSorryController.h"
#import "NoticeMoreWantController.h"
@interface NoticeChoiceReasonController ()
@property (strong, nonatomic)  UILabel *topTitleL;

@end

@implementation NoticeChoiceReasonController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-319)/2, NAVIGATION_BAR_HEIGHT+65, 319, 20)];
    imageView.image = UIImageNamed(@"Image_register");
    [self.view addSubview:imageView];
    
    NSArray *arr = @[@"Image_comfr",@"Image_sayyou"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-260)/2, CGRectGetMaxY(imageView.frame)+70+69*i, 260, 44)];
        [btn setBackgroundImage:UIImageNamed(arr[i]) forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)choiceClick:(UIButton *)button{
    if (button.tag == 1) {
        NoticeSorryController *ctl = [[NoticeSorryController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    NoticeMoreWantController *ctl = [[NoticeMoreWantController alloc] init];
    ctl.phone = self.phone;
    ctl.isThird = self.isThird;
    ctl.areaModel = self.areaModel;
    ctl.regModel = self.regModel;
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
