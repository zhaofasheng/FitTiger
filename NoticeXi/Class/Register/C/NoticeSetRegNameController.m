//
//  NoticeSetRegNameController.m
//  NoticeXi
//
//  Created by li lei on 2021/5/14.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeSetRegNameController.h"
#import "NoticeNewTestRegController.h"
@interface NoticeSetRegNameController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UILabel *numL;
@end

@implementation NoticeSetRegNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.text = [NoticeTools getLocalStrWith:@"reg.setname"];
    [self.view addSubview:label];
    
    UILabel *tiaoguoL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-20, STATUS_BAR_HEIGHT, 50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    tiaoguoL.text = [NoticeTools getLocalStrWith:@"reg.jump"];
    tiaoguoL.font = SIXTEENTEXTFONTSIZE;
    tiaoguoL.textColor = [UIColor colorWithHexString:@"#25262E"];
    tiaoguoL.userInteractionEnabled = YES;
    tiaoguoL.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *nextT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextTap)];
    [tiaoguoL addGestureRecognizer:nextT];
    [self.view addSubview:tiaoguoL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(68,NAVIGATION_BAR_HEIGHT+200,DR_SCREEN_WIDTH-68*2, 56);
    [btn setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = XGTwentyBoldFontSize;
    btn.layer.cornerRadius = 56/2;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 30+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 56)];
    backV.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    backV.layer.cornerRadius = 5;
    backV.layer.masksToBounds = YES;
    [self.view addSubview:backV];
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 56)];
    markL.text = [NoticeTools getLocalStrWith:@"intro.username"];
    markL.textAlignment = NSTextAlignmentCenter;
    markL.font = SIXTEENTEXTFONTSIZE;
    markL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [backV addSubview:markL];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL.frame), 17, 1, 22)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [backV addSubview:line];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+10,0, DR_SCREEN_WIDTH-40, 56)];

    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"reg.limit"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
    self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nameField becomeFirstResponder];
    [backV addSubview:self.nameField];

    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backV.frame)+10, 100, 13)];
    self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.numL.font = THRETEENTEXTFONTSIZE;
    self.numL.text = @"0/10";
    [self.view addSubview:self.numL];
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (_field.text.length > 10) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/10",(unsigned long)_field.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",_field.text.length] beginSize:0];
    }else{
        NSString *allStr = [NSString stringWithFormat:@"%lu/10",(unsigned long)_field.text.length];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"10" beginSize:allStr.length-2];
    }
}


- (void)fifinshClick{
    
    
    if (!self.nameField.text.length) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"reg.inout"]];
        return;
    }
    if (self.nameField.text.length > 10) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"reg.limit"]];
        return;
    }
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.nameField.text forKey:@"nickName"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success1) {
        
        if (success1) {
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success2) {
                [self hideHUD];
                if (success2) {
                    NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
                    [NoticeSaveModel saveUserInfo:userIn];
                    //执行引导页
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    //上传成功，执行引导页
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                }
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];

}

- (void)nextTap{
//    NoticeNewTestRegController *ctl = [[NoticeNewTestRegController alloc] init];
//    [self.navigationController pushViewController:ctl animated:YES];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success2) {
        [self hideHUD];
        if (success2) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            [NoticeSaveModel saveUserInfo:userIn];
            //执行引导页
            [self.navigationController popToRootViewControllerAnimated:NO];
            //上传成功，执行引导页
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
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
