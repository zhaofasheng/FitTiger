//
//  NoticeDanMuInputView.m
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuInputView.h"

@implementation NoticeDanMuInputView

{
    CGFloat kebordHeight;
    UILabel *_plaL;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#292B33"] colorWithAlphaComponent:0];

        self.userInteractionEnabled = YES;
        
        self.isTop = NO;
        self.color = @"#FFFFFF";
        
        self.choiceIng = NO;

        UIImageView *imageChoiceView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-25,(50-25)/2,25, 25)];
        imageChoiceView.image = UIImageNamed(@"Image_sentextdanmu");
        imageChoiceView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sentText)];
        [imageChoiceView addGestureRecognizer:tap];
        [self addSubview:imageChoiceView];
        self.sendImageView = imageChoiceView;

        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 7, DR_SCREEN_WIDTH-110+15+25, 36)];
        backV.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
        backV.layer.cornerRadius = 6;
        backV.layer.masksToBounds = YES;
        [self addSubview:backV];
        self.backView = backV;
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(backV.frame.size.width-GET_STRWIDTH(@"00:000", 12, 36)-3, 0, GET_STRWIDTH(@"00:000", 12, 36), 36)];
        self.timeL.font = TWOTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.timeL.hidden = YES;
        self.timeL.text = @"00:00";
        [backV addSubview:self.timeL];
        
        self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(15, 7, DR_SCREEN_WIDTH-110+15+25-GET_STRWIDTH(@"00:000", 12, 36)-3, 36)];
        self.contentView.tintColor = GetColorWithName(VMainThumeColor);
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0];
        self.contentView.delegate = self;
        self.contentView.font = FIFTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentView.layer.cornerRadius = 6;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.returnKeyType = UIReturnKeyDone;
        [self addSubview:self.contentView];
        self.contentView.keyboardAppearance = UIKeyboardAppearanceDark;
        
        
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(67,7, 200, 36)];
        _plaL.text = [NoticeTools getLocalStrWith:@"bk.saysay" ];
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self addSubview:_plaL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{

    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.frame.size.height, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = keyboardF.size.height;
    self.emtionBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.sendImageView.frame =  CGRectMake(DR_SCREEN_WIDTH-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.voiceBtn.frame = CGRectMake(15,self.frame.size.height- (50-25)/2-25, 25, 25);

    NSArray *ws = [[UIApplication sharedApplication] windows];
    for(UIView *w in ws){
        NSArray *vs = [w subviews];
        for(UIView *v in vs){
            if([[NSString stringWithUTF8String:object_getClassName(v)] isEqualToString:@"UIPeripheralHostView"]){
                v.backgroundColor = [UIColor redColor];
                
            }
        }
    }
    
    self.isUpKeyBorder = YES;
    [self refreshUI];
}

- (void)refreshUI{
    if (self.choiceIng) {
        self.isUpKeyBorder = YES;
    }
    self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:self.isUpKeyBorder?1:0];
    self.backView.backgroundColor = self.isUpKeyBorder?[UIColor whiteColor]:[[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.1];
    [self.voiceBtn setBackgroundImage:UIImageNamed(self.isUpKeyBorder?@"Image_choiceDanmmup": @"Image_choiceDanmmu") forState:UIControlStateNormal];
    self.sendImageView.image = UIImageNamed(self.isUpKeyBorder?@"Image_sentextdanmup": @"Image_sentextdanmu");
}

- (void)keyboardDiddisss{
    
    self.isUpKeyBorder = NO;
    [self refreshUI];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = 0;
    self.emtionBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.sendImageView.frame =  CGRectMake(DR_SCREEN_WIDTH-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.voiceBtn.frame = CGRectMake(15,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.hidden = YES;
    self.timeL.hidden = YES;
}

- (void)keyboardDidShow{
    if (!self.isNoneedReGetTime) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyboderDidShow)]) {
            [self.delegate keyboderDidShow];
        }
    }
    if (self.isNoneedReGetTime) {
        self.isNoneedReGetTime = NO;
    }
    self.choiceIng = NO;
    self.timeL.hidden = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceType:)]) {
        [self.delegate choiceType:self.choiceIng];
    }
    
    [self.voiceBtn setBackgroundImage:UIImageNamed(self.choiceIng?@"Image_choiceDanmmuy": self.isUpKeyBorder?@"Image_choiceDanmmup": @"Image_choiceDanmmu") forState:UIControlStateNormal];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.contentView resignFirstResponder];

        return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length) {
        _plaL.text = @"";
        self.sendImageView.image = UIImageNamed(@"Image_suresendDanmu");
    }else{
        self.sendImageView.image = UIImageNamed(self.isUpKeyBorder?@"Image_sentextdanmup": @"Image_sentextdanmu");
        _plaL.text = [NoticeTools getLocalStrWith:@"bk.saysay" ];
    }
    CGRect frame = textView.frame;
    if (textView.text.length > 20) {
        textView.text = [textView.text substringToIndex:20];
    }
    float height;
    height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@",textView.text]];
    if (height > 100) {
        height = 100;
    }
    if (height <= 35) {
        height = 36;
    }
    frame.size.height = height;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(14+height)-self->kebordHeight, DR_SCREEN_WIDTH,14+height);

        textView.frame = frame;
        self.sendImageView.frame =  CGRectMake(DR_SCREEN_WIDTH-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
        self.backView.frame = CGRectMake(15, 7, DR_SCREEN_WIDTH-110+15+25, height);
    } completion:nil];
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height+(size.size.height>36?10:0)+5;
    return textHeight;
}

- (void)sendImage{

    [self.contentView resignFirstResponder];

}

- (void)sentText{
    if (!self.contentView.text.length) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendContent:color:isTop:)]) {
        [self.delegate sendContent:self.contentView.text color:self.color isTop:self.isTop];
    }
    self.contentView.text = @"";
    [self.contentView resignFirstResponder];

}

@end
