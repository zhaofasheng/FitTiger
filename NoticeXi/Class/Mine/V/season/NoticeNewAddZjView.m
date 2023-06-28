//
//  NoticeNewAddZjView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/21.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewAddZjView.h"

@implementation NoticeNewAddZjView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

        self.userInteractionEnabled = YES;

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,173)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        
        UIView *radView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, DR_SCREEN_WIDTH, 20)];
        radView.layer.cornerRadius = 10;
        radView.layer.masksToBounds = YES;
        [self.backView addSubview:radView];
        radView.backgroundColor = self.backView.backgroundColor;
                
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        label.text = [NoticeTools getLocalStrWith:@"zj.creatnewzj"];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        self.titleL = label;
        

        UILabel *cancelL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, 50)];
        cancelL.userInteractionEnabled = YES;
        cancelL.font = FOURTHTEENTEXTFONTSIZE;
        cancelL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        cancelL.text = [NoticeTools getLocalStrWith:@"main.cancel"];
        UITapGestureRecognizer *cantap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [cancelL addGestureRecognizer:cantap];
        [self.backView addSubview:cancelL];
   
        self.sendButton = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-50, 0, 50, 50)];
        self.sendButton.text = [NoticeTools getLocalStrWith:@"groupfm.finish"];
        self.sendButton.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.sendButton.font = FOURTHTEENTEXTFONTSIZE;
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.textAlignment = NSTextAlignmentRight;
        [self.backView addSubview:self.sendButton];
        UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendClick)];
        [self.sendButton addGestureRecognizer:sendTap];
        
        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(20,70, DR_SCREEN_WIDTH-40, 48)];
        self.contentBackView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentBackView.layer.cornerRadius = 8;
        self.contentBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.contentBackView];
        
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(10,0,self.contentBackView.frame.size.width-37-10, 48)];
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"zj.inputname"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
        self.nameField.tintColor = [UIColor colorWithHexString:@"#0099E6"];
        self.nameField.delegate = self;
        self.nameField.font =SIXTEENTEXTFONTSIZE;
        self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.nameField.layer.cornerRadius = 5;
        self.nameField.layer.masksToBounds = YES;
        [self.nameField becomeFirstResponder];
        self.nameField.backgroundColor = self.contentBackView.backgroundColor;
        [self.contentBackView addSubview:self.nameField];
        [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(self.contentBackView.frame.size.width-37, 0, 30, 48)];
        self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.numL.font = SIXTEENTEXTFONTSIZE;
        self.numL.textAlignment = NSTextAlignmentRight;
        [self.contentBackView addSubview:self.numL];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
        
        UIImageView *choiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.contentBackView.frame)+20, 16, 16)];
        [self.backView addSubview:choiceImage];
        self.choiceTapView = choiceImage;
        self.choiceTapView.image = UIImageNamed(@"Image_nochoice");
        
        UILabel *choiceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(choiceImage.frame)+8, CGRectGetMaxY(self.contentBackView.frame)+20,80, 16)];
        choiceL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        choiceL.font = TWOTEXTFONTSIZE;
        choiceL.text = [NoticeTools getLocalStrWith:@"zj.seetopen"];
        self.choiceL = choiceL;
        [self.backView addSubview:choiceL];
        
        UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentBackView.frame), 140, 40)];
        tapV.userInteractionEnabled = YES;
        tapV.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:tapV];
        UITapGestureRecognizer *choicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTap)];
        [tapV addGestureRecognizer:choicTap];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-120, choiceL.frame.origin.y, 120, 16)];
        self.markL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.markL.font = TWOTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentRight;
        self.markL.text = [NoticeTools getLocalStrWith:@"zj.limit"];
        self.markL.hidden = YES;
        [self.backView addSubview:self.markL];
    }
    return self;
}

- (void)setIsDiaZJ:(BOOL)isDiaZJ{
    _isDiaZJ = isDiaZJ;
    if (isDiaZJ) {
        self.titleL.text = [NoticeTools getLocalStrWith:@"zj.neduihuazj"];
        self.choiceTapView.hidden = YES;
        self.choiceL.hidden = YES;
    }
}

- (void)openTap{
    self.isOpen = !self.isOpen;
    if (self.isOpen) {
        self.choiceTapView.image = UIImageNamed(@"Image_choiceadd_b");
    }else{
        self.choiceTapView.image = UIImageNamed(@"Image_nochoice");
    }
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.backView.frame.size.height, DR_SCREEN_WIDTH, self.backView.frame.size.height);

}

- (void)keyboardDiddisss{
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.backView.frame.size.height);
}

- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    self.numL.text = [NSString stringWithFormat:@"%ld",_field.text.length];
    self.markL.hidden = _field.text.length>20?NO:YES;
    self.sendButton.textColor = [UIColor colorWithHexString:_field.text.length?@"#0099E6":@"#A1A7B3"];
}

- (void)sendClick{
    if (self.nameField.text.length > 20) {
        return;
    }
    if (self.nameField.text.length && self.nameField.text.length <= 20) {
        if (self.addBlock) {
            self.addBlock(self.nameField.text, self.isOpen);
        }
        [self.nameField resignFirstResponder];
    }
}
    
- (void)cancelClick{
    [self.nameField resignFirstResponder];
}
    
- (void)keyboardDidHide{
    [self removeFromSuperview];
}

@end
