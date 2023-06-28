//
//  NoticeConnectPhoneController.m
//  NoticeXi
//
//  Created by li lei on 2020/7/3.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeConnectPhoneController.h"
#import "FSCustomButton.h"
#import "NoticeAreaViewController.h"
#import "DDHAttributedMode.h"
#import "NoticeCodeInputViewController.h"
#import "NoticeCheckModel.h"
#import "NoticeWebViewController.h"
#import "NoticeXieYiViewController.h"
#import "NoticeNoNet.h"

@interface NoticeConnectPhoneController ()<UITextFieldDelegate>

@property (strong, nonatomic)  UITextField *phoneView;
@property (strong, nonatomic)  UILabel *topTitleL;
@property (strong, nonatomic)  UILabel *markL;

@property (strong, nonatomic) FSCustomButton *choiceBtn;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *regBtn;

@property (strong, nonatomic) UILabel *agreeProL;
@property (strong, nonatomic) UILabel *secrProL;
@end

@implementation NoticeConnectPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor colorWithHexString:WHITEBACKCOLOR];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-137)/2,77, 137, 56)];
    imageView.image = UIImageNamed(@"Image_finfishin");
    [self.view addSubview:imageView];
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(46, CGRectGetMaxY(imageView.frame)+85, DR_SCREEN_WIDTH-46*2, 44)];
    [self.view addSubview:textView];
    if (!self.areaModel) {
        self.areaModel = [[NoticeAreaModel alloc] init];
        self.areaModel.phone_code = @"86";
        self.areaModel.area_code = @"CN";
        self.areaModel.area_name = @"中国大陆";
    }

    [NoticeSaveModel saveArea:self.areaModel];
    self.choiceBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0,66, 44)];
    [self.choiceBtn setTitle:[NSString stringWithFormat:@"+%@ ",self.areaModel.phone_code] forState:UIControlStateNormal];
    [self.choiceBtn setTitleColor:[UIColor colorWithHexString:WHITENAVTITLECOLOR] forState:UIControlStateNormal];
    [self.choiceBtn setImage:[UIImage imageNamed:@"login_choice"] forState:UIControlStateNormal];
    [self.choiceBtn addTarget:self action:@selector(choiceNumTypeClick) forControlEvents:UIControlEventTouchUpInside];
    self.choiceBtn.buttonImagePosition = FSCustomButtonImagePositionRight;
    self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.choiceBtn.frame)+10, 0, textView.frame.size.width-self.choiceBtn.frame.size.width-10, 44)];
    self.phoneView.delegate = self;
    self.phoneView.delegate = self;
    self.phoneView.textColor = GetColorWithName(VMainTextColor);
    self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"Login.phone"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:GetColorWithName(VDarkTextColor)}];
    if (self.phone) {
        self.phoneView.text = self.phone;
    }
    self.phoneView.keyboardType = UIKeyboardTypePhonePad;
    [self.phoneView setupToolbarToDismissRightButton];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, textView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#D0D0D0"];
    [textView addSubview:line];
    [textView addSubview:self.choiceBtn];
    [textView addSubview:self.phoneView];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(textView.frame.origin.x, CGRectGetMaxY(textView.frame)+25, textView.frame.size.width, 45)];
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.loginBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn setTitle:[NoticeTools getLocalStrWith:@"main.sure"] forState:UIControlStateNormal];
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn addTarget:self action:@selector(inputCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];

    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 42, 44);
    [backButton setTitle:@"    " forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Image_nophone"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)backToPageAction{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定取消注册吗？" message:@"将失去录制内容" sureBtn:[NoticeTools getLocalStrWith:@"main.sure"] cancleBtn:@"继续注册" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}

- (void)xieyiTap{
    NoticeXieYiViewController * webctl = [[NoticeXieYiViewController alloc] init];
    [self.navigationController pushViewController:webctl animated:YES];
    
}
- (void)yinsiTap{
    NoticeWebViewController * webctl = [[NoticeWebViewController alloc] init];
    webctl.type = @"1";
    webctl.isAboutSX = YES;
    [self.navigationController pushViewController:webctl animated:YES];
}

- (void)inputCodeClick{
    //检测手机是否注册过
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/%@",[[NoticeSaveModel getArea] area_code],self.phoneView.text] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeCheckModel *checkM = [NoticeCheckModel mj_objectWithKeyValues:dict[@"data"]];
            if ([checkM.is_exist isEqualToString:@"1"]) {
                [self showToastWithText:@"该手机已注册"];
                return;
            }
            NoticeCodeInputViewController *ctl = [[NoticeCodeInputViewController alloc] init];
            ctl.phone = self.phoneView.text;
            ctl.areaModel = self.areaModel;
            ctl.isThird = self.isThird;
            ctl.isRemember = self.isRemember;
            ctl.regModel = self.regModel;
            ctl.locapath = self.locapath;
            ctl.timeLength = self.timeLength;
            ctl.text = self.text;
            [self.navigationController pushViewController:ctl animated:YES];
        }
        
    } fail:^(NSError *error) {
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"网络未开启，请确保系统设置「声昔—无线数据」处于打开状态" sureBtn:@"检查" cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                UIApplication *application = [UIApplication sharedApplication];
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([application canOpenURL:url]) {
                    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                        if (@available(iOS 10.0, *)) {
                            [application openURL:url options:@{} completionHandler:nil];
                        }
                    } else {
                        [application openURL:url options:@{} completionHandler:nil];
                    }
                }
            }
        };
        [alerView showXLAlertView];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //禁用右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.phoneView resignFirstResponder];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)choiceNumTypeClick{
    NoticeAreaViewController *ctl = [[NoticeAreaViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    ctl.adressBlock = ^(NoticeAreaModel *adressModel) {
        weakSelf.areaModel = adressModel;
        [NoticeSaveModel saveArea:adressModel];
        [weakSelf.choiceBtn setTitle:[NSString stringWithFormat:@"+%@ ",weakSelf.areaModel.phone_code] forState:UIControlStateNormal];
    };
     [self.navigationController pushViewController:ctl animated:YES];
}

@end
