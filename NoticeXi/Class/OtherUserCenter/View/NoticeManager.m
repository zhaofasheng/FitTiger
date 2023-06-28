//
//  NoticeManager.m
//  NoticeXi
//
//  Created by li lei on 2019/6/24.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManager.h"
#import "JJCPayCodeTextField.h"
@implementation NoticeManager
{
    UILabel *_typeL;
    JJCPayCodeTextField *_codeField;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
       
        self.tostView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-325)/2,50+NAVIGATION_BAR_HEIGHT,325, 217)];
        self.tostView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        self.tostView.layer.cornerRadius = 10;
        self.tostView.layer.masksToBounds = YES;
        [self addSubview:self.tostView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.tostView.frame.size.width, 13)];
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.font = THRETEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        _typeL = label;
        [self.tostView addSubview:label];

        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(label.frame)+15, self.tostView.frame.size.width, 13)];
        label1.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        label1.font = THRETEENTEXTFONTSIZE;
        label1.text = @"请输入管理员密码确认指令:";
        label1.textAlignment = NSTextAlignmentCenter;
        [self.tostView addSubview:label1];
        
        JJCPayCodeTextField *codeField = [[JJCPayCodeTextField alloc] initWithFrame:CGRectMake(34,CGRectGetMaxY(label1.frame)+25, self.tostView.frame.size.width-68, 35) TextFieldType:JJCPayCodeTextFieldTypeSpaceBorder];
        codeField.borderSpace = 9;
        codeField.borderColor = [UIColor clearColor];
        codeField.textFieldNum = 6;
        codeField.isShowTrueCode = YES;
        codeField.textField.keyboardType = UIKeyboardTypePhonePad;
        [codeField.textField setupToolbarToDismissRightButton];
        [self.tostView addSubview:codeField];
        _codeField = codeField;
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0,self.tostView.frame.size.height-53-14, self.tostView.frame.size.width, 14)];
        label2.textColor = [UIColor colorWithHexString:@"#FC5185"];
        label2.font = FOURTHTEENTEXTFONTSIZE;
        label2.textAlignment = NSTextAlignmentCenter;
        [self.tostView addSubview:label2];
        _markL = label2;
        
        NSArray *chnArr = @[[NoticeTools getLocalStrWith:@"sure.comgir"],[NoticeTools getLocalStrWith:@"main.cancel"]];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(13.5+149*i, self.tostView.frame.size.height-53,149,53)];
            btn.titleLabel.font = THRETEENTEXTFONTSIZE;
            if (i == 0) {
                [btn setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
            }
            [btn setTitle:chnArr[i] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(sureOrCancelClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tostView addSubview:btn];
        }
    }
    return self;
}

- (void)setType:(NSString *)type{
    _type = type;
    _typeL.text = [NSString stringWithFormat:@"当前操作：%@",type];
}

- (void)sureOrCancelClick:(UIButton *)button{
    if (button.tag == 0) {
        if (_codeField.payCodeString.length == 6) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(sureManagerClick:)]) {
                [self.delegate sureManagerClick:_codeField.payCodeString];
            }
        }
    }else{
        [self removeFromSuperview];
    }
}

- (void)show{
    self.markL.text = @"";
    [_codeField clearKeyCode];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.tostView.layer.position = self.tostView.center;
    self.tostView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tostView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
@end
