//
//  NoticeChangeNickNameView.m
//  NoticeXi
//
//  Created by li lei on 2022/8/4.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeNickNameView.h"

@implementation NoticeChangeNickNameView

{
    CGFloat kebordHeight;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

        self.userInteractionEnabled = YES;

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,265)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        self.backView.layer.cornerRadius = 20;
        self.backView.layer.masksToBounds = YES;

        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        label.text = [NoticeTools getLocalStrWith:@"setmarkname"];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        self.titleL = label;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50,0,50,50)];
        [self.backView addSubview:cancelBtn];
        [cancelBtn setImage:UIImageNamed(@"Image_closechange") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton = cancelBtn;
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-240)/2,165,240,50)];
        sendBtn.layer.cornerRadius = 25;
        sendBtn.layer.masksToBounds = YES;
        sendBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [sendBtn setTitle:[NoticeTools getLocalStrWith:@"groupfm.finish"] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:sendBtn];
        self.sendButton = sendBtn;
        
        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 65, DR_SCREEN_WIDTH-40, 50)];
        self.contentBackView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentBackView.layer.cornerRadius = 8;
        self.contentBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.contentBackView];
        self.contentBackView.userInteractionEnabled = YES;

        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,65,  50)];
        label1.text = [NoticeTools getLocalType]>0?[NoticeTools getLocalStrWith:@"setmarkname"]: @"备注";
        label1.font = FIFTHTEENTEXTFONTSIZE;
        label1.textColor = [UIColor colorWithHexString:@"#25262E"];
        label1.textAlignment = NSTextAlignmentCenter;
        [self.contentBackView addSubview:label1];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(64, 10, 1, 30)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E1E4F0"];
        [self.contentBackView addSubview:line];
        
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(70,0,DR_SCREEN_WIDTH-40-70,50)];
        self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"nomoreten"] attributes:@{NSFontAttributeName:XGEightBoldFontSize,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
        [self.contentBackView addSubview:self.nameField];
        self.nameField.font = FIFTHTEENTEXTFONTSIZE;
        self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(85,CGRectGetMaxY(self.contentBackView.frame)+5,200, 25)];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        [self.backView addSubview:self.numL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.backView.frame.size.height+20, DR_SCREEN_WIDTH, self.backView.frame.size.height);
    kebordHeight = keyboardF.size.height;
   
}

- (void)keyboardDiddisss{

    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.backView.frame.size.height);
    kebordHeight = 0;
   
}

- (void)keyboardDidHide{
    [self removeFromSuperview];
}

- (void)cancelClick{
    [self.nameField resignFirstResponder];
}

- (void)sendClick{
    if (self.sendBlock) {
        self.sendBlock(self.nameField.text);
        [self cancelClick];
    }
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (_field.text.length > 10) {
        self.numL.text = [NoticeTools getLocalStrWith:@"nomoreten"];
    }else{
        self.numL.text = @"";
    }
}
@end
