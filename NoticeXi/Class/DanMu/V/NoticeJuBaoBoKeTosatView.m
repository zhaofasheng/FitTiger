//
//  NoticeJuBaoBoKeTosatView.m
//  NoticeXi
//
//  Created by li lei on 2022/9/26.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeJuBaoBoKeTosatView.h"

@implementation NoticeJuBaoBoKeTosatView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

        self.userInteractionEnabled = YES;

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,270)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        self.backView.layer.cornerRadius = 20;
        self.backView.layer.masksToBounds = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 45)];
        label.text = [NoticeTools chinese:@"填写举报理由" english:@"Description" japan:@"説明"];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        self.titleL = label;
        
        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(20,45, DR_SCREEN_WIDTH-40,110)];
        self.contentBackView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentBackView.layer.cornerRadius = 4;
        self.contentBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.contentBackView];
        self.contentBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regFirst)];
        [self.contentBackView addGestureRecognizer:tap];
        
        self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(10,5, DR_SCREEN_WIDTH-40-20, 36-16)];
        self.contentView.tintColor = [UIColor colorWithHexString:@"#0099E6"];
        self.contentView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.contentView.backgroundColor = [self.contentBackView.backgroundColor colorWithAlphaComponent:0];
        self.contentView.delegate = self;
        self.contentView.font = FOURTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.bounces = NO;
        self.contentView.clearsOnInsertion = YES;
        [self.contentBackView addSubview:self.contentView];
        [self.contentView becomeFirstResponder];
        
        self.plaStr = [NoticeTools getLocalStrWith:@"chat.sendTextPla"];
                
        self.plaStr = [NoticeTools chinese:@"为帮助审核人员更快处理，请详细填写" english:@"Clear description would help!" japan:@"分かりやすい説明で助かります！"];
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(10,5,DR_SCREEN_WIDTH-20-40, 36-16)];
        _plaL.text = self.plaStr;
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self.contentBackView addSubview:_plaL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(self.contentBackView.frame)+10,100, 17)];
        numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        numL.font = TWOTEXTFONTSIZE;
        NSString *allStr = @"0/100";
        numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:@"0" beginSize:0];
        [self.backView addSubview:numL];
        self.numL = numL;
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(numL.frame)+20,DR_SCREEN_WIDTH-40,40)];
        sendBtn.layer.cornerRadius = 20;
        sendBtn.layer.masksToBounds = YES;
        sendBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [sendBtn setTitle:[NoticeTools getLocalStrWith:@"group.submit"] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:sendBtn];
        self.sendButton = sendBtn;
    
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50,0, 45, 45)];
        [cancelBtn setImage:UIImageNamed(@"Image_closechange") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:cancelBtn];
    }
    return self;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

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
       
        
        self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else{
        _plaL.text = self.plaStr;
        self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }
    
    if (textView.text.length > 100) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/100",textView.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
        
    }else{
        NSString *allStr = [NSString stringWithFormat:@"%lu/100",textView.text.length];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:[NSString stringWithFormat:@"%ld",textView.text.length] beginSize:0];
    }
}

- (float)heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 0.0;
    return textHeight;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.backView.frame.size.height+20, DR_SCREEN_WIDTH, self.backView.frame.size.height);
   
}

- (void)keyboardDiddisss{

    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.backView.frame.size.height);
}

- (void)keyboardDidHide{
    [self removeFromSuperview];
}

- (void)sendClick{
    if (self.contentView.text.length) {
        if (self.jubaoBlock) {
            self.jubaoBlock(self.contentView.text);
        }
        [self cancelClick];
        
    }
}

- (void)regFirst{
    [self.contentView becomeFirstResponder];
}

- (void)showView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self.contentView becomeFirstResponder];
}

- (void)cancelClick{
    [self.contentView resignFirstResponder];

}
@end
