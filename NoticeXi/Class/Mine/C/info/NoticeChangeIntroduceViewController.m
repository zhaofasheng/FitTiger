//
//  NoticeChangeIntroduceViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeIntroduceViewController.h"
#import "DDHAttributedMode.h"
@interface NoticeChangeIntroduceViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITextView *nameField;
@property (nonatomic, strong) UILabel *numL;
@end

@implementation NoticeChangeIntroduceViewController
{
    UILabel *_plaL;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isFromReg) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"intro.textintro"];
    
        
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 12+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-30, 100)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    if (self.isFromReg) {
        self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"intro.texipnpla"];
        self.navigationItem.title = [NoticeTools getLocalStrWith:@"intro.texipnpla"];
        self.navBarView.backButton.hidden = YES;
    }
    
    self.nameField = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, DR_SCREEN_WIDTH-30, 30)];
    self.nameField.text = self.induce;
    self.nameField.backgroundColor = backView.backgroundColor;
    self.nameField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
    if ([[NoticeSaveModel getUserInfo] self_intro]) {
        self.nameField.text = [[NoticeSaveModel getUserInfo] self_intro];
    }
    
    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.nameField becomeFirstResponder];
    [backView addSubview:self.nameField];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 14)];
    if ([[NoticeSaveModel getUserInfo] self_intro].length) {
        _plaL.text = @"";
    }else{
        _plaL.text = [NoticeTools getLocalStrWith:@"intro.texipnpla"];
    }
    
    _plaL.font = FIFTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [backView addSubview:_plaL];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(backView.frame)+10,50, 13)];
    self.numL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.numL.font = TWOTEXTFONTSIZE;
    NSString *allStr = [NSString stringWithFormat:@"%lu/20",(unsigned long)self.induce.length];
    self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"20" beginSize:allStr.length-2];
    [self.view addSubview:self.numL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(68,CGRectGetMaxY(self.numL.frame)+64,DR_SCREEN_WIDTH-68*2, 56);
    [btn setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = XGTwentyBoldFontSize;
    btn.layer.cornerRadius = 56/2;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)fifinshClick{
    if (!self.nameField.text.length) {
        return;
    }
    if (self.nameField.text.length > 20) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.tosat"]];
        return;
    }
    [self showHUD];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (self.isFromReg && self.name) {
        [parm setObject:self.name forKey:@"nickName"];
    }
    [parm setObject:self.nameField.text.length > 20? [self.nameField.text substringToIndex:20] :self.nameField.text forKey:@"selfIntro"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
            NoticeUserInfoModel *infoM = [NoticeSaveModel getUserInfo];
            infoM.self_intro = self.nameField.text.length > 20? [self.nameField.text substringToIndex:20] :self.nameField.text;
            [NoticeSaveModel saveUserInfo:infoM];
            if (self.isFromReg) {
                //执行引导页
                [self.navigationController popToRootViewControllerAnimated:NO];
                //上传成功，执行引导页
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
                return;
            }
            [UIView animateWithDuration:1 animations:^{
                [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.changesus"]];
            } completion:^(BOOL finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    if (height > 100) {
        height = 100;
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = [NoticeTools getLocalStrWith:@"intro.texipnpla"];
    }
    
    if (textView.text.length > 20) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/20",textView.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
        
    }else{
        NSString *allStr = [NSString stringWithFormat:@"%lu/20",textView.text.length];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"20" beginSize:allStr.length-2];
    }
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}


@end
