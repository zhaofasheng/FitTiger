//
//  NoticeIntuputTextController.m
//  NoticeXi
//
//  Created by li lei on 2020/7/17.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeIntuputTextController.h"
#import "NoticeConnectPhoneController.h"
@interface NoticeIntuputTextController ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, assign) CGFloat keyBordHeight;
@property (nonatomic, strong) UILabel *titlel;
@end

@implementation NoticeIntuputTextController
{
    UILabel *_plaL;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = EIGHTEENTEXTFONTSIZE;
    label.textColor = self.isRegier?[UIColor colorWithHexString:@"#333333"]: GetColorWithName(VMainTextColor);
    label.text = self.navigationItem.title;
    [self.view addSubview:label];
    if (self.isRegier) {
        label.text = @"最开心的一件事";
    }
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, STATUS_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:[UIImage imageNamed:[NoticeTools isWhiteTheme]?@"btn_nav_back":@"btn_nav_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-40-15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-25)/2,40, 25);
    [btn setTitle:[NoticeTools getLocalStrWith:@"chat.sendTextTitle"] forState:UIControlStateNormal];
    [btn setTitleColor:[NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#3E3E4A"] forState:UIControlStateNormal];
    btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [btn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _sendBtn = btn;
    
    if (self.isRegier) {
        self.view.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 25/2;
        btn.layer.masksToBounds = YES;
        btn.frame = CGRectMake(DR_SCREEN_WIDTH-15-60, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-25)/2,60, 25);
        [btn setTitle:[NoticeTools getLocalStrWith:@"groupfm.finish"] forState:UIControlStateNormal];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [btn setTitleColor:[UIColor colorWithHexString:@"#B2B2B2"] forState:UIControlStateNormal];
        btn.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#DDDDDD"];
    }

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor =self.isRegier?[UIColor colorWithHexString:@"#EDEDED"]: GetColorWithName(VlineColor);
    [self.view addSubview:line];
    
    self.plaStr =self.isRegier?@"告诉我最近最让你开心的一件事吧!": [NoticeTools getLocalStrWith:@"chat.sendTextPla"];
    
    _backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(line.frame), DR_SCREEN_WIDTH, 100+(DR_SCREEN_WIDTH-30-10)/3)];
    _backView.backgroundColor =self.isRegier?[UIColor whiteColor]: GetColorWithName(VBackColor);
    [self.view addSubview:_backView];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, 260, 14)];
    _plaL.text = self.plaStr;
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor =self.isRegier?[UIColor colorWithHexString:@"#b2b2b2"] :[NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#3e3e4a"];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15,5, DR_SCREEN_WIDTH-30,45)];
    _textView.font = SIXTEENTEXTFONTSIZE;
    _textView.clearsOnInsertion = YES;
    _textView.backgroundColor = self.isRegier?[UIColor whiteColor]: GetColorWithName(VBackColor);
    _textView.delegate = self;
    _textView.textColor = self.isRegier?[UIColor colorWithHexString:@"#333333"]: GetColorWithName(VMainTextColor);
    [_textView becomeFirstResponder];
    _textView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    [_backView addSubview:_textView];
    [_backView addSubview:_plaL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (keyboardF.size.height>200) {
        self.keyBordHeight = keyboardF.size.height;
        [self refreshHeight];
    }
}
-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyboardF.size.height>200) {
        self.keyBordHeight = keyboardF.size.height;
        [self refreshHeight];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 3000) {
        textView.text = [textView.text substringToIndex:3000];
        [self showToastWithText:[NoticeTools getLocalStrWith:@"chat.limitText"]];
    }
    float height;
    if ([text isEqual:@""]) {
        if (![textView.text isEqualToString:@""]) {
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
        }else{
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    self.textHeight = height;
    [self refreshHeight];
    return YES;
}

- (void)refreshHeight{

    _backView.frame = CGRectMake(0,1+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.keyBordHeight-5-NAVIGATION_BAR_HEIGHT);
    self.textView.frame = CGRectMake(15,5, DR_SCREEN_WIDTH-30,self.textHeight>45?self.textHeight:45);
    
    if (self.textHeight >= (_backView.frame.size.height-5)) {
        _backView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, self.textHeight);
        [_backView setContentOffset:CGPointMake(0, (self.textHeight-(_backView.frame.size.height-5)))];
    }else{
        _backView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, 0);
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length) {
        _plaL.text = @"";
        [_sendBtn setTitleColor:GetColorWithName(VMainThumeColor) forState:UIControlStateNormal];
        if (self.isRegier) {
            [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _sendBtn.backgroundColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        }
    }else{
        _plaL.text = self.plaStr;
        [_sendBtn setTitleColor:[NoticeTools getWhiteColor:@"#3E3E4A" NightColor:@"#666666"] forState:UIControlStateNormal];
        if (self.isRegier) {
            [_sendBtn setTitleColor:[NoticeTools getWhiteColor:@"#B2B2B2" NightColor:@"#B2B2B2"] forState:UIControlStateNormal];
            _sendBtn.backgroundColor = [NoticeTools getWhiteColor:@"#DDDDDD" NightColor:@"#DDDDDD"];
        }
    }
}

- (float)heightForTextView:(UITextView *)textView WithText:(NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [_textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)backClick{
    [_textView resignFirstResponder];
    if (_textView.text.length) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"xl.suregp"] message:[NoticeTools getLocalStrWith:@"xl.nosavenr"] sureBtn:[NoticeTools getLocalStrWith:@"xl.suresure"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [self->_textView becomeFirstResponder];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)sendClick{
    if (!self.textView.text.length) {
        return;
    }
    if (self.textView.text.length > 3000) {
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"chat.overLimit"]];
        return;
    }
    if (self.isRegier) {
        NoticeConnectPhoneController *ctl = [[NoticeConnectPhoneController alloc] init];
        ctl.phone = self.phone;
        ctl.isRemember = !self.isRemember;
        ctl.isThird = self.isThird;
        ctl.areaModel = self.areaModel;
        ctl.regModel = self.regModel;
        ctl.text = self.textView.text;
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendTextDelegate:)]) {
        [self.delegate sendTextDelegate:self.textView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
