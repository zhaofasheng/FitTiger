//
//  NoticeHasLinkPhoneController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/23.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeHasLinkPhoneController.h"
#import "NoticeChangePhoneViewController.h"
@interface NoticeHasLinkPhoneController ()
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UIButton *changeBtn;
@end

@implementation NoticeHasLinkPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"bdphone.title"];
    
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-49)/2, 94+NAVIGATION_BAR_HEIGHT, 49, 75)];

    [self.view addSubview:titleImageView];
    self.markImageView = titleImageView;
    
    UILabel *phoneL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleImageView.frame)+34, DR_SCREEN_WIDTH, 30)];
    phoneL.font = XGTwentyTwoBoldFontSize;
    phoneL.textAlignment = NSTextAlignmentCenter;
    phoneL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.view addSubview:phoneL];
    self.numL = phoneL;
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneL.frame)+13, DR_SCREEN_WIDTH, 23)];
    markL.font = SIXTEENTEXTFONTSIZE;
    markL.textAlignment = NSTextAlignmentCenter;
    markL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    markL.text = [NoticeTools getLocalStrWith:@"bdphone.currentphone"];
    [self.view addSubview:markL];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-240)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT-50-56, 240, 56)];
    [self.view addSubview:btn];
    self.changeBtn = btn;
    [btn addTarget:self action:@selector(changePhoneClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    self.numL.text = userM.mobile.length>6?userM.mobile:[NoticeTools getLocalStrWith:@"bdphone.nophone"];
    self.markImageView.image = UIImageNamed(userM.mobile.length>6? @"Image_changePhone":@"Image_hasnophone");
    [self.changeBtn setBackgroundImage:UIImageNamed(userM.mobile.length>6? [NoticeTools getLocalImageNameCN:@"Image_chanphbtn"]:@"Image_newbdphone") forState:UIControlStateNormal];
}

- (void)changePhoneClick{

    NoticeChangePhoneViewController *vc = [[NoticeChangePhoneViewController alloc] init];
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    vc.hasPhone = userM.mobile.length>6?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
