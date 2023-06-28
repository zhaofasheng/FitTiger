//
//  NoticeCheckGroupReplyController.m
//  NoticeXi
//
//  Created by li lei on 2020/9/4.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeCheckGroupReplyController.h"

@interface NoticeCheckGroupReplyController ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, strong) UITextView*nameFiled;
@property (nonatomic, strong) UITextView *suggestFiled;
@property (nonatomic, assign) BOOL agree;
@property (nonatomic, assign) BOOL hasClick;
@property (nonatomic, strong) NoticeManagerGroupReplyModel *agreeModel;
@end

@implementation NoticeCheckGroupReplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =self.replyModel.type.intValue == 2?@"社团延期审核": @"创建社团申请审核";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    self.infoL = [[UILabel alloc] initWithFrame:CGRectMake(15,0, DR_SCREEN_WIDTH-30, 130)];
    self.infoL.font = FIFTHTEENTEXTFONTSIZE;
    self.infoL.numberOfLines = 0;
    self.infoL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.infoL];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 60, 30)];
    label.text = @"决定";
    label.font = SIXTEENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:label];
    
    self.noBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-43, 130, 43, 30)];
    self.noBtn.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
    self.noBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.noBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    self.noBtn.layer.cornerRadius = 5;
    self.noBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.noBtn];
    [self.noBtn setTitle:@"驳回" forState:UIControlStateNormal];
    [self.noBtn addTarget:self action:@selector(noClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-43-15-43, 130, 43, 30)];
    self.agreeBtn.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
    self.agreeBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.agreeBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    self.agreeBtn.layer.cornerRadius = 5;
    self.agreeBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.agreeBtn];
    [self.agreeBtn setTitle:[NoticeTools getLocalStrWith:@"group.agrees"] forState:UIControlStateNormal];
    [self.agreeBtn addTarget:self action:@selector(agreeeClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.agreeBtn.frame),90,20)];
    label1.text = @"驳回理由";
    label1.font = SIXTEENTEXTFONTSIZE;
    label1.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:label1];
    
    self.nameFiled = [[UITextView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(label1.frame),DR_SCREEN_WIDTH-30,50)];
    self.nameFiled.delegate = self;
    self.nameFiled.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.nameFiled.delegate = self;
    self.nameFiled.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    self.nameFiled.layer.cornerRadius = 5;
    self.nameFiled.layer.masksToBounds = YES;
    [self.view addSubview:self.nameFiled];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameFiled.frame), 60, 20)];
    label2.text = @"建议";
    label2.font = SIXTEENTEXTFONTSIZE;
    label2.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:label2];
    
    self.suggestFiled = [[UITextView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(label2.frame),DR_SCREEN_WIDTH-30,50)];
    self.suggestFiled.delegate = self;
    self.suggestFiled.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.suggestFiled.delegate = self;
    self.suggestFiled.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    self.suggestFiled.layer.cornerRadius = 5;
    self.suggestFiled.layer.masksToBounds = YES;
    [self.view addSubview:self.suggestFiled];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-45-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 45)];
    [sendButton setTitle:@"发送决定" forState:UIControlStateNormal];
    [sendButton setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
    sendButton.backgroundColor = GetColorWithName(VMainThumeColor);
    sendButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [self.view addSubview:sendButton];
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arr = @[@"世上最不能急功近利的有两件事：一是学习，一是爱情，请换个宗旨和社名",@"有礼貌，人人笑，请换个宗旨和社名",@"无目标的努力，有如在黑暗中远征，请换个宗旨和社名",@"每一段青春都是限量版，创建一个你真正感兴趣的社团"];
    for (int i = 0; i < 4; i++) {
        UILabel *copyL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.suggestFiled.frame)+30+50*i, DR_SCREEN_WIDTH-20, 50)];
        copyL.numberOfLines = 0;
        copyL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        copyL.font = TWOTEXTFONTSIZE;
        [self.view addSubview:copyL];
        copyL.text = arr[i];
        copyL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyTap:)];
        [copyL addGestureRecognizer:tap];
    }
    
    [self request];
}

- (void)copyTap:(UITapGestureRecognizer *)tap{
    UILabel *tapL = (UILabel *)tap.view;
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:tapL.text];
    [self showToastWithText:@"已复制"];
}

- (void)request{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"manage/Detail/%@?confirmPasswd=%@",self.replyModel.replyId,self.managerCode] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.agreeModel = [NoticeManagerGroupReplyModel mj_objectWithKeyValues:dict[@"data"]];
            self.infoL.text = [NSString stringWithFormat:@"%@：\n%@\n\n%@：\n%@",[NoticeTools getLocalStrWith:@"group.name"],self.agreeModel.title,[NoticeTools getLocalStrWith:@"group.value"],self.agreeModel.content];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    
    return YES;
}

- (void)agreeeClick{
    self.agreeBtn.backgroundColor = [UIColor colorWithHexString:@"#6CCC46"];
    self.noBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    self.agree = YES;
    self.hasClick = YES;
}

- (void)noClick{
    self.agreeBtn.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    self.noBtn.backgroundColor = [UIColor redColor];
    self.agree = NO;
    self.hasClick = YES;
}

- (void)sendClick{
    if (!self.hasClick) {
        [self showToastWithText:@"请选择同意或者驳回"];
        return;
    }
    if (!self.agree) {
        if (!self.nameFiled.text.length || !self.suggestFiled.text.length) {
            [self showToastWithText:@"请输入驳回理由和建议"];
            return;
        }
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    
    if (!self.agree) {
        [parm setValue:self.nameFiled.text forKey:@"describe"];
        [parm setValue:self.suggestFiled.text forKey:@"proposal"];
    }
    if (self.replyModel.type.intValue == 2) {
        [parm setValue:self.agree?@"2":@"3" forKey:@"type"];
        [parm setValue:self.managerCode forKey:@"confirmPasswd"];
    }else{
        [parm setValue:self.agree?@"2":@"3" forKey:@"status"];
    }
    
    [self showHUD];
    [[DRNetWorking shareInstance] requestWithPatchPath:self.replyModel.type.intValue==2?[NSString stringWithFormat:@"assoc/trialDelay/%@",self.replyModel.replyId]:[NSString stringWithFormat:@"assoc/%@?confirmPasswd=%@",self.replyModel.replyId,self.managerCode] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self showToastWithText:self.agree? @"已通过":@"已驳回"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}


@end
