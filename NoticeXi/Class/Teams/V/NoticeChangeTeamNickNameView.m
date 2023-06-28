//
//  NoticeChangeTeamNickNameView.m
//  NoticeXi
//
//  Created by li lei on 2023/6/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeTeamNickNameView.h"
#import "UIView+CLSetRect.h"
@implementation NoticeChangeTeamNickNameView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-325)/2,NAVIGATION_BAR_HEIGHT, 325, 295)];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setAllCorner:20];
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(30, 113, 256, 56)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [backV setAllCorner:28];
        [self.contentView addSubview:backV];
        
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(10,0, 256-40-10, 56)];
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置聊天昵称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#8A8F99"]}];

        self.nameField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.nameField.delegate = self;
        self.nameField.font = FIFTHTEENTEXTFONTSIZE;
        self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.nameField becomeFirstResponder];
        [backV addSubview:self.nameField];

        self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.nameField.leftViewMode = UITextFieldViewModeAlways;
        [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(225,0,40, 56)];
        self.numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.text = @"0/10";
        [backV addSubview:self.numL];

        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(backV.frame)+5,256, 17)];
        self.markL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.markL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.markL];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,40,325, 33)];
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.font = XGTwentyTwoBoldFontSize;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"欢迎加入社团";
        [self.contentView addSubview:titleL];
        self.titleL = titleL;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(30,self.contentView.frame.size.height-40-56, 264, 56)];
        [cancelBtn setTitle:@"进入聊天" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [cancelBtn setAllCorner:28];
        cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        
        
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-15-24, 15, 24, 24)];
        [self.closeBtn setImage:UIImageNamed(@"Image_blackX") forState:UIControlStateNormal];
        [self.contentView addSubview:self.closeBtn];
        self.closeBtn.hidden = YES;
        [self.closeBtn addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
        
        self.sureBtn = cancelBtn;
    }
    return self;
}

- (void)setCurrentName:(NSString *)currentName{
    _currentName = currentName;
    self.nameField.text = currentName;
    [self textFieldDidChange:self.nameField];
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (_field.text.length > 10) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/10",(unsigned long)_field.text.length] setColor:[UIColor colorWithHexString:@"#EE4B4E"] setLengthString:[NSString stringWithFormat:@"%lu",_field.text.length] beginSize:0];
    }else{
        NSString *allStr = [NSString stringWithFormat:@"%lu/10",(unsigned long)_field.text.length];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#8A8F99"] setLengthString:@"10" beginSize:allStr.length-2];
    }
    if(_field.text.length){
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    }else{
        [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
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


- (void)cancelClick{
    if(!self.nameField.text.length){
        self.markL.text = @"请输入聊天昵称";
        return;
    }
    if(self.nameField.text.length > 10){
        self.markL.text = @"昵称不可以超过十个字哦~";
        return;
    }
    if(self.sureNameBlock){
        self.sureNameBlock(self.nameField.text);
    }
    [self dissMissView];
}

- (void)showNameView{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{

    self.contentView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)dissMissView{
    [self.nameField resignFirstResponder];
    [self removeFromSuperview];
}


@end
