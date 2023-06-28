//
//  NoticeSupplyOpenShopController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSupplyOpenShopController.h"
#import "NoticeSupplyCheckController.h"
@interface NoticeSupplyOpenShopController ()
@property (strong, nonatomic) UITextField *codeView;
@property (strong, nonatomic) UITextField *phoneView;
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation NoticeSupplyOpenShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needHideNavBar = YES;
    self.needBackGroundView = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navBarView.titleL.text = @"申请开通店铺";
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 50)];
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
    label.numberOfLines = 0;
    label.text = @"认证信息将用于店铺的收益提现，与帐号唯一绑定，我们会对信息进行严格保密。";
    [self.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-306)/2, 60+NAVIGATION_BAR_HEIGHT, 306, 41)];
    imageView.image = UIImageNamed(@"Image_shopone");
    [self.view addSubview:imageView];
    
    for (int i = 0; i < 2; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(imageView.frame)+10+71*i, DR_SCREEN_WIDTH-40, 56)];
        backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
        [self.view addSubview:backView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 84, 56)];
        titleL.font = SIXTEENTEXTFONTSIZE;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:titleL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(84, 17, 1, 22)];
        line.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
        [backView addSubview:line];
        
        if (i == 0) {
            titleL.text = @"真实姓名";
            self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+10, 0, backView.frame.size.width-CGRectGetMaxX(line.frame)-10, 56)];
            [self.phoneView setupToolbarToDismissRightButton];
            self.phoneView.textColor = [UIColor colorWithHexString:@"#25262E"];
            self.phoneView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
            self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入你的身份证姓名" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
            [backView addSubview:self.phoneView];
            self.phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
        }else{
            titleL.text = @"身份证号";
            self.codeView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+10, 0, backView.frame.size.width-CGRectGetMaxX(line.frame)-10, 56)];
            [self.codeView setupToolbarToDismissRightButton];
            self.codeView.textColor = [UIColor colorWithHexString:@"#25262E"];
            self.codeView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入你的身份证号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
            self.codeView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
            [backView addSubview:self.codeView];
                    
        }
    }
    
    [self.phoneView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(68,CGRectGetMaxY(imageView.frame)+71*2+40,DR_SCREEN_WIDTH-68*2, 56);
    [btn setTitle:[NoticeTools getLocalStrWith:@"photo.next"] forState:UIControlStateNormal];
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
    if (self.phoneView.text.length && self.codeView.text.length) {
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.nextButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else{
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.nextButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }
}

//身份证号
- (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


- (void)upDataClick{

    if (self.phoneView.text.length && self.codeView.text.length) {
        if (![self validateIdentityCard:self.codeView.text]) {
            [self showToastWithText:@"请输入正确身份证号码"];
            return;
        }
        
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定信息是否无误？" message:[NSString stringWithFormat:@"%@\n%@\n错误的信息会导致提现失败哦",self.phoneView.text,self.codeView.text] sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                [parm setObject:self.phoneView.text forKey:@"real_name"];
                [parm setObject:self.codeView.text forKey:@"cert_no"];
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/certification" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        NoticeSupplyCheckController *ctl = [[NoticeSupplyCheckController alloc] init];
                   
                        [weakSelf.navigationController pushViewController:ctl animated:YES];
                    }
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
        
            }
        };
        [alerView showXLAlertView];
        

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
