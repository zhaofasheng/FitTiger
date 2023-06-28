//
//  NoticeSendChatView.m
//  NoticeXi
//
//  Created by li lei on 2022/7/13.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendChatView.h"

@implementation NoticeSendChatView
{
    CGFloat kebordHeight;
    UILabel *_plaL;

}
- (instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(20, 5, DR_SCREEN_WIDTH-40, 40)];
        self.contentView.tintColor = GetColorWithName(VMainThumeColor);
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.delegate = self;
        self.contentView.font = FIFTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.returnKeyType = UIReturnKeySend;
        [self addSubview:self.contentView];
        
        NSArray *arr = @[@"Image_heiluy",@"Image_heiemo",@"Image_heiimg",@"Image_heipaiz"];
        CGFloat space = (DR_SCREEN_WIDTH-120-24*3)/3;
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60+(24+space)*i,CGRectGetMaxY(self.contentView.frame)+9, 24, 24)];
            [btn setImage:UIImageNamed(arr[i]) forState:UIControlStateNormal];
            [self addSubview:btn];
            if (i == 0) {
                self.sendBtn = btn;
            }else if (i == 1){
                self.emtionBtn = btn;
            }else if(i == 2){
                self.imgBtn = btn;
            }else if(i == 3){
                self.carmBtn = btn;
            }
        }
        
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(23,3, 200, 40)];
        _plaL.text = @"输入文字";
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self addSubview:_plaL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
 
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = keyboardF.size.height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshTableViewWithFrame: keyBordyHight:)]) {
        [self.delegate refreshTableViewWithFrame:self.frame keyBordyHight:kebordHeight];
    }
}

- (void)keyboardDiddisss{
    
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshTableViewWithHideFrame:)]) {
        [self.delegate refreshTableViewWithHideFrame:self.frame];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sentText];
        return NO;
    }

    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"输入文字";
    }
    CGRect frame = textView.frame;
    if (textView.text.length > 3000) {
        textView.text = [textView.text substringToIndex:3000];
    }
    float height;
    height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@",textView.text]];
    if (height > 100) {
        height = 100;
    }
    if (height <= 39) {
        height = 40;
    }
    frame.size.height = height;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(14+height+35)-self->kebordHeight, DR_SCREEN_WIDTH,14+height+35);

        textView.frame = frame;
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x,CGRectGetMaxY(self.contentView.frame)+9, 24, 24);
        self.emtionBtn.frame = CGRectMake(self.emtionBtn.frame.origin.x,CGRectGetMaxY(self.contentView.frame)+9, 24, 24);
        self.imgBtn.frame = CGRectMake(self.imgBtn.frame.origin.x,CGRectGetMaxY(self.contentView.frame)+9, 24, 24);
        self.carmBtn.frame = CGRectMake(self.carmBtn.frame.origin.x,CGRectGetMaxY(self.contentView.frame)+9, 24, 24);
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshTableViewWithFrame: keyBordyHight:)]) {
            [self.delegate refreshTableViewWithFrame:self.frame keyBordyHight:self->kebordHeight];
        }
    } completion:nil];
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height+(size.size.height>40?10:0)+5;
    return textHeight;
}


- (void)sentText{
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendContent:)]) {
        [self.delegate sendContent:self.contentView.text];
    }
    self.contentView.text = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshTableViewWithFrame: keyBordyHight:)]) {
        [self.delegate refreshTableViewWithFrame:self.frame keyBordyHight:kebordHeight];
    }
}


@end
