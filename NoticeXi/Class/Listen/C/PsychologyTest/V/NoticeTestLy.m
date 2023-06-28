//
//  NoticeTestLy.m
//  NoticeXi
//
//  Created by li lei on 2019/2/1.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTestLy.h"

@implementation NoticeTestLy
{
    CGFloat kH;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.userInteractionEnabled = YES;
        
        self.textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-45-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, 45)];
        self.textBackView.backgroundColor = GetColorWithName(VBackColor);
        [self addSubview:self.textBackView];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-73-50, 10)];
        lineV.backgroundColor = GetColorWithName(VlineColor);
        [self.textBackView addSubview:lineV];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0,7, DR_SCREEN_WIDTH-73-50, 38)];
        self.textView.backgroundColor = GetColorWithName(VBackColor);
        self.textView.font = THRETEENTEXTFONTSIZE;
        self.textView.backgroundColor = GetColorWithName(VlineColor);
        self.textView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.textColor = GetColorWithName(VMainTextColor);
        [self.textBackView addSubview:self.textView];
        
        _numL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textView.frame), 0, 50,45)];
        _numL.textColor = GetColorWithName(VDarkTextColor);
        _numL.font = ELEVENTEXTFONTSIZE;
        _numL.textAlignment = NSTextAlignmentCenter;
        _numL.text = @"0/100";
        _numL.backgroundColor = GetColorWithName(VlineColor);
        [self.textBackView addSubview:_numL];
        
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_numL.frame)+13, (45-29)/2, 47, 29)];
        [_sendBtn setTitle:[NoticeTools isSimpleLau] ? [NoticeTools getLocalStrWith:@"read.send"]:@"發送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:GetColorWithName(VMainThumeWhiteColor) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
        _sendBtn.backgroundColor = GetColorWithName(VDarkTextColor);
        _sendBtn.layer.cornerRadius = 5;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.enabled = NO;
        [self.textBackView addSubview:_sendBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissInput)];
        self.dissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.textBackView.frame.size.height)];
        self.dissView.userInteractionEnabled = YES;
        [self addSubview:self.dissView];
        
        [self.dissView addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //        NSLog(@"%@",NSStyringFromCGRect(keyboardF));
    CGFloat keyboardY = keyboardF.origin.y;
   [self dealKeyBoardWithKeyboardH:keyboardF.size.height keyboardY:keyboardY duration:duration];
    
}
-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardY = keyboardF.origin.y;
    [self dealKeyBoardWithKeyboardH:keyboardF.size.height keyboardY:keyboardY duration:duration];
}

#pragma mark---处理高度---
-(void)dealKeyBoardWithKeyboardH:(CGFloat)keyboardH keyboardY:(CGFloat)keyboardY duration:(CGFloat)duration{
    kH = keyboardH;
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        CGRect oldFrame = self.textBackView.frame;
        self.textBackView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-keyboardH-oldFrame.size.height, DR_SCREEN_WIDTH,oldFrame.size.height);
        self.dissView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.textBackView.frame.size.height-keyboardH);
        
        self.textView.frame = CGRectMake(0,7, DR_SCREEN_WIDTH-73-50,self.textBackView.frame.size.height);
        self->_numL.frame = CGRectMake(CGRectGetMaxX(self.textView.frame), 0, 50,self.textBackView.frame.size.height);
        self->_sendBtn.frame = CGRectMake(CGRectGetMaxX(self->_numL.frame)+13, (self.textBackView.frame.size.height-29)/2, 47, 29);
    }];
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                        context:nil];
    float textHeight = size.size.height+32;
    return textHeight;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    self.sendBtn.enabled = textView.text.length ? YES : NO;
    self.sendBtn.backgroundColor = textView.text.length ? GetColorWithName(VMainThumeColor) : GetColorWithName(VDarkTextColor);
    _numL.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(liuyan)]) {
            [self.delegate liuyan];
        }
        [self dissInput];
    }

 
    CGRect frame = self.textBackView.frame;
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
    
    if (height > 35) {
        frame.size.height = height;
        frame.origin.y = DR_SCREEN_HEIGHT-height-kH;
        [UIView animateWithDuration:0.5 animations:^{
            
            self.textBackView.frame = frame;
            self.textView.frame = CGRectMake(0,7, DR_SCREEN_WIDTH-73-50,frame.size.height);
            self.dissView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.frame.size.height-self.textBackView.frame.size.height-self->kH);
            self->_numL.frame = CGRectMake(CGRectGetMaxX(self.textView.frame), 0, 50,frame.size.height);
            self->_sendBtn.frame = CGRectMake(CGRectGetMaxX(self->_numL.frame)+13, (frame.size.height-29)/2, 47, 29);
            
        } completion:nil];
    }
 
    
    return YES;
}
- (void)keyboardDiddisss{
    [self dissInput];
}


- (void)dissInput{
    [self removeFromSuperview];
    [self.textView resignFirstResponder];
}
@end
