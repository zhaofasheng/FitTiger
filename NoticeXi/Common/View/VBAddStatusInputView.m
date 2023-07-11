//
//  VBAddStatusInputView.m
//  VoiceBook
//
//  Created by li lei on 2021/3/21.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "VBAddStatusInputView.h"
#import "DDHAttributedMode.h"
@implementation VBAddStatusInputView

{
    CGFloat kebordHeight;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

        self.userInteractionEnabled = YES;

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,300)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        
        UIView *radView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, DR_SCREEN_WIDTH, 20)];
        radView.layer.cornerRadius = 10;
        radView.layer.masksToBounds = YES;
        [self.backView addSubview:radView];
        radView.backgroundColor = self.backView.backgroundColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, DR_SCREEN_WIDTH-20, 40)];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:label];
        self.titleL = label;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,50,50)];
        [self.backView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton = cancelBtn;
        [cancelBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-55,0,50,50)];
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:sendBtn];
        self.sendButton = sendBtn;
        
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, DR_SCREEN_WIDTH-115, 50)];
        self.statusL.font = TWOTEXTFONTSIZE;
        self.statusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:self.statusL];
        self.statusL.hidden = YES;
        
        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 90, DR_SCREEN_WIDTH-40, self.backView.frame.size.height-100)];
        self.contentBackView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentBackView.layer.cornerRadius = 10;
        self.contentBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.contentBackView];
        self.contentBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regFirst)];
        [self.contentBackView addGestureRecognizer:tap];
        
        self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(15,5, DR_SCREEN_WIDTH-40-30, 36-16)];
        self.contentView.tintColor = [UIColor colorWithHexString:@"#0099E6"];
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
        
        self.num = 3000;
        
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(20,8,DR_SCREEN_WIDTH-30-40, 36-16)];
        _plaL.text = self.plaStr;
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self.contentBackView addSubview:_plaL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)setSaveKey:(NSString *)saveKey{
    _saveKey = saveKey;
    if(saveKey){
        self.statusL.hidden = NO;
        NSString *saveContent = [NoticeComTools getInputWithKey:saveKey];
        if(saveContent && saveContent.length){
            self.contentView.text = saveContent;
            [self textViewDidChangeSelection:self.contentView];
        }
    }
}

- (void)setIsReply:(BOOL)isReply{
    _isReply = isReply;
    if (isReply) {
        [self.cancelButton setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.sendButton setImage:UIImageNamed(self.contentView.text.length? @"Image_sendtextbtn":@"Image_sendtextbtntext") forState:UIControlStateNormal];
    }else{

        [self.sendButton setTitle:[NoticeTools getLocalStrWith:@"groupfm.finish"] forState:UIControlStateNormal];
        self.sendButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    }
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.backView.frame.size.height, DR_SCREEN_WIDTH, self.backView.frame.size.height);
    kebordHeight = keyboardF.size.height;
   
}

- (void)keyboardDiddisss{

    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.backView.frame.size.height);
    kebordHeight = 0;
   
}

- (void)setPlaStr:(NSString *)plaStr{
    _plaStr = plaStr;
    _plaL.text = self.contentView.text.length?@"": _plaStr;
}

- (void)keyboardDidHide{
    [self removeFromSuperview];
}

- (void)textViewDidChange:(UITextView *)textView{
    //获取高亮部分
    UITextPosition * position = [textView positionFromPosition:textView.markedTextRange.start offset:0];
    if(position){
        if (self.saveKey) {
            self.statusL.text = @"内容保存中...";
        }
    }else{
        if(self.saveKey){
            [NoticeComTools saveInput:textView.text saveKey:self.saveKey];
        }
        self.statusL.text = @"内容已保存";
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length) {
        _plaL.text = @"";
        [_sendButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
    }else{
        [_sendButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        _plaL.text = self.plaStr;
    }
    if (self.isReply) {
        [self.sendButton setImage:UIImageNamed(self.contentView.text.length? @"Image_sendtextbtn":@"Image_sendtextbtntext") forState:UIControlStateNormal];
    }
    NSInteger num = self.num;
    if (textView.text.length > self.num) {
        textView.text = [textView.text substringToIndex:num];
    }
    float height;
    height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@",textView.text]];
    if (height > (self.backView.frame.size.height-100)) {
        height = self.backView.frame.size.height-100;
    }
    if (height <= 22) {
        height = 20;
    }
   
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.frame = CGRectMake(15,5, DR_SCREEN_WIDTH-40-30, height);

    } completion:nil];
}

- (float)heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height+5;
    return textHeight;
}

- (void)sendClick{
    if (self.contentView.text.length >= 3000) {
        self.titleL.text = @"不能超过三千个字哦~";
        return;
    }
    [self.contentView resignFirstResponder];
    [self removeFromSuperview];
    if(self.saveKey){
        [NoticeComTools removeWithKey:self.saveKey];
    }
    
    if (self.contentView.text.length && self.contentView.text.length < self.num) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendTextDelegate:)]) {
            [self.delegate sendTextDelegate:self.contentView.text];
        }
    }
}

- (void)cancelClick{
    [self.contentView resignFirstResponder];
}

- (void)regFirst{
    [self.contentView becomeFirstResponder];
}
@end
