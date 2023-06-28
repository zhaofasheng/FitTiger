//
//  NoticeSupplyNicknameController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/4.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSupplyNicknameController.h"
#import "NoticeXi-Swift.h"
#import "NoticeMyJieYouShopController.h"
@interface NoticeSupplyNicknameController ()
@property (strong, nonatomic) UITextField *phoneView;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation NoticeSupplyNicknameController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.needBackGroundView = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navBarView.titleL.text = @"申请开通店铺";
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-306)/2, 20+NAVIGATION_BAR_HEIGHT, 306, 41)];
    imageView.image = UIImageNamed(@"Image_shopthree");
    [self.view addSubview:imageView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(imageView.frame)+10, DR_SCREEN_WIDTH-40, 56)];
    backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    
    
    self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, backView.frame.size.width-10, 56)];
    [self.phoneView setupToolbarToDismissRightButton];
    self.phoneView.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.phoneView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"最多可设置4个字" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
    [backView addSubview:self.phoneView];
    self.phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.phoneView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.markL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backView.frame), DR_SCREEN_WIDTH-20, 40)];
    self.markL.font = TWOTEXTFONTSIZE;
    self.markL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
    [self.view addSubview:self.markL];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(68,CGRectGetMaxY(imageView.frame)+71*2+40,DR_SCREEN_WIDTH-68*2, 56);
    [btn setTitle:@"申请" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    btn.layer.cornerRadius = 56/2;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [btn addTarget:self action:@selector(upDataClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.nextButton = btn;
}
- (void)textFieldDidChange:(id) sender {
    if (self.phoneView.text.length > 4) {
        self.markL.text = @"不能超过4个字";
    }else{
        self.markL.text = @"";
    }
    
    if (self.phoneView.text.length <= 4 && self.phoneView.text.length > 0){
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.nextButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
}

- (void)upDataClick{
    

    
    if (self.phoneView.text.length <= 4 && self.phoneView.text.length > 0) {
        
        __weak typeof(self) weakSelf = self;
        [self showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];

        [parm setObject:self.phoneView.text forKey:@"shop_name"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [weakSelf hideHUD];
            if (success) {
                __block UIViewController *pushVC;
                [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NoticeMyJieYouShopController class]]) {//返回到指定界面
                        pushVC = obj;
                    }
                }];
                if (pushVC) {
                    [self.navigationController popToViewController:pushVC animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HASSUPPLYSHOPNOTICE" object:nil];
            }
        } fail:^(NSError * _Nullable error) {
            [weakSelf hideHUD];
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
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


@end
