

#import "LHTopTextView.h"

@interface LHTopTextView()<UITextFieldDelegate>{
    CGFloat _space;
    NSString *_text;
    CGFloat _margin;
}
@end

@implementation LHTopTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        //设置两个控件之间的间距
        _space=10.0;
        //设置与边框的间距
        _margin=15.0;
        
        //设置圆角
        self.layer.cornerRadius=10;
        [self.layer setMasksToBounds:YES];
        
        //设置背景色
        self.backgroundColor = GetColorWithName(VBackColor);
        
        //输入框
        UITextField *textView=[[UITextField alloc]initWithFrame:CGRectMake(_margin,15, frame.size.width-2*_margin, 45)];
        textView.backgroundColor=GetColorWithName(VBigLineColor);
        self.textView=textView;
        textView.font=[UIFont systemFontOfSize:13];
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
        [textView becomeFirstResponder];
        textView.placeholder=@"请输入预设回复语";
        textView.textColor=GetColorWithName(VMainTextColor);
        textView.returnKeyType=UIReturnKeyDone;
        textView.delegate=self;
        textView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        [self addSubview:textView];
        
        //seperateLine
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+15, frame.size.width, 1)];
        lineView.backgroundColor = GetColorWithName(VlineColor);
        [self addSubview:lineView];
        
        //取消按钮
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(0, frame.size.height-43, frame.size.width/2,43);
        [cancelBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        self.cancelBtn=cancelBtn;
        self.cancelBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        //按钮分隔线
        UIView *seperateLine=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMinY(cancelBtn.frame), 1, CGRectGetHeight(cancelBtn.frame))];
        seperateLine.backgroundColor=GetColorWithName(VlineColor);
        [self addSubview:seperateLine];
    
        //确定按钮
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame=CGRectMake(CGRectGetMaxX(seperateLine.frame), CGRectGetMinY(cancelBtn.frame), CGRectGetWidth(cancelBtn.frame), CGRectGetHeight(cancelBtn.frame));
        self.submitBtn=sureBtn;
        [sureBtn setTitle:[NoticeTools getLocalStrWith:@"main.sure"] forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor colorWithHexString:WHITEMAINCOLOR] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self addSubview:sureBtn];
        
    }
    return self;
}

#pragma mark -处理确定点击事件

- (void)setIsAdd:(BOOL)isAdd{
    _isAdd = isAdd;
    if (isAdd) {
        [self.submitBtn setTitle:@"录制语音" forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"上传图片" forState:UIControlStateNormal];
        [self.submitBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeOneCI:)
        name:UITextFieldTextDidChangeNotification
        object:self.textView];
    }

}
-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    if (textfield.text.length) {
        [self.submitBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    }else{
        [self.submitBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:GetColorWithName(VDarkTextColor) forState:UIControlStateNormal];
    }
}
-(void)clickSubmit:(id)sender{
    [self.textView resignFirstResponder];
    if(self.textView.text.length>0){
        if([self.textView.textColor isEqual:[UIColor redColor]]||[self.textView.textColor isEqual:[UIColor whiteColor]]){
            [self.textView becomeFirstResponder];
        }else{
            if(self.submitBlock){
                self.submitBlock(self.textView.text);
            }
        }
    }else{
        self.textView.placeholder=@"您输入的内容不能为空，请您输入内容";
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}


#pragma mark -处理取消点击事件

-(void)clickCancel:(id)sender{
    [self.textView resignFirstResponder];
    if (self.isAdd) {
        if(self.textView.text.length>0){
            if([self.textView.textColor isEqual:[UIColor redColor]]||[self.textView.textColor isEqual:[UIColor whiteColor]]){
                [self.textView becomeFirstResponder];
            }else{
                if(self.submitImageBlock){
                    self.submitImageBlock(self.textView.text);
                }
            }
        }else{
            self.textView.placeholder=@"您输入的内容不能为空，请您输入内容";
        }
        return;
    }
    
    if(self.closeBlock){
        self.closeBlock();
    }
}


@end
