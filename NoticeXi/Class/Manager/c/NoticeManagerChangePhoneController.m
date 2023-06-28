//
//  NoticeManagerChangePhoneController.m
//  NoticeXi
//
//  Created by li lei on 2021/2/3.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerChangePhoneController.h"
#import "NoticeAreaViewController.h"
#import "NoticeNearPerson.h"
@interface NoticeManagerChangePhoneController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *nameFiled;
@property (strong, nonatomic) UITextField *phoneView;
@property (strong, nonatomic) FSCustomButton *choiceBtn;
@property (strong, nonatomic) NoticeAreaModel *areaModel;
@end

@implementation NoticeManagerChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameFiled = [[UITextField alloc] initWithFrame:CGRectMake(17,100,DR_SCREEN_WIDTH-32,40)];
    self.nameFiled.delegate = self;
    self.nameFiled.textColor = GetColorWithName(VMainTextColor);
    self.nameFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户学号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:GetColorWithName(VDarkTextColor)}];
    self.nameFiled.delegate = self;
    self.nameFiled.font = XGFifthBoldFontSize;
    self.nameFiled.tintColor = GetColorWithName(VMainThumeColor);
    [self.view addSubview:self.nameFiled];
    self.nameFiled.layer.cornerRadius = 3;
    self.nameFiled.layer.masksToBounds = YES;
    self.nameFiled.layer.borderWidth = 1;
    self.nameFiled.layer.borderColor = GetColorWithName(VMainThumeColor).CGColor;
    
    self.nameFiled.keyboardType = UIKeyboardTypePhonePad;
    [self.nameFiled setupToolbarToDismissRightButton];
    
    self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(17,CGRectGetMaxY(self.nameFiled.frame)+40,DR_SCREEN_WIDTH-32,40)];
    self.phoneView.delegate = self;
    self.phoneView.textColor = GetColorWithName(VMainTextColor);
    self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入为绑定的手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:GetColorWithName(VDarkTextColor)}];
    self.phoneView.delegate = self;
    self.phoneView.font = XGFifthBoldFontSize;
    self.phoneView.tintColor = GetColorWithName(VMainThumeColor);
    [self.view addSubview:self.phoneView];
    
    self.phoneView.layer.cornerRadius = 3;
    self.phoneView.layer.masksToBounds = YES;
    self.phoneView.layer.borderWidth = 1;
    self.phoneView.layer.borderColor = GetColorWithName(VMainThumeColor).CGColor;
    
    self.phoneView.keyboardType = UIKeyboardTypePhonePad;
    [self.phoneView setupToolbarToDismissRightButton];
    
    self.areaModel = [[NoticeAreaModel alloc] init];
    self.areaModel.phone_code = @"86";
    self.areaModel.area_code = @"CN";
    self.areaModel.area_name = @"中国大陆";
    self.choiceBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-64)/2,CGRectGetMaxY(self.phoneView.frame)+30,66, 44)];
    [self.choiceBtn setTitle:@"+86  " forState:UIControlStateNormal];
    [self.choiceBtn setTitleColor:[UIColor colorWithHexString:WHITENAVTITLECOLOR] forState:UIControlStateNormal];
    [self.choiceBtn setImage:[UIImage imageNamed:@"login_choice"] forState:UIControlStateNormal];
    [self.choiceBtn addTarget:self action:@selector(choiceNumTypeClick) forControlEvents:UIControlEventTouchUpInside];
    self.choiceBtn.buttonImagePosition = FSCustomButtonImagePositionRight;
    [self.view addSubview:self.choiceBtn];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.choiceBtn.frame)+30, DR_SCREEN_WIDTH-60, 40)];
    [btn setTitle:@"绑定" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.backgroundColor = GetColorWithName(VMainThumeColor);
    [btn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)changeClick{
    if (!self.nameFiled.text.length) {
        [self showToastWithText:@"输入用户学号"];
        return;
    }
    if (!self.phoneView.text.length) {
        [self showToastWithText:@"输入要绑定的手机号"];
        return;
    }
    [self showHUD];
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.areaModel.area_code forKey:@"newAreaCode"];
    [parm setObject:self.phoneView.text forKey:@"newMobile"];
    [parm setObject:self.managerCode forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/users/frequencyNo/%@",self.nameFiled.text] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:@"绑定成功"];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}


@end
