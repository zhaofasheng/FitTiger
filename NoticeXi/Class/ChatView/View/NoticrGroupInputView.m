//
//  NoticrGroupInputView.m
//  NoticeXi
//
//  Created by li lei on 2020/8/13.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticrGroupInputView.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "RACSignal.h"
#import "RACScheduler.h"
#import "RACSubscriber.h"
#import "YYKit.h"


@implementation NoticrGroupInputView
{
    CGFloat kebordHeight;
    UILabel *_plaL;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#292B33"];

        self.userInteractionEnabled = YES;
        
        self.voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, (50-25)/2, 25, 25)];
        [self.voiceBtn setBackgroundImage:UIImageNamed(@"Image_stluyy") forState:UIControlStateNormal];
        [self.voiceBtn addTarget:self action:@selector(sendVoiceClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.voiceBtn];
        
        UIImageView *imageChoiceView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-25,(50-25)/2,25, 25)];
        imageChoiceView.image = UIImageNamed(@"Image_groupchat_mnb");
        imageChoiceView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendImage)];
        [imageChoiceView addGestureRecognizer:tap];
        [self addSubview:imageChoiceView];
        self.sendImageView = imageChoiceView;
        
        self.emtionBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-25-15-25, (50-25)/2, 25, 25)];
        [self.emtionBtn setBackgroundImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        [self.emtionBtn addTarget:self action:@selector(emtionClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.emtionBtn];
        
        self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(55, 7, DR_SCREEN_WIDTH-150, 36)];
        self.contentView.tintColor = GetColorWithName(VMainThumeColor);
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentView.delegate = self;
        self.contentView.font = FIFTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#E1E2E6"];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.returnKeyType = UIReturnKeySend;
        [self addSubview:self.contentView];
        
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(67,7, 200, 36)];
        _plaL.text = @"输出越多，收获越多";
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:_plaL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];

    
    }
    return self;
}

- (void)sendVoiceClick{
    
    if ([self.delegate respondsToSelector:@selector(sendVoiceDelegate)]) {
        [self.delegate sendVoiceDelegate];
    }
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
 
    [self.emtionBtn setBackgroundImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.frame.size.height, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = keyboardF.size.height;
    self.emtionBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.sendImageView.frame =  CGRectMake(DR_SCREEN_WIDTH-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.voiceBtn.frame = CGRectMake(15,self.frame.size.height- (50-25)/2-25, 25, 25);
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshTableViewWithFrame: keyBordyHight:)]) {
        [self.delegate refreshTableViewWithFrame:self.frame keyBordyHight:kebordHeight];
    }
}

- (void)keyboardDiddisss{
    
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = 0;
    self.emtionBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.sendImageView.frame =  CGRectMake(DR_SCREEN_WIDTH-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
    self.voiceBtn.frame = CGRectMake(15,self.frame.size.height- (50-25)/2-25, 25, 25);
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


- (NSString *)getAtNameWith:(NSString *)name
{
    return [NSString stringWithFormat:@"%@ ",name];
}



- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"输出越多，收获越多";
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
    if (height <= 35) {
        height = 36;
    }
    frame.size.height = height;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(14+height)-self->kebordHeight, DR_SCREEN_WIDTH,14+height);

        textView.frame = frame;
        self.emtionBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-25-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
        self.sendImageView.frame =  CGRectMake(DR_SCREEN_WIDTH-15-25,self.frame.size.height- (50-25)/2-25, 25, 25);
        self.voiceBtn.frame = CGRectMake(15,self.frame.size.height- (50-25)/2-25, 25, 25);
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
    float textHeight = size.size.height+(size.size.height>36?10:0)+5;
    return textHeight;
}

- (void)sendImage{
 
    [self.contentView resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendImageDelegate)]) {
        [self.delegate sendImageDelegate];
    }
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

- (void)emtionClick{
 
    [self.contentView resignFirstResponder];
    [self.emtionBtn setBackgroundImage:UIImageNamed(@"Image_emtion_sb") forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendEmotionOpen)]) {
        [self.delegate sendEmotionOpen];
    }
}

@end
